# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# VERSION
VERSION = 0.3.7-1
DEFINES += APP_VERSION=\\\"$$VERSION\\\"

# The name of your application
TARGET = harbour-hafenschau
DEFINES += APP_TARGET=\\\"$$TARGET\\\"

QT += multimedia dbus

CONFIG += link_pkgconfig sailfishapp
PKGCONFIG += qt5embedwidget nemonotifications-qt5

LIBS += -L../../lib -lkeepalive
LIBS += -lz

SOURCES += src/harbour-hafenschau.cpp \
    src/api/api_keys.cpp \
    src/api/apiinterface.cpp \
    src/comments/commentsmodel.cpp \
    src/comments/commentssortfiltermodel.cpp \
    src/content/contentitem.cpp \
    src/content/contentitemaudio.cpp \
    src/content/contentitembox.cpp \
    src/content/contentitemgallery.cpp \
    src/content/contentitemlist.cpp \
    src/content/contentitemrelated.cpp \
    src/content/contentitemsocial.cpp \
    src/content/contentitemvideo.cpp \
    src/content/galleryitem.cpp \
    src/content/gallerymodel.cpp \
    src/content/relateditem.cpp \
    src/content/relatedmodel.cpp \
    src/hafenschauprovider.cpp \
    src/news/news.cpp \
    src/news/newsmodel.cpp \
    src/news/newssortfiltermodel.cpp \
    src/region/regionsmodel.cpp

DISTFILES += qml/harbour-hafenschau.qml \
    qml/content/ContentAudio.qml \
    qml/content/ContentBox.qml \
    qml/content/ContentGallery.qml \
    qml/content/ContentHeadline.qml \
    qml/content/ContentHtmlEmbed.qml \
    qml/content/ContentList.qml \
    qml/content/ContentQuotation.qml \
    qml/content/ContentRelated.qml \
    qml/content/ContentSocial.qml \
    qml/content/ContentText.qml \
    qml/content/ContentUnkown.qml \
    qml/content/ContentVideo.qml \
    qml/cover/CoverPage.qml \
    qml/delegates/NewsListItem.qml \
    qml/dialogs/OpenExternalUrlDialog.qml \
    qml/pages/CommentsListPage.qml \
    qml/pages/DataReaderPage.qml \
    qml/pages/GalleryPage.qml \
    qml/pages/NewsListPage.qml \
    qml/pages/ReaderPage.qml \
    qml/pages/RessortListPage.qml \
    qml/pages/SearchPage.qml \
    qml/pages/StartPage.qml \
    qml/pages/VideoPlayerPage.qml \
    qml/pages/WebViewPage.qml \
    qml/pages/settings/SettingsAutoRefreshPage.qml \
    qml/pages/settings/SettingsCoverPage.qml \
    qml/pages/settings/SettingsDeveloperPage.qml \
    qml/pages/settings/SettingsPage.qml \
    qml/pages/settings/SettingsRegionsPage.qml \
    rpm/harbour-hafenschau.changes \
    rpm/harbour-hafenschau.changes.run.in \
    rpm/harbour-hafenschau.spec \
    rpm/harbour-hafenschau.yaml \
    translations/*.ts \
    harbour-hafenschau.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172 512x512

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/harbour-hafenschau-de.ts

HEADERS += \
    src/api/api_keys.h \
    src/api/apiinterface.h \
    src/comments/comment.h \
    src/comments/commentsmodel.h \
    src/comments/commentssortfiltermodel.h \
    src/content/contentitem.h \
    src/content/contentitemaudio.h \
    src/content/contentitembox.h \
    src/content/contentitemgallery.h \
    src/content/contentitemlist.h \
    src/content/contentitemrelated.h \
    src/content/contentitemsocial.h \
    src/content/contentitemvideo.h \
    src/content/galleryitem.h \
    src/content/gallerymodel.h \
    src/content/relateditem.h \
    src/content/relatedmodel.h \
    src/hafenschauprovider.h \
    src/news/news.h \
    src/news/newsmodel.h \
    src/news/newssortfiltermodel.h \
    src/region/regionsmodel.h

RESOURCES += \
    ressources.qrc

dbus.files = data/harbour.hafenschau.service
dbus.path = $$INSTALL_ROOT/usr/share/dbus-1/services

images.files = images/*.png
images.path = $$INSTALL_ROOT/usr/share/harbour-hafenschau/images

INSTALLS += dbus images
