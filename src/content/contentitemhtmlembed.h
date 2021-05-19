#ifndef CONTENTITEMHTMLEMBED_H
#define CONTENTITEMHTMLEMBED_H

#include "contentitem.h"

class ContentItemHtmlEmbed : public ContentItem
{
    Q_OBJECT

    Q_PROPERTY(bool available READ available WRITE setAvailable NOTIFY availableChanged)
    Q_PROPERTY(QString image READ image WRITE setImage NOTIFY imageChanged)
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)

public:
    explicit ContentItemHtmlEmbed(QObject *parent = nullptr);

    bool available() const;
    QString image() const;
    QString title() const;

signals:
    void availableChanged(bool available);
    void imageChanged(const QString &image);
    void titleChanged(const QString &title);

public slots:
    void setAvailable(bool available);
    void setImage(const QString &image);
    void setTitle(const QString &title);

private:
    bool m_available{true};
    QString m_image;
    QString m_title;

};

#endif // CONTENTITEMHTMLEMBED_H
