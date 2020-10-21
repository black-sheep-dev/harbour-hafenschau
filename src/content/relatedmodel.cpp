#include "relatedmodel.h"

RelatedModel::RelatedModel(QObject *parent) :
    QAbstractListModel(parent)
{

}

RelatedItem *RelatedModel::itemAt(int index)
{
    if (index < 0 || index >= m_items.count())
        return nullptr;

    return m_items.at(index);
}

int RelatedModel::itemsCount() const
{
    return m_items.count();
}

void RelatedModel::addItem(RelatedItem *item)
{
    if (!item)
        return;

    beginInsertRows(QModelIndex(), m_items.count(), m_items.count());
    item->setParent(this);
    m_items.append(item);
    endInsertRows();
}

void RelatedModel::setItems(const QList<RelatedItem *> &items)
{
    beginResetModel();
    qDeleteAll(m_items.begin(), m_items.end());
    m_items.clear();

    for (auto *item : items) {
        if (!item)
            continue;

        item->setParent(this);
        m_items.append(item);
    }
    endResetModel();
}

int RelatedModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);

    return m_items.count();
}

QVariant RelatedModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    const auto *item = m_items.at(index.row());

    switch (role) {
    case ToplineRole:
        return item->topline();

    case TitleRole:
        return item->title();

    case ImageRole:
        return item->image();

    case LinkRole:
        return item->link();

    case DateRole:
        return item->date();

    case RelatedType:
        return item->relatedType();

    case SophoraIdRole:
        return item->sophoraId();

    case StreamRole:
        return item->stream();

    default:
        return QVariant();
    }
}

QHash<int, QByteArray> RelatedModel::roleNames() const
{
    QHash<int, QByteArray> roles;

    roles[DateRole]             = "date";
    roles[ImageRole]            = "image";
    roles[LinkRole]             = "link";
    roles[RelatedType]          = "related_type";
    roles[SophoraIdRole]        = "sophora_id";
    roles[StreamRole]           = "stream";
    roles[TitleRole]            = "title";
    roles[ToplineRole]          = "topline";

    return roles;
}
