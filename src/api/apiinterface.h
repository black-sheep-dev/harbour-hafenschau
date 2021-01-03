#ifndef APIINTERFACE_H
#define APIINTERFACE_H

#define     HAFENSCHAU_API_URL                          "https://www.tagesschau.de/api2/"
#define     HAFENSCHAU_API_ENDPOINT_REGIONAL_NEWS       "news/"
#define     HAFENSCHAU_API_ENDPOINT_HOMEPAGE            "homepage/"
#define     HAFENSCHAU_API_ENDPOINT_INDEX_FEED_COUNT    "https://www.tagesschau.de/api2/indexfeedcount"

#include <QObject>

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QQueue>

#include "src/news/news.h"
#include "src/news/newsmodel.h"

class ApiInterface : public QObject
{
    Q_OBJECT

public:
    explicit ApiInterface(QObject *parent = nullptr);

    void enableDeveloperMode(bool enable = true);

    QList<int> activeRegions() const;
    NewsModel *newsModel();

signals:
    void internalLinkAvailable(News *news);
    void newsAvailable(const QList<News *> &news);
    void regionalNewsAvailable(const QList<News *> &news);

public slots:
    void refresh();
    void getInteralLink(const QString &link);
    void setActiveRegions(const QList<int> &regions);

private slots:
    void onHomepageRequestFinished();
    void onInternalLinkRequestFinished();
    void onNewStoriesCountRequestFinished();
    void onUpdateCheckRequestFinished();
    void onUpdateNewsRequestFinished();

private:
    QByteArray getReplyData(QNetworkReply *reply);
    QNetworkRequest getRequest(const QString &endpoint = QString());
    QByteArray gunzip(const QByteArray &data);

    void checkForNewsUpdate(const QString &url);
    void getHomepage();
    void getNewsUpdates();
    void getNewStoriesCount();
    QJsonDocument parseJson(const QByteArray &data);
    News *parseNews(const QJsonObject &obj);
    ContentItemAudio *parseContentItemAudio(const QJsonObject &obj);
    ContentItemBox *parseContentItemBox(const QJsonObject &obj);
    ContentItemGallery *parseContentItemGallery(const QJsonArray &arr);
    ContentItemRelated *parseContentItemRelated(const QJsonArray &arr);
    ContentItemSocial *parseContentItemSocial(const QJsonObject &obj);
    ContentItemVideo *parseContentItemVideo(const QJsonObject &obj);
    bool newNewsAvailable(const QJsonObject &obj);
    void updateNews(const QString &url);

    QList<int> m_activeRegions;
    bool m_developerMode{false};
    QNetworkAccessManager *m_manager;
    NewsModel *m_newsModel{nullptr};
    QString m_newStoriesCountLink;

};

#endif // APIINTERFACE_H
