import QtQuick 2.0
import Sailfish.Silica 1.0

import "../delegates"
import "../."

Page {
    id: page

    allowedOrientations: Orientation.All

    PageBusyIndicator {
        running: mainNews.busy && listView.count === 0
    }

    SilicaListView {
        PullDownMenu {
            busy: mainNews.busy
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
            MenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.push(Qt.resolvedUrl("settings/SettingsPage.qml"))
            }
            MenuItem {
                text: qsTr("Refresh")
                onClicked: mainNews.refresh()
            }
        }

        id: listView

        anchors.fill: parent

        header: PageHeader {
            title: qsTr("Top News")
        }

        model: mainNews

        delegate: NewsListItem {
            id: delegate

            onClicked: {
                if (type === "webview") {
                    if (config.internalWebView) {
                        pageStack.push(Qt.resolvedUrl("WebViewPage.qml"), { url: detailsweb })
                    } else {
                        Qt.openUrlExternally(detailsweb)
                    }

                } else {
                    pageStack.push(Qt.resolvedUrl("ReaderPage.qml"), { link: details })
                }
            }
        }

        ViewPlaceholder {
            visible: !mainNews.busy
            enabled: listView.count === 0
            text: qsTr("No news available")
            hintText: qsTr("Check your internet connection")
        }

        VerticalScrollDecorator {}
    }

    onStatusChanged: if (status === PageStatus.Active) pageStack.pushAttached(Qt.resolvedUrl("RessortListPage.qml"))
}
