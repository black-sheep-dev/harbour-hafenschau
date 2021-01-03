#ifndef HAFENSCHAUPROVIDER_H
#define HAFENSCHAUPROVIDER_H

#include <QObject>

#include "api/apiinterface.h"
#include "news/newsmodel.h"
#include "region/regionsmodel.h"

class HafenschauProvider : public QObject
{
    Q_OBJECT

    Q_PROPERTY(quint16 developerOptions READ developerOptions WRITE setDeveloperOptions NOTIFY developerOptionsChanged)

public:
    enum DeveloperOption {
        DevOptNone          = 0x00,
        DevOptSaveNews      = 0x01
    };
    Q_ENUM(DeveloperOption)
    Q_DECLARE_FLAGS(DeveloperOptions, DeveloperOption)

    explicit HafenschauProvider(QObject *parent = nullptr);
    ~HafenschauProvider() override;

    Q_INVOKABLE void getInternalLink(const QString &link);
    Q_INVOKABLE void initialize();
    Q_INVOKABLE bool isInternalLink(const QString &link) const;
    Q_INVOKABLE NewsModel *newsModel();
    Q_INVOKABLE RegionsModel *regionsModel();
    Q_INVOKABLE void saveSettings();
    Q_INVOKABLE void saveNews(News *news);

    // properties
    quint16 developerOptions() const;

signals:
    void internalLinkAvailable(News *news);

    // properties
    void developerOptionsChanged(quint16 options);

public slots:
    Q_INVOKABLE void refresh();

    // properties
    void setDeveloperOptions(quint16 options);

private:
    void readSettings();
    void writeSettings();

    ApiInterface *m_api{nullptr};
    NewsModel *m_newsModel{nullptr};

    // properties
    quint16 m_developerOptions{DevOptNone};
};
Q_DECLARE_OPERATORS_FOR_FLAGS(HafenschauProvider::DeveloperOptions)

#endif // HAFENSCHAUPROVIDER_H
