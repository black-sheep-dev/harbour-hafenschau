#ifndef RELATEDMODEL_H
#define RELATEDMODEL_H

#include <QAbstractListModel>

#include "relateditem.h"

class RelatedModel : public QAbstractListModel
{
    Q_OBJECT

public:
    enum RelatedItemRoles {
        DateRole        = Qt::UserRole + 1,
        ImageRole,
        LinkRole,

        SophoraIdRole,
        TitleRole,
        ToplineRole
    };
    Q_ENUM(RelatedItemRoles)

    explicit RelatedModel(QObject *parent = nullptr);

    Q_INVOKABLE RelatedItem *itemAt(int index);
    Q_INVOKABLE int itemsCount() const;
    void addItem(RelatedItem *item);
    void setItems(const QList<RelatedItem *> &items);

private:
    QList<RelatedItem *> m_items;

    // QAbstractItemModel interface
public:
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;
};

#endif // RELATEDMODEL_H
