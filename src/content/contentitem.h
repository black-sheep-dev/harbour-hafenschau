#ifndef CONTENTITEM_H
#define CONTENTITEM_H

#include <QObject>

class ContentItem : public QObject
{
    Q_OBJECT

    Q_PROPERTY(quint8 contentType READ contentType WRITE setContentType NOTIFY contentTypeChanged)
    Q_PROPERTY(QString value READ value WRITE setValue NOTIFY valueChanged)

public:
    enum ContentType {
        Unkown,
        Audio,              // audio
        Box,                // box
        Gallery,            // image_gallery
        Headline,           // headline
        List,               // list
        Quotation,          // quotation
        Related,            // related
        Social,             // socialmedia
        Text,               // text
        Video               // video
    };
    Q_ENUM(ContentType)

    explicit ContentItem(QObject *parent = nullptr);
    explicit ContentItem(const ContentItem &other);

    quint8 contentType() const;
    QString value() const;

signals:
    void contentTypeChanged(quint8 contentType);
    void valueChanged(const QString &value);

public slots:
    void setContentType(quint8 contentType);
    void setValue(const QString &value);

private:
    quint8 m_contentType{Unkown};
    QString m_value;
};

#endif // CONTENTITEM_H
