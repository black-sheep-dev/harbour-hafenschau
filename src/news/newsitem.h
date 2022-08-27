#ifndef NEWSITEM_H
#define NEWSITEM_H

#include <QDateTime>
#include <QJsonObject>
#include <QString>

struct NewsItem {
    QDateTime datetime;
    QString details;
    QString detailsWeb;
    QString firstSentence;
    QString shareUrl;
    QJsonObject streams;
    QString thumbnail;
    QString title;
    QString topline;
    quint8 type{0};
};

#endif // NEWSITEM_H
