#include "contentitemsocial.h"

ContentItemSocial::ContentItemSocial(QObject *parent) :
    ContentItem(parent)
{
    setContentType(ContentType::Social);
}

QString ContentItemSocial::account() const
{
    return m_account;
}

QString ContentItemSocial::avatar() const
{
    return m_avatar;
}

QDateTime ContentItemSocial::date() const
{
    return m_date;
}

QString ContentItemSocial::image() const
{
    return m_image;
}

QString ContentItemSocial::shorttext() const
{
    return m_shorttext;
}

quint8 ContentItemSocial::socialType() const
{
    return m_socialType;
}

QString ContentItemSocial::title() const
{
    return m_title;
}

QString ContentItemSocial::url() const
{
    return m_url;
}

QString ContentItemSocial::username() const
{
    return m_username;
}

void ContentItemSocial::setAccount(const QString &account)
{
    if (m_account == account)
        return;

    m_account = account;
    emit accountChanged(m_account);
}

void ContentItemSocial::setAvatar(const QString &avatar)
{
    if (m_avatar == avatar)
        return;

    m_avatar = avatar;
    emit avatarChanged(m_avatar);
}

void ContentItemSocial::setDate(const QDateTime &date)
{
    if (m_date == date)
        return;

    m_date = date;
    emit dateChanged(m_date);
}

void ContentItemSocial::setImage(const QString &image)
{
    if (m_image == image)
        return;

    m_image = image;
    emit imageChanged(m_image);
}

void ContentItemSocial::setShorttext(const QString &shorttext)
{
    if (m_shorttext == shorttext)
        return;

    m_shorttext = shorttext;
    emit shorttextChanged(m_shorttext);
}

void ContentItemSocial::setSocialType(quint8 socialType)
{
    if (m_socialType == socialType)
        return;

    m_socialType = socialType;
    emit socialTypeChanged(m_socialType);
}

void ContentItemSocial::setTitle(const QString &title)
{
    if (m_title == title)
        return;

    m_title = title;
    emit titleChanged(m_title);
}

void ContentItemSocial::setUrl(const QString &url)
{
    if (m_url == url)
        return;

    m_url = url;
    emit urlChanged(m_url);
}

void ContentItemSocial::setUsername(const QString &username)
{
    if (m_username == username)
        return;

    m_username = username;
    emit usernameChanged(m_username);
}
