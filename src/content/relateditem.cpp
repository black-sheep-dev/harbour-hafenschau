#include "relateditem.h"

RelatedItem::RelatedItem(QObject *parent) :
    QObject(parent)
{

}

QDateTime RelatedItem::date() const
{
    return m_date;
}

QString RelatedItem::image() const
{
    return m_image;
}

QString RelatedItem::link() const
{
    return m_link;
}

quint8 RelatedItem::relatedType() const
{
    return m_relatedType;
}

QString RelatedItem::sophoraId() const
{
    return m_sophoraId;
}

QString RelatedItem::stream() const
{
    return m_stream;
}

QString RelatedItem::title() const
{
    return m_title;
}

QString RelatedItem::topline() const
{
    return m_topline;
}

void RelatedItem::setDate(const QDateTime &date)
{
    if (m_date == date)
        return;

    m_date = date;
    emit dateChanged(m_date);
}

void RelatedItem::setImage(const QString &image)
{
    if (m_image == image)
        return;

    m_image = image;
    emit imageChanged(m_image);
}

void RelatedItem::setLink(const QString &link)
{
    if (m_link == link)
        return;

    m_link = link;
    emit linkChanged(m_link);
}

void RelatedItem::setRelatedType(quint8 relatedType)
{
    if (m_relatedType == relatedType)
        return;

    m_relatedType = relatedType;
    emit relatedTypeChanged(m_relatedType);
}

void RelatedItem::setSophoraId(const QString &sophoraId)
{
    if (m_sophoraId == sophoraId)
        return;

    m_sophoraId = sophoraId;
    emit sophoraIdChanged(m_sophoraId);
}

void RelatedItem::setStream(const QString &stream)
{
    if (m_stream == stream)
        return;

    m_stream = stream;
    emit streamChanged(m_stream);
}

void RelatedItem::setTitle(const QString &title)
{
    if (m_title == title)
        return;

    m_title = title;
    emit titleChanged(m_title);
}

void RelatedItem::setTopline(const QString &topline)
{
    if (m_topline == topline)
        return;

    m_topline = topline;
    emit toplineChanged(m_topline);
}
