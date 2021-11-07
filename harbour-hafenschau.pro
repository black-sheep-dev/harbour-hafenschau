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
VERSION = 0.6.1-1
DEFINES += APP_VERSION=\\\"$$VERSION\\\"

# The name of your application
TARGET = harbour-hafenschau
DEFINES += APP_TARGET=\\\"$$TARGET\\\"

QT += multimedia dbus

CONFIG += link_pkgconfig sailfishapp
PKGCONFIG += \
    qt5embedwidget \
    nemonotifications-qt5 \
    connman-qt5

LIBS += -L../../lib -lkeepalive
LIBS += -lz

SOURCES += src/harbour-hafenschau.cpp \
    src/api/apiinterface.cpp \
    src/comments/commentsmodel.cpp \
    src/comments/commentssortfiltermodel.cpp \
    src/news/newslistmodel.cpp \
    src/news/newssortfiltermodel.cpp \
    src/region/regionsmodel.cpp \
    src/tools/datawriter.cpp

DISTFILES += qml/harbour-hafenschau.qml \
    qml/components/RemoteImage.qml \
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
    qml/content/ContentWebview.qml \
    qml/cover/CoverPage.qml \
    qml/delegates/NewsListItem.qml \
    qml/global.qml \
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
    qml/pages/settings/SettingsCachePage.qml \
    qml/pages/settings/SettingsCoverPage.qml \
    qml/pages/settings/SettingsDeveloperPage.qml \
    qml/pages/settings/SettingsPage.qml \
    qml/pages/settings/SettingsRegionsPage.qml \
    qml/pages/settings/SettingsVideoPage.qml \
    qml/pages/settings/SettingsWebviewPage.qml \
    qml/qmldir \
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
    src/api/apiinterface.h \
    src/comments/comment.h \
    src/comments/commentsmodel.h \
    src/comments/commentssortfiltermodel.h \
    src/enums/developeroption.h \
    src/enums/enums.h \
    src/enums/newstype.h \
    src/enums/ressort.h \
    src/enums/videoquality.h \
    src/news/newsitem.h \
    src/news/newslistmodel.h \
    src/news/newssortfiltermodel.h \
    src/region/regionsmodel.h \
    src/tools/datawriter.h

RESOURCES += \
    ressources.qrc

dbus.files = data/harbour.hafenschau.service
dbus.path = $$INSTALL_ROOT/usr/share/dbus-1/services

images.files = images/*.png
images.path = $$INSTALL_ROOT/usr/share/harbour-hafenschau/images

INSTALLS += dbus images
