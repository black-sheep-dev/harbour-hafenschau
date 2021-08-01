#include "apiinterface.h"

#ifdef QT_DEBUG
#include <QDebug>
#endif

#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonParseError>
#include <QRegularExpression>
#include <QRegularExpressionMatch>
#include <QStandardPaths>
#include <QUrlQuery>

#include <QUuid>

#include <zlib.h>

#include "api_keys.h"

static const quint8 pageSize = 20;

ApiInterface::ApiInterface(QObject *parent) :
    QObject(parent)
{
    m_cache->setCacheDirectory(QStandardPaths::writableLocation(QStandardPaths::CacheLocation) + QStringLiteral("/api"));
    m_manager->setCache(m_cache);
}

void ApiInterface::enableDeveloperMode(bool enable)
{
    m_developerMode = enable;
}

QList<int> ApiInterface::activeRegions() const
{
    return m_activeRegions;
}

quint64 ApiInterface::cacheSize() const
{
    return m_cache->cacheSize();
}

void ApiInterface::clearCache()
{
    m_cache->clear();
}

void ApiInterface::getNextPage(quint8 newsType)
{
    auto model = m_newsModels.value(newsType, nullptr);

    if (model == nullptr)
        return;

    if (model->nextPage().isEmpty())
        return;

    model->setLoadingNextPage(true);
    getNews(newsType);
}

NewsModel *ApiInterface::newsModel(quint8 newsType)
{
    auto model = m_newsModels.value(newsType, nullptr);

    if (model == nullptr) {
        model = new NewsModel(this);
        model->setNewsType(newsType);
        m_newsModels.insert(newsType, model);
        refresh(newsType, true);
    }

    return model;
}

void ApiInterface::getComments(const QString &link)
{
    auto reply = m_manager->get(getRequest(link));
    connect(reply, &QNetworkReply::finished, this, &ApiInterface::onCommentsMetaLinkAvailable);
}

void ApiInterface::getInteralLink(const QString &link)
{
    auto reply = m_manager->get(getRequest(link));
    connect(reply, &QNetworkReply::finished, this, &ApiInterface::onInternalLinkRequestFinished);
}

void ApiInterface::getHtmlEmbed(const QString &link)
{
    if (link == nullptr)
        return;

    auto reply = m_manager->get(getRequest(link));
    connect(reply, &QNetworkReply::finished, this, &ApiInterface::onHtmlEmbedRequestFinished);
}

void ApiInterface::checkForUpdate(News *news)
{
    if (news == nullptr)
        return;

    const QString uuid = QUuid::createUuid().toString();

    m_pendingNews.insert(uuid, news);

    auto reply = m_manager->get(getRequest(news->updateCheckUrl(), false));
    reply->setProperty("uuid", uuid);
    connect(reply, &QNetworkReply::finished, this, &ApiInterface::onCheckForUpdateFinished);
}

void ApiInterface::refresh(quint8 newsType, bool complete)
{
    auto model = m_newsModels.value(newsType, nullptr);

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

void ApiInterface::refreshNews(News *news)
{
    if (news == nullptr)
        return;

    const QString uuid = QUuid::createUuid().toString();

    m_pendingNews.insert(uuid, news);

    auto reply = m_manager->get(getRequest(news->details()));
    reply->setProperty("uuid", uuid);
    connect(reply, &QNetworkReply::finished, this, &ApiInterface::onNewsRefreshFinished);
}

void ApiInterface::setActiveRegions(const QList<int> &regions)
{
    m_activeRegions = regions;
}

void ApiInterface::searchContent(const QString &pattern, quint16 page)
{
    auto model = m_newsModels.value(NewsModel::Search, nullptr);

    if (!model)
        return;

    model->setLoadingNextPage(page > 1);

    const QString url = QStringLiteral("search/?searchText=%1&pageSize=%2&resultPage=%3")
            .arg(pattern, QString::number(pageSize), QString::number(page));

    QNetworkReply *reply = m_manager->get(getRequest(url));
    reply->setProperty("news_type", NewsModel::Search);
    connect(reply, &QNetworkReply::finished, this, &ApiInterface::onNewsRequestFinished);
}

void ApiInterface::onCheckForUpdateFinished()
{
    auto reply = qobject_cast<QNetworkReply *>(sender());
    const QString uuid = reply->property("uuid").toString();

    auto news = m_pendingNews.take(uuid);

    if (news == nullptr)
        return;

    const QString data = getReplyData(reply);

    if (data == QLatin1String("true"))
        refreshNews(news);
}

void ApiInterface::onCommentsAvailable()
{
#ifdef QT_DEBUG
        qDebug() << QStringLiteral("COMMENTS");
#endif

    auto reply = qobject_cast<QNetworkReply *>(sender());

    const bool closed = reply->property("closed").toBool();

    const auto obj = parseJson(getReplyData(reply)).object();

    if (obj.isEmpty())
        return;

    const auto items = obj.value(QStringLiteral("Items")).toArray();

    QList<Comment> comments;
    for (const auto &item : items) {
        const auto data = item.toObject();

        Comment comment;
        comment.author = data.value(ApiKey::benutzer).toString();
        comment.text = data.value(ApiKey::kommentar).toString();
        comment.timestamp = QDateTime::fromString(data.value(ApiKey::beitragsdatum).toString(), Qt::ISODate);
        comment.title = data.value(ApiKey::titel).toString();

        comments.append(comment);
    }

    auto model = new CommentsModel;
    model->setClosed(closed);
    model->setComments(comments);

    emit commentsModelAvailable(model);
}

void ApiInterface::onCommentsMetaLinkAvailable()
{
#ifdef QT_DEBUG
        qDebug() << QStringLiteral("COMMENTS META LINK");
#endif

    const auto obj = parseJson(getReplyData(qobject_cast<QNetworkReply *>(sender()))).object();

    if (obj.isEmpty())
        return;

    QNetworkReply *reply = m_manager->get(getRequest(obj.value(ApiKey::details).toString()));
    reply->setProperty("closed", !obj.value(ApiKey::commentsAllowed).toBool());
    connect(reply, &QNetworkReply::finished, this, &ApiInterface::onCommentsAvailable);
}

void ApiInterface::onHtmlEmbedRequestFinished()
{
    auto reply = qobject_cast<QNetworkReply *>(sender());

    if (reply == nullptr)
        return;

    const int status = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();

    // parse data
    const QString url = reply->url().toString();
    const QString data = getReplyData(reply);

    // check status code
    if (status != 200) {
        return;
    }

    // image
    QRegularExpression re(QStringLiteral("<img.*?src=\"(.*?)\""));
    QRegularExpressionMatch match = re.match(data);

    QString image;

    if (match.hasMatch()) {
        image = match.captured(1);
    }

    // title
    QString title;

    re.setPattern(QStringLiteral("<img.*?alt=\"(.*?)\""));
    match = re.match(data);

    if (match.hasMatch()) {
        title = match.captured(1);
    }

    emit htmlEmbedAvailable(url, image, title);
}

void ApiInterface::onInternalLinkRequestFinished()
{
#ifdef QT_DEBUG
        qDebug() << QStringLiteral("INTERNAL LINK");
#endif

    auto reply = qobject_cast<QNetworkReply *>(sender());
    bool isCached = reply->attribute(QNetworkRequest::SourceIsFromCacheAttribute).toBool();

    const QJsonDocument doc = parseJson(getReplyData(reply));

    if (doc.isEmpty())
        return;

    auto news = parseNews(doc.object());

    if (news == nullptr)
        return;

    news->setCached(isCached);
    emit internalLinkAvailable(news);
}

void ApiInterface::onNewsRefreshFinished()
{
    auto reply = qobject_cast<QNetworkReply *>(sender());
    const QString uuid = reply->property("uuid").toString();

    auto news = m_pendingNews.take(uuid);

    if (news == nullptr)
        return;

    const QJsonDocument doc = parseJson(getReplyData(reply));

    if (doc.isEmpty())
        return;

    parseNews(doc.object(), news);
    emit news->changed();
}

void ApiInterface::onNewsRequestFinished()
{
#ifdef QT_DEBUG
        qDebug() << QStringLiteral("NEWS");
#endif

    auto reply = qobject_cast<QNetworkReply *>(sender());

    if (reply == nullptr)
        return;

    quint8 newsType = reply->property("news_type").toInt();
    auto model = m_newsModels.value(newsType, nullptr);

    if (model == nullptr)
        return;

    // parse data
    const QByteArray data = getReplyData(reply);

    const QJsonObject obj = parseJson(data).object();

    if (obj.isEmpty())
        return;

    QList<News *> list;

    // parse content
    if (newsType == NewsModel::Search) {
        model->setCurrentPage(obj.value(ApiKey::resultPage).toInt());
        model->setPages(qRound((obj.value(ApiKey::totalItemCount).toInt() + 0.5) / pageSize));

        // news
        const QJsonArray newsArray = obj.value(ApiKey::searchResults).toArray();
        for (const auto &n : newsArray) {
            auto news = parseNews(n.toObject());

            if (news == nullptr)
                continue;

            list.append(news);
        }

    } else {
        // get next page
        model->setNextPage(obj.value(ApiKey::nextPage).toString());

        // news
        const QJsonArray newsArray = obj.value(ApiKey::news).toArray();
        for (const auto &n : newsArray) {
            auto news = parseNews(n.toObject());

            if (news == nullptr)
                continue;

            if (news->breakingNews())
                emit breakingNewsAvailable(news);

            list.append(news);
        }

        // regional news
        QStringList regionalNews;

        const QJsonArray regionalNewsArray = obj.value(ApiKey::regional).toArray();
        for (const auto &r : regionalNewsArray) {
            auto news = parseNews(r.toObject());

            if (news == nullptr)
                continue;

            if (regionalNews.contains(news->sophoraId()))
                continue;

            regionalNews.append(news->sophoraId());

            list.append(news);
        }

        model->setNewStoriesCountLink(obj.value(ApiKey::newStoriesCountLink).toString().remove(HAFENSCHAU_API_URL));
    }

    if (model->loadingNextPage()) {
        model->addNews(list);
        model->setLoadingNextPage(false);
    } else {
        model->setNews(list);
    }
}

void ApiInterface::onNewStoriesCountRequestFinished()
{
    auto reply = qobject_cast<QNetworkReply *>(sender());

    if (reply == nullptr)
        return;

    const QJsonDocument doc = parseJson(getReplyData(reply));

    const quint8 newsType = reply->property("news_type").toInt();

    // force complete update if error occurs
    if (doc.isEmpty()) {
        getNews(newsType);
        return;
    }

    //
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
        qDebug() << reply->errorString();
        qDebug() << reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
#endif
        emit error(reply->error());
        reply->deleteLater();
        return QByteArray();
    }

    const QByteArray raw = reply->readAll();

    QByteArray data = gunzip(raw);
    if (data.isEmpty())
        data = raw;

    reply->deleteLater();

    return data;
}

QNetworkRequest ApiInterface::getRequest(const QString &endpoint, bool cached)
{
    QNetworkRequest request;

    if (endpoint.startsWith(QStringLiteral("http")))
        request.setUrl(endpoint);
    else
        request.setUrl(HAFENSCHAU_API_URL + endpoint);

    if (cached)
        request.setAttribute(QNetworkRequest::CacheLoadControlAttribute, QNetworkRequest::PreferNetwork);

    //request.setRawHeader("Cache-Control", "no-cache");
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

    int ret{0};
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
    QNetworkReply *reply = m_manager->get(getRequest(model->newStoriesCountLink(), false));
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

News *ApiInterface::parseNews(const QJsonObject &obj, News *news)
{
    // region filter
    const auto regIds = obj.value(ApiKey::regionIds).toArray();

    quint8 region{0};

    if (regIds.isEmpty()) {
        region = quint8(obj.value(ApiKey::regionId).toInt());
        if (region != 0 && !m_activeRegions.contains(region))
            return nullptr;
    } else {
        for (const auto &id : regIds) {
            auto reg = quint8(id.toInt());
            if (m_activeRegions.contains(reg))
                region = reg;
        }

        if (region == 0)
            return nullptr;
    }

    // create news
    if (news == nullptr)
        news = new News;

    if (m_developerMode)
        news->setDebugData(obj);

    news->setSophoraId(obj.value(ApiKey::sophoraId).toString());
    news->setBreakingNews(obj.value(ApiKey::breakingNews).toBool());
    news->setDate(QDateTime::fromString(obj.value(ApiKey::date).toString(), Qt::ISODate));
    news->setFirstSentence(obj.value(ApiKey::firstSentence).toString());
    news->setRegion(region);
    news->setTitle(obj.value(ApiKey::title).toString());
    news->setTopline(obj.value(ApiKey::topline).toString());

    const auto teaserImage = obj.value(ApiKey::teaserImage).toObject();

    news->setThumbnail(teaserImage.value(ApiKey::portraetGross8x9).toObject()
                       .value(ApiKey::imageUrl).toString());

    news->setImage(teaserImage.value(ApiKey::videoWebL).toObject()
                   .value(ApiKey::imageUrl).toString());

    news->setPortrait(teaserImage.value(ApiKey::portraetGrossPlus8x9).toObject()
                      .value(ApiKey::imageUrl).toString());

    news->setBrandingImage(obj.value(ApiKey::brandingImage).toObject()
                           .value(ApiKey::videoWebM).toObject()
                           .value(ApiKey::imageUrl).toString());

    news->setDetails(obj.value(ApiKey::details).toString());

    news->setComments(obj.value(ApiKey::comments).toString());

    const auto type = obj.value(ApiKey::type).toString();

    if (type == ApiKey::story) {
        news->setNewsType(News::Story);
    } else if (type == ApiKey::video) {
        news->setNewsType(News::Video);
        news->setStream(obj.value(ApiKey::streams).toObject()
                           .value(ApiKey::adaptiveStreaming).toString());
    } else if (type == ApiKey::webview) {
        news->setNewsType(News::WebView);
        news->setDetailsWeb(obj.value(ApiKey::detailsWeb).toString());
    }

    news->setUpdateCheckUrl(obj.value(ApiKey::updateCheckUrl).toString());


    // parse content
    const auto content = obj.value(ApiKey::content).toArray();

    QList<ContentItem *> items;

    for (const QJsonValue &x : content) {
        const QJsonObject objC = x.toObject();

        const QString contentType = objC.value(ApiKey::type).toString();

        ContentItem *item{nullptr};

        if (contentType == ApiKey::audio) {
            item = parseContentItemAudio(objC.value(ApiKey::audio).toObject());
        } else if (contentType == ApiKey::box) {
            item = parseContentItemBox(objC.value(ApiKey::box).toObject());
        } else if (contentType == ApiKey::imageGallery) {
            item = parseContentItemGallery(objC.value(ApiKey::gallery).toArray());
        } else if (contentType == ApiKey::headline) {
            item = new ContentItem;
            item->setContentType(ContentItem::Headline);
            const QString headline = objC.value(ApiKey::value).toString().remove(QRegExp("<[^>]*>"));
            item->setValue(headline);
        } else if (contentType == ApiKey::htmlEmbed) {
            item = new ContentItem;
            item->setContentType(ContentItem::HtmlEmbed);
            item->setValue(objC
                           .value(ApiKey::htmlEmbed)
                           .toObject().value(ApiKey::url)
                           .toString());
        } else if (contentType == ApiKey::list) {
            item = parseContentItemList(objC.value(ApiKey::list).toObject());
        } else if (contentType == ApiKey::quotation) {
            item = new ContentItem;
            item->setContentType(ContentItem::Quotation);
            item->setValue(objC.value(ApiKey::quotation).toObject()
                           .value(ApiKey::text).toString());
        } else if (contentType == ApiKey::related) {
            item = parseContentItemRelated(objC.value(ApiKey::related).toArray());
        } else if (contentType == ApiKey::socialMedia) {
            item = parseContentItemSocial(objC.value(ApiKey::social).toObject());
        } else if (contentType == ApiKey::text) {
            item = new ContentItem;
            item->setContentType(ContentItem::Text);
            item->setValue(objC.value(ApiKey::value).toString());
        } else if (contentType == ApiKey::video) {
            item = parseContentItemVideo(objC.value(ApiKey::video).toObject());
        } else {
            item = new ContentItem;
            item->setValue(QJsonDocument(objC).toJson(QJsonDocument::Indented));
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
    auto audio = new ContentItemAudio;

    audio->setDate(QDateTime::fromString(obj.value(ApiKey::date).toString(), Qt::ISODate));
    audio->setText(obj.value(ApiKey::text).toString());
    audio->setTitle(obj.value(ApiKey::title).toString());
    audio->setImage(obj.value(ApiKey::teaserImage).toObject()
                    .value(ApiKey::videoWebL).toObject()
                    .value(ApiKey::imageUrl).toString());
    audio->setStream(obj.value(ApiKey::stream).toString());

    return audio;
}

ContentItemBox *ApiInterface::parseContentItemBox(const QJsonObject &obj)
{
    auto box = new ContentItemBox;
    box->setCopyright(obj.value(ApiKey::copyright).toString());

    QString link = obj.value(ApiKey::link).toString();
    box->setLinkInternal(link.contains("type=\"intern\""));
    box->setLink(link.remove("<a href=\"").mid(0, link.indexOf("\"")));

    box->setSubtitle(obj.value(ApiKey::subtitle).toString());
    box->setText(obj.value(ApiKey::text).toString());
    box->setTitle(obj.value(ApiKey::title).toString());

    box->setImage(obj.value(ApiKey::images).toObject()
                  .value(ApiKey::videoWebL).toObject()
                  .value(ApiKey::imageUrl).toString());

    return box;
}

ContentItemGallery *ApiInterface::parseContentItemGallery(const QJsonArray &arr)
{
    QList<GalleryItem *> list;
    for (const QJsonValue &x : arr) {
        const QJsonObject obj = x.toObject();

        auto item = new GalleryItem;
        item->setCopyright(obj.value(ApiKey::copyright).toString());
        item->setTitle(obj.value(ApiKey::title).toString());
        item->setImage(obj.value(ApiKey::videoWebL).toObject()
                       .value(ApiKey::imageUrl).toString());

        list.append(item);
    }

    auto gallery = new ContentItemGallery;
    gallery->model()->setItems(list);

    return gallery;
}

ContentItemList *ApiInterface::parseContentItemList(const QJsonObject &obj)
{
    auto list = new ContentItemList;
    list->setTitle(obj.value(ApiKey::title).toString());

    QStringList items;
    const QJsonArray array = obj.value(ApiKey::items).toArray();
    for (const auto &item : array) {
        const QString str = item.toObject().value(ApiKey::url).toString();
        if (str.isEmpty())
            continue;

        items.append(str);
    }
    list->setItems(items);

    return list;
}

ContentItemRelated *ApiInterface::parseContentItemRelated(const QJsonArray &arr)
{
    QList<RelatedItem *> list;

    for (const QJsonValue &x : arr) {
        const QJsonObject obj = x.toObject();

        auto item = new RelatedItem;
        item->setDate(QDateTime::fromString(obj.value(ApiKey::date).toString(), Qt::ISODate));
        item->setTitle(obj.value(ApiKey::title).toString());
        item->setTopline(obj.value(ApiKey::topline).toString());
        item->setLink(obj.value(ApiKey::details).toString());
        item->setSophoraId(obj.value(ApiKey::sophoraId).toString());
        item->setImage(obj.value(ApiKey::teaserImage).toObject()
                       .value(ApiKey::videoWebL).toObject()
                       .value(ApiKey::imageUrl).toString());
        item->setStream(obj.value(ApiKey::streams).toObject()
                        .value(ApiKey::adaptiveStreaming).toString());

        const QString type = obj.value(ApiKey::type).toString();

        if (type == ApiKey::video) {
            item->setRelatedType(RelatedItem::RelatedVideo);
        } else if (type == ApiKey::webview) {
            item->setRelatedType(RelatedItem::RelatedWebView);
            item->setLink(obj.value(ApiKey::detailsWeb).toString());
        } else {
            item->setRelatedType(RelatedItem::RelatedStory);
        }

        list.append(item);
    }

    auto related = new ContentItemRelated;
    related->model()->setItems(list);

    return related;
}

ContentItemSocial *ApiInterface::parseContentItemSocial(const QJsonObject &obj)
{
    auto social = new ContentItemSocial;

    social->setAccount(obj.value(ApiKey::account).toString());

    QString avatar = obj.value(ApiKey::avatar).toString();

    if (!avatar.isEmpty())
        avatar.remove(QStringLiteral("https://www.tagesschau.de/p/")).prepend("https://");

    social->setAvatar(avatar);
    social->setDate(QDateTime::fromString(obj.value(ApiKey::date).toString(), Qt::ISODate));
    social->setShorttext(obj.value(ApiKey::shortText).toString());
    social->setTitle(obj.value(ApiKey::title).toString());
    social->setUrl(obj.value(ApiKey::url).toString());
    social->setUsername(obj.value(ApiKey::username).toString());

    QString image = obj.value(ApiKey::images).toObject()
            .value(ApiKey::mittel16x9).toObject()
            .value(ApiKey::imageUrl).toString();

    if (!image.isEmpty())
        image.remove(QStringLiteral("https://www.tagesschau.de/p/")).prepend("https://");

    social->setImage(image);

    const QString type = obj.value(ApiKey::type).toString();

    if (type == ApiKey::twitter) {
        social->setSocialType(ContentItemSocial::Twitter);
    } else {
        social->setSocialType(ContentItemSocial::Unkown);
    }

    return social;
}

ContentItemVideo *ApiInterface::parseContentItemVideo(const QJsonObject &obj)
{
    auto video = new ContentItemVideo;
    video->setCopyright(obj.value(ApiKey::copyright).toString());
    video->setDate(QDateTime::fromString(obj.value(ApiKey::date).toString(), Qt::ISODate));
    video->setTitle(obj.value(ApiKey::title).toString());
    video->setImage(obj.value(ApiKey::teaserImage).toObject()
                  .value(ApiKey::videoWebL).toObject()
                  .value(ApiKey::imageUrl).toString());
    video->setStream(obj.value(ApiKey::streams).toObject()
                     .value(ApiKey::adaptiveStreaming).toString());

    return video;
}

bool ApiInterface::newNewsAvailable(const QJsonObject &obj)
{
    if (obj.value(ApiKey::tagesschau).toInt() > 0)
        return true;

    QList<int>::iterator it;
    for (it = m_activeRegions.begin(); it != m_activeRegions.end(); ++it) {
        if (obj.value(QString::number(*it)).toInt() > 0)
            return true;
    }

    return false;
}
