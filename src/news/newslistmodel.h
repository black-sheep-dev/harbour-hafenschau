#ifndef NEWSLISTMODEL_H
#define NEWSLISTMODEL_H

#include <QAbstractListModel>

#include "newsitem.h"

class NewsListModel : public QAbstractListModel
{
    Q_OBJECT

public:
    enum NewsItemRoles {
        DatetimeRole        = Qt::UserRole + 1,
        DetailsRole,
        DetailsWebRole,
        FirstSentenceRole,
        StreamsRole,
        ThumbnailRole,
        TitleRole,
        ToplineRole,
        TypeRole,
        SearchRole
    };
    Q_ENUM(NewsItemRoles)

    explicit NewsListModel(QObject *parent = nullptr);
    ~NewsListModel() override;

    Q_INVOKABLE QString newsDetails(int index) const;
    Q_INVOKABLE void addItems(const QJsonArray &items);
    Q_INVOKABLE void setItems(const QJsonArray &items);

public slots:
    void clear();
    void refresh();

private:
    QList<NewsItem> parseItems(const QJsonArray &items);

    QList<NewsItem> m_items;


    // QAbstractItemModel interface
public:
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;
};

#endif // NEWSLISTMODEL_H
