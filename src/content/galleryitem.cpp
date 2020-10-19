#include "galleryitem.h"

GalleryItem::GalleryItem(QObject *parent) :
    QObject(parent)
{

}

QString GalleryItem::copyright() const
{
    return m_copyright;
}

QString GalleryItem::image() const
{
    return m_image;
}

QString GalleryItem::title() const
{
    return m_title;
}

void GalleryItem::setCopyright(const QString &copyright)
{
    if (m_copyright == copyright)
        return;

    m_copyright = copyright;
    emit copyrightChanged(m_copyright);
}

void GalleryItem::setImage(const QString &image)
{
    if (m_image == image)
        return;

    m_image = image;
    emit imageChanged(m_image);
}

void GalleryItem::setTitle(const QString &title)
{
    if (m_title == title)
        return;

    m_title = title;
    emit titleChanged(m_title);
}
