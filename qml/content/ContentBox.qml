import QtQuick 2.0
import Sailfish.Silica 1.0

import "../components/"

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
            visible: item.images.videowebl.imageurl.length === 0
            id: separatorTop
            width: parent.width
            color: Theme.highlightBackgroundColor
        }

        RemoteImage {
            id: headerImage
            visible: item.images.videowebl.imageurl.length > 0
            source: item.images.videowebl.imageurl
        }

        Label {
            id: labelSubtitle

            visible: item.hasOwnProperty("subtitle")

            width: parent.width

            font.pixelSize: Theme.fontSizeSmall
            wrapMode: Text.WordWrap

            text: item.subtitle
        }

        Label {
            id: labelTitle

            visible: item.hasOwnProperty("title")

            width: parent.width

            font.pixelSize: Theme.fontSizeMedium
            wrapMode: Text.WordWrap
            color: Theme.highlightColor

            text: item.title
        }

        Label {
            id: labelText

            visible: item.hasOwnProperty("text")

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
        var link = item.link.match(/(?:ht|f)tps?:\/\/[-a-zA-Z0-9.]+\.[a-zA-Z]{2,3}(\/[^"<]*)?/g)[0]

        if (link.substr(0, 31) === "https://www.tagesschau.de/api2/")
            pageStack.push(Qt.resolvedUrl("../pages/ReaderPage.qml"), {link: link})
        else
            Qt.openUrlExternally(link)
    }
}
