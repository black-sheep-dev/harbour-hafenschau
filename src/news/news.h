#ifndef NEWS_H
#define NEWS_H

#include <QObject>

#include <QDateTime>
#include <QJsonObject>
#include <QList>

#include "src/content/contentitem.h"
#include "src/content/contentitemaudio.h"
#include "src/content/contentitembox.h"
#include "src/content/contentitemgallery.h"
#include "src/content/contentitemrelated.h"
#include "src/content/contentitemsocial.h"
#include "src/content/contentitemvideo.h"

class News : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QList<ContentItem *> contentItems READ contentItems WRITE setContentItems NOTIFY contentItemsChanged)

    Q_PROPERTY(QString brandingImage READ brandingImage WRITE setBrandingImage NOTIFY brandingImageChanged)
    Q_PROPERTY(bool breakingNews READ breakingNews WRITE setBreakingNews NOTIFY breakingNewsChanged)
    Q_PROPERTY(QDateTime date READ date WRITE setDate NOTIFY dateChanged)
    Q_PROPERTY(QString detailsWeb READ detailsWeb WRITE setDetailsWeb NOTIFY detailsWebChanged)
    Q_PROPERTY(QString firstSentence READ firstSentence WRITE setFirstSentence NOTIFY firstSentenceChanged)
    Q_PROPERTY(QString image READ image WRITE setImage NOTIFY imageChanged)
    Q_PROPERTY(quint8 newsType READ newsType WRITE setNewsType NOTIFY newsTypeChanged)
    Q_PROPERTY(QString portrait READ portrait WRITE setPortrait NOTIFY portraitChanged)
    Q_PROPERTY(quint8 region READ region WRITE setRegion NOTIFY regionChanged)
    Q_PROPERTY(QString sophoraId READ sophoraId WRITE setSophoraId NOTIFY sophoraIdChanged)
    Q_PROPERTY(QString thumbnail READ thumbnail WRITE setThumbnail NOTIFY thumbnailChanged)
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
    Q_PROPERTY(QString topline READ topline WRITE setTopline NOTIFY toplineChanged)
    Q_PROPERTY(QString updateCheckUrl READ updateCheckUrl WRITE setUpdateCheckUrl NOTIFY updateCheckUrlChanged)

public:
    enum NewsType {
        Undefined,
        Story,              // story
        WebView             // webview
    };
    Q_ENUM(NewsType)

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

    // developer mode debug data
    QJsonObject debugData() const;
    void setDebugData(const QJsonObject &obj);

    // properties
    QString brandingImage() const;
    bool breakingNews() const;
    QDateTime date() const;
    QString detailsWeb() const;
    QString firstSentence() const;
    QString image() const;
    quint8 newsType() const;
    QString portrait() const;
    quint8 region() const;
    QString sophoraId() const;
    QString thumbnail() const;
    QString title() const;
    QString topline() const;
    QString updateCheckUrl() const;

signals:
    void contentItemsChanged(const QList<ContentItem *> &contentItems);

    // properties
    void brandingImageChanged(const QString &brandingImage);
    void breakingNewsChanged(bool breakingNews);
    void dateChanged(const QDateTime &date);
    void detailsWebChanged(const QString &detailsWeb);
    void firstSentenceChanged(const QString &firstSentence);
    void imageChanged(const QString &image);
    void newsTypeChanged(quint8 newsType);
    void portraitChanged(const QString &portrait);
    void regionChanged(quint8 region);
    void sophoraIdChanged(const QString &sophoraId);
    void thumbnailChanged(const QString &thumbnail);
    void titleChanged(const QString &title);
    void toplineChanged(const QString &topline);
    void updateCheckUrlChanged(const QString &url);

public slots:
    void setContentItems(const QList<ContentItem *> &items);

    // properties
    void setBrandingImage(const QString &brandingImage);
    void setBreakingNews(bool breakingNews);
    void setDate(const QDateTime &date);
    void setDetailsWeb(const QString &detailsWeb);
    void setFirstSentence(const QString &firstSentence);
    void setImage(const QString &image);
    void setNewsType(quint8 newsType);
    void setPortrait(const QString &portrait);
    void setRegion(quint8 region);
    void setSophoraId(const QString &sophoraId);
    void setThumbnail(const QString &thumbnail);
    void setTitle(const QString &title);
    void setTopline(const QString &topline);  
    void setUpdateCheckUrl(const QString &url);

private:
    QList<ContentItem *> m_contentItems;

    QJsonObject m_debugData;

    // properties
    QString m_brandingImage;
    bool m_breakingNews{false};
    QDateTime m_date;
    QString m_detailsWeb;
    QString m_firstSentence;
    quint8 m_newsType{Undefined};
    QString m_portrait;
    quint8 m_region{RegionUndefined};
    QString m_thumbnail;
    QString m_sophoraId;
    QString m_title;
    QString m_topline;
    QString m_image;
    QString m_updateCheckUrl;
};

#endif // NEWS_H
