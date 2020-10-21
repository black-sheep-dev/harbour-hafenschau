#include "news.h"

News::News(QObject *parent) :
    QObject(parent)
{

}

void News::addContentItem(ContentItem *item)
{
    if (!item)
        return;

    item->setParent(this);
    m_contentItems.append(item);
    emit contentItemsChanged(m_contentItems);
}

void News::clearContentItems()
{
    qDeleteAll(m_contentItems.begin(), m_contentItems.end());
    m_contentItems.clear();
    emit contentItemsChanged(m_contentItems);
}

ContentItem *News::contentItemAt(int index)
{
    if (index < 0 || index >= m_contentItems.count())
        return nullptr;

    return m_contentItems.at(index);
}

QList<ContentItem *> News::contentItems() const
{
    return m_contentItems;
}

int News::contentItemsCount() const
{
    return m_contentItems.count();
}

QJsonObject News::debugData() const
{
    return m_debugData;
}

void News::setDebugData(const QJsonObject &obj)
{
    m_debugData = obj;
}

QString News::brandingImage() const
{
    return m_brandingImage;
}

bool News::breakingNews() const
{
    return m_breakingNews;
}

QDateTime News::date() const
{
    return m_date;
}

QString News::detailsWeb() const
{
    return m_detailsWeb;
}

QString News::firstSentence() const
{
    return m_firstSentence;
}

QString News::image() const
{
    return m_image;
}

quint8 News::newsType() const
{
    return m_newsType;
}

QString News::portrait() const
{
    return m_portrait;
}

quint8 News::region() const
{
    return m_region;
}

QString News::sophoraId() const
{
    return m_sophoraId;
}

QString News::thumbnail() const
{
    return m_thumbnail;
}

QString News::title() const
{
    return m_title;
}

QString News::topline() const
{
    return m_topline;
}

void News::setContentItems(const QList<ContentItem *> &items)
{
    qDeleteAll(m_contentItems.begin(), m_contentItems.end());

    for (ContentItem *item : items) {
        item->setParent(this);
    }

    m_contentItems = items;
    emit contentItemsChanged(m_contentItems);
}

void News::setBrandingImage(const QString &brandingImage)
{
    if (m_brandingImage == brandingImage)
        return;

    m_brandingImage = brandingImage;
    emit brandingImageChanged(m_brandingImage);
}

void News::setBreakingNews(bool breakingNews)
{
    if (m_breakingNews == breakingNews)
        return;

    m_breakingNews = breakingNews;
    emit breakingNewsChanged(m_breakingNews);
}

void News::setDate(const QDateTime &date)
{
    if (m_date == date)
        return;

    m_date = date;
    emit dateChanged(m_date);
}

void News::setDetailsWeb(const QString &detailsWeb)
{
    if (m_detailsWeb == detailsWeb)
        return;

    m_detailsWeb = detailsWeb;
    emit detailsWebChanged(m_detailsWeb);
}

void News::setFirstSentence(const QString &firstSentence)
{
    if (m_firstSentence == firstSentence)
        return;

    m_firstSentence = firstSentence;
    emit firstSentenceChanged(m_firstSentence);
}

void News::setImage(const QString &image)
{
    if (m_image == image)
        return;

    m_image = image;
    emit imageChanged(m_image);
}

void News::setNewsType(quint8 newsType)
{
    if (m_newsType == newsType)
        return;

    m_newsType = newsType;
    emit newsTypeChanged(m_newsType);
}

void News::setPortrait(const QString &portrait)
{
    if (m_portrait == portrait)
        return;

    m_portrait = portrait;
    emit portraitChanged(m_portrait);
}

void News::setRegion(quint8 region)
{
    if (m_region == region)
        return;

    m_region = region;
    emit regionChanged(m_region);
}

void News::setSophoraId(const QString &sophoraId)
{
    if (m_sophoraId == sophoraId)
        return;

    m_sophoraId = sophoraId;
    emit sophoraIdChanged(m_sophoraId);
}

void News::setThumbnail(const QString &thumbnail)
{
    if (m_thumbnail == thumbnail)
        return;

    m_thumbnail = thumbnail;
    emit thumbnailChanged(m_thumbnail);
}

void News::setTitle(const QString &title)
{
    if (m_title == title)
        return;

    m_title = title;
    emit titleChanged(m_title);
}

void News::setTopline(const QString &topline)
{
    if (m_topline == topline)
        return;

    m_topline = topline;
    emit toplineChanged(m_topline);
}
