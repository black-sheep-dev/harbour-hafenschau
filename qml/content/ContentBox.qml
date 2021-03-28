import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nubecula.harbour.hafenschau 1.0

BackgroundItem {
    property ContentItemBox item

    x: Theme.horizontalPageMargin
    width: parent.width - 2*x
    height: {
        var value = labelSubtitle.height + labelTitle.height + labelText.height + separatorBottom.height + 4 * columnBox.spacing
        if (item.image.length > 0)
            value += headerImage.height
        else
            value += separatorTop.height

        return value
    }

    Column {
        id: columnBox
        width: parent.width
        spacing: Theme.paddingMedium

        Separator {
            visible: item.image.length === 0
            id: separatorTop
            width: parent.width
            color: Theme.highlightBackgroundColor
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
                running: headerImage.status === Image.Loading
            }

            onStatusChanged: if (status === Image.Error) source = "qrc:///images/dummy_image"
        }


        Label {
            id: labelSubtitle
            width: parent.width

            font.pixelSize: Theme.fontSizeSmall
            wrapMode: Text.WordWrap

            text: item.subtitle
        }

        Label {
            id: labelTitle
            width: parent.width

            font.pixelSize: Theme.fontSizeMedium
            wrapMode: Text.WordWrap
            color: Theme.highlightColor

            text: item.title
        }

        Label {
            id: labelText
            width: parent.width

            font.pixelSize: Theme.fontSizeSmall
            wrapMode: Text.WordWrap
            linkColor: Theme.highlightColor

            text: item.text
        }

        Separator {
            id: separatorBottom
            width: parent.width
            color: Theme.highlightBackgroundColor
        }
    }

    onClicked: {
        if (!item.linkInternal)
            pageStack.push(Qt.resolvedUrl("../dialogs/OpenExternalUrlDialog.qml"), { url: item.link })
        else
            HafenschauProvider.getInternalLink(item.link)
    }
}
