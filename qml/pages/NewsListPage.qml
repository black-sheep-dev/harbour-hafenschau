import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nubecula.harbour.hafenschau 1.0

import "../delegates"
import "../."

Page {
    property string ressortTitle
    property int ressort: Ressort.Undefined
    property string ressortQuery

    property string previousPage
    property string nextPage

    id: page

    allowedOrientations: Orientation.All

    function checkRequest(request) {
        const parts = request.split('.')
        if (parts.length <= 3) return false

        if (parts[0] !== "ressortModel") return false
        if (parts[1] !== String(ressort)) return false

        return true
    }

    function refresh() {
        newsModel.loading = true
        newsModel.error = false

        const query = "https://www.tagesschau.de/api2/news/"
        query += ressortQuery

        api.request(query, "ressortModel." + ressort + ".refresh", false)
    }

    function loadMore() {
        newsModel.loading = true
        newsModel.error = false
        api.request(nextPage, "ressortModel." + ressort + ".loadMore", false)
    }

    Connections {
        target: api
        onRequestFailed: {
            if (checkRequest(id)) return
            newsModel.loading = false
            newsModel.error = true
            notification.show(qsTr("Failed to get news"))
        }

        onRequestFinished: {
            if (checkRequest(id)) return

            const mode = id.split('.')[2]

            newsModel.loading = false

            if (mode === "refresh") {
                newsModel.setItems(data.news)
            } else if (mode === "loadMore") {
                newsModel.addItems(data.news)
            }

            nextPage = data.nextPage
        }
    }

    PageBusyIndicator {
        running: newsModel.loading && listView.count === 0
    }

    SilicaFlickable {
        PullDownMenu {
            busy: newsModel.loading

            MenuItem {
                enabled: networkManager.connected
                text: qsTr("Refresh")
                onClicked: refresh()
            }
            MenuItem {
                text: listView.showSearch ? qsTr("Hide search") : qsTr("Search")
                onClicked: {
                    listView.showSearch = !listView.showSearch

                    if (!listView.showSearch) {
                        searchField.focus = false
                        searchField.text = ""
                    }
                }
            }
        }

        PushUpMenu {
            busy: newsModel.loading
            visible: nextPage.length > 0

            MenuItem  {
                text: qsTr("Load more")
                onClicked: loadMore()
            }
        }

        anchors.fill: parent

        Column {
            id: header
            width: parent.width

            PageHeader {
                title: page.ressortTitle
            }

            SearchField {
                id: searchField
                width: parent.width
                height: listView.showSearch ? implicitHeight : 0
                opacity: listView.showSearch ? 1 : 0
                onTextChanged: {
                    filterModel.setFilterFixedString(text)
                }

                EnterKey.onClicked: searchField.focus = false

                Connections {
                    target: listView
                    onShowSearchChanged: {
                        searchField.forceActiveFocus()
                    }
                }

                Behavior on height {
                    NumberAnimation { duration: 300 }
                }
                Behavior on opacity {
                    NumberAnimation { duration: 300 }
                }
            }
        }

        SilicaListView {
            property bool showSearch: false

            id: listView

            width: parent.width
            anchors.top: header.bottom
            anchors.bottom: parent.bottom

            clip: true

            model: NewsSortFilterModel {
                id: filterModel
                sourceModel: NewsListModel {
                    property bool error: false
                    property bool loading: false

                    id: newsModel
                }
            }

            delegate: NewsListItem {
                id: delegate

                onClicked: {
                    if (model.type === NewsType.WebView) {
                        if (settings.internalWebView) {
                            pageStack.push(Qt.resolvedUrl("WebViewPage.qml"), {url: model.detailsWeb })
                        } else {
                            Qt.openUrlExternally(model.detailsWeb)
                        }
                    } else if (model.type === NewsType.Video) {
                        pageStack.push(Qt.resolvedUrl("VideoPlayerPage.qml"), {
                                                   title: model.title,
                                                   streams: model.streams
                                               })
                    } else {
                        pageStack.push(Qt.resolvedUrl("ReaderPage.qml"), {link: model.details})
                    }
                }
            }

            ViewPlaceholder {
                enabled: listView.count === 0 && !newsModel.loading
                text: qsTr("No news available")
                hintText: {
                    if (ressort === Ressort.Regional)
                        return qsTr("Please select some regions in settings first!")
                    else
                        return qsTr("Please refresh or check internet connection!")
                }
            }

            VerticalScrollDecorator {}
        }
    }

    onStatusChanged: {
        if (status === PageStatus.Deactivating) {
            searchField.focus = false
            searchField.text = ""
            listView.showSearch = false
        }
    }

    Component.onCompleted: {
        const query = "?ressort="

        switch (ressort) {
        case Ressort.Ausland:
            query += "ausland"
            break;

        case Ressort.Inland:
            query += "inland"
            break;

        case Ressort.Investigativ:
            query += "investigativ"
            break;

        case Ressort.Regional:
            query = "?regions=" + Global.activeRegions.join(',')
            break;

        case Ressort.Search:
            break;

        case Ressort.Sport:
            query += "sport"
            break;

        case Ressort.Video:
            query += "video"
            break;

        case Ressort.Wirtschaft:
            query += "wirtschaft"
            break;

        default:
            break;
        }

        ressortQuery = query

        refresh()
    }
}

