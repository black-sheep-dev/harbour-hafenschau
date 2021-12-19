#include "networkaccessmanagerfactory.h"

#include <QStandardPaths>

#include <QNetworkDiskCache>
#include <QNetworkAccessManager>

QNetworkAccessManager *NetworkAccessManagerFactory::create(QObject *parent)
{
    auto manager = new QNetworkAccessManager(parent);
    auto cache = new QNetworkDiskCache(parent);
    cache->setCacheDirectory(QStandardPaths::writableLocation(QStandardPaths::CacheLocation) + "/api");
    cache->setMaximumCacheSize(100000000);
    manager->setCache(cache);

    return manager;
}
