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
            visible: !item.hasOwnProperty("images")
            width: parent.width
            color: Theme.highlightBackgroundColor
        }

        RemoteImage {
            visible: item.hasOwnProperty("images")
            source: item.images.videowebl.imageurl
        }

        Label {
            visible: item.hasOwnProperty("subtitle")

            width: parent.width

            font.pixelSize: Theme.fontSizeSmall
            wrapMode: Text.WordWrap

            text: item.subtitle
        }

        Label {
            visible: item.hasOwnProperty("title")

            width: parent.width

            font.pixelSize: Theme.fontSizeMedium
            wrapMode: Text.WordWrap
            color: Theme.highlightColor

            text: item.title
        }

        Label {
            visible: item.hasOwnProperty("text")

            width: parent.width

            font.pixelSize: Theme.fontSizeSmall
            wrapMode: Text.WordWrap
            linkColor: Theme.highlightColor

            textFormat: Text.RichText

            text: item.text
        }

        Separator {
            width: parent.width
            color: Theme.highlightBackgroundColor
        }
    }

    onClicked: {
        if (item.link === undefined) return
        var link = item.link.match(/(?:ht|f)tps?:\/\/[-a-zA-Z0-9.]+\.[a-zA-Z]{2,3}(\/[^"<]*)?/g)[0]

        if (link.substr(0, 31) === "https://www.tagesschau.de/api2/")
            pageStack.push(Qt.resolvedUrl("../pages/ReaderPage.qml"), {link: link})
        else
            Qt.openUrlExternally(link)
    }
}
