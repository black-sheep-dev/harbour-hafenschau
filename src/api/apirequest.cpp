#include "apirequest.h"

#include <QUuid>

ApiRequest::ApiRequest(QObject *parent) :
    QObject(parent),
    m_uuid(QUuid::createUuid().toString().mid(1,34))
{

}

bool ApiRequest::cached() const
{
    return m_cached;
}

void ApiRequest::setCached(bool newCached)
{
    if (m_cached == newCached)
        return;
    m_cached = newCached;
    emit cachedChanged();
}


int ApiRequest::error() const
{
    return m_error;
}

void ApiRequest::setError(int error)
{
    if (m_error == error)
        return;
    m_error = error;
    emit errorChanged();
}

bool ApiRequest::hasResult() const
{
    return !m_result.isEmpty() || !m_resultRaw.isEmpty();
}

bool ApiRequest::loading() const
{
    return m_loading;
}

void ApiRequest::setLoading(bool loading)
{
    if (m_loading == loading)
        return;
    m_loading = loading;
    emit loadingChanged();
}

const QString &ApiRequest::query() const
{
    return m_query;
}

void ApiRequest::setQuery(const QString &query)
{
    if (m_query == query)
        return;
    m_query = query;
    emit queryChanged();
}

const QJsonObject &ApiRequest::result() const
{
    return m_result;
}

void ApiRequest::setResult(const QJsonObject &result)
{
    if (m_result == result)
        return;
    m_result = result;
    emit resultChanged();
    emit finished();
    emit hasResultChanged();
}

const QString &ApiRequest::resultRaw() const
{
    return m_resultRaw;
}

void ApiRequest::setResultRaw(const QString &result)
{
    if (m_resultRaw == result)
        return;
    m_resultRaw = result;
    emit resultRawChanged();
    emit finished();
    emit hasResultChanged();
}

const QString &ApiRequest::uuid() const
{
    return m_uuid;
}
