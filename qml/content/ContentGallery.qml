import QtQuick 2.0
import Sailfish.Silica 1.0

import "../components/"
import "../js/helper.js" as Helper

BackgroundItem {
    property var item

    width: parent.width
    height: columnBox.height

    Timer {
        id: switchTimer
        running: item.length > 1
        repeat: true
        interval: 5000

        onTriggered: {
            if (slideShow.currentIndex < item.length)
                slideShow.incrementCurrentIndex()
            else
                slideShow.currentIndex = 0
        }
    }

    Column {
        id: columnBox
        x: Theme.horizontalPageMargin
        width: parent.width - 2*x
        spacing: Theme.paddingMedium

        SlideshowView {
            id: slideShow
            width: parent.width
            height: parent.width * 9 / 16

            itemHeight: parent.width * 9 / 16
            itemWidth: parent.width

            clip: true

            model: item

            delegate: RemoteImage {
                source: modelData.imageVariants["16x9-" + Helper.getPreferredImageSize16x9(width)]
            }

            onDragStarted: switchTimer.stop()
        }

        Label {
            width: parent.width

            font.pixelSize: Theme.fontSizeSmall
            wrapMode: Text.WordWrap
            color: Theme.highlightColor

            text: item[slideShow.currentIndex].title
        }

        Row {
            visible: item.length > 1
            width: parent.width
            spacing: Theme.paddingLarge

            Label {
                font.pixelSize: Theme.fontSizeSmall
                text: qsTr("Gallery with %n pictures", "", item.length)
            }

            Label {
               font.pixelSize: Theme.fontSizeSmall
               text: (slideShow.currentIndex + 1) + " / " + item.length
            }
        }


        Separator {
            id: separatorBottom
            width: parent.width
            color: Theme.highlightBackgroundColor
        }
    }

    onClicked: pageStack.push(Qt.resolvedUrl("../pages/GalleryPage.qml"), {items: item})
}
