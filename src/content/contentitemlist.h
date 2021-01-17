#ifndef CONTENTITEMLIST_H
#define CONTENTITEMLIST_H

#include "contentitem.h"

class ContentItemList : public ContentItem
{
    Q_OBJECT

    Q_PROPERTY(QStringList items READ items WRITE setItems NOTIFY itemsChanged)
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)

public:
    explicit ContentItemList(QObject *parent = nullptr);

    QStringList items() const;
    QString title() const;

signals:
    void itemsChanged(const QStringList &items);
    void titleChanged(const QString &title);

public slots:
    void setItems(const QStringList &items);
    void setTitle(const QString &title);

private:
    QStringList m_items;
    QString m_title;
};

#endif // CONTENTITEMLIST_H
