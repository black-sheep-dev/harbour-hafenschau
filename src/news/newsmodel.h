#ifndef NEWSMODEL_H
#define NEWSMODEL_H

#include <QAbstractListModel>

#include "news.h"

class NewsModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum NewsRoles {
        BreakingNewsRole            = Qt::UserRole + 1,
        DateRole,
        FirstSentenceRole,
        ImageRole,
        RegionRole,
        SophoraIdRole,
        ThumbnailRole,
        TitleRole,
        ToplineRole
    };
    Q_ENUMS(NewsRoles)

    explicit NewsModel(QObject *parent = nullptr);

    Q_INVOKABLE int newsCount() const;
    Q_INVOKABLE News *newsAt(const int index);

public slots:
    void setNews(const QList<News *> newsAt);

private:
    QList<News *> m_news;

    // QAbstractItemModel interface
public:
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;

    // QAbstractItemModel interface
public:
    QHash<int, QByteArray> roleNames() const override;
};

#endif // NEWSMODEL_H
