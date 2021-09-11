import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nubecula.harbour.hafenschau 1.0

import "../delegates"
import "../."

Page {
    id: page

    allowedOrientations: Orientation.All

    PageBusyIndicator {
        running: mainModel.loading && listView.count === 0
    }

    SilicaListView {
        PullDownMenu {
            busy: mainModel.loading
            MenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.animatorPush(Qt.resolvedUrl("settings/SettingsPage.qml"))
            }
            MenuItem {
                text: qsTr("Livestream")
                onClicked: pageStack.animatorPush(Qt.resolvedUrl("VideoPlayerPage.qml"), {
                                                      title: "Tagesschau 24 (Live)",
                                                      livestream: "https://tagesschau-lh.akamaihd.net/i/tagesschau_3@66339/master.m3u8"
                                                  })
            }

            MenuItem {
                text: qsTr("All News")
                onClicked: pageStack.animatorPush(Qt.resolvedUrl("RessortListPage.qml"))
            }
            MenuItem {
                enabled: networkManager.connected
                text: qsTr("Refresh")
                onClicked: mainModel.checkForUpdate()
            }
        }

        id: listView

        anchors.fill: parent

        header: PageHeader {
            title: qsTr("Top News")
        }

        model: mainModel

        delegate: NewsListItem {
            id: delegate

            onClicked: {
                if (model.type === NewsType.WebView) {
                    if (settings.internalWebView) {
                        pageStack.animatorPush(Qt.resolvedUrl("WebViewPage.qml"), {url: model.detailsWeb })
                    } else {
                        Qt.openUrlExternally(model.detailsWeb)
                    }

                } else {
                    pageStack.animatorPush(Qt.resolvedUrl("ReaderPage.qml"), {link: model.details})
                }
            }
        }

        ViewPlaceholder {
            enabled: listView.count === 0 && !mainModel.loading
            text: qsTr("No news available")
            hintText: qsTr("Check your internet connection")
        }

        VerticalScrollDecorator {}
    }

    Component.onCompleted: mainModel.refresh()
}
