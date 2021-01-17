#include "contentitemlist.h"

ContentItemList::ContentItemList(QObject *parent) :
    ContentItem(parent)
{
    setContentType(ContentItem::List);
}

QStringList ContentItemList::items() const
{
    return m_items;
}

QString ContentItemList::title() const
{
    return m_title;
}

void ContentItemList::setItems(const QStringList &items)
{
    if (m_items == items)
        return;

    m_items = items;
    emit itemsChanged(m_items);
}

void ContentItemList::setTitle(const QString &title)
{
    if (m_title == title)
        return;

    m_title = title;
    emit titleChanged(m_title);
}
