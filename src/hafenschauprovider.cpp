#include "hafenschauprovider.h"

HafenschauProvider::HafenschauProvider(QObject *parent) :
    QObject(parent),
    m_api(new ApiInterface(this)),
    m_newsModel(new NewsModel(this))
{
    connect(m_api, &ApiInterface::newsAvailable, m_newsModel, &NewsModel::setNews);
    connect(m_api, &ApiInterface::internalLinkAvailable, this, &HafenschauProvider::internalLinkAvailable);
}

void HafenschauProvider::getInternalLink(const QString &link)
{
    m_api->getInteralLink(link);
}

void HafenschauProvider::initialize()
{
    m_api->refresh();
}

bool HafenschauProvider::isInternalLink(const QString &link) const
{
    return link.endsWith(QStringLiteral(".json")) && link.startsWith(QStringLiteral("https://www.tagesschau.de/api2"));
}

NewsModel *HafenschauProvider::newsModel()
{
    return m_newsModel;
}

void HafenschauProvider::refresh()
{
    m_api->refresh();
}
