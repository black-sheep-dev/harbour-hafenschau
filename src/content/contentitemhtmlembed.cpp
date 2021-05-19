#include "contentitemhtmlembed.h"

ContentItemHtmlEmbed::ContentItemHtmlEmbed(QObject *parent) :
    ContentItem(parent)
{

}

bool ContentItemHtmlEmbed::available() const
{
    return m_available;
}

QString ContentItemHtmlEmbed::image() const
{
    return m_image;
}

QString ContentItemHtmlEmbed::title() const
{
    return m_title;
}

void ContentItemHtmlEmbed::setAvailable(bool available)
{
    if (m_available == available)
        return;

    m_available = available;
    emit availableChanged(m_available);
}

void ContentItemHtmlEmbed::setImage(const QString &image)
{
    if (m_image == image)
        return;

    m_image = image;
    emit imageChanged(m_image);
}

void ContentItemHtmlEmbed::setTitle(const QString &title)
{
    if (m_title == title)
        return;

    m_title = title;
    emit titleChanged(m_title);
}
