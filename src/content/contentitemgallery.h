#ifndef CONTENTITEMGALLERY_H
#define CONTENTITEMGALLERY_H

#include "contentitem.h"

#include "gallerymodel.h"

class ContentItemGallery : public ContentItem
{
    Q_OBJECT
public:
    explicit ContentItemGallery(QObject *parent = nullptr);

    Q_INVOKABLE GalleryModel *model();

private:
    GalleryModel *m_model{new GalleryModel(this)};
};

#endif // CONTENTITEMGALLERY_H
