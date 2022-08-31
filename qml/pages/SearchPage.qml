import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nubecula.harbour.hafenschau 1.0

import "../delegates"

Page {
    property int ressort: Ressort.Search
    property string ressortTitle

    property int currentPage: 0
    property int totalItemCount: 0
    readonly property int pageSize: 20

    function search() {
        searchRequest.query = "https://www.tagesschau.de/api2/search/"
                + "?searchText=" + searchField.text
                + "&resultPage=" + currentPage
                + "&pageSize=" + pageSize

        api.request(searchRequest)
    }

    function reset() {
        currentPage = 0
        totalItemCount = 0
        searchField.text = ""
        newsModel.clear()
    }

    ApiRequest {
        id: searchRequest

        onFinished: {
            if (currentPage > 0) {
                newsModel.addItems(result.searchResults)
            } else {
                newsModel.setItems(result.searchResults)
            }
            totalItemCount = result.totalItemCount
        }
    }

    id: page

    allowedOrientations: Orientation.All

    SilicaFlickable {
        PushUpMenu {
            busy: searchRequest.loading
            visible: totalItemCount  > pageSize * currentPage + 1
            MenuItem {
                text: qsTr("Load more") + " (" + (currentPage + 1) + "/" + (Math.floor(totalItemCount / pageSize)) + ")"
                onClicked: {
                    currentPage++
                    search()
                }
            }
        }

        anchors.fill: parent

        Column {
            id: header
            width: parent.width

            PageHeader {
                title: ressortTitle
            }

            SearchField {
                id: searchField
                width: parent.width
                height: implicitHeight

                focus: true

                onTextChanged: if (searchField.text.length === 0) reset()

                EnterKey.onClicked: {
                    focus = false
                    search()
                }
            }
        }

        PageBusyIndicator {
            running: searchRequest.loading && listView.count === 0
        }

        SilicaListView {
            id: listView

            width: parent.width
            anchors.top: header.bottom
            anchors.bottom: parent.bottom

            clip: true

            model: NewsListModel {
                property bool error: false
                property bool loading: false

                id: newsModel
            }

            delegate: NewsListItem {
                id: delegate

                onClicked: {
                    if (model.type === NewsType.WebView) {
                        pageStack.push(Qt.resolvedUrl("WebViewPage.qml"), {url: model.detailsWeb })
                    } else if (model.type === NewsType.Video) {
                        pageStack.push(Qt.resolvedUrl("../pages/VideoPlayerPage.qml"), {streams: model.streams})
                    } else {
                        pageStack.push(Qt.resolvedUrl("ReaderPage.qml"), {link: model.details})
                    }
                }
            }

            ViewPlaceholder {
                enabled: listView.count === 0 && !searchRequest.loading
                text: qsTr("No content found")
                hintText: qsTr("Type in a search pattern to find content")
            }

            VerticalScrollDecorator {}
        }
    }
}
