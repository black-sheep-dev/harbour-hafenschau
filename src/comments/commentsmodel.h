#ifndef COMMENTSMODEL_H
#define COMMENTSMODEL_H

#include <QAbstractListModel>

#include "comment.h"

class CommentsModel : public QAbstractListModel
{
    Q_OBJECT

public:
    enum CommentRoles {
        AuthorRole                  = Qt::UserRole + 1,
        TextRole,
        TimestampRole,
        TitleRole
    };
    Q_ENUM(CommentRoles)

    explicit CommentsModel(QObject *parent = nullptr);

    Q_INVOKABLE void setComments(const QJsonArray &comments);

private:
    QList<Comment> parseComments(const QJsonArray &comments) const;

    QList<Comment> m_comments;

    // QAbstractItemModel interface
public:
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;
};

#endif // COMMENTSMODEL_H
