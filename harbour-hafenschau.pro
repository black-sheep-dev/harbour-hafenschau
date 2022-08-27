# VERSION
VERSION = 0.8.0-1
DEFINES += APP_VERSION=\\\"$$VERSION\\\"

# The name of your application
TARGET = harbour-hafenschau
DEFINES += APP_TARGET=\\\"$$TARGET\\\"

QT += dbus

CONFIG += link_pkgconfig sailfishapp
PKGCONFIG += \
    qt5embedwidget \
    nemonotifications-qt5 \
    keepalive

LIBS += -lz

SOURCES += src/harbour-hafenschau.cpp \
    src/api/apiinterface.cpp \
    src/api/apirequest.cpp \
    src/api/networkaccessmanagerfactory.cpp \
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
    qml/pages/StreamsListPage.qml \
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

CONFIG += sailfishapp_i18n

TRANSLATIONS += translations/harbour-hafenschau-de.ts

HEADERS += \
    src/api/apiinterface.h \
    src/api/apirequest.h \
    src/api/networkaccessmanagerfactory.h \
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

images.files = images/*.png
images.path = $$INSTALL_ROOT/usr/share/harbour-hafenschau/images

INSTALLS += images
