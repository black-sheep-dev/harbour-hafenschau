#ifndef CONTENTITEMVIDEO_H
#define CONTENTITEMVIDEO_H

#include "contentitem.h"

#include <QDateTime>

class ContentItemVideo : public ContentItem
{
    Q_OBJECT

    Q_PROPERTY(QString copyright READ copyright WRITE setCopyright NOTIFY copyrightChanged)
    Q_PROPERTY(QDateTime date READ date WRITE setDate NOTIFY dateChanged)
    Q_PROPERTY(QString image READ image WRITE setImage NOTIFY imageChanged)
    Q_PROPERTY(QString stream READ stream WRITE setStream NOTIFY streamChanged)
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)

public:
    explicit ContentItemVideo(QObject *parent = nullptr);

    QString copyright() const;
    QDateTime date() const;
    QString image() const;
    QString stream() const;
    QString title() const;

signals:
    void copyrightChanged(const QString &copyright);
    void dateChanged(const QDateTime &date);
    void imageChanged(const QString &image);
    void streamChanged(const QString &stream);
    void titleChanged(const QString &title);

public slots:
    void setCopyright(const QString &copyright);
    void setDate(const QDateTime &date);
    void setImage(const QString &image);
    void setStream(const QString &stream);
    void setTitle(const QString &title);

private:
    QString m_copyright;
    QDateTime m_date;
    QString m_image;
    QString m_stream;
    QString m_title;
};

#endif // CONTENTITEMVIDEO_H
