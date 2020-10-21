#ifndef CONTENTITEMSOCIAL_H
#define CONTENTITEMSOCIAL_H

#include "contentitem.h"

#include <QDateTime>

class ContentItemSocial : public ContentItem
{
    Q_OBJECT

    Q_PROPERTY(QString account READ account WRITE setAccount NOTIFY accountChanged)
    Q_PROPERTY(QString avatar READ avatar WRITE setAvatar NOTIFY avatarChanged)
    Q_PROPERTY(QDateTime date READ date WRITE setDate NOTIFY dateChanged)
    Q_PROPERTY(QString image READ image WRITE setImage NOTIFY imageChanged)
    Q_PROPERTY(QString shorttext READ shorttext WRITE setShorttext NOTIFY shorttextChanged)
    Q_PROPERTY(quint8 socialType READ socialType WRITE setSocialType NOTIFY socialTypeChanged)
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
    Q_PROPERTY(QString url READ url WRITE setUrl NOTIFY urlChanged)
    Q_PROPERTY(QString username READ username WRITE setUsername NOTIFY usernameChanged)

public:
    enum SocialType {
        Unkown,
        Twitter
    };
    Q_ENUM(SocialType)

    explicit ContentItemSocial(QObject *parent = nullptr);

    QString account() const;
    QString avatar() const;
    QDateTime date() const;
    QString image() const;
    QString shorttext() const;
    quint8 socialType() const;
    QString title() const;
    QString url() const;
    QString username() const;

signals:
    void accountChanged(const QString &account);
    void avatarChanged(const QString &avatar);
    void dateChanged(QDateTime date);
    void imageChanged(const QString &image);
    void shorttextChanged(const QString &shorttext);
    void socialTypeChanged(quint8 socialType);
    void titleChanged(const QString &title);
    void urlChanged(const QString &url);
    void usernameChanged(const QString &username);

public slots:
    void setAccount(const QString &account);
    void setAvatar(const QString &avatar);
    void setDate(const QDateTime &date);
    void setImage(const QString &image);
    void setShorttext(const QString &shorttext);
    void setSocialType(quint8 socialType);
    void setTitle(const QString &title);
    void setUrl(const QString &url);
    void setUsername(const QString &username);

private:
    QString m_account;
    QString m_avatar;
    QDateTime m_date;
    QString m_image;
    QString m_shorttext;
    quint8 m_socialType{SocialType::Unkown};
    QString m_title;
    QString m_url;
    QString m_username;

};

#endif // CONTENTITEMSOCIAL_H
