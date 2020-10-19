#ifndef NEWS_H
#define NEWS_H

#include <QObject>

#include <QDateTime>
#include <QList>

#include "src/content/contentitem.h"
#include "src/content/contentitembox.h"
#include "src/content/contentitemgallery.h"
#include "src/content/contentitemrelated.h"
#include "src/content/contentitemvideo.h"

class News : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QList<ContentItem *> contentItems READ contentItems WRITE setContentItems NOTIFY contentItemsChanged)

    Q_PROPERTY(bool breakingNews READ breakingNews WRITE setBreakingNews NOTIFY breakingNewsChanged)
    Q_PROPERTY(QDateTime date READ date WRITE setDate NOTIFY dateChanged)
    Q_PROPERTY(QString firstSentence READ firstSentence WRITE setFirstSentence NOTIFY firstSentenceChanged)
    Q_PROPERTY(QString image READ image WRITE setImage NOTIFY imageChanged)
    Q_PROPERTY(quint8 region READ region WRITE setRegion NOTIFY regionChanged)
    Q_PROPERTY(QString sophoraId READ sophoraId WRITE setSophoraId NOTIFY sophoraIdChanged)
    Q_PROPERTY(QString thumbnail READ thumbnail WRITE setThumbnail NOTIFY thumbnailChanged)
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
    Q_PROPERTY(QString topline READ topline WRITE setTopline NOTIFY toplineChanged)

public:
    enum Region {
        RegionUndefined,
        RegionBW,
        RegionBY,
        RegionBE,
        RegionBB,
        RegionHB,
        RegionHH,
        RegionHE,
        RegionMV,
        RegionNI,
        RegionNW,
        RegionRP,
        RegionSR,
        RegionSN,
        RegionST,
        RegionSH,
        RegionTH
    };
    Q_ENUM(Region)

    explicit News(QObject *parent = nullptr);

    void addContentItem(ContentItem *item);
    void clearContentItems();
    Q_INVOKABLE ContentItem *contentItemAt(int index);
    QList<ContentItem *> contentItems() const;
    Q_INVOKABLE int contentItemsCount() const;


    // properties
    bool breakingNews() const;
    QDateTime date() const;
    QString firstSentence() const;
    QString image() const;
    quint8 region() const;
    QString sophoraId() const;
    QString thumbnail() const;
    QString title() const;
    QString topline() const;

signals:
    void contentItemsChanged(const QList<ContentItem *> &contentItems);

    // properties
    void breakingNewsChanged(bool breakingNews);
    void dateChanged(const QDateTime &date);
    void firstSentenceChanged(const QString &firstSentence);
    void imageChanged(const QString &image);
    void regionChanged(quint8 region);
    void sophoraIdChanged(const QString &sophoraId);
    void thumbnailChanged(const QString &thumbnail);
    void titleChanged(const QString &title);
    void toplineChanged(const QString &topline);

public slots:
    void setContentItems(const QList<ContentItem *> &items);

    // properties
    void setBreakingNews(bool breakingNews);
    void setDate(const QDateTime &date);
    void setFirstSentence(const QString &firstSentence);
    void setImage(const QString &image);
    void setRegion(quint8 region);
    void setSophoraId(const QString &sophoraId);
    void setThumbnail(const QString &thumbnail);
    void setTitle(const QString &title);
    void setTopline(const QString &topline);

private:
    QList<ContentItem *> m_contentItems;

    // properties
    bool m_breakingNews{false};
    QDateTime m_date;
    QString m_firstSentence;
    quint8 m_region{RegionUndefined};
    QString m_thumbnail;
    QString m_sophoraId;
    QString m_title;
    QString m_topline;
    QString m_image;
};

#endif // NEWS_H
