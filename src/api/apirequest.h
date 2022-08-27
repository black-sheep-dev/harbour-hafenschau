#ifndef APIREQUEST_H
#define APIREQUEST_H

#include <QObject>

#include <QJsonObject>

class ApiRequest : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool cached READ cached WRITE setCached NOTIFY cachedChanged)
    Q_PROPERTY(int error READ error WRITE setError NOTIFY errorChanged)
    Q_PROPERTY(bool loading READ loading WRITE setLoading NOTIFY loadingChanged)
    Q_PROPERTY(QString query READ query WRITE setQuery NOTIFY queryChanged)
    Q_PROPERTY(QJsonObject result READ result WRITE setResult NOTIFY resultChanged)
    Q_PROPERTY(QString resultRaw READ resultRaw WRITE setResultRaw NOTIFY resultRawChanged)
    Q_PROPERTY(QString uuid READ uuid NOTIFY uuidChanged)

public:
    explicit ApiRequest(QObject *parent = nullptr);

    bool cached() const;
    void setCached(bool newCached);

    int error() const;
    void setError(int error);

    bool loading() const;
    void setLoading(bool loading);

    const QString &query() const;
    void setQuery(const QString &query);

    const QJsonObject &result() const;
    void setResult(const QJsonObject &result);

    const QString &resultRaw() const;
    void setResultRaw(const QString &result);

    const QString &uuid() const;

signals:
    void finished();

    void cachedChanged();
    void errorChanged();
    void loadingChanged();
    void queryChanged();
    void resultChanged();
    void resultRawChanged();
    void uuidChanged();

private:
    bool m_cached{false};
    int m_error{0};
    bool m_loading{false};
    QString m_query;
    QJsonObject m_result;
    QString m_resultRaw;
    QString m_uuid;


};

#endif // APIREQUEST_H
