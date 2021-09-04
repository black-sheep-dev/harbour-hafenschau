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
    explicit ApiInterface(QObject *parent = nullptr);

    Q_INVOKABLE quint64 cacheSize();
    Q_INVOKABLE void clearCache();

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

    QNetworkDiskCache *m_cache{new QNetworkDiskCache(this)};
    QNetworkAccessManager *m_manager{new QNetworkAccessManager(this)};
};

#endif // APIINTERFACE_H
