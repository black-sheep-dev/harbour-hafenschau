#include "contentitemvideo.h"

ContentItemVideo::ContentItemVideo(QObject *parent) :
    ContentItem(parent)
{
    setContentType(ContentItem::Video);
}

QString ContentItemVideo::copyright() const
{
    return m_copyright;
}

QDateTime ContentItemVideo::date() const
{
    return m_date;
}

QString ContentItemVideo::image() const
{
    return m_image;
}

QString ContentItemVideo::stream() const
{
    return m_stream;
}

QString ContentItemVideo::title() const
{
    return m_title;
}

void ContentItemVideo::setCopyright(const QString &copyright)
{
    if (m_copyright == copyright)
        return;

    m_copyright = copyright;
    emit copyrightChanged(m_copyright);
}

void ContentItemVideo::setDate(const QDateTime &date)
{
    if (m_date == date)
        return;

    m_date = date;
    emit dateChanged(m_date);
}

void ContentItemVideo::setImage(const QString &image)
{
    if (m_image == image)
        return;

    m_image = image;
    emit imageChanged(m_image);
}

void ContentItemVideo::setStream(const QString &stream)
{
    if (m_stream == stream)
        return;

    m_stream = stream;
    emit streamChanged(m_stream);
}

void ContentItemVideo::setTitle(const QString &title)
{
    if (m_title == title)
        return;

    m_title = title;
    emit titleChanged(m_title);
}
