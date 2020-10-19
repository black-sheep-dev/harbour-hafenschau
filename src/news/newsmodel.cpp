#include "newsmodel.h"

#ifdef QT_DEBUG
#include <QDebug>
#endif

NewsModel::NewsModel(QObject *parent) :
    QAbstractListModel(parent)
{

}

int NewsModel::newsCount() const
{
    return m_news.count();
}

News *NewsModel::newsAt(const int index)
{
    if (index >= m_news.count() || index < 0)
        return nullptr;

    return m_news.at(index);
}

void NewsModel::setNews(const QList<News *> news)
{
    beginResetModel();
    for (News *news : m_news) {
        news->deleteLater();
    }

    for (News *n : news) {
        n->setParent(this);
    }

    m_news = news;
    endResetModel();
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

    // additional info
    case BreakingNewsRole:
        return news->breakingNews();

    case DateRole:
        return news->date();

    case RegionRole:
        return news->region();

    case SophoraIdRole:
        return news->sophoraId();

    default:
        return QVariant();
    }
}

QHash<int, QByteArray> NewsModel::roleNames() const
{
    QHash<int, QByteArray> roles;

    roles[BreakingNewsRole]             = "breaking_news";
    roles[DateRole]                     = "date";
    roles[FirstSentenceRole]            = "first_sentence";
    roles[ImageRole]                    = "image";
    roles[RegionRole]                   = "region";
    roles[SophoraIdRole]                = "sophora_id";
    roles[ThumbnailRole]                = "thumbnail";
    roles[TitleRole]                    = "title";
    roles[ToplineRole]                  = "topline";

    return roles;
}
