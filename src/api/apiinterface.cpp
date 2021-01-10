#include "apiinterface.h"

#ifdef QT_DEBUG
#include <QDebug>
#endif

#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonParseError>
#include <QUrlQuery>

#include <zlib.h>

#include "api_keys.h"

ApiInterface::ApiInterface(QObject *parent) :
    QObject(parent),
    m_manager(new QNetworkAccessManager(this))
{

}

void ApiInterface::enableDeveloperMode(bool enable)
{
    m_developerMode = enable;
}

QList<int> ApiInterface::activeRegions() const
{
    return m_activeRegions;
}

NewsModel *ApiInterface::newsModel(quint8 newsType)
{
    NewsModel *model = m_newsModels.value(newsType, nullptr);

    if (model == nullptr) {
        model = new NewsModel(this);
        model->setNewsType(newsType);
        m_newsModels.insert(newsType, model);
        refresh(newsType, true);
    }

    return model;
}

void ApiInterface::getInteralLink(const QString &link)
{
    QNetworkReply *reply = m_manager->get(getRequest(link));
    connect(reply, &QNetworkReply::finished, this, &ApiInterface::onInternalLinkRequestFinished);
}

void ApiInterface::refresh(quint8 newsType, bool complete)
{
    NewsModel *model = m_newsModels.value(newsType, nullptr);

    if (model == nullptr) {
        model = new NewsModel(this);
        model->setNewsType(newsType);
        m_newsModels.insert(newsType, model);
    }

    model->setLoading(true);

    if (model->newStoriesCountLink().isEmpty() || complete) {
        getNews(newsType);
    } else {
        getNewStoriesCount(model);
    }
}

void ApiInterface::setActiveRegions(const QList<int> &regions)
{
    m_activeRegions = regions;
}

void ApiInterface::onInternalLinkRequestFinished()
{
#ifdef QT_DEBUG
        qDebug() << QStringLiteral("INTERNAL LINK");
#endif

    const QJsonDocument doc = parseJson(getReplyData(qobject_cast<QNetworkReply *>(sender())));

    if (doc.isEmpty())
        return;

    auto *news = parseNews(doc.object());

    if (news != nullptr)
        emit internalLinkAvailable(news);
}

void ApiInterface::onNewsRequestFinished()
{
#ifdef QT_DEBUG
        qDebug() << QStringLiteral("NEWS");
#endif

    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());

    if (reply == nullptr)
        return;

    quint8 newsType = reply->property("news_type").toInt();
    NewsModel *model = m_newsModels.value(newsType, nullptr);

    if (model == nullptr)
        return;

    // parse data
    const QByteArray data = getReplyData(reply);

#ifdef QT_DEBUG
        //qDebug() << data;
#endif

    const QJsonDocument doc = parseJson(data);

    if (doc.isEmpty())
        return;

    QList<News *> list;

    // news
    const QJsonArray newsArray = doc.object().value(HAFENSCHAU_API_KEY_NEWS).toArray();
    for (const auto &n : newsArray) {
        auto *news = parseNews(n.toObject());

        if (news == nullptr)
            continue;

        list.append(news);
    }

    // regional news
    const QJsonArray regionalNewsArray = doc.object().value(HAFENSCHAU_API_KEY_REGIONAL).toArray();
    for (const auto &r : regionalNewsArray) {
        auto *news = parseNews(r.toObject());

        if (news == nullptr)
            continue;

        list.append(news);
    }

    model->setNewStoriesCountLink(doc.object().value(HAFENSCHAU_API_KEY_NEW_STORIES_COUNT_LINK).toString().remove(HAFENSCHAU_API_URL));
    model->setNews(list);
}

void ApiInterface::onNewStoriesCountRequestFinished()
{
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());

    QJsonParseError error;

    const QJsonDocument doc = parseJson(getReplyData(reply));

    if (error.error) {
        reply->deleteLater();
        return;
    }

    const quint8 newsType = reply->property("news_type").toInt();

    if (newNewsAvailable(doc.object())) {
        getNews(newsType);
    } else {
        m_newsModels.value(newsType)->setLoading(false);
    }

    reply->deleteLater();
}

QString ApiInterface::activeRegionsAsString() const
{
    QStringList list;

    for (auto region : m_activeRegions) {
        list.append(QString::number(region));
    }

    return list.join(QStringLiteral(","));
}

QByteArray ApiInterface::getReplyData(QNetworkReply *reply)
{
    if (reply == nullptr)
        return QByteArray();

#ifdef QT_DEBUG
    qDebug() << reply->url();
#endif

    if (reply->error()) {
#ifdef QT_DEBUG
        qDebug() << QStringLiteral("Reply Error");
        qDebug() << reply->error();
#endif
        reply->deleteLater();
        return QByteArray();
    }

    const QByteArray data = gunzip(reply->readAll());

    reply->deleteLater();

    return data;
}

QNetworkRequest ApiInterface::getRequest(const QString &endpoint)
{
    QNetworkRequest request;

    if (endpoint.startsWith(QStringLiteral("http")))
        request.setUrl(endpoint);
    else
        request.setUrl(HAFENSCHAU_API_URL + endpoint);


    request.setRawHeader("Cache-Control", "no-cache");
    request.setRawHeader("User-Agent", "Mozilla/5.0 (X11; Linux x86_64; rv:80.0) Gecko/20100101 Firefox/80.0");
    request.setRawHeader("Accept", "application/json");
    request.setRawHeader("Connection", "keep-alive");
    request.setRawHeader("Accept-Encoding", "gzip");

    request.setSslConfiguration(QSslConfiguration::defaultConfiguration());

    return request;
}

QByteArray ApiInterface::gunzip(const QByteArray &data)
{
    if (data.size() <= 4) {
        return QByteArray();
    }

    QByteArray result;

    int ret;
    z_stream strm;
    static const int CHUNK_SIZE = 1024;
    char out[CHUNK_SIZE];

    /* allocate inflate state */
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    strm.opaque = Z_NULL;
    strm.avail_in = data.size();
    strm.next_in = (Bytef*)(data.data());

    ret = inflateInit2(&strm, 15 +  32); // gzip decoding
    if (ret != Z_OK)
        return QByteArray();

    // run inflate()
    do {
        strm.avail_out = CHUNK_SIZE;
        strm.next_out = (Bytef*)(out);

        ret = inflate(&strm, Z_NO_FLUSH);
        Q_ASSERT(ret != Z_STREAM_ERROR);  // state not clobbered

        switch (ret) {
        case Z_NEED_DICT:
            ret = Z_DATA_ERROR;     // and fall through
        case Z_DATA_ERROR:
        case Z_MEM_ERROR:
            (void)inflateEnd(&strm);
            return QByteArray();
        }

        result.append(out, CHUNK_SIZE - strm.avail_out);
    } while (strm.avail_out == 0);

    // clean up and return
    inflateEnd(&strm);
    return result;
}

void ApiInterface::getNews(quint8 newsType)
{
    QString url = HAFENSCHAU_API_URL + HAFENSCHAU_API_ENDPOINT_NEWS;

#ifdef QT_DEBUG
    qDebug() << newsType;
#endif

    switch (newsType) {
    case NewsModel::Ausland:
        url.append(QStringLiteral("?ressort=ausland"));
        break;

    case NewsModel::Homepage:
        url = HAFENSCHAU_API_ENDPOINT_HOMEPAGE;
        break;

    case NewsModel::Inland:
        url.append(QStringLiteral("?ressort=inland"));
        break;

    case NewsModel::Investigativ:
        url.append(QStringLiteral("?ressort=investigativ"));
        break;

    case NewsModel::Regional:
        if (m_activeRegions.isEmpty()) {
            m_newsModels.value(NewsModel::Regional)->setLoading(false);
            return;
        }

        url.append(QStringLiteral("?regions=") + activeRegionsAsString());
        break;

    case NewsModel::Sport:
        url.append(QStringLiteral("?ressort=sport"));
        break;

    case NewsModel::Video:
        url.append(QStringLiteral("?ressort=video"));
        break;

    case NewsModel::Wirtschaft:
        url.append(QStringLiteral("?ressort=wirtschaft"));
        break;

    default:
        return;
    }

    QNetworkReply *reply = m_manager->get(getRequest(url));
    reply->setProperty("news_type", newsType);
    connect(reply, &QNetworkReply::finished, this, &ApiInterface::onNewsRequestFinished);
}

void ApiInterface::getNewStoriesCount(NewsModel *model)
{
    QNetworkReply *reply = m_manager->get(getRequest(model->newStoriesCountLink()));
    reply->setProperty("news_type", model->newsType());
    connect(reply, &QNetworkReply::finished, this, &ApiInterface::onNewStoriesCountRequestFinished);
}

QJsonDocument ApiInterface::parseJson(const QByteArray &data)
{
    // check json response
    QJsonParseError error{};

    const QJsonDocument doc = QJsonDocument::fromJson(data, &error);

    if (error.error) {
#ifdef QT_DEBUG
        qDebug() << QStringLiteral("JSON parse error");
        qDebug() << data;
#endif
    }

    return doc;
}

News *ApiInterface::parseNews(const QJsonObject &obj)
{
    // region filter
    const QJsonArray regionIds = obj.value(HAFENSCHAU_API_KEY_REGION_IDS).toArray();

    quint8 region{0};

    if (regionIds.isEmpty()) {
        region = quint8(obj.value(HAFENSCHAU_API_KEY_REGION_ID).toInt());
        if (region != 0 && !m_activeRegions.contains(region))
            return nullptr;
    } else {
        for (const auto &id : regionIds) {
            quint8 reg = quint8(id.toInt());
            if (m_activeRegions.contains(reg))
                region = reg;
        }

        if (region == 0)
            return nullptr;
    }

    // create news
    News *news = new News;

    if (m_developerMode)
        news->setDebugData(obj);

    news->setBreakingNews(obj.value(HAFENSCHAU_API_KEY_BREACKING_NEWS).toBool());
    news->setDate(QDateTime::fromString(obj.value(HAFENSCHAU_API_KEY_DATE).toString(), Qt::ISODate));
    news->setFirstSentence(obj.value(HAFENSCHAU_API_KEY_FIRST_SENTENCE).toString());
    news->setRegion(region);
    news->setTitle(obj.value(HAFENSCHAU_API_KEY_TITLE).toString());
    news->setTopline(obj.value(HAFENSCHAU_API_KEY_TOPLINE).toString());

    const QJsonObject teaserImage = obj.value(HAFENSCHAU_API_KEY_TEASER_IMAGE).toObject();

    news->setThumbnail(teaserImage.value(HAFENSCHAU_API_KEY_PORTRAIT_GROSS_8X9).toObject()
                       .value(HAFENSCHAU_API_KEY_IMAGE_URL).toString());

    news->setImage(teaserImage.value(HAFENSCHAU_API_KEY_VIDEO_WEB_L).toObject()
                   .value(HAFENSCHAU_API_KEY_IMAGE_URL).toString());

    news->setPortrait(teaserImage.value(HAFENSCHAU_API_KEY_PORTRAIT_GROSS_PLUS_8X9).toObject()
                      .value(HAFENSCHAU_API_KEY_IMAGE_URL).toString());

    news->setBrandingImage(obj.value(HAFENSCHAU_API_KEY_BRANDING_IMAGE).toObject()
                           .value(HAFENSCHAU_API_KEY_VIDEO_WEB_M).toObject()
                           .value(HAFENSCHAU_API_KEY_IMAGE_URL).toString());

    news->setDetails(obj.value(HAFENSCHAU_API_KEY_DETAILS).toString());

    const QString type = obj.value(HAFENSCHAU_API_KEY_TYPE).toString();

    if (type == HAFENSCHAU_API_KEY_STORY) {
        news->setNewsType(News::Story);
    } else if (type == HAFENSCHAU_API_KEY_VIDEO) {
        news->setNewsType(News::Video);
        news->setStream(obj.value(HAFENSCHAU_API_KEY_STREAMS).toObject()
                           .value(HAFENSCHAU_API_KEY_ADAPTIVE_STREAMING).toString());
    } else if (type == HAFENSCHAU_API_KEY_WEBVIEW) {
        news->setNewsType(News::WebView);
        news->setDetailsWeb(obj.value(HAFENSCHAU_API_KEY_DETAILS_WEB).toString());
    }

    news->setUpdateCheckUrl(obj.value(HAFENSCHAU_API_KEY_UPDATE_CHECK_URL).toString());


    // parse content
    const QJsonArray content = obj.value(HAFENSCHAU_API_KEY_CONTENT).toArray();

    QList<ContentItem *> items;

    for (const QJsonValue &x : content) {
        const QJsonObject &objC = x.toObject();

        const QString contentType = objC.value(HAFENSCHAU_API_KEY_TYPE).toString();

        ContentItem *item{nullptr};

        if (contentType == HAFENSCHAU_API_KEY_AUDIO) {
            item = parseContentItemAudio(objC.value(HAFENSCHAU_API_KEY_AUDIO).toObject());
        } else if (contentType == HAFENSCHAU_API_KEY_BOX) {
            item = parseContentItemBox(objC.value(HAFENSCHAU_API_KEY_BOX).toObject());
        } else if (contentType == HAFENSCHAU_API_KEY_IMAGE_GALLERY) {
            item = parseContentItemGallery(objC.value(HAFENSCHAU_API_KEY_GALLERY).toArray());
        } else if (contentType == HAFENSCHAU_API_KEY_HEADLINE) {
            item = new ContentItem;
            item->setContentType(ContentItem::Headline);
            const QString headline = objC.value(HAFENSCHAU_API_KEY_VALUE).toString().remove(QRegExp("<[^>]*>"));
            item->setValue(headline);
        } else if (contentType == HAFENSCHAU_API_KEY_RELATED) {
            item = parseContentItemRelated(objC.value(HAFENSCHAU_API_KEY_RELATED).toArray());
        } else if (contentType == HAFENSCHAU_API_KEY_SOCIAL_MEDIA) {
            item = parseContentItemSocial(objC.value(HAFENSCHAU_API_KEY_SOCIAL).toObject());
        } else if (contentType == HAFENSCHAU_API_KEY_TEXT) {
            item = new ContentItem;
            item->setContentType(ContentItem::Text);
            item->setValue(objC.value(HAFENSCHAU_API_KEY_VALUE).toString());
        } else if (contentType == HAFENSCHAU_API_KEY_VIDEO) {
            item = parseContentItemVideo(objC.value(HAFENSCHAU_API_KEY_VIDEO).toObject());
        }

        if (!item)
            continue;

        items.append(item);
    }

    news->setContentItems(items);


    return news;
}

ContentItemAudio *ApiInterface::parseContentItemAudio(const QJsonObject &obj)
{
    auto *audio = new ContentItemAudio;

    audio->setDate(QDateTime::fromString(obj.value(HAFENSCHAU_API_KEY_DATE).toString(), Qt::ISODate));
    audio->setText(obj.value(HAFENSCHAU_API_KEY_TEXT).toString());
    audio->setTitle(obj.value(HAFENSCHAU_API_KEY_TITLE).toString());
    audio->setImage(obj.value(HAFENSCHAU_API_KEY_TEASER_IMAGE).toObject()
                    .value(HAFENSCHAU_API_KEY_VIDEO_WEB_L).toObject()
                    .value(HAFENSCHAU_API_KEY_IMAGE_URL).toString());
    audio->setStream(obj.value(HAFENSCHAU_API_KEY_STREAM).toString());

    return audio;
}

ContentItemBox *ApiInterface::parseContentItemBox(const QJsonObject &obj)
{
    auto *box = new ContentItemBox;
    box->setCopyright(obj.value(HAFENSCHAU_API_KEY_COPYRIGHT).toString());

    QString link = obj.value(HAFENSCHAU_API_KEY_LINK).toString();
    box->setLinkInternal(link.contains("type=\"intern\""));
    box->setLink(link.remove("<a href=\"").mid(0, link.indexOf("\"")));

    box->setSubtitle(obj.value(HAFENSCHAU_API_KEY_SUBTITLE).toString());
    box->setText(obj.value(HAFENSCHAU_API_KEY_TEXT).toString());
    box->setTitle(obj.value(HAFENSCHAU_API_KEY_TITLE).toString());

    box->setImage(obj.value(HAFENSCHAU_API_KEY_IMAGES).toObject()
                  .value(HAFENSCHAU_API_KEY_VIDEO_WEB_L).toObject()
                  .value(HAFENSCHAU_API_KEY_IMAGE_URL).toString());

    return box;
}

ContentItemGallery *ApiInterface::parseContentItemGallery(const QJsonArray &arr)
{
    QList<GalleryItem *> list;
    for (const QJsonValue &x : arr) {
        const QJsonObject obj = x.toObject();

        auto *item = new GalleryItem;
        item->setCopyright(obj.value(HAFENSCHAU_API_KEY_COPYRIGHT).toString());
        item->setTitle(obj.value(HAFENSCHAU_API_KEY_TITLE).toString());
        item->setImage(obj.value(HAFENSCHAU_API_KEY_VIDEO_WEB_L).toObject()
                       .value(HAFENSCHAU_API_KEY_IMAGE_URL).toString());

        list.append(item);
    }

    auto *gallery = new ContentItemGallery;
    gallery->model()->setItems(list);

    return gallery;
}

ContentItemRelated *ApiInterface::parseContentItemRelated(const QJsonArray &arr)
{
    QList<RelatedItem *> list;

    for (const QJsonValue &x : arr) {
        const QJsonObject obj = x.toObject();

        auto *item = new RelatedItem;
        item->setDate(QDateTime::fromString(obj.value(HAFENSCHAU_API_KEY_DATE).toString(), Qt::ISODate));
        item->setTitle(obj.value(HAFENSCHAU_API_KEY_TITLE).toString());
        item->setTopline(obj.value(HAFENSCHAU_API_KEY_TOPLINE).toString());
        item->setLink(obj.value(HAFENSCHAU_API_KEY_DETAILS).toString());
        item->setSophoraId(obj.value(HAFENSCHAU_API_KEY_SOPHORA_ID).toString());
        item->setImage(obj.value(HAFENSCHAU_API_KEY_TEASER_IMAGE).toObject()
                       .value(HAFENSCHAU_API_KEY_VIDEO_WEB_L).toObject()
                       .value(HAFENSCHAU_API_KEY_IMAGE_URL).toString());
        item->setStream(obj.value(HAFENSCHAU_API_KEY_STREAMS).toObject()
                        .value(HAFENSCHAU_API_KEY_ADAPTIVE_STREAMING).toString());

        const QString type = obj.value(HAFENSCHAU_API_KEY_TYPE).toString();

        if (type == HAFENSCHAU_API_KEY_VIDEO) {
            item->setRelatedType(RelatedItem::RelatedVideo);
        } else if (type == HAFENSCHAU_API_KEY_WEBVIEW) {
            item->setRelatedType(RelatedItem::RelatedWebView);
            item->setLink(obj.value(HAFENSCHAU_API_KEY_DETAILS_WEB).toString());
        } else {
            item->setRelatedType(RelatedItem::RelatedStory);
        }

        list.append(item);
    }

    auto *related = new ContentItemRelated;
    related->model()->setItems(list);

    return related;
}

ContentItemSocial *ApiInterface::parseContentItemSocial(const QJsonObject &obj)
{
    auto *social = new ContentItemSocial;

    social->setAccount(obj.value(HAFENSCHAU_API_KEY_ACCOUNT).toString());
    social->setAvatar(obj.value(HAFENSCHAU_API_KEY_AVATAR).toString());
    social->setDate(QDateTime::fromString(obj.value(HAFENSCHAU_API_KEY_DATE).toString(), Qt::ISODate));
    social->setShorttext(obj.value(HAFENSCHAU_API_KEY_SHORT_TEXT).toString());
    social->setTitle(obj.value(HAFENSCHAU_API_KEY_TITLE).toString());
    social->setUrl(obj.value(HAFENSCHAU_API_KEY_URL).toString());
    social->setUsername(obj.value(HAFENSCHAU_API_KEY_USERNAME).toString());

    social->setImage(obj.value(HAFENSCHAU_API_KEY_IMAGES).toObject()
                     .value(HAFENSCHAU_API_KEY_MITTEL_16X9).toObject()
                     .value(HAFENSCHAU_API_KEY_IMAGE_URL).toString());

    const QString type = obj.value(HAFENSCHAU_API_KEY_TYPE).toString();

    if (type == HAFENSCHAU_API_KEY_TWITTER) {
        social->setSocialType(ContentItemSocial::Twitter);
    } else {
        social->setSocialType(ContentItemSocial::Unkown);
    }

    return social;
}

ContentItemVideo *ApiInterface::parseContentItemVideo(const QJsonObject &obj)
{
    auto *video = new ContentItemVideo;
    video->setCopyright(obj.value(HAFENSCHAU_API_KEY_COPYRIGHT).toString());
    video->setDate(QDateTime::fromString(obj.value(HAFENSCHAU_API_KEY_DATE).toString(), Qt::ISODate));
    video->setTitle(obj.value(HAFENSCHAU_API_KEY_TITLE).toString());
    video->setImage(obj.value(HAFENSCHAU_API_KEY_TEASER_IMAGE).toObject()
                  .value(HAFENSCHAU_API_KEY_VIDEO_WEB_L).toObject()
                  .value(HAFENSCHAU_API_KEY_IMAGE_URL).toString());
    video->setStream(obj.value(HAFENSCHAU_API_KEY_STREAMS).toObject()
                     .value(HAFENSCHAU_API_KEY_ADAPTIVE_STREAMING).toString());

    return video;
}

bool ApiInterface::newNewsAvailable(const QJsonObject &obj)
{
    if (obj.value(HAFENSCHAU_API_KEY_TAGESSCHAU).toInt() > 0)
        return true;

    for (const int region : m_activeRegions) {
        if (obj.value(QString::number(region)).toInt() > 0)
            return true;
    }

    return false;
}
