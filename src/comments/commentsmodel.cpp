#include "commentsmodel.h"

#include <QJsonArray>
#include <QJsonObject>

CommentsModel::CommentsModel(QObject *parent) :
    QAbstractListModel(parent)
{

}

void CommentsModel::setComments(const QJsonArray &comments)
{
    beginResetModel();
    m_comments.clear();
    m_comments = parseComments(comments);
    endResetModel();
}

QList<Comment> CommentsModel::parseComments(const QJsonArray &comments) const
{
    QList<Comment> list;

    for (const auto &v : comments) {
        const auto obj = v.toObject();

        if (obj.isEmpty())
            continue;

        Comment comment;
        comment.author = obj.value("Benutzer").toString();
        comment.text = obj.value("Kommentar").toString();
        comment.timestamp = QDateTime::fromString(obj.value("Beitragsdatum").toString(), Qt::ISODate);
        comment.title = obj.value("Titel").toString();

        list.append(comment);
    }

    return list;
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
