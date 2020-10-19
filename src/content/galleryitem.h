#ifndef GALLERYITEM_H
#define GALLERYITEM_H

#include <QObject>

class GalleryItem : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString copyright READ copyright WRITE setCopyright NOTIFY copyrightChanged)
    Q_PROPERTY(QString image READ image WRITE setImage NOTIFY imageChanged)
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)

public:
    explicit GalleryItem(QObject *parent = nullptr);

    QString copyright() const;
    QString image() const;
    QString title() const;

signals:
    void copyrightChanged(const QString &copyright);
    void imageChanged(const QString &image);
    void titleChanged(const QString &title);

public slots:
    void setCopyright(const QString &copyright);
    void setImage(const QString &image);
    void setTitle(const QString &title);

private:
    QString m_copyright;
    QString m_image;
    QString m_title;
};

#endif // GALLERYITEM_H
