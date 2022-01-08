#include "apiinterface.h"

#ifdef QT_DEBUG
#include <QDebug>
#endif

#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonParseError>
#include <QStandardPaths>

#include <zlib.h>

ApiInterface::ApiInterface(QNetworkAccessManager *manager, QObject *parent) :
    QObject(parent),
    m_manager(manager)
{
    m_manager->setParent(this);

    connect(m_manager, &QNetworkAccessManager::finished, this, &ApiInterface::onRequestFinished);
}

qint64 ApiInterface::cacheSize() const
{
    return m_manager->cache()->cacheSize();
}

void ApiInterface::clearCache() const
{
    m_manager->cache()->clear();
}

qint64 ApiInterface::maxCacheSize() const
{
    return qobject_cast<QNetworkDiskCache *>(m_manager->cache())->maximumCacheSize();
}

void ApiInterface::request(const QString &query, const QString &id, bool cached)
{
#ifdef QT_DEBUG
    qDebug() << "REQUEST";
    qDebug() << "QUERY: " << query;
    qDebug() << "ID: " << id;
    qDebug() << "CACHED: " << cached;
#endif

    QNetworkRequest request(query);

    if (cached) {
        request.setAttribute(QNetworkRequest::CacheLoadControlAttribute, QNetworkRequest::PreferCache);
    } else {
        request.setRawHeader("Cache-Control", "no-cache");
    }

    request.setRawHeader("User-Agent", "Mozilla/5.0 (X11; Linux x86_64; rv:80.0) Gecko/20100101 Firefox/80.0");
    request.setRawHeader("Accept", "application/json");
    request.setRawHeader("Connection", "keep-alive");
    request.setRawHeader("Accept-Encoding", "gzip");

    request.setSslConfiguration(QSslConfiguration::defaultConfiguration());

    auto reply = m_manager->get(request);
    reply->setProperty("id", id);
}

void ApiInterface::onRequestFinished(QNetworkReply *reply)
{
#ifdef QT_DEBUG
    qDebug() << QStringLiteral("REQUEST FINISHED");
#endif

    if (reply == nullptr)
        return;

    // read request id
    const QString id = reply->property("id").toString();

    // check if an error occured
    if (reply->error()) {
        emit requestFailed(id, reply->error());
        reply->deleteLater();
        return;
    }

    // read and unzip data
    const auto data = gunzip(reply->readAll());

    // delete reply
    reply->deleteLater();

    // parse data
    QJsonParseError error{};

    const QJsonObject obj = QJsonDocument::fromJson(data, &error).object();

    if (error.error) {
#ifdef QT_DEBUG
        qDebug() << QStringLiteral("JSON parse error");
#endif
        emit requestFinishedWithRawData(id, data);
        return;
    }

    emit requestFinished(id, obj);
}

QByteArray ApiInterface::gunzip(const QByteArray &data)
{
    if (data.size() <= 4) {
        return data;
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
        return data;

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
            return data;
        }

        result.append(out, CHUNK_SIZE - strm.avail_out);
    } while (strm.avail_out == 0);

    // clean up and return
    inflateEnd(&strm);
    return result;
}
