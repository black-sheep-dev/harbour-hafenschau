#ifndef COMMENTSMODEL_H
#define COMMENTSMODEL_H

#include <QAbstractListModel>

#include "comment.h"

class CommentsModel : public QAbstractListModel
{
    Q_OBJECT

    Q_PROPERTY(bool closed READ closed WRITE setClosed NOTIFY closedChanged)

public:
    enum CommentRoles {
        AuthorRole                  = Qt::UserRole + 1,
        TextRole,
        TimestampRole,
        TitleRole
    };
    Q_ENUM(CommentRoles)

    explicit CommentsModel(QObject *parent = nullptr);

    void setComments(const QList<Comment> &comments);

    // properties
    bool closed() const;

signals:
    // properties
    void closedChanged(bool closed);

public slots:
    // properties
    void setClosed(bool closed);

private:
    QList<Comment> m_comments;

    // properties
    bool m_closed{false};

    // QAbstractItemModel interface
public:
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;
};

#endif // COMMENTSMODEL_H
