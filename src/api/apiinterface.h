#ifndef APIINTERFACE_H
#define APIINTERFACE_H

#define     HAFENSCHAU_API_URL                  "https://www.tagesschau.de/api2/"
#define     HAFENSCHAU_API_ENDPOINT_HOMEPAGE    "homepage/"

#include <QObject>

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>

#include "src/news/news.h"

class ApiInterface : public QObject
{
    Q_OBJECT

public:
    explicit ApiInterface(QObject *parent = nullptr);

    void enableDeveloperMode(bool enable = true);

signals:
    void internalLinkAvailable(News *news);
    void newsAvailable(const QList<News *> &news);

public slots:
    void refresh();
    void getInteralLink(const QString &link);

private slots:
    void onRequestFinished(QNetworkReply *reply);

private:
    QNetworkRequest getRequest(const QString &endpoint = QString());
    QByteArray gunzip(const QByteArray &data);

    News *parseNews(const QJsonObject &obj);
    ContentItemAudio *parseContentItemAudio(const QJsonObject &obj);
    ContentItemBox *parseContentItemBox(const QJsonObject &obj);
    ContentItemGallery *parseContentItemGallery(const QJsonArray &arr);
    ContentItemRelated *parseContentItemRelated(const QJsonArray &arr);
    ContentItemSocial *parseContentItemSocial(const QJsonObject &obj);
    ContentItemVideo *parseContentItemVideo(const QJsonObject &obj);

    bool m_developerMode{false};
    QNetworkAccessManager *m_manager;
};

#endif // APIINTERFACE_H
