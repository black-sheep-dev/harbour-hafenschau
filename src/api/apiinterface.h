#ifndef APIINTERFACE_H
#define APIINTERFACE_H

#include <QObject>

#include <QHash>
#include <QNetworkAccessManager>
#include <QNetworkDiskCache>
#include <QNetworkReply>
#include <QNetworkRequest>

#include "apirequest.h"

class ApiInterface : public QObject
{
    Q_OBJECT
public:
    explicit ApiInterface(QNetworkAccessManager *manager, QObject *parent = nullptr);

    Q_INVOKABLE qint64 cacheSize() const;
    Q_INVOKABLE void clearCache() const;
    Q_INVOKABLE qint64 maxCacheSize() const;

public slots:
    void request(ApiRequest *request);

private slots:
    void onRequestFinished(QNetworkReply *reply);

private:
    QByteArray gunzip(const QByteArray &data);

    QNetworkAccessManager *m_manager{nullptr};
    QHash<QString, ApiRequest *> m_requests;
};

#endif // APIINTERFACE_H
