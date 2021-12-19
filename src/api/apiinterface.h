#ifndef APIINTERFACE_H
#define APIINTERFACE_H

#include <QObject>

#include <QNetworkAccessManager>
#include <QNetworkDiskCache>
#include <QNetworkReply>
#include <QNetworkRequest>

class ApiInterface : public QObject
{
    Q_OBJECT
public:
    explicit ApiInterface(QNetworkAccessManager *manager, QObject *parent = nullptr);

    Q_INVOKABLE qint64 cacheSize() const;
    Q_INVOKABLE void clearCache() const;
    Q_INVOKABLE qint64 maxCacheSize() const;

signals:
    void requestFinished(const QString &id, const QJsonObject &data);
    void requestFinishedWithRawData(const QString &id, const QString &data);
    void requestFailed(const QString &id, int error = 0);

public slots:
    void request(const QString &query, const QString &id, bool cached = true);

private slots:
    void onRequestFinished(QNetworkReply *reply);

private:
    QByteArray gunzip(const QByteArray &data);

    //QNetworkDiskCache *m_cache{new QNetworkDiskCache(this)};
    QNetworkAccessManager *m_manager{nullptr};
};

#endif // APIINTERFACE_H
