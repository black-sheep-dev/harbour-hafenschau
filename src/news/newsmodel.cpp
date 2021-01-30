#include "newsmodel.h"

#ifdef QT_DEBUG
#include <QDebug>
#endif

NewsModel::NewsModel(QObject *parent) :
    QAbstractListModel(parent)
{

}

bool NewsModel::isEmpty() const
{
    return m_news.empty();
}

QList<News *> NewsModel::news() const
{
    return m_news;
}

int NewsModel::newsCount() const
{
    return m_news.count();
}

News *NewsModel::newsAt(int index)
{
    if (index >= m_news.count() || index < 0)
        return nullptr;

    return m_news.at(index);
}

News *NewsModel::newsById(const QString &sophoraId)
{
    for (auto &news : m_news) {
        if (news->sophoraId() == sophoraId)
            return news;
    }

    return nullptr;
}

void NewsModel::updateNews(News *news)
{
    if (news == nullptr)
        return;

    News *old = newsById(news->sophoraId());

    if (old == nullptr)
        return;

    const QModelIndex idx = index(m_news.indexOf(old));

    m_news.replace(idx.row(), news);
    emit dataChanged(idx, idx);

    old->deleteLater();
}

bool NewsModel::loading() const
{
    return m_loading;
}

QString NewsModel::newStoriesCountLink() const
{
    return m_newStoriesCountLink;
}

quint8 NewsModel::newsType() const
{
    return m_newsType;
}

QString NewsModel::nextPage() const
{
    return m_nextPage;
}

void NewsModel::setNews(const QList<News *> &news)
{
    beginResetModel();

    for (auto &old : m_news) {
        old->deleteLater();
    }

    for (auto *n : news) {
        n->setParent(this);
    }

    m_news = news;
    endResetModel();

    emit newsChanged();

    setLoading(false);
}

void NewsModel::setLoading(bool loading)
{
    if (m_loading == loading)
        return;

    m_loading = loading;
    emit loadingChanged(m_loading);
}

void NewsModel::setNewsType(quint8 newsType)
{
    if (m_newsType == newsType)
        return;

    m_newsType = newsType;
    emit newsTypeChanged(m_newsType);
}

void NewsModel::setNewStoriesCountLink(const QString &link)
{
    if (m_newStoriesCountLink == link)
        return;

    m_newStoriesCountLink = link;
    emit newStoriesCountLinkChanged(m_newStoriesCountLink);
}

void NewsModel::setNextPage(const QString &nextPage)
{
    if (m_nextPage == nextPage)
        return;

    m_nextPage = nextPage;
    emit nextPageChanged(m_nextPage);
}

int NewsModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)

    return m_news.count();
}

QVariant NewsModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    News *news = m_news.at(index.row());

    switch (role) {
    // important ones
    case ThumbnailRole:
        return news->thumbnail();

    case ToplineRole:
        return news->topline();

    case TitleRole:
        return news->title();

    case FirstSentenceRole:
        return news->firstSentence();

    case ImageRole:
        return news->image();

    case PortraitRole:
        return news->portrait();

    // additional info
    case NewsTypeRole:
        return news->newsType();

    case BrandingImageRole:
        return news->brandingImage();

    case BreakingNewsRole:
        return news->breakingNews();

    case DateRole:
        return news->date();

    case DetailsRole:
        return news->details();

    case DetailsWebRole:
        return news->detailsWeb();

    case HasContentRole:
        return news->hasContent();

    case RegionRole:
        return news->region();

    case SophoraIdRole:
        return news->sophoraId();

    case SearchRole:
        return news->topline() + news->title() + news->firstSentence();

    case StreamRole:
        return news->stream();

    case RowRole:
        return index.row();

    default:
        return QVariant();
    }
}

QHash<int, QByteArray> NewsModel::roleNames() const
{
    QHash<int, QByteArray> roles;

    roles[BrandingImageRole]            = "brandingImage";
    roles[BreakingNewsRole]             = "breakingNews";
    roles[DateRole]                     = "date";
    roles[DetailsRole]                  = "details";
    roles[DetailsWebRole]               = "detailsWeb";
    roles[FirstSentenceRole]            = "firstSentence";
    roles[HasContentRole]               = "hasContent";
    roles[ImageRole]                    = "image";
    roles[NewsTypeRole]                 = "newsType";
    roles[PortraitRole]                 = "portrait";
    roles[RegionRole]                   = "region";
    roles[SophoraIdRole]                = "sophoraId";
    roles[StreamRole]                   = "stream";
    roles[ThumbnailRole]                = "thumbnail";
    roles[TitleRole]                    = "title";
    roles[ToplineRole]                  = "topline";
    roles[RowRole]                      = "row"; 

    return roles;
}
