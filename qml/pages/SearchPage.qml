import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nubecula.harbour.hafenschau 1.0

import "../delegates"

Page {
    id: page

    allowedOrientations: Orientation.All

    SilicaFlickable {
        PullDownMenu {
            busy: ressortModel.loading
            MenuItem {
                text: qsTr("Refresh")
                onClicked: {
                    console.log(ressortModel.newsType)
                    HafenschauProvider.refresh(ressortModel.newsType)
                }
            }
        }

        anchors.fill: parent

        Column {
            id: header
            width: parent.width

            PageHeader {
                title: qsTr("Search Content")
            }

            SearchField {
                id: searchField
                width: parent.width
                height: listView.showSearch ? implicitHeight : 0
                opacity: listView.showSearch ? 1 : 0
                onTextChanged: {
                    filterModel.setFilterFixedString(text)
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

                thumbnail: model.thumbnail
                title: model.title
                firstSentence: model.firstSentence
                topline: model.topline

                onClicked: {
                    if (model.newsType === News.WebView) {
                        pageStack.push(Qt.resolvedUrl("../dialogs/OpenExternalUrlDialog.qml"), {url: model.detailsWeb })
                    } else if (model.newsType === News.Video) {
                        pageStack.push(Qt.resolvedUrl("../pages/VideoPlayerPage.qml"), {url: model.stream})
                    } else {
                        if (model.hasContent)
                            pageStack.push(Qt.resolvedUrl("ReaderPage.qml"), {news: ressortModel.newsAt(row)})
                        else
                            HafenschauProvider.getInternalLink(model.details)
                    }
                }
            }

            ViewPlaceholder {
                enabled: listView.count === 0
                text: qsTr("No content found")
                hintText: qsTr("Type in a search pattern to find content")
            }

            VerticalScrollDecorator {}
        }
    }

    Connections {
        target: HafenschauProvider
        onInternalLinkAvailable: pageStack.push(Qt.resolvedUrl("ReaderPage.qml"), { news: news })
    }

    onStatusChanged: {
        if (status === PageStatus.Deactivating) {
            searchField.focus = false
            searchField.text = ""
            listView.showSearch = false
        }
    }
}


