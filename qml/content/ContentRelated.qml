import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nubecula.harbour.hafenschau 1.0

import "../components/"

BackgroundItem {
    property ContentItemRelated item

    width: parent.width
    height: separatorTop.height + labelHeader.height + listView.height + 2 * columnBox.spacing

    Column {
        id: columnBox
        width: parent.width
        spacing: Theme.paddingMedium

        Separator {
            id: separatorTop
            x: Theme.horizontalPageMargin
            width: parent.width - 2*x
            color: Theme.highlightBackgroundColor
        }

        Label {
            id: labelHeader
            x: Theme.horizontalPageMargin
            width: parent.width - 2*x

            font.pixelSize: Theme.fontSizeMedium
            wrapMode: Text.WordWrap

            color: Theme.highlightColor

            text: qsTr("More on the subject")
        }

        SilicaListView {
            id: listView
            width: parent.width

            height: Theme.itemSizeHuge * item.model().itemsCount()

            model: item.model()

            contentHeight: Theme.itemSizeHuge

            delegate: ListItem {
                id: delegate

                contentHeight: Theme.itemSizeHuge

                RemoteImage {
                    id: thumbnailImage
                    anchors.verticalCenter: parent.verticalCenter

                    x: Theme.horizontalPageMargin
                    width: Theme.itemSizeHuge * 0.8
                    height: width

                    source: model.image
                    placeholderUrl: "/usr/share/harbour-hafenschau/images/dummy_thumbnail.png"

                    Image {
                        visible: related_type === RelatedItem.RelatedVideo
                        anchors.centerIn: parent
                        source: "image://theme/icon-m-play"
                    }
                }

                Column {
                    id: column

                    anchors.left: thumbnailImage.right
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter

                    spacing: Theme.paddingSmall

                    Label {
                        visible: related_type !== RelatedItem.RelatedVideo

                        text: topline

                        x: Theme.paddingMedium
                        width: parent.width - 2*x
                        wrapMode: Text.WordWrap

                        font.pixelSize: Theme.fontSizeSmall
                    }
                    Label {
                        text: title

                        x: Theme.paddingMedium
                        width: parent.width - 2*x
                        wrapMode: Text.WordWrap

                        font.pixelSize: Theme.fontSizeMedium
                        color: Theme.highlightColor
                    }
                }

                Separator {
                    visible: index < (listView.count - 1)
                    id: separatorBottom
                    anchors.bottom: parent.bottom
                    x: Theme.horizontalPageMargin
                    width: parent.width - 2*x
                    color: Theme.primaryColor
                }

                onClicked: {
                    if (related_type === RelatedItem.RelatedVideo) {
                        pageStack.push(Qt.resolvedUrl("../pages/VideoPlayerPage.qml"), {url: stream})
                        return
                    }

                    if (!HafenschauProvider.isInternalLink(link))
                        pageStack.push(Qt.resolvedUrl("../dialogs/OpenExternalUrlDialog.qml"), {url: link})
                    else
                        HafenschauProvider.getInternalLink(link)
                }
            }
        }
    }
}

