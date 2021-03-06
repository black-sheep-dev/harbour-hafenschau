import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nubecula.harbour.hafenschau 1.0

BackgroundItem {
    property ContentItem item

    visible: titleLabel.text.length > 0
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

        Image {
            id: headerImage
            cache: true
            smooth: true

            width: parent.width
            height: sourceSize.height * parent.width / sourceSize.width

            source: "/usr/share/harbour-hafenschau/images/webcontent.png"

            BusyIndicator {
                size: BusyIndicatorSize.Medium
                anchors.centerIn: headerImage
                running: headerImage.status === Image.Loading
            }

            onStatusChanged: if (status === Image.Error) source = "/usr/share/harbour-hafenschau/images/webcontent.png"
        }

        Label {
            id: titleLabel
            width: parent.width

            font.pixelSize: Theme.fontSizeMedium
            wrapMode: Text.WordWrap
            color: Theme.highlightColor
        }

        Separator {
            width: parent.width
            color: Theme.highlightBackgroundColor
        }
    }

    onClicked: pageStack.push(Qt.resolvedUrl("../pages/WebViewPage.qml"), { url: item.value })

    Connections {
        target: HafenschauProvider
        onHtmlEmbedAvailable: {
            if (url !== item.value) return
            titleLabel.text = title
            headerImage.source = image
        }
    }

    Component.onCompleted: HafenschauProvider.getHtmlEmbed(item.value)
}
