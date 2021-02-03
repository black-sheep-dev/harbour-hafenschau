#include "contentitemgallery.h"

ContentItemGallery::ContentItemGallery(QObject *parent) :
    ContentItem(parent)
{
    setContentType(ContentItem::Gallery);
}

GalleryModel *ContentItemGallery::model()
{
    return m_model;
}
