import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nubecula.harbour.hafenschau 1.0

Page {
    id: page

    allowedOrientations: Orientation.All

    SilicaListView {
        PullDownMenu {
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
            MenuItem {
                text: qsTr("Preferences")
                //onClicked: {}
            }
            MenuItem {
                text: qsTr("Refresh")
                onClicked: HafenschauProvider.refresh()
            }
        }

        id: listView
        model: HafenschauProvider.newsModel()

        anchors.fill: parent

        header: PageHeader {
            title: qsTr("Top News")
        }

        delegate: ListItem {
            id: delegate

            contentHeight: Theme.itemSizeHuge * 1.2


            Image {
                id: thumbnailImage

                x: Theme.horizontalPageMargin
                width: Theme.itemSizeHuge
                height: width
                anchors.verticalCenter: parent.verticalCenter

                fillMode: Image.PreserveAspectCrop

                source: thumbnail
                cache: true
                smooth: true

                BusyIndicator {
                    size: BusyIndicatorSize.Medium
                    anchors.centerIn: thumbnailImage
                    running: thumbnailImage.status != Image.Ready
                }
            }

            Column {
                id: column

                anchors.left: thumbnailImage.right
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter

                spacing: Theme.paddingSmall

                Label {
                    text: topline

                    x: Theme.paddingMedium
                    width: parent.width - 2*x
                    wrapMode: Text.WordWrap

                    font.pixelSize: Theme.fontSizeExtraSmall
                }
                Label {
                    text: title

                    x: Theme.paddingMedium
                    width: parent.width - 2*x
                    wrapMode: Text.WordWrap

                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.highlightColor
                }
                Label {
                    text: first_sentence

                    x: Theme.paddingMedium
                    width: parent.width - 2*x
                    wrapMode: Text.WordWrap

                    font.pixelSize: Theme.fontSizeExtraSmall
                }
            }

            Separator {
                id: separatorBottom
                x: Theme.horizontalPageMargin
                anchors.bottom: parent.bottom
                width: parent.width
                color: Theme.primaryColor
            }


            onClicked: pageStack.push(Qt.resolvedUrl("ReaderPage.qml"), {news: HafenschauProvider.newsModel().newsAt(index)})
        }
        VerticalScrollDecorator {}
    }
}
