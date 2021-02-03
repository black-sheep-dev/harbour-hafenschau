#include "commentsmodel.h"

CommentsModel::CommentsModel(QObject *parent) :
    QAbstractListModel(parent)
{

}

void CommentsModel::setComments(const QList<Comment> &comments)
{
    beginResetModel();
    m_comments.clear();
    m_comments = comments;
    endResetModel();
}

bool CommentsModel::closed() const
{
    return m_closed;
}

void CommentsModel::setClosed(bool closed)
{
    if (m_closed == closed)
        return;

    m_closed = closed;
    emit closedChanged(m_closed);
}

int CommentsModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)

    return m_comments.count();
}

QVariant CommentsModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    const auto comment = m_comments.at(index.row());

    switch (role) {
    case AuthorRole:
        return comment.author;

    case TextRole:
        return comment.text;

    case TimestampRole:
        return comment.timestamp;

    case TitleRole:
        return comment.title;

    default:
        return QVariant();
    }
}

QHash<int, QByteArray> CommentsModel::roleNames() const
{
    QHash<int, QByteArray> roles;

    roles[AuthorRole]       = "author";
    roles[TextRole]         = "text";
    roles[TimestampRole]    = "timestamp";
    roles[TitleRole]        = "title";

    return roles;
}
