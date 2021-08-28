import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nubecula.harbour.hafenschau 1.0

import "../components/"

BackgroundItem {
    property ContentItemSocial item

    width: parent.width
    height: columnBox.height

    Column {
        id: columnBox
        x: Theme.horizontalPageMargin
        width: parent.width - 2*x
        spacing: Theme.paddingMedium

        Separator {
            id: separatorTop
            width: parent.width
            color: Theme.highlightBackgroundColor
        }

        Label {
            id: labelTitle
            width: parent.width

            font.pixelSize: Theme.fontSizeMedium
            wrapMode: Text.WordWrap
            color: Theme.highlightColor
            linkColor: Theme.secondaryHighlightColor

            text: item.title
        }

        RemoteImage {
            id: headerImage
            visible: item.image.length > 0

            source: item.image
        }

        Label {
            id: labelShorttext
            width: parent.width

            font.pixelSize: Theme.fontSizeSmall
            wrapMode: Text.WordWrap
            linkColor: Theme.secondaryHighlightColor

            text: item.shorttext
        }

        Row {
            id: accountRow
            width: parent.width
            height: Theme.itemSizeMedium
            spacing: Theme.paddingMedium

            RemoteImage {
               id: avatarImage
               source: item.avatar

               width: Theme.itemSizeMedium
               height: Theme.itemSizeMedium
               fillMode: Image.PreserveAspectCrop

               placeholderUrl: "qrc:/icons/twitter"
            }

            Label {
                id: labelText
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
            id: separatorBottom
            width: parent.width
            color: Theme.highlightBackgroundColor
        }
    }

    onClicked: {
        pageStack.push(Qt.resolvedUrl("../dialogs/OpenExternalUrlDialog.qml"), { url: item.url })
    }
}
