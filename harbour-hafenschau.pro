TARGET = harbour-hafenschau

CONFIG += sailfishapp_qml
PKGCONFIG += \
    qt5embedwidget \
    nemonotifications-qt5 \
    keepalive

DISTFILES += qml/harbour-hafenschau.qml \
    qml/api.qml \
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
    qml/models/CommentsModel.qml \
    qml/models/NewsModel.qml \
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
    qml/pages/settings/SettingsCoverPage.qml \
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

icons.files = icons/*.svg
icons.path = $$INSTALL_ROOT/usr/share/harbour-hafenschau/icons

images.files = images/*.png
images.path = $$INSTALL_ROOT/usr/share/harbour-hafenschau/images

INSTALLS += icons images
