#include "commentssortfiltermodel.h"

#include "commentsmodel.h"

CommentsSortFilterModel::CommentsSortFilterModel(QObject *parent) :
    QSortFilterProxyModel(parent)
{
    setSortRole(CommentsModel::TimestampRole);
}

void CommentsSortFilterModel::setPattern(const QString &pattern)
{
    m_pattern = pattern;

    invalidateFilter();
}

void CommentsSortFilterModel::sortModel(Qt::SortOrder order)
{
    sort(order);
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
