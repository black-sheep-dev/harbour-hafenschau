#include "contentitemrelated.h"

ContentItemRelated::ContentItemRelated(QObject *parent) :
    ContentItem(parent),
    m_model(new RelatedModel(this))
{
    setContentType(ContentItem::Related);
}

RelatedModel *ContentItemRelated::model()
{
    return m_model;
}
