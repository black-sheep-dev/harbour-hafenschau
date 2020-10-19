#ifndef CONTENTITEMBOX_H
#define CONTENTITEMBOX_H

#include "contentitem.h"

class ContentItemBox : public ContentItem
{
    Q_OBJECT

    Q_PROPERTY(QString copyright READ copyright WRITE setCopyright NOTIFY copyrightChanged)
    Q_PROPERTY(QString image READ image WRITE setImage NOTIFY imageChanged)
    Q_PROPERTY(QString link READ link WRITE setLink NOTIFY linkChanged)
    Q_PROPERTY(bool linkInternal READ linkInternal WRITE setLinkInternal NOTIFY linkInternalChanged)
    Q_PROPERTY(QString subtitle READ subtitle WRITE setSubtitle NOTIFY subtitleChanged)
    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged)
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)

public:
    explicit ContentItemBox(QObject *parent = nullptr);

    QString copyright() const;
    QString image() const;
    QString link() const;
    bool linkInternal() const;
    QString subtitle() const;
    QString text() const;
    QString title() const;

signals:
    void copyrightChanged(const QString &copyright);
    void imageChanged(const QString &image);
    void linkChanged(const QString &link);
    void linkInternalChanged(bool linkInternal);
    void subtitleChanged(const QString &subtitle);
    void textChanged(const QString &text);
    void titleChanged(const QString &title);

public slots:
    void setCopyright(const QString &copyright);
    void setImage(const QString &image);
    void setLink(const QString &link);
    void setLinkInternal(bool linkInternal);
    void setSubtitle(const QString &subtitle);
    void setText(const QString &text);
    void setTitle(const QString &title);

private:
    QString m_copyright;
    QString m_image;
    QString m_link;
    bool m_linkInternal{false};
    QString m_subtitle;
    QString m_text;
    QString m_title;   
};

#endif // CONTENTITEMBOX_H
