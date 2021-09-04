#ifndef DATAWRITER_H
#define DATAWRITER_H

#include <QObject>

class DataWriter : public QObject
{
    Q_OBJECT
public:
    explicit DataWriter(QObject *parent = nullptr);

    Q_INVOKABLE void saveNews(const QJsonObject &news);
};

#endif // DATAWRITER_H
