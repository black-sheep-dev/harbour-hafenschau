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
        id: newsResortModel
        url: {
            if (ressort === "regional") {
                const regions = JSON.parse(config.activeRegions)
                return "https://tagesschau.de/api2/news?regions=" + regions.join(',')
            } else {
                return "https://tagesschau.de/api2/news?ressort=" + ressort
            }
        }
    }

    PageBusyIndicator {
        running: newsResortModel.busy && listView.count === 0
    }

    SilicaListView {
        PullDownMenu {
            busy: newsResortModel.busy

            MenuItem {
                text: qsTr("Refresh")
                onClicked: newsResortModel.refresh()
            }
        }

        PushUpMenu {
            busy: newsResortModel.busy

            visible: newsResortModel.nextPage.length > 0

            MenuItem  {
                text: qsTr("Load more")
                onClicked: newsResortModel.loadMore()
            }
        }

        id: listView
        anchors.fill: parent

        header: PageHeader {
            title: page.ressortTitle
        }



        clip: true

        model: newsResortModel


        delegate: NewsListItem {
            id: delegate

            onClicked: {
                if (type === "webview") {
                    if (config.internalWebView) {
                        pageStack.push(Qt.resolvedUrl("WebViewPage.qml"), { url: detailsweb })
                    } else {
                        Qt.openUrlExternally(detailsweb)
                    }
                } else if (type === "video") {
                    pageStack.push(Qt.resolvedUrl("VideoPlayerPage.qml"), {
                                               title: title,
                                               streams: streams
                                           })
                } else {
                    pageStack.push(Qt.resolvedUrl("ReaderPage.qml"), { link: details })
                }
            }
        }

        ViewPlaceholder {
            enabled: listView.count === 0 && !newsResortModel.busy
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

    onRessortChanged: newsResortModel.fetch()
}

