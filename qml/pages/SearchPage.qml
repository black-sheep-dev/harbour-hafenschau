import QtQuick 2.0
import Sailfish.Silica 1.0

import "../delegates"
import "../."

Page {
    property bool busy: false
    property int ressort: Ressort.Search
    property string ressortTitle

    property int currentPage: 0
    property int totalItemCount: 0
    readonly property int pageSize: 20

    //property var items: []

    function search() {
        var query = "https://www.tagesschau.de/api2/search"
                + "?searchText=" + searchField.text
                + "&resultPage=" + currentPage
                + "&pageSize=" + pageSize

        busy = true
        Api.request(query, function(data, status) {
            busy = false
            if (status !== 200) {
                notify.show(qsTr("Failed to search"))
                console.log("Failed to search, got status:", status)
                return
            }

            totalItemCount = data.totalItemCount
            data.searchResults.forEach(function(item) { searchModel.append(item) })
        })
    }

    function reset() {
        currentPage = 0
        totalItemCount = 0
        searchField.text = ""
        items = []
    }

    id: page

    allowedOrientations: Orientation.All

    SilicaFlickable {
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
            running: busy && listView.count === 0
        }

        SilicaListView {
            id: listView

            onAtYEndChanged: {
                if (atYEnd && totalItemCount  > pageSize * currentPage + 1) {
                    currentPage++
                    search()
                }
            }

            width: parent.width
            anchors.top: header.bottom
            anchors.bottom: parent.bottom

            clip: true

            model: ListModel { id: searchModel }

            delegate: NewsListItem {
                id: delegate

                onClicked: {
                    if (modelData.type === "webview") {
                        pageStack.push(Qt.resolvedUrl("WebViewPage.qml"), {url: modelData.detailsWeb })
                    } else if (modelData.type === "video") {
                        pageStack.push(Qt.resolvedUrl("../pages/VideoPlayerPage.qml"), {streams: modelData.streams})
                    } else {
                        pageStack.push(Qt.resolvedUrl("ReaderPage.qml"), {link: modelData.details})
                    }
                }
            }

            ViewPlaceholder {
                enabled: listView.count === 0 && busy
                text: qsTr("No content found")
                hintText: qsTr("Type in a search pattern to find content")
            }

            VerticalScrollDecorator {}
        }
    }
}
