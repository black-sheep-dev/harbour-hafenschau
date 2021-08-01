#ifndef NEWSMODEL_H
#define NEWSMODEL_H

#include <QAbstractListModel>

#include "news.h"

class NewsModel : public QAbstractListModel
{
    Q_OBJECT

    Q_PROPERTY(quint16 currentPage READ currentPage WRITE setCurrentPage NOTIFY currentPageChanged)
    Q_PROPERTY(bool loading READ loading WRITE setLoading NOTIFY loadingChanged)
    Q_PROPERTY(bool loadingNextPage READ loadingNextPage WRITE setLoadingNextPage NOTIFY loadingNextPageChanged)
    Q_PROPERTY(QString newStoriesCountLink READ newStoriesCountLink WRITE setNewStoriesCountLink NOTIFY newStoriesCountLinkChanged)
    Q_PROPERTY(quint8 newsType READ newsType WRITE setNewsType NOTIFY newsTypeChanged)
    Q_PROPERTY(QString nextPage READ nextPage WRITE setNextPage NOTIFY nextPageChanged)
    Q_PROPERTY(quint16 pages READ pages WRITE setPages NOTIFY pagesChanged)


public:
    enum NewsRoles {
        BrandingImageRole       = Qt::UserRole + 1,
        BreakingNewsRole,
        CommentsRole,
        DateRole,
        DetailsRole,
        DetailsWebRole,
        FirstSentenceRole,
        HasContentRole,
        ImageRole,
        NewsTypeRole,
        PortraitRole,
        RegionRole,
        SophoraIdRole,
        ThumbnailRole,
        TitleRole,
        ToplineRole,
        SearchRole,
        StreamRole,
        RowRole
    };
    Q_ENUM(NewsRoles)

    enum NewsModelType {
        Undefined,
        Ausland,
        Homepage,
        Inland,
        Investigativ,
        Regional,
        Search,
        Sport,
        Video,
        Wirtschaft
    };
    Q_ENUM(NewsModelType)

    explicit NewsModel(QObject *parent = nullptr);

    Q_INVOKABLE bool isEmpty() const;
    QList<News *> news() const;
    Q_INVOKABLE int newsCount() const;
    Q_INVOKABLE News *newsAt(int index);
    Q_INVOKABLE News *newsById(const QString &sophoraId);

    void updateNews(News *news);

    // properties
    quint16 currentPage() const;
    bool loading() const;
    bool loadingNextPage() const;
    QString newStoriesCountLink() const;
    quint8 newsType() const;
    QString nextPage() const;
    quint16 pages() const;

signals:
    void newsChanged();

    // properties
    void currentPageChanged(quint16 page);
    void loadingChanged(bool loading);
    void loadingNextPageChanged(bool loadingNextPage);
    void newStoriesCountLinkChanged(const QString &link);
    void newsTypeChanged(quint8 newsType);
    void nextPageChanged(const QString &nextPage);

    void pagesChanged(quint16 pages);

public slots:
    void addNews(const QList<News *> &news);
    void forceRefresh();
    void setNews(const QList<News *> &news);

    Q_INVOKABLE void reset();

    // properties
    void setCurrentPage(quint16 page);
    void setLoading(bool loading);
    void setLoadingNextPage(bool loadingNextPage);
    void setNewsType(quint8 newsType);
    void setNewStoriesCountLink(const QString &link);
    void setNextPage(const QString &nextPage);
    void setPages(quint16 pages);

private:
    QList<News *> m_news;

    // properties
    quint16 m_currentPage{1};
    bool m_loading{false};
    bool m_loadingNextPage{false};
    QString m_newStoriesCountLink;
    quint8 m_newsType{Undefined};
    QString m_nextPage;
    quint16 m_pages{1};

    // QAbstractItemModel interface
public:
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;
};

#endif // NEWSMODEL_H
