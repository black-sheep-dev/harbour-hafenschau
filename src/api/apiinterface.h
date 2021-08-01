#ifndef APIINTERFACE_H
#define APIINTERFACE_H

#include <QObject>

static const QString HAFENSCHAU_API_URL                         = QStringLiteral("https://www.tagesschau.de/api2/");
static const QString HAFENSCHAU_API_ENDPOINT_NEWS               = QStringLiteral("news/");
static const QString HAFENSCHAU_API_ENDPOINT_HOMEPAGE           = QStringLiteral("homepage/");
static const QString HAFENSCHAU_API_ENDPOINT_INDEX_FEED_COUNT   = QStringLiteral("https://www.tagesschau.de/api2/indexfeedcount");

#include <QNetworkAccessManager>
#include <QNetworkDiskCache>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QQueue>

#include "src/comments/commentsmodel.h"
#include "src/news/news.h"
#include "src/news/newsmodel.h"

class ApiInterface : public QObject
{
    Q_OBJECT

public:
    explicit ApiInterface(QObject *parent = nullptr);

    void enableDeveloperMode(bool enable = true);

    QList<int> activeRegions() const;
    quint64 cacheSize() const;
    void clearCache();
    void getNextPage(quint8 newsType);
    NewsModel *newsModel(quint8 newsType = NewsModel::Homepage);

signals:
    void error(quint16 error);

    void breakingNewsAvailable(News *news);
    void commentsModelAvailable(CommentsModel *model);
    void htmlEmbedAvailable(const QString &url, const QString &image, const QString &title);
    void internalLinkAvailable(News *news);

public slots:
    void getComments(const QString &link);
    void getInteralLink(const QString &link);
    void getHtmlEmbed(const QString &link);
    void checkForUpdate(News *news);
    void refresh(quint8 newsType, bool complete = false);
    void refreshNews(News *news);
    void setActiveRegions(const QList<int> &regions);
    void searchContent(const QString &pattern, quint16 page = 1);

private slots:
    void onCheckForUpdateFinished();
    void onCommentsAvailable();
    void onCommentsMetaLinkAvailable();
    void onHtmlEmbedRequestFinished();
    void onInternalLinkRequestFinished();
    void onNewsRefreshFinished();
    void onNewsRequestFinished();
    void onNewStoriesCountRequestFinished();

private:
    QString activeRegionsAsString() const;
    QByteArray getReplyData(QNetworkReply *reply);
    QNetworkRequest getRequest(const QString &endpoint = QString(), bool cached = true);
    QByteArray gunzip(const QByteArray &data);

    // API helper
    void getNews(quint8 newsType);
    void getNewStoriesCount(NewsModel *model);

    // parsing
    QJsonDocument parseJson(const QByteArray &data);
    News *parseNews(const QJsonObject &obj, News *news = nullptr);
    ContentItemAudio *parseContentItemAudio(const QJsonObject &obj);
    ContentItemBox *parseContentItemBox(const QJsonObject &obj);
    ContentItemGallery *parseContentItemGallery(const QJsonArray &arr);
    ContentItemList *parseContentItemList(const QJsonObject &obj);
    ContentItemRelated *parseContentItemRelated(const QJsonArray &arr);
    ContentItemSocial *parseContentItemSocial(const QJsonObject &obj);
    ContentItemVideo *parseContentItemVideo(const QJsonObject &obj);
    bool newNewsAvailable(const QJsonObject &obj);


    QList<int> m_activeRegions;
    QNetworkDiskCache *m_cache{new QNetworkDiskCache(this)};
    bool m_developerMode{false};
    QNetworkAccessManager *m_manager{new QNetworkAccessManager(this)};
    QHash<quint8, NewsModel *> m_newsModels;
    QHash<QString, News *> m_pendingNews;
};

#endif // APIINTERFACE_H
