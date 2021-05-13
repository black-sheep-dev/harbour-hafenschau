#ifndef CONTENTITEMHTMLEMBED_H
#define CONTENTITEMHTMLEMBED_H

#include "contentitem.h"

class ContentItemHtmlEmbed : public ContentItem
{
    Q_OBJECT

    Q_PROPERTY(QString image READ image WRITE setImage NOTIFY imageChanged)
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)

public:
    explicit ContentItemHtmlEmbed(QObject *parent = nullptr);

    QString image() const;
    QString title() const;

signals:
    void imageChanged(const QString &image);
    void titleChanged(const QString &title);

public slots:
    void setImage(const QString &image);
    void setTitle(const QString &title);

private:
    QString m_image;
    QString m_title;
};

#endif // CONTENTITEMHTMLEMBED_H
