import QtQuick 2.0
import Sailfish.Silica 1.0

import "../components/"
import "../."

BackgroundItem {
    property var item

    width: parent.width
    height: columnBox.height

    Column {
        id: columnBox
        x: Theme.horizontalPageMargin
        width: parent.width - 2*x
        spacing: Theme.paddingMedium

        Separator {
            width: parent.width
            color: Theme.highlightBackgroundColor
        }

        Label {
            width: parent.width

            font.pixelSize: Theme.fontSizeMedium
            wrapMode: Text.WordWrap
            color: Theme.highlightColor
            linkColor: Theme.secondaryHighlightColor

            text: item.title
        }

        RemoteImage {
            visible: item.images.gross16x9.imageurl.length > 0
            source: "https://" + item.images.gross16x9.imageurl.substr(28)
        }

        Label {
            width: parent.width

            font.pixelSize: Theme.fontSizeSmall
            wrapMode: Text.WordWrap
            linkColor: Theme.secondaryHighlightColor

            text: item.shorttext
        }

        Row {
            width: parent.width
            height: Theme.itemSizeMedium
            spacing: Theme.paddingMedium

            RemoteImage {
               id: avatarImage
               source: "https://" + item.avatar.substr(28)

               width: Theme.itemSizeMedium
               height: Theme.itemSizeMedium
               fillMode: Image.PreserveAspectCrop

               placeholderUrl: "/usr/share/harbour-" + Qt.application.name + "/icons/twitter.svg"
            }

            Label {
                width: parent.width - avatarImage.width - parent.spacing

                anchors.verticalCenter: avatarImage.verticalCenter

                font.pixelSize: Theme.fontSizeMedium
                wrapMode: Text.WordWrap
                color: Theme.secondaryColor
                linkColor: Theme.secondaryHighlightColor


                text: "@" + item.username
            }
        }

        Separator {
            width: parent.width
            color: Theme.highlightBackgroundColor
        }
    }

    onClicked: Qt.openUrlExternally(item.url)
}
