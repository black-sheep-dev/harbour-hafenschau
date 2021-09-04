#include "commentssortfiltermodel.h"

#include "commentsmodel.h"

CommentsSortFilterModel::CommentsSortFilterModel(QObject *parent) :
    QSortFilterProxyModel(parent)
{
    setSortRole(CommentsModel::TimestampRole);

    connect(this, &CommentsSortFilterModel::sortOrderChanged, this, &CommentsSortFilterModel::sortModel);
}

void CommentsSortFilterModel::setPattern(const QString &pattern)
{
    m_pattern = pattern;

    invalidateFilter();
}

Qt::SortOrder CommentsSortFilterModel::sortOrder() const
{
    return m_sortOrder;
}

void CommentsSortFilterModel::setSortOrder(Qt::SortOrder sortOrder)
{
    if (m_sortOrder == sortOrder)
        return;

    m_sortOrder = sortOrder;
    emit sortOrderChanged(m_sortOrder);
}

void CommentsSortFilterModel::sortModel(Qt::SortOrder order)
{
    this->sort(0, order);
}

bool CommentsSortFilterModel::filterAcceptsRow(int source_row, const QModelIndex &source_parent) const
{
    const auto index = sourceModel()->index(source_row, 0, source_parent);

    if (!index.isValid())
        return false;

    if (sourceModel()->data(index, CommentsModel::TitleRole).toString().contains(m_pattern, Qt::CaseInsensitive)
            || sourceModel()->data(index, CommentsModel::AuthorRole).toString().contains(m_pattern, Qt::CaseInsensitive)
            || sourceModel()->data(index, CommentsModel::TextRole).toString().contains(m_pattern, Qt::CaseInsensitive)) {
        return true;
    }

    return false;
}
