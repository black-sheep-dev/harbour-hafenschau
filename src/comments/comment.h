#ifndef COMMENT_H
#define COMMENT_H

#include <QDateTime>
#include <QMetaType>
#include <QString>

struct Comment {
    QString author;
    QString text;
    QDateTime timestamp;
    QString title;

    Comment() = default;
    bool operator==(const Comment &other) {
        return author == other.author
                && text == other.text
                && timestamp == other.timestamp
                && title == other.title;

    }
    bool operator!=(const Comment &other) {
        return !(*this == other);
    }

};
Q_DECLARE_METATYPE(Comment)


#endif // COMMENT_H
