import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nubecula.harbour.hafenschau 1.0

BackgroundItem {
    property ContentItemSocial item

    x: Theme.horizontalPageMargin
    width: parent.width - 2*x
    height: {
        var value = labelShorttext.height + labelTitle.height + separatorBottom.height + accountRow.height + 4 * columnBox.spacing
        if (item.image.length > 0)
            value += headerImage.height

        return value
    }

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
            id: labelTitle
            width: parent.width

            font.pixelSize: Theme.fontSizeMedium
            wrapMode: Text.WordWrap
            color: Theme.highlightColor

            text: item.title
        }

        Image {
            visible: item.image.length > 0

            id: headerImage
            source: item.image
            cache: true
            smooth: true


            width: parent.width
            fillMode: Image.PreserveAspectCrop

            BusyIndicator {
                size: BusyIndicatorSize.Medium
                anchors.centerIn: headerImage
                running: headerImage.status != Image.Ready
            }
        }


        Label {
            id: labelShorttext
            width: parent.width

            font.pixelSize: Theme.fontSizeSmall
            wrapMode: Text.WordWrap

            text: item.shorttext
        }

        Row {
            id: accountRow
            width: parent.width
            height: Theme.itemSizeMedium
            spacing: Theme.paddingMedium

            Image {
                id: avatarImage
                source: item.avatar
                cache: true
                smooth: true

                width: Theme.itemSizeMedium
                height: Theme.itemSizeMedium
                fillMode: Image.PreserveAspectCrop

                BusyIndicator {
                    size: BusyIndicatorSize.Medium
                    anchors.centerIn: avatarImage
                    running: avatarImage.status != Image.Ready
                }
            }

            Label {
                id: labelText
                width: parent.width - avatarImage.width - parent.spacing

                anchors.verticalCenter: avatarImage.verticalCenter

                font.pixelSize: Theme.fontSizeMedium
                wrapMode: Text.WordWrap
                linkColor: Theme.highlightColor

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
