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
                onClicked: pageStack.push(Qt.resolvedUrl("settings/SettingsPage.qml"))
            }
            MenuItem {
                text: qsTr("Refresh")
                onClicked: mainModel.checkForUpdate()
            }
        }

        id: listView

        anchors.fill: parent

        opacity: (mainModel.loading && listView.count === 0) ? 0.0 : 1.0

        Behavior on opacity { FadeAnimation {} }

        header: PageHeader {
            title: qsTr("Top News")
        }

        model: mainModel

        delegate: NewsListItem {
            id: delegate

            onClicked: {
                if (model.type === NewsType.WebView) {
                    if (settings.internalWebView) {
                        pageStack.push(Qt.resolvedUrl("WebViewPage.qml"), {url: model.detailsWeb })
                    } else {
                        Qt.openUrlExternally(model.detailsWeb)
                    }

                } else {
                    pageStack.push(Qt.resolvedUrl("ReaderPage.qml"), {link: model.details})
                }
            }
        }

        ViewPlaceholder {
            visible: !mainModel.loading
            enabled: listView.count === 0
            text: qsTr("No news available")
            hintText: qsTr("Check your internet connection")
        }

        VerticalScrollDecorator {}
    }

    Component.onCompleted: mainModel.refresh()

    onStatusChanged: if (status === PageStatus.Active) pageStack.pushAttached(Qt.resolvedUrl("RessortListPage.qml"))
}
