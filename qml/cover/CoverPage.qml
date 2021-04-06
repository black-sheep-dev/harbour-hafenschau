import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nubecula.harbour.hafenschau 1.0

CoverBackground {

    Timer {
        id: timer
        interval: HafenschauProvider.coverSwitchInterval
        repeat: true
        running: HafenschauProvider.coverSwitch

        onTriggered: slideShow.incrementCurrentIndex()
    }

    SlideshowView {
        id: slideShow
        anchors.fill: parent

        model: HafenschauProvider.newsModel(NewsModel.Homepage)

        delegate: Rectangle {
            anchors.fill: parent
            color: "#000000"

            Image {
                id: imageDelegate
                anchors.fill: parent
                anchors.centerIn: parent

                fillMode: Image.PreserveAspectCrop

                opacity: 0.5

                source: model.portrait.length > 0 ? model.portrait : "qrc:///images/dummy_image"
                cache: true
                smooth: true

                BusyIndicator {
                    size: BusyIndicatorSize.Small
                    anchors.centerIn: imageDelegate
                    running: imageDelegate.status === Image.Loading
                }
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



    CoverActionList {
        id: coverAction

        CoverAction {
            iconSource: "image://theme/icon-cover-previous"
            onTriggered: slideShow.decrementCurrentIndex()
        }

        CoverAction {
            iconSource: "image://theme/icon-cover-refresh"
            onTriggered: HafenschauProvider.refresh(NewsModel.Homepage)
        }

        CoverAction {
            iconSource: "image://theme/icon-cover-next"
            onTriggered: slideShow.incrementCurrentIndex()
        }
    }
}
