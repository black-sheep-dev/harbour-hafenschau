import QtQuick 2.0
import Sailfish.Silica 1.0

import "../components/"
import "../js/helper.js" as Helper

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
            visible: !item.hasOwnProperty("image")
            width: parent.width
            color: Theme.highlightBackgroundColor
        }

        RemoteImage {
            visible: item.hasOwnProperty("image")
            source: item.image.imageVariants["16x9-" + Helper.getPreferredImageSize16x9(width)]
        }

        Label {
            visible: item.hasOwnProperty("subtitle") && item.subtitle.length > 0

            width: parent.width

            font.pixelSize: Theme.fontSizeSmall
            wrapMode: Text.WordWrap

            text: item.hasOwnProperty("subtitle") ? item.subtitle : ""
        }

        Label {
            visible: item.hasOwnProperty("title") && item.title.length > 0

            width: parent.width

            font.pixelSize: Theme.fontSizeMedium
            wrapMode: Text.WordWrap
            color: Theme.highlightColor

            text: item.title
        }

        Label {
            visible: item.hasOwnProperty("text") && item.text.length > 0

            width: parent.width

            font.pixelSize: Theme.fontSizeSmall
            wrapMode: Text.WordWrap
            linkColor: Theme.highlightColor

            textFormat: Text.RichText

            text: item.hasOwnProperty("text") ? item.text : ""
        }

        Separator {
            width: parent.width
            color: Theme.highlightBackgroundColor
        }
    }

    onClicked: {
        if (item.link === undefined) return
        var link = item.link.match(/(?:ht|f)tps?:\/\/[-a-zA-Z0-9.]+\.[a-zA-Z]{2,3}(\/[^"<]*)?/g)[0]

        if (link.substr(0, 30) === "https://www.tagesschau.de/api2")
            pageStack.push(Qt.resolvedUrl("../pages/ReaderPage.qml"), {link: link})
        else
            Qt.openUrlExternally(link)
    }
}
