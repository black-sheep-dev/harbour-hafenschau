#include "hafenschauprovider.h"

#include <QSettings>
#include <QFile>
#include <QJsonDocument>
#include <QStandardPaths>

HafenschauProvider::HafenschauProvider(QObject *parent) :
    QObject(parent),
    m_api(new ApiInterface(this)),
    m_newsModel(new NewsModel(this))
{
    connect(m_api, &ApiInterface::newsAvailable, m_newsModel, &NewsModel::setNews);
    connect(m_api, &ApiInterface::internalLinkAvailable, this, &HafenschauProvider::internalLinkAvailable);

    readSettings();
}

HafenschauProvider::~HafenschauProvider()
{
    writeSettings();
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

RegionsModel *HafenschauProvider::regionsModel()
{
    RegionsModel *model = new RegionsModel;
    model->setActiveRegions(m_activeRegions);
    connect(model, &RegionsModel::activeRegionsChanged, this, &HafenschauProvider::setActiveRegions);

    return model;
}

void HafenschauProvider::saveSettings()
{
    writeSettings();
}

void HafenschauProvider::saveNews(News *news)
{
    if (!news)
        return;

    QFile file(QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation)
               + QStringLiteral("/hafenschau-news-")
               + QDateTime::currentDateTimeUtc().toString("yyyyMMddhhmmss")
               + QStringLiteral(".json"));

    if (!file.open(QIODevice::WriteOnly | QIODevice::Text))
        return;

    QTextStream out(&file);

    out << QString(QJsonDocument(news->debugData()).toJson(QJsonDocument::Indented));

    file.close();
}

quint16 HafenschauProvider::developerOptions() const
{
    return m_developerOptions;
}

void HafenschauProvider::refresh()
{
    m_api->refresh();
}

void HafenschauProvider::setDeveloperOptions(quint16 options)
{
    if (m_developerOptions == options)
        return;

    m_developerOptions = options;
    emit developerOptionsChanged(m_developerOptions);

    // internal settings
    m_api->enableDeveloperMode((m_developerOptions & DevOptSaveNews) == DevOptSaveNews);
}

void HafenschauProvider::setActiveRegions(const QList<int> &actives)
{
    m_activeRegions = actives;
}

void HafenschauProvider::readSettings()
{
    QSettings settings;

    settings.beginGroup(QStringLiteral("REGIONS"));
    m_activeRegions.clear();

    int size = settings.beginReadArray(QStringLiteral("active"));
    for (int i = 0; i < size; ++i) {
        settings.setArrayIndex(i);
        m_activeRegions.append(settings.value(QStringLiteral("code")).toInt());
    }
    settings.endArray();
    settings.endGroup();

    settings.beginGroup(QStringLiteral("DEVELOPER"));
    setDeveloperOptions(quint16(settings.value(QStringLiteral("options"), DeveloperOption::DevOptNone).toInt()));
    settings.endGroup();
}

void HafenschauProvider::writeSettings()
{
    QSettings settings;

    settings.beginGroup(QStringLiteral("REGIONS"));
    settings.beginWriteArray(QStringLiteral("active"));
    for (int i = 0; i < m_activeRegions.count(); ++i) {
        settings.setArrayIndex(i);
        settings.setValue(QStringLiteral("code"), m_activeRegions.at(i));
    }
    settings.endArray();
    settings.endGroup();

    settings.beginGroup(QStringLiteral("DEVELOPER"));
    settings.setValue(QStringLiteral("options"), m_developerOptions);
    settings.endGroup();
}
