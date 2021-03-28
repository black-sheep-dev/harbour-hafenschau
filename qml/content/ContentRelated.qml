import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nubecula.harbour.hafenschau 1.0

BackgroundItem {
    property ContentItemRelated item

    x: Theme.horizontalPageMargin
    width: parent.width - 2*x
    height: separatorTop.height + labelHeader.height + listView.height + 2 * columnBox.spacing

    Column {
        id: columnBox
        width: parent.width
        spacing: Theme.paddingMedium

        Separator {
            id: separatorTop
            width: parent.width
            color: Theme.highlightBackgroundColor
        }

        Label {
            id: labelHeader
            width: parent.width

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


                Image {
                    id: thumbnailImage
                    anchors.verticalCenter: parent.verticalCenter

                    fillMode: Image.PreserveAspectCrop

                    width: Theme.itemSizeHuge * 0.8
                    height: width

                    source: image
                    cache: true
                    smooth: true

                    BusyIndicator {
                        size: BusyIndicatorSize.Medium
                        anchors.centerIn: thumbnailImage
                        running: thumbnailImage.status === Image.Loading
                    }

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
                    width: parent.width
                    color: Theme.primaryColor
                }

                onClicked: {
                    if (related_type === RelatedItem.RelatedVideo) {
                        pageStack.push(Qt.resolvedUrl("../pages/VideoPlayerPage.qml"), { url: stream })
                        return;
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

