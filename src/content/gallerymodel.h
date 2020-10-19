#ifndef GALLERYMODEL_H
#define GALLERYMODEL_H

#include <QAbstractListModel>

#include "galleryitem.h"

class GalleryModel : public QAbstractListModel
{
    Q_OBJECT

public:
    enum GalleryItemRoles {
        CopyrightRole,
        ImageRole,
        TitleRole
    };
    Q_ENUM(GalleryItemRoles)

    explicit GalleryModel(QObject *parent = nullptr);

    Q_INVOKABLE GalleryItem *itemAt(int index);
    void addItem(GalleryItem *item);
    void setItems(const QList<GalleryItem *> &items);

private:
    QList<GalleryItem *> m_items;

    // QAbstractItemModel interface
public:
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;
};

#endif // GALLERYMODEL_H
