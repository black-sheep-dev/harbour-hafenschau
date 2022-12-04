import QtQuick 2.0
import Sailfish.Silica 1.0

import "../components/"
import "../."

CoverBackground {
    function increment() {
        if (currentCoverIndex === (mainNews.items.length - 1)) {
            currentCoverIndex = 0
        } else {
            currentCoverIndex++
        }
    }

    Connections {
        target: mainNews
        onItemsChanged: currentCoverIndex = 0
    }

    id: coverBackground

    Timer {
        id: timer
        interval: config.coverSwitchInterval
        repeat: true
        running: config.coverSwitch

        onTriggered: increment()
    }

    Row {
        x: currentCoverIndex * parent.width * -1
        height: parent.height

        Behavior on x {
            NumberAnimation { duration: currentCoverIndex === (mainNews.items.length - 1) ? 0 : 250 }
        }

        Repeater {
            model: mainNews.items

            Rectangle {
                width: coverBackground.width
                height: coverBackground.height
                color: "#000000"

                RemoteImage {
                    id: imageDelegate
                    anchors.fill: parent
                    anchors.centerIn: parent
                    fillMode: Image.PreserveAspectCrop

                    opacity: 0.5

                    source: modelData.teaserImage.portraetgross8x9.imageurl
                }

                Column {
                    anchors.fill: parent
                    spacing: Theme.paddingSmall

                    Item {
                        width: 1
                        height: Theme.paddingSmall
                    }

                    Label {
                        x: Theme.horizontalPageMargin
                        width: parent.width - 2*x
                        text: modelData.title
                        font.bold: true
                        wrapMode: Text.WordWrap
                        font.pixelSize: Theme.fontSizeSmall
                    }

                    Label {
                        x: Theme.horizontalPageMargin
                        width: parent.width - 2*x
                        text: modelData.hasOwnProperty("firstSentence") ? modelData.firstSentence : ""
                        wrapMode: Text.WordWrap
                        font.pixelSize: Theme.fontSizeExtraSmall
                    }
                }
            }
        }
    }

    CoverActionList {
        id: coverAction

        CoverAction {
            iconSource: "image://theme/icon-cover-refresh"
            onTriggered: mainNews.refresh()
        }

        CoverAction {
            iconSource: "image://theme/icon-cover-next"
            onTriggered: increment()
        }
    }
}
