import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nubecula.harbour.hafenschau 1.0

import "../delegates"

Page {
    property string ressortTitle
    property NewsModel ressortModel

    id: page

    allowedOrientations: Orientation.All

    SilicaFlickable {
        PullDownMenu {
            busy: ressortModel.loading
            MenuItem {
                text: qsTr("Refresh")
                onClicked: {
                    ressortModel.forceRefresh()
                    HafenschauProvider.refresh(ressortModel.newsType)    
                }
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
            busy: ressortModel.loading
            visible: ressortModel.nextPage.length > 0
            MenuItem {
                text: qsTr("Load more")
                onClicked: HafenschauProvider.getNextPage(ressortModel.newsType)
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
                sourceModel: ressortModel
            }

            delegate: NewsListItem {
                id: delegate

                onClicked: {
                    if (model.newsType === News.WebView) {
                        if (HafenschauProvider.internalWebView) {
                            pageStack.push(Qt.resolvedUrl("WebViewPage.qml"), {url: model.detailsWeb })
                        } else {
                            pageStack.push(Qt.resolvedUrl("../dialogs/OpenExternalUrlDialog.qml"), {url: model.detailsWeb })
                        }
                    } else if (model.newsType === News.Video) {
                        pageStack.push(Qt.resolvedUrl("VideoPlayerPage.qml"), {url: model.stream})
                    } else {
                        if (model.hasContent)
                            pageStack.push(Qt.resolvedUrl("ReaderPage.qml"), {news: ressortModel.newsAt(row)})
                        else
                            pageStack.push(Qt.resolvedUrl("ReaderPage.qml"), {link: model.details})
                    }
                }
            }

            ViewPlaceholder {
                enabled: listView.count === 0
                text: qsTr("No news available")
                hintText: {
                    if (ressortModel.newsType === NewsModel.Regional)
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
}

