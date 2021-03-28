import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nubecula.harbour.hafenschau 1.0

CoverBackground {
    property int index: 0
    property NewsModel model: HafenschauProvider.newsModel(NewsModel.Homepage)

    SlideshowView {
        id: slideShow
        anchors.fill: parent

        model: HafenschauProvider.newsModel(NewsModel.Homepage)

        delegate: Rectangle {
            anchors.fill: parent

            Image {
                id: imageDelegate
                anchors.fill: parent
                anchors.centerIn: parent

                fillMode: Image.PreserveAspectCrop

                //opacity: 0.0

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
            onTriggered: {
                if (index > 0)
                    index -= 1
                else
                    index = model.newsCount() - 1

                slideShow.decrementCurrentIndex()
            }
        }

        CoverAction {
            iconSource: "image://theme/icon-cover-refresh"
            onTriggered: HafenschauProvider.refresh(NewsModel.Homepage)
        }

        CoverAction {
            iconSource: "image://theme/icon-cover-next"
            onTriggered: {
//                if (index < (model.newsCount() - 1))
//                    index += 1
//                else
//                    index = 0
                slideShow.incrementCurrentIndex()
            }
        }
    }

    Connections {
        target: model
        onNewsChanged: index = 0
    }
}
