import QtQuick 2.0
import Sailfish.Silica 1.0

import "../delegates"
import "../models"
import "../."

Page {
    property string ressortTitle
    property string ressort: ""

    id: page

    allowedOrientations: Orientation.All

    NewsModel {
        id: newsModel
        url: "https://tagesschau.de/api2/news?ressort=" + ressort
    }

    PageBusyIndicator {
        running: newsModel.busy && listView.count === 0
    }

    SilicaListView {
        PullDownMenu {
            busy: newsModel.busy

            MenuItem {
                text: qsTr("Refresh")
                onClicked: newsModel.refresh()
            }
        }

        PushUpMenu {
            busy: newsModel.busy

            visible: newsModel.nextPage.length > 0

            MenuItem  {
                text: qsTr("Load more")
                onClicked: newsModel.loadMore()
            }
        }

        id: listView
        anchors.fill: parent

        header: PageHeader {
            title: page.ressortTitle
        }



        clip: true

        model: newsModel.items

        delegate: NewsListItem {
            id: delegate



            onClicked: {
                if (modelData.type === "webview") {
                    if (config.internalWebView) {
                        pageStack.push(Qt.resolvedUrl("WebViewPage.qml"), {url: modelData.detailsweb })
                    } else {
                        Qt.openUrlExternally(modelData.detailsweb)
                    }
                } else if (modelData.type === "video") {
                    pageStack.push(Qt.resolvedUrl("VideoPlayerPage.qml"), {
                                               title: modelData.title,
                                               streams: modelData.streams
                                           })
                } else {
                    pageStack.push(Qt.resolvedUrl("ReaderPage.qml"), {link: modelData.details})
                }
            }
        }

        ViewPlaceholder {
            enabled: listView.count === 0 && !newsModel.busy
            text: qsTr("No news available")
            hintText: {
                if (ressort === "regional")
                    return qsTr("Please select some regions in settings first!")
                else
                    return qsTr("Please refresh or check internet connection!")
            }
        }

        VerticalScrollDecorator {}
    }

    onRessortChanged: newsModel.fetch()
}

