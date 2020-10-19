#include "contentitemgallery.h"

ContentItemGallery::ContentItemGallery(QObject *parent) :
    ContentItem(parent),
    m_model(new GalleryModel(this))
{
    setContentType(ContentItem::Gallery);
}

GalleryModel *ContentItemGallery::model()
{
    return m_model;
}
