#include "hafenschauprovider.h"

#ifdef QT_DEBUG
    #include <QDebug>
#endif

#include <QFile>
#include <QJsonDocument>
#include <QSettings>
#include <QStandardPaths>

#include <notification.h>

HafenschauProvider::HafenschauProvider(QObject *parent) :
    QObject(parent)
{
    readSettings();

    connect(m_api, &ApiInterface::commentsModelAvailable, this, &HafenschauProvider::commentsModelAvailable);
    connect(m_api, &ApiInterface::internalLinkAvailable, this, &HafenschauProvider::internalLinkAvailable); 
    connect(m_api, &ApiInterface::breakingNewsAvailable, this, &HafenschauProvider::onBreakingNewsAvailable);
    connect(m_api, &ApiInterface::htmlEmbedAvailable, this, &HafenschauProvider::htmlEmbedAvailable);
}

HafenschauProvider::~HafenschauProvider()
{
    writeSettings();
}

quint64 HafenschauProvider::cacheSize() const
{
    return m_api->cacheSize();
}

void HafenschauProvider::getComments(const QString &link)
{
    m_api->getComments(link);
}

void HafenschauProvider::getHtmlEmbed(const QString &link)
{
    m_api->getHtmlEmbed(link);
}

void HafenschauProvider::getInternalLink(const QString &link)
{
    m_api->getInteralLink(link);
}

void HafenschauProvider::getNextPage(quint8 newsType)
{
    m_api->getNextPage(newsType);
}

void HafenschauProvider::initialize()
{
    m_api->refresh(NewsModel::Homepage);
}

bool HafenschauProvider::isInternalLink(const QString &link) const
{
    return link.endsWith(QStringLiteral(".json")) && link.startsWith(QStringLiteral("https://www.tagesschau.de/api2"));
}

News *HafenschauProvider::newsById(const QString &sophoraId)
{
    auto model = m_api->newsModel(NewsModel::Homepage);

    if (model == nullptr)
        return nullptr;

    return model->newsById(sophoraId);
}

NewsModel *HafenschauProvider::newsModel(quint8 newsType)
{
    return m_api->newsModel(newsType);
}

void HafenschauProvider::refreshNews(News *news)
{
    m_api->checkForUpdate(news);
}

RegionsModel *HafenschauProvider::regionsModel()
{
    auto model = new RegionsModel();
    model->setActiveRegions(m_api->activeRegions());
    connect(model, &RegionsModel::activeRegionsChanged, m_api, &ApiInterface::setActiveRegions);

    return model;
}

void HafenschauProvider::saveSettings()
{
    writeSettings();
}

void HafenschauProvider::saveNews(News *news)
{
    if (news == nullptr)
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

void HafenschauProvider::searchContent(const QString &pattern, quint16 page)
{
    m_api->searchContent(pattern, page);
}

void HafenschauProvider::preventDisplayBlanking(bool enabled)
{
    m_displayBlanking->setPreventBlanking(enabled);
}

void HafenschauProvider::test()
{
    onBreakingNewsAvailable(m_api->newsModel(NewsModel::Homepage)->newsAt(0));
}

quint8 HafenschauProvider::autoRefresh() const
{
    return m_autoRefresh;
}

bool HafenschauProvider::coverSwitch() const
{
    return m_coverSwitch;
}

quint32 HafenschauProvider::coverSwitchInterval() const
{
    return m_coverSwitchInterval;
}

quint8 HafenschauProvider::developerOptions() const
{
    return m_developerOptions;
}

bool HafenschauProvider::notification() const
{
    return m_notification;
}

void HafenschauProvider::clearCache()
{
    m_api->clearCache();
}

void HafenschauProvider::refresh(bool complete)
{
    m_api->refresh(complete);
}

void HafenschauProvider::refresh(quint8 newsType, bool complete)
{
    m_api->refresh(newsType, complete);
}

void HafenschauProvider::setAutoRefresh(quint8 interval)
{
    if (m_autoRefresh == interval)
        return;

    m_autoRefresh = interval;
    emit autoRefreshChanged(m_autoRefresh);

    updateBackgroundActivity();
}

void HafenschauProvider::setCoverSwitch(bool enabled)
{
    if (m_coverSwitch == enabled)
        return;

    m_coverSwitch = enabled;
    emit coverSwitchChanged(m_coverSwitch);
}

void HafenschauProvider::setCoverSwitchInterval(quint32 interval)
{
    if (m_coverSwitchInterval == interval)
        return;

    m_coverSwitchInterval = interval;
    emit coverSwitchIntervalChanged(m_coverSwitchInterval);
}

void HafenschauProvider::setDeveloperOptions(quint8 options)
{
    if (m_developerOptions == options)
        return;

    m_developerOptions = options;
    emit developerOptionsChanged(m_developerOptions);

    // internal settings
    m_api->enableDeveloperMode((m_developerOptions & DevOptSaveNews) == DevOptSaveNews);
}

void HafenschauProvider::setNotification(bool notification)
{
    if (m_notification == notification)
        return;

    m_notification = notification;
    emit notificationChanged(m_notification);
}

void HafenschauProvider::onBackgroundActivityRunning()
{
#ifdef QT_DEBUG
    qDebug() << "BACKGROUND ACTIVITY RUNNING";
#endif

    m_api->refresh(NewsModel::Homepage);

    updateBackgroundActivity();
}

void HafenschauProvider::onBreakingNewsAvailable(News *news)
{
#ifdef QT_DEBUG
    qDebug() << "BREACKING NEWS AVAILABLE";
#endif

    if (!m_notification || news == nullptr)
        return;

    if (m_notifications.contains(news->sophoraId()))
        return;

    Notification notification;
    notification.setAppName(tr("Hafenschau"));
    notification.setIcon(QStringLiteral("image://theme/icon-lock-information"));
    notification.setCategory(QStringLiteral("x-hafenschau.information"));
    notification.setSummary(news->title());
    notification.setBody(news->firstSentence());
    notification.setRemoteAction(Notification::remoteAction(
                                    QStringLiteral("default"),
                                    tr("Default"),
                                    QStringLiteral("harbour.hafenschau.service"),
                                    QStringLiteral("/harbour/hafenschau/service"),
                                    QStringLiteral("harbour.hafenschau.service"),
                                    QStringLiteral("open"),
                                    QVariantList() << news->sophoraId()
                                 ));
    notification.publish();
    connect(&notification, &Notification::clicked, &notification, &Notification::close);

    m_notifications.append(news->sophoraId());
}


void HafenschauProvider::updateBackgroundActivity()
{
    // update background service
    if (m_autoRefresh == AutoRefreshOff) {
        if (m_backgroundActivity != nullptr) {
            m_backgroundActivity->deleteLater();
            m_backgroundActivity = nullptr;
        }
        return;
    }

    if (m_autoRefresh != AutoRefreshOff && m_backgroundActivity == nullptr) {
        m_backgroundActivity = new BackgroundActivity(this);
        connect(m_backgroundActivity, &BackgroundActivity::running, this, &HafenschauProvider::onBackgroundActivityRunning);
    }

    switch (m_autoRefresh) {
    case AutoRefresh30Sec:
        m_backgroundActivity->wait(BackgroundActivity::ThirtySeconds);
        break;

    case AutoRefresh150Sec:
        m_backgroundActivity->wait(BackgroundActivity::TwoAndHalfMinutes);
        break;

    case AutoRefresh5Min:
        m_backgroundActivity->wait(BackgroundActivity::FiveMinutes);
        break;

    case AutoRefresh15Min:
        m_backgroundActivity->wait(BackgroundActivity::FifteenMinutes);
        break;

    case AutoRefresh30Min:
        m_backgroundActivity->wait(BackgroundActivity::ThirtyMinutes);
        break;

    case AutoRefresh60Min:
        m_backgroundActivity->wait(BackgroundActivity::OneHour);
        break;

    default:
        break;
    }
}

void HafenschauProvider::readSettings()
{
    QSettings settings;

    settings.beginGroup(QStringLiteral("APP"));
    setAutoRefresh(settings.value(QStringLiteral("auto_refresh"), m_autoRefresh).toUInt());
    setCoverSwitch(settings.value(QStringLiteral("cover_switch"), m_coverSwitch).toBool());
    setCoverSwitchInterval(settings.value(QStringLiteral("cover_switch_interval"), m_coverSwitchInterval).toUInt());
    setNotification(settings.value(QStringLiteral("notification"), m_notification).toBool());
    settings.endGroup();

    settings.beginGroup(QStringLiteral("REGIONS"));
    QList<int> regions;

    int size = settings.beginReadArray(QStringLiteral("active"));
    for (int i = 0; i < size; ++i) {
        settings.setArrayIndex(i);
        regions.append(settings.value(QStringLiteral("code")).toInt());
    }
    m_api->setActiveRegions(regions);
    settings.endArray();
    settings.endGroup();

    settings.beginGroup(QStringLiteral("DEVELOPER"));
    setDeveloperOptions(quint16(settings.value(QStringLiteral("options"), DeveloperOption::DevOptNone).toInt()));
    settings.endGroup();
}

void HafenschauProvider::writeSettings()
{
    QSettings settings;

    settings.beginGroup(QStringLiteral("APP"));
    settings.setValue(QStringLiteral("auto_refresh"), m_autoRefresh);
    settings.setValue(QStringLiteral("cover_switch"), m_coverSwitch);
    settings.setValue(QStringLiteral("cover_switch_interval"), m_coverSwitchInterval);
    settings.setValue(QStringLiteral("notification"), m_notification);
    settings.endGroup();

    settings.beginGroup(QStringLiteral("REGIONS"));
    settings.beginWriteArray(QStringLiteral("active"));
    for (int i = 0; i < m_api->activeRegions().count(); ++i) {
        settings.setArrayIndex(i);
        settings.setValue(QStringLiteral("code"), m_api->activeRegions().at(i));
    }
    settings.endArray();
    settings.endGroup();

    settings.beginGroup(QStringLiteral("DEVELOPER"));
    settings.setValue(QStringLiteral("options"), m_developerOptions);
    settings.endGroup();
}
