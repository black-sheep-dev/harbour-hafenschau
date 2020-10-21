#include "newssortfiltermodel.h"

NewsSortFilterModel::NewsSortFilterModel(QObject *parent) :
    QSortFilterProxyModel(parent)
{
    setFilterRole(NewsModel::SearchRole);
}

int NewsSortFilterModel::sourceIndex(const QModelIndex &index) const
{
    return mapToSource(index).row();
}
