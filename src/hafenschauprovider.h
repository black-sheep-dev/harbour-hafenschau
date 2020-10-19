#ifndef HAFENSCHAUPROVIDER_H
#define HAFENSCHAUPROVIDER_H

#include <QObject>

#include "api/apiinterface.h"
#include "news/newsmodel.h"

class HafenschauProvider : public QObject
{
    Q_OBJECT
public:
    explicit HafenschauProvider(QObject *parent = nullptr);

    Q_INVOKABLE void getInternalLink(const QString &link);
    Q_INVOKABLE void initialize();
    Q_INVOKABLE bool isInternalLink(const QString &link) const;
    Q_INVOKABLE NewsModel *newsModel();

signals:
    void internalLinkAvailable(News *news);

public slots:
    Q_INVOKABLE void refresh();

private:
    ApiInterface *m_api;
    NewsModel *m_newsModel;
};

#endif // HAFENSCHAUPROVIDER_H
