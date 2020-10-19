#include "contentitembox.h"

ContentItemBox::ContentItemBox(QObject *parent) :
    ContentItem(parent)
{
    setContentType(ContentItem::Box);
}

QString ContentItemBox::copyright() const
{
    return m_copyright;
}

QString ContentItemBox::image() const
{
    return m_image;
}

QString ContentItemBox::link() const
{
    return m_link;
}

bool ContentItemBox::linkInternal() const
{
    return m_linkInternal;
}

QString ContentItemBox::subtitle() const
{
    return m_subtitle;
}

QString ContentItemBox::text() const
{
    return m_text;
}

QString ContentItemBox::title() const
{
    return m_title;
}

void ContentItemBox::setCopyright(const QString &copyright)
{
    if (m_copyright == copyright)
        return;

    m_copyright = copyright;
    emit copyrightChanged(m_copyright);
}

void ContentItemBox::setImage(const QString &image)
{
    if (m_image == image)
        return;

    m_image = image;
    emit imageChanged(m_image);
}

void ContentItemBox::setLink(const QString &link)
{
    if (m_link == link)
        return;

    m_link = link;
    emit linkChanged(m_link);
}

void ContentItemBox::setLinkInternal(bool linkInternal)
{
    if (m_linkInternal == linkInternal)
        return;

    m_linkInternal = linkInternal;
    emit linkInternalChanged(m_linkInternal);
}

void ContentItemBox::setSubtitle(const QString &subtitle)
{
    if (m_subtitle == subtitle)
        return;

    m_subtitle = subtitle;
    emit subtitleChanged(m_subtitle);
}

void ContentItemBox::setText(const QString &text)
{
    if (m_text == text)
        return;

    m_text = text;
    emit textChanged(m_text);
}

void ContentItemBox::setTitle(const QString &title)
{
    if (m_title == title)
        return;

    m_title = title;
    emit titleChanged(m_title);
}
