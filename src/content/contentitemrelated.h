#ifndef CONTENTITEMRELATED_H
#define CONTENTITEMRELATED_H

#include "contentitem.h"

#include "relatedmodel.h"

class ContentItemRelated : public ContentItem
{
    Q_OBJECT
public:
    explicit ContentItemRelated(QObject *parent = nullptr);

    Q_INVOKABLE RelatedModel *model();

private:
    RelatedModel *m_model{nullptr};
};

#endif // CONTENTITEMRELATED_H
