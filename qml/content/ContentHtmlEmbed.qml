import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nubecula.harbour.hafenschau 1.0

BackgroundItem {
    property ContentItemHtmlEmbed item

    width: parent.width
    height: columnBox.height

    Column {
        id: columnBox
        x: Theme.horizontalPageMargin
        width: parent.width - 2*x
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
            height: sourceSize.height * parent.width / sourceSize.width

            BusyIndicator {
                size: BusyIndicatorSize.Medium
                anchors.centerIn: headerImage
                running: headerImage.status === Image.Loading
            }

            onStatusChanged: if (status === Image.Error) source = "/usr/share/harbour-hafenschau/images/dummy_image.png"
        }

        Label {
            id: labelTitle
            width: parent.width

            font.pixelSize: Theme.fontSizeMedium
            wrapMode: Text.WordWrap
            color: Theme.highlightColor

            text: item.title
        }

        Separator {
            id: separatorBottom
            width: parent.width
            color: Theme.highlightBackgroundColor
        }
    }

    onClicked: pageStack.push(Qt.resolvedUrl("../pages/WebViewPage.qml"), { url: item.value })
}
