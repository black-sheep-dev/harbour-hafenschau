#include "newssortfiltermodel.h"

#include "newslistmodel.h"

NewsSortFilterModel::NewsSortFilterModel(QObject *parent) :
    QSortFilterProxyModel(parent)
{
    setFilterRole(NewsListModel::SearchRole);
}

int NewsSortFilterModel::sourceIndex(const QModelIndex &index) const
{
    return mapToSource(index).row();
}
