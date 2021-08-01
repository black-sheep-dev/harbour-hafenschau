import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nubecula.harbour.hafenschau 1.0

import "../delegates"

Page {
    id: page

    allowedOrientations: Orientation.All

    SilicaListView {
        PullDownMenu {
            busy: HafenschauProvider.newsModel().loading
            MenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.push(Qt.resolvedUrl("settings/SettingsPage.qml"))
            }
            MenuItem {
                text: qsTr("All News")
                onClicked: pageStack.push(Qt.resolvedUrl("RessortListPage.qml"))
            }
//            MenuItem {
//                text: qsTr("Test")
//                onClicked: HafenschauProvider.test()
//            }
            MenuItem {
                text: qsTr("Refresh")
                onClicked: {
                    HafenschauProvider.newsModel().forceRefresh()
                    HafenschauProvider.refresh(NewsModel.Homepage)

                }
            }
        }

        id: listView

        anchors.fill: parent

        header: PageHeader {
            title: qsTr("Top News")
        }

        model: NewsSortFilterModel {
            id: filterModel
            sourceModel: HafenschauProvider.newsModel()
        }

        delegate: NewsListItem {
            id: delegate

            onClicked: {
                if (newsType === News.WebView) {
                    if (HafenschauProvider.internalWebView) {
                        pageStack.push(Qt.resolvedUrl("WebViewPage.qml"), {url: model.detailsWeb })
                    } else {
                        pageStack.push(Qt.resolvedUrl("../dialogs/OpenExternalUrlDialog.qml"), {url: model.detailsWeb })
                    }

                } else {
                    pageStack.push(Qt.resolvedUrl("ReaderPage.qml"), {news: HafenschauProvider.newsModel().newsAt(row)})
                }
            }
        }

        ViewPlaceholder {
            enabled: listView.count === 0 && !HafenschauProvider.newsModel().loading
            text: qsTr("No news available")
            hintText: qsTr("Check your internet connection")
        }

        VerticalScrollDecorator {}
    }
}
