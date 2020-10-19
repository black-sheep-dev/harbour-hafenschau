#ifndef RELATEDITEM_H
#define RELATEDITEM_H

#include <QObject>
#include <QDateTime>

class RelatedItem : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QDateTime date READ date WRITE setDate NOTIFY dateChanged)
    Q_PROPERTY(QString image READ image WRITE setImage NOTIFY imageChanged)
    Q_PROPERTY(QString link READ link WRITE setLink NOTIFY linkChanged)
    Q_PROPERTY(QString sophoraId READ sophoraId WRITE setSophoraId NOTIFY sophoraIdChanged)
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
    Q_PROPERTY(QString topline READ topline WRITE setTopline NOTIFY toplineChanged)

public:
    explicit RelatedItem(QObject *parent = nullptr);

    QDateTime date() const;
    QString image() const;
    QString link() const;
    QString sophoraId() const;
    QString title() const;
    QString topline() const;

signals:
    void dateChanged(const QDateTime &date);
    void imageChanged(const QString &image);
    void linkChanged(const QString &link);
    void sophoraIdChanged(const QString &sophoraId);
    void titleChanged(const QString &title);
    void toplineChanged(const QString &topline);

public slots:
    void setDate(const QDateTime &date);
    void setImage(const QString &image);
    void setLink(const QString &link);
    void setSophoraId(const QString &sophoraId);
    void setTitle(const QString &title);
    void setTopline(const QString &topline);

private:
    QDateTime m_date;
    QString m_image;
    QString m_link;
    QString m_sophoraId;
    QString m_title;
    QString m_topline;
};

#endif // RELATEDITEM_H
