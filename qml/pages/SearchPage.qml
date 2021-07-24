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
        PushUpMenu {
            busy: ressortModel.loading
            visible: ressortModel.pages > ressortModel.currentPage
            MenuItem {
                text: qsTr("Load more") + " (" + ressortModel.currentPage + "/" + ressortModel.pages + ")"
                onClicked: HafenschauProvider.searchContent(searchField.text, ressortModel.currentPage + 1)
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

                onTextChanged: if (text.length === 0) ressortModel.reset()

                EnterKey.onClicked: {
                    focus = false
                    HafenschauProvider.searchContent(text, ressortModel.currentPage)
                }
            }
        }

        SilicaListView {
            id: listView

            width: parent.width
            anchors.top: header.bottom
            anchors.bottom: parent.bottom

            clip: true

            model: ressortModel

            delegate: NewsListItem {
                id: delegate

                onClicked: {
                    if (model.newsType === News.WebView) {
                        pageStack.push(Qt.resolvedUrl("../dialogs/OpenExternalUrlDialog.qml"), {url: model.detailsWeb })
                    } else if (model.newsType === News.Video) {
                        pageStack.push(Qt.resolvedUrl("../pages/VideoPlayerPage.qml"), {url: model.stream})
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
                text: qsTr("No content found")
                hintText: qsTr("Type in a search pattern to find content")
            }

            VerticalScrollDecorator {}
        }
    }
}


