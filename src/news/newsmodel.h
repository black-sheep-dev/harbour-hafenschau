#ifndef NEWSMODEL_H
#define NEWSMODEL_H

#include <QAbstractListModel>

#include "news.h"

class NewsModel : public QAbstractListModel
{
    Q_OBJECT

public:
    enum NewsRoles {
        BrandingImageRole       = Qt::UserRole + 1,
        BreakingNewsRole,
        DateRole,
        FirstSentenceRole,
        ImageRole,
        NewsTypeRole,
        PortraitRole,
        RegionRole,
        SophoraIdRole,
        ThumbnailRole,
        TitleRole,
        ToplineRole,
        SearchRole,
        RowRole
    };
    Q_ENUM(NewsRoles)

    explicit NewsModel(QObject *parent = nullptr);

    Q_INVOKABLE bool isEmpty() const;
    QList<News *> news() const;
    Q_INVOKABLE int newsCount() const;
    Q_INVOKABLE News *newsAt(int index);
    Q_INVOKABLE News *newsById(const QString &sophoraId);

    void updateNews(News *news);

signals:
    void newsChanged();

public slots:
    void setNews(const QList<News *> &newsAt);

private:
    QList<News *> m_news;

    // QAbstractItemModel interface
public:
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;
};

#endif // NEWSMODEL_H
