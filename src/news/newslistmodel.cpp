#include "newslistmodel.h"

#include <QJsonArray>
#include <QJsonObject>

#include "src/enums/newstype.h"

NewsListModel::NewsListModel(QObject *parent) :
    QAbstractListModel(parent)
{

}

NewsListModel::~NewsListModel()
{
    m_items.clear();
}

QString NewsListModel::newsDetails(int index) const
{
    if (index < 0 || index >= m_items.count())
        return QString();

    return m_items[index].details;
}

void NewsListModel::addItems(const QJsonArray &items)
{
    QList<NewsItem> list = parseItems(items);

    if (list.isEmpty())
        return;

    beginInsertRows(QModelIndex(), m_items.count(), m_items.count() + list.count() - 1);
    m_items.append(list);
    endInsertRows();
}

void NewsListModel::setItems(const QJsonArray &items)
{
    beginResetModel();
    m_items.clear();
    m_items = parseItems(items);
    endResetModel();
}

void NewsListModel::clear()
{
    beginResetModel();
    m_items.clear();
    endResetModel();
}

void NewsListModel::refresh()
{
    beginResetModel();
    endResetModel();
}

QList<NewsItem> NewsListModel::parseItems(const QJsonArray &items)
{
    QList<NewsItem> list;

    for (const auto &v : items) {
        const auto obj = v.toObject();

        if (obj.isEmpty())
            continue;

        NewsItem item;
        item.datetime = QDateTime::fromString(obj.value("date").toString(), Qt::ISODate);
        item.details = obj.value("details").toString();
        item.firstSentence = obj.value("firstSentence").toString();
        item.thumbnail = obj.value("teaserImage").toObject()
                .value("portraetgross8x9").toObject()
                .value("imageurl").toString();
        item.title = obj.value("title").toString();
        item.topline = obj.value("topline").toString();

        const QString type = obj.value("type").toString();
        if (type == QLatin1String("story")) {
            item.type = NewsType::Story;
        } else if (type == QLatin1String("video")) {
            item.type = NewsType::Video;
            item.streams = obj.value("streams").toObject();
        } else if (type == QLatin1String("webview")) {
            item.type = NewsType::WebView;
            item.detailsWeb = obj.value("detailsWeb").toString();
        } else {
            item.type = NewsType::Undefined;
        }

        list.append(item);
    }

    return list;
}

int NewsListModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)

    return m_items.count();
}

QVariant NewsListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    const auto &item = m_items[index.row()];

    switch (role) {
    case DetailsRole:
        return item.details;

    case DetailsWebRole:
        return item.detailsWeb;

    case FirstSentenceRole:
        return item.firstSentence;

    case ThumbnailRole:
        return item.thumbnail;

    case TitleRole:
        return item.title;

    case ToplineRole:
        return item.topline;

    case TypeRole:
        return item.type;

    case DatetimeRole:
        return item.datetime;

    case StreamsRole:
        return item.streams;

    case SearchRole:
        return item.title + item.topline + item.firstSentence;

    default:
        return QVariant();
    }
}

QHash<int, QByteArray> NewsListModel::roleNames() const
{
    QHash<int, QByteArray> roles;

    roles[DatetimeRole]         = "datetime";
    roles[DetailsRole]          = "details";
    roles[DetailsWebRole]       = "detailsWeb";
    roles[FirstSentenceRole]    = "firstSentence";
    roles[StreamsRole]          = "streams";
    roles[ThumbnailRole]        = "thumbnail";
    roles[TitleRole]            = "title";
    roles[ToplineRole]          = "topline";
    roles[TypeRole]             = "type";
    roles[SearchRole]           = "search";

    return roles;
}
