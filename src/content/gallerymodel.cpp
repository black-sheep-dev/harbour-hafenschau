#include "gallerymodel.h"

GalleryModel::GalleryModel(QObject *parent) :
    QAbstractListModel(parent)
{

}

GalleryItem *GalleryModel::itemAt(int index)
{
    if (index < 0 || index >= m_items.count())
        return nullptr;

    return m_items.at(index);
}

void GalleryModel::addItem(GalleryItem *item)
{
    if (item == nullptr)
        return;

    beginInsertRows(QModelIndex(), m_items.count(), m_items.count());
    item->setParent(this);
    m_items.append(item);
    endInsertRows();
}

void GalleryModel::setItems(const QList<GalleryItem *> &items)
{
    beginResetModel();
    qDeleteAll(m_items.begin(), m_items.end());
    m_items.clear();

    for (auto *item : items) {
        if (item == nullptr)
            continue;

        item->setParent(this);
        m_items.append(item);
    }
    endResetModel();
}

int GalleryModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)

    return  m_items.count();
}

QVariant GalleryModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    const auto *item = m_items.at(index.row());

    switch (role) {
    case CopyrightRole:
        return item->copyright();

    case ImageRole:
        return item->image();

    case TitleRole:
        return item->title();

    default:
        return QVariant();
    }
}

QHash<int, QByteArray> GalleryModel::roleNames() const
{
    QHash<int, QByteArray> roles;

    roles[CopyrightRole]    = "copyright";
    roles[ImageRole]        = "image";
    roles[TitleRole]        = "title";

    return roles;
}
