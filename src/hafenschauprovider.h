#ifndef HAFENSCHAUPROVIDER_H
#define HAFENSCHAUPROVIDER_H

#include <QObject>

#include <keepalive/backgroundactivity.h>
#include <keepalive/displayblanking.h>

#include "api/apiinterface.h"
#include "news/newsmodel.h"
#include "region/regionsmodel.h"

class HafenschauProvider : public QObject
{
    Q_OBJECT

    Q_PROPERTY(quint8 autoRefresh READ autoRefresh WRITE setAutoRefresh NOTIFY autoRefreshChanged)
    Q_PROPERTY(bool coverSwitch READ coverSwitch WRITE setCoverSwitch NOTIFY coverSwitchChanged)
    Q_PROPERTY(quint32 coverSwitchInterval READ coverSwitchInterval WRITE setCoverSwitchInterval NOTIFY coverSwitchIntervalChanged)
    Q_PROPERTY(quint8 developerOptions READ developerOptions WRITE setDeveloperOptions NOTIFY developerOptionsChanged)
    Q_PROPERTY(bool notification READ notification WRITE setNotification NOTIFY notificationChanged)

public:
    enum AutoRefresh {
        AutoRefreshOff,
        AutoRefresh30Sec,
        AutoRefresh150Sec,
        AutoRefresh5Min,
        AutoRefresh15Min,
        AutoRefresh30Min,
        AutoRefresh60Min
    };
    Q_ENUM(AutoRefresh)

    enum DeveloperOption {
        DevOptNone                  = 0x00,
        DevOptSaveNews              = 0x01,
        DevOptShowUnkownContent     = 0x02,
    };
    Q_ENUM(DeveloperOption)
    Q_DECLARE_FLAGS(DeveloperOptions, DeveloperOption)

    explicit HafenschauProvider(QObject *parent = nullptr);
    ~HafenschauProvider() override;

    Q_INVOKABLE void getComments(const QString &link);
    Q_INVOKABLE void getInternalLink(const QString &link);
    Q_INVOKABLE void getNextPage(quint8 newsType);
    Q_INVOKABLE void initialize();
    Q_INVOKABLE bool isInternalLink(const QString &link) const;
    Q_INVOKABLE News *newsById(const QString &sophoraId);
    Q_INVOKABLE NewsModel *newsModel(quint8 newsType = NewsModel::Homepage);
    Q_INVOKABLE RegionsModel *regionsModel();
    Q_INVOKABLE void saveSettings();
    Q_INVOKABLE void saveNews(News *news);
    Q_INVOKABLE void searchContent(const QString &pattern, quint16 page = 1);

    Q_INVOKABLE void preventDisplayBlanking(bool enabled = true);

    Q_INVOKABLE void test();

    // properties
    quint8 autoRefresh() const;
    bool coverSwitch() const;
    quint32 coverSwitchInterval() const;
    quint8 developerOptions() const;
    bool notification() const;

signals:
    void commentsModelAvailable(CommentsModel *model);
    void internalLinkAvailable(News *news);

    // properties  
    void autoRefreshChanged(quint8 interval);
    void coverSwitchChanged(bool enabled);
    void coverSwitchIntervalChanged(quint32 interval);
    void developerOptionsChanged(quint16 options);   

    void notificationChanged(bool notification);

public slots:
    Q_INVOKABLE void refresh(bool complete = false);
    Q_INVOKABLE void refresh(quint8 newsType, bool complete = false);

    // properties
    void setAutoRefresh(quint8 interval);
    void setCoverSwitch(bool enabled);
    void setCoverSwitchInterval(quint32 interval);
    void setDeveloperOptions(quint8 options);
    void setNotification(bool notification);

private slots:
    void onBackgroundActivityRunning();
    void onBreakingNewsAvailable(News *news);

private:
    void updateBackgroundActivity();

    void readSettings();
    void writeSettings();

    ApiInterface *m_api{new ApiInterface(this)};
    BackgroundActivity *m_backgroundActivity{nullptr};
    DisplayBlanking *m_displayBlanking{new DisplayBlanking(this)};
    QStringList m_notifications;

    // properties
    quint8 m_autoRefresh{AutoRefreshOff};
    bool m_coverSwitch{true};
    quint32 m_coverSwitchInterval{15000};
    quint8 m_developerOptions{DevOptNone};
    bool m_notification{false};
};
Q_DECLARE_OPERATORS_FOR_FLAGS(HafenschauProvider::DeveloperOptions)

#endif // HAFENSCHAUPROVIDER_H
