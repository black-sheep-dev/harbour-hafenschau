#include "apiinterface.h"

#ifdef QT_DEBUG
#include <QDebug>
#endif

#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonParseError>

#include <zlib.h>

ApiInterface::ApiInterface(QObject *parent) :
    QObject(parent),
    m_manager(new QNetworkAccessManager(this))
{
    connect(m_manager, &QNetworkAccessManager::finished, this, &ApiInterface::onRequestFinished);
}

void ApiInterface::enableDeveloperMode(bool enable)
{
    m_developerMode = enable;
}

void ApiInterface::refresh()
{
    m_manager->get(getRequest());
}

void ApiInterface::getInteralLink(const QString &link)
{
    m_manager->get(getRequest(link));
}

void ApiInterface::onRequestFinished(QNetworkReply *reply)
{
    if (reply->error()) {
#ifdef QT_DEBUG
        qDebug() << QStringLiteral("Reply Error");
        qDebug() << reply->error();
#endif
        reply->deleteLater();
        return;
    }

    // check json response
    const QByteArray data = gunzip(reply->readAll());

    //qDebug() << data;

    QJsonParseError error{};

    const QJsonDocument doc = QJsonDocument::fromJson(data, &error);

    reply->deleteLater();

    if (error.error) {
#ifdef QT_DEBUG
        qDebug() << QStringLiteral("JSON parse error");
#endif
        return;
    }

    const QString url = reply->url().toString();

    if (url == QStringLiteral(HAFENSCHAU_API_URL)) {

        const QJsonArray newsArray = doc.object().value(QStringLiteral("news")).toArray();

        QList<News *> list;

        for (const QJsonValue &v: newsArray) {
            list.append(parseNews(v.toObject()));
        }

        emit newsAvailable(list);
    } else if (url.endsWith(QStringLiteral(".json"))) {
        emit internalLinkAvailable(parseNews(doc.object()));
    }
}



QNetworkRequest ApiInterface::getRequest(const QString &endpoint)
{
    QNetworkRequest request;

    if (endpoint.startsWith("http"))
        request.setUrl(endpoint);
    else
        request.setUrl(QStringLiteral(HAFENSCHAU_API_URL) + endpoint);


    request.setRawHeader("Cache-Control", "no-cache");
    request.setRawHeader("Host", "www.tagesschau.de");
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

News *ApiInterface::parseNews(const QJsonObject &obj)
{
    News *news = new News;

    if (m_developerMode)
        news->setDebugData(obj);

    news->setBreakingNews(obj.value(QStringLiteral("breakingNews")).toBool());
    news->setDate(QDateTime::fromString(obj.value(QStringLiteral("date")).toString(), Qt::ISODate));
    news->setFirstSentence(obj.value(QStringLiteral("firstSentence")).toString());
    news->setRegion(quint8(obj.value(QStringLiteral("regionId")).toInt()));
    news->setTitle(obj.value(QStringLiteral("title")).toString());
    news->setTopline(obj.value(QStringLiteral("topline")).toString());

    const QJsonObject teaserImage = obj.value(QStringLiteral("teaserImage")).toObject();

    news->setThumbnail(teaserImage.value(QStringLiteral("portraetgross8x9")).toObject()
                       .value(QStringLiteral("imageurl")).toString());

    news->setImage(teaserImage.value(QStringLiteral("videowebl")).toObject()
                   .value(QStringLiteral("imageurl")).toString());

    news->setPortrait(teaserImage.value(QStringLiteral("portraetgrossplus8x9")).toObject()
                      .value(QStringLiteral("imageurl")).toString());

    news->setBrandingImage(obj.value(QStringLiteral("brandingImage")).toObject()
                           .value(QStringLiteral("videowebm")).toObject()
                           .value(QStringLiteral("imageurl")).toString());

    const QString type = obj.value(QStringLiteral("type")).toString();

    if (type == QStringLiteral("story")) {
        news->setNewsType(News::Story);
    } else if (type == QStringLiteral("webview")) {
        news->setNewsType(News::WebView);
        news->setDetailsWeb(obj.value(QStringLiteral("detailsweb")).toString());
    }


    // parse content
    const QJsonArray content = obj.value(QStringLiteral("content")).toArray();

    QList<ContentItem *> items;

    for (const QJsonValue &x : content) {
        const QJsonObject &objC = x.toObject();

        const QString contentType = objC.value(QStringLiteral("type")).toString();

        ContentItem *item{nullptr};

        if (contentType == QStringLiteral("audio")) {
            item = parseContentItemAudio(objC.value(QStringLiteral("audio")).toObject());
        } else if (contentType == QStringLiteral("box")) {
            item = parseContentItemBox(objC.value(QStringLiteral("box")).toObject());
        } else if (contentType == QStringLiteral("image_gallery")) {
            item = parseContentItemGallery(objC.value(QStringLiteral("gallery")).toArray());
        } else if (contentType == QStringLiteral("headline")) {
            item = new ContentItem;
            item->setContentType(ContentItem::Headline);
            const QString headline = objC.value(QStringLiteral("value")).toString().remove(QRegExp("<[^>]*>"));
            item->setValue(headline);
        } else if (contentType == QStringLiteral("related")) {
            item = parseContentItemRelated(objC.value(QStringLiteral("related")).toArray());
        } else if (contentType == QStringLiteral("socialmedia")) {
            item = parseContentItemSocial(objC.value(QStringLiteral("social")).toObject());
        } else if (contentType == QStringLiteral("text")) {
            item = new ContentItem;
            item->setContentType(ContentItem::Text);
            item->setValue(objC.value(QStringLiteral("value")).toString());
        } else if (contentType == QStringLiteral("video")) {
            item = parseContentItemVideo(objC.value(QStringLiteral("video")).toObject());
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

    audio->setDate(QDateTime::fromString(obj.value(QStringLiteral("date")).toString(), Qt::ISODate));
    audio->setText(obj.value(QStringLiteral("text")).toString());
    audio->setTitle(obj.value(QStringLiteral("title")).toString());
    audio->setImage(obj.value(QStringLiteral("teaserImage")).toObject()
                    .value(QStringLiteral("videowebl")).toObject()
                    .value(QStringLiteral("imageurl")).toString());
    audio->setStream(obj.value(QStringLiteral("stream")).toString());

    return audio;
}

ContentItemBox *ApiInterface::parseContentItemBox(const QJsonObject &obj)
{
    auto *box = new ContentItemBox;
    box->setCopyright(obj.value(QStringLiteral("copyright")).toString());

    QString link = obj.value(QStringLiteral("link")).toString();
    box->setLinkInternal(link.contains("type=\"intern\""));
    box->setLink(link.remove("<a href=\"").mid(0, link.indexOf("\"")));

    box->setSubtitle(obj.value(QStringLiteral("subtitle")).toString());
    box->setText(obj.value(QStringLiteral("text")).toString());
    box->setTitle(obj.value(QStringLiteral("title")).toString());

    box->setImage(obj.value(QStringLiteral("images")).toObject()
                  .value(QStringLiteral("videowebl")).toObject()
                  .value(QStringLiteral("imageurl")).toString());

    return box;
}

ContentItemGallery *ApiInterface::parseContentItemGallery(const QJsonArray &arr)
{
    QList<GalleryItem *> list;
    for (const QJsonValue &x : arr) {
        const QJsonObject obj = x.toObject();

        auto *item = new GalleryItem;
        item->setCopyright(obj.value(QStringLiteral("copyright")).toString());
        item->setTitle(obj.value(QStringLiteral("title")).toString());
        item->setImage(obj.value(QStringLiteral("videowebl")).toObject()
                       .value(QStringLiteral("imageurl")).toString());

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
        item->setDate(QDateTime::fromString(obj.value(QStringLiteral("date")).toString(), Qt::ISODate));
        item->setTitle(obj.value(QStringLiteral("title")).toString());
        item->setTopline(obj.value(QStringLiteral("topline")).toString());
        item->setLink(obj.value(QStringLiteral("details")).toString());
        item->setSophoraId(obj.value(QStringLiteral("sophoraId")).toString());
        item->setImage(obj.value(QStringLiteral("teaserImage")).toObject()
                       .value(QStringLiteral("videowebl")).toObject()
                       .value(QStringLiteral("imageurl")).toString());
        item->setStream(obj.value(QStringLiteral("streams")).toObject()
                        .value(QStringLiteral("adaptivestreaming")).toString());

        const QString type = obj.value(QStringLiteral("type")).toString();

        if (type == QStringLiteral("video")) {
            item->setRelatedType(RelatedItem::RelatedVideo);
        } else if (type == QStringLiteral("webview")) {
            item->setRelatedType(RelatedItem::RelatedWebView);
            item->setLink(obj.value(QStringLiteral("detailsweb")).toString());
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

    social->setAccount(obj.value(QStringLiteral("account")).toString());
    social->setAvatar(obj.value(QStringLiteral("avatar")).toString());
    social->setDate(QDateTime::fromString(obj.value(QStringLiteral("date")).toString(), Qt::ISODate));
    social->setShorttext(obj.value(QStringLiteral("shorttext")).toString());
    social->setTitle(obj.value(QStringLiteral("title")).toString());
    social->setUrl(obj.value(QStringLiteral("url")).toString());
    social->setUsername(obj.value(QStringLiteral("username")).toString());

    social->setImage(obj.value(QStringLiteral("images")).toObject()
                     .value(QStringLiteral("mittel16x9")).toObject()
                     .value(QStringLiteral("imageurl")).toString());

    const QString type = obj.value(QStringLiteral("type")).toString();

    if (type == QStringLiteral("twitter")) {
        social->setSocialType(ContentItemSocial::Twitter);
    } else {
        social->setSocialType(ContentItemSocial::Unkown);
    }

    return social;
}

ContentItemVideo *ApiInterface::parseContentItemVideo(const QJsonObject &obj)
{
    auto *video = new ContentItemVideo;
    video->setCopyright(obj.value(QStringLiteral("copyright")).toString());
    video->setDate(QDateTime::fromString(obj.value(QStringLiteral("date")).toString(), Qt::ISODate));
    video->setTitle(obj.value(QStringLiteral("title")).toString());
    video->setImage(obj.value(QStringLiteral("teaserImage")).toObject()
                  .value(QStringLiteral("videowebl")).toObject()
                  .value(QStringLiteral("imageurl")).toString());
    video->setStream(obj.value(QStringLiteral("streams")).toObject()
                     .value(QStringLiteral("adaptivestreaming")).toString());

    return video;
}
