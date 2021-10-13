import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nubecula.harbour.hafenschau 1.0

import "../components/"

CoverBackground {
    property int currentIndex: 0

    function increment() {
        if (currentIndex === (mainModel.count - 1)) {
            currentIndex = 0
        } else {
            currentIndex++
        }
    }

    Connections {
        target: mainModel
        onCountChanged: currentIndex = 0
    }

    id: coverBackground

    Timer {
        id: timer
        interval: settings.coverSwitchInterval
        repeat: true
        running: settings.coverSwitch

        onTriggered: increment()
    }

    Row {
        x: currentIndex * parent.width * -1
        height: parent.height

        Behavior on x {
            NumberAnimation { duration: currentIndex === (mainModel.count - 1) ? 0 : 250 }
        }

        Repeater {
            model: mainModel

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

                    source: model.thumbnail
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
                        text: model.title
                        font.bold: true
                        wrapMode: Text.WordWrap
                        font.pixelSize: Theme.fontSizeSmall
                    }

                    Label {
                        x: Theme.horizontalPageMargin
                        width: parent.width - 2*x
                        text: model.firstSentence
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
            iconSource: "image://theme/icon-cover-search"
            onTriggered: dbusAdaptor.open(mainModel.newsDetails(currentIndex))
        }

        CoverAction {
            iconSource: "image://theme/icon-cover-refresh"
            onTriggered: mainModel.checkForUpdate()
        }

        CoverAction {
            iconSource: "image://theme/icon-cover-next"
            onTriggered: increment()
        }
    }
}
