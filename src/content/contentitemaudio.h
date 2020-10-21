#ifndef CONTENTITEMAUDIO_H
#define CONTENTITEMAUDIO_H

#include "contentitem.h"

#include <QDateTime>

class ContentItemAudio : public ContentItem
{
    Q_OBJECT

    Q_PROPERTY(QDateTime date READ date WRITE setDate NOTIFY dateChanged)
    Q_PROPERTY(QString image READ image WRITE setImage NOTIFY imageChanged)
    Q_PROPERTY(QString stream READ stream WRITE setStream NOTIFY streamChanged)
    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged)
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)

public:
    explicit ContentItemAudio(QObject *parent = nullptr);

    QDateTime date() const;
    QString image() const;
    QString stream() const;
    QString text() const;
    QString title() const;

signals:
    void dateChanged(const QDateTime &date);
    void imageChanged(const QString &image);
    void streamChanged(const QString &stream);
    void textChanged(const QString &text);
    void titleChanged(const QString &title);

public slots:
    void setDate(const QDateTime &date);
    void setImage(const QString &image);
    void setStream(const QString &stream);
    void setText(const QString &text);
    void setTitle(const QString &title);

private:
    QDateTime m_date;
    QString m_image;
    QString m_stream;
    QString m_text;
    QString m_title;
};

#endif // CONTENTITEMAUDIO_H
