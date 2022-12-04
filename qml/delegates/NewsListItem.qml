import QtQuick 2.0
import Sailfish.Silica 1.0

import "../components/"

ListItem {
    contentHeight: contentRow.height + separatorBottom.height

    menu: ContextMenu {
        enabled: modelData.shareURL.length > 0
        MenuItem {
            text: qsTr("Copy link to clipboard")
            onClicked: Clipboard.text = modelData.shareURL
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

            source: modelData.teaserImage.portraetgross8x9.imageurl
            placeholderUrl: "/usr/share/harbour-hafenschau/images/dummy_thumbnail.png"


            Image {
                visible: modelData.type === "video"
                anchors.centerIn: parent
                source: "image://theme/icon-m-play"
            }
        }

        Column {
            id: column
            width: parent.width - thumbnailImage.width - parent.spacing
            spacing: Theme.paddingSmall

            Label {
                text: modelData.type === "video" ? new Date(modelData.date).toLocaleString() : modelData.topline

                width: parent.width
                wrapMode: Text.WordWrap

                font.pixelSize: Theme.fontSizeExtraSmall
            }
            Label {
                text: modelData.title

                width: parent.width
                wrapMode: Text.WordWrap

                font.pixelSize: Theme.fontSizeSmall
                color: Theme.highlightColor
            }
            Label {
                text: modelData.hasOwnProperty("firstSentence") ? modelData.firstSentence : ""
                width: parent.width
                wrapMode: Text.WordWrap

                font.pixelSize: Theme.fontSizeExtraSmall
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
