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

        RemoteImage {
            source: item[0].videowebl.imageurl
        }

        Label {
            width: parent.width

            font.pixelSize: Theme.fontSizeSmall
            wrapMode: Text.WordWrap
            color: Theme.highlightColor

            text: item[0].title
        }

        Label {
            width: parent.width
            text: qsTr("Gallery with %n pictures", "", item.length)
        }

        Separator {
            id: separatorBottom
            width: parent.width
            color: Theme.highlightBackgroundColor
        }
    }

    onClicked: pageStack.push(Qt.resolvedUrl("../pages/GalleryPage.qml"), {items: item})
}
