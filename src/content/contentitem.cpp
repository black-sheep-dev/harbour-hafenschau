#include "contentitem.h"

ContentItem::ContentItem(QObject *parent) :
    QObject(parent)
{

}

ContentItem::ContentItem(const ContentItem &other) :
    QObject(nullptr)
{
    m_contentType = other.contentType();
    m_value = other.value();
}

quint8 ContentItem::contentType() const
{
    return m_contentType;
}

QString ContentItem::value() const
{
    return m_value;
}

void ContentItem::setContentType(quint8 contentType)
{
    if (m_contentType == contentType)
        return;

    m_contentType = contentType;
    emit contentTypeChanged(m_contentType);
}

void ContentItem::setValue(const QString &value)
{
    if (m_value == value)
        return;

    m_value = value;
    emit valueChanged(m_value);
}
