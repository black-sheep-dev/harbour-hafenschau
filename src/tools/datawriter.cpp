#include "datawriter.h"

#include <QDateTime>
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QSettings>
#include <QStandardPaths>
#include <QTextStream>

DataWriter::DataWriter(QObject *parent) :
    QObject(parent)
{

}

void DataWriter::saveNews(const QJsonObject &news)
{
    QFile file(QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation)
               + QStringLiteral("/hafenschau-news-")
               + news.value("sophoraId").toString()
               + '-'
               + QDateTime::currentDateTimeUtc().toString("yyyyMMddhhmmss")
               + QStringLiteral(".json"));

    if (!file.open(QIODevice::WriteOnly | QIODevice::Text))
        return;

    QTextStream out(&file);

    out << QString(QJsonDocument(news).toJson(QJsonDocument::Indented));

    file.close();
}
