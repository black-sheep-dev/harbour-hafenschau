import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nubecula.harbour.hafenschau 1.0

BackgroundItem {
    property ContentItemSocial item

    width: parent.width
    height: {
        var value = labelShorttext.height + labelTitle.height + separatorBottom.height + accountRow.height + 4 * columnBox.spacing
        if (item.image.length > 0)
            value += headerImage.height

        return value
    }

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

        Image {
            visible: item.image.length > 0 && headerImage.status != Image.Error

            id: headerImage
            source: item.image
            cache: true
            smooth: true

            width: parent.width
            height: sourceSize.height * parent.width / sourceSize.width

            BusyIndicator {
                size: BusyIndicatorSize.Medium
                anchors.centerIn: headerImage
                running: headerImage.status === Image.Loading
            }
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
                    running: headerImage.status === Image.Loading
                }

                onStatusChanged: if (avatarImage.status === Image.Error) source = "qrc:///icons/twitter"
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
