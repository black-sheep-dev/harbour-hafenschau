#include "contentitemaudio.h"

ContentItemAudio::ContentItemAudio(QObject *parent) :
    ContentItem(parent)
{
    setContentType(ContentItem::Audio);
}

QDateTime ContentItemAudio::date() const
{
    return m_date;
}

QString ContentItemAudio::image() const
{
    return m_image;
}

QString ContentItemAudio::stream() const
{
    return m_stream;
}

QString ContentItemAudio::text() const
{
    return m_text;
}

QString ContentItemAudio::title() const
{
    return m_title;
}

void ContentItemAudio::setDate(const QDateTime &date)
{
    if (m_date == date)
        return;

    m_date = date;
    emit dateChanged(m_date);
}

void ContentItemAudio::setImage(const QString &image)
{
    if (m_image == image)
        return;

    m_image = image;
    emit imageChanged(m_image);
}

void ContentItemAudio::setStream(const QString &stream)
{
    if (m_stream == stream)
        return;

    m_stream = stream;
    emit streamChanged(m_stream);
}

void ContentItemAudio::setText(const QString &text)
{
    if (m_text == text)
        return;

    m_text = text;
    emit textChanged(m_text);
}

void ContentItemAudio::setTitle(const QString &title)
{
    if (m_title == title)
        return;

    m_title = title;
    emit titleChanged(m_title);
}
