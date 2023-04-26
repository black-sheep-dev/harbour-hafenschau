import QtQuick 2.0
import Sailfish.Silica 1.0

import "../components/"
import "../js/helper.js" as Helper

ListItem {
    contentHeight: contentRow.height + separatorBottom.height

    menu: ContextMenu {
        enabled: model.hasOwnProperty("shareURL")
        MenuItem {
            text: qsTr("Copy link to clipboard")
            onClicked: Clipboard.text = shareURL
        }
    }

    Row {
        id: contentRow
        x: Theme.horizontalPageMargin
        width: parent.width - 2*x
        spacing: Theme.paddingSmall

        RemoteImage {
            id: thumbnailImage

            width: Theme.itemSizeExtraLarge
            height: Theme.itemSizeExtraLarge * 1.4

            source: teaserImage.imageVariants["1x1-" + Helper.getPreferredImageSize1x1(height)]
            placeholderUrl: "/usr/share/harbour-hafenschau/images/dummy_thumbnail.png"


            Image {
                visible: type === "video"
                anchors.centerIn: parent
                source: "image://theme/icon-m-play"
            }
        }

        Column {
            id: column
            width: parent.width - thumbnailImage.width - parent.spacing
            spacing: Theme.paddingSmall

            Label {
                text: type === "video" ? new Date(date).toLocaleString() : topline

                width: parent.width
                wrapMode: Text.WordWrap

                font.pixelSize: Theme.fontSizeExtraSmall
                truncationMode: TruncationMode.Fade
            }
            Label {
                text: title

                width: parent.width
                wrapMode: Text.WordWrap

                font.pixelSize: Theme.fontSizeSmall
                color: Theme.highlightColor
                truncationMode: TruncationMode.Fade
            }
            Label {
                text: model.hasOwnProperty("firstSentence") ? firstSentence : ""
                width: parent.width
                wrapMode: Text.WordWrap

                font.pixelSize: Theme.fontSizeExtraSmall
                truncationMode: TruncationMode.Fade
            }
            Item {
                width: 1
                height: Theme.paddingSmall
            }
        }
    }

    Separator {
        id: separatorBottom
        visible: index < (listView.count - 1)
        x: Theme.horizontalPageMargin
        width: parent.width - 2*x
        anchors.top: contentRow.bottom
        color: Theme.primaryColor
    }
}
