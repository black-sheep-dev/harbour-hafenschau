#ifndef NEWSMODEL_H
#define NEWSMODEL_H

#include <QAbstractListModel>

#include "news.h"

class NewsModel : public QAbstractListModel
{
    Q_OBJECT

    Q_PROPERTY(bool loading READ loading WRITE setLoading NOTIFY loadingChanged)
    Q_PROPERTY(QString newStoriesCountLink READ newStoriesCountLink WRITE setNewStoriesCountLink NOTIFY newStoriesCountLinkChanged)
    Q_PROPERTY(quint8 newsType READ newsType WRITE setNewsType NOTIFY newsTypeChanged)
    Q_PROPERTY(QString nextPage READ nextPage WRITE setNextPage NOTIFY nextPageChanged)

public:
    enum NewsRoles {
        BrandingImageRole       = Qt::UserRole + 1,
        BreakingNewsRole,
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
    bool loading() const;
    QString newStoriesCountLink() const;
    quint8 newsType() const;
    QString nextPage() const;

signals:
    void newsChanged();

    // properties
    void loadingChanged(bool loading);
    void newStoriesCountLinkChanged(const QString &link);
    void newsTypeChanged(quint8 newsType);
    void nextPageChanged(const QString &nextPage);

public slots:
    void setNews(const QList<News *> &newsAt);

    // properties
    void setLoading(bool loading);
    void setNewsType(quint8 newsType);
    void setNewStoriesCountLink(const QString &link);
    void setNextPage(const QString &nextPage);

private:
    QList<News *> m_news;

    // properties
    bool m_loading{false};
    QString m_newStoriesCountLink;
    quint8 m_newsType{Undefined};
    QString m_nextPage;

    // QAbstractItemModel interface
public:
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;
};

#endif // NEWSMODEL_H
