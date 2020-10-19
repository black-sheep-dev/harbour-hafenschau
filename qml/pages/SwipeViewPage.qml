import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nubecula.harbour.hafenschau 1.0

Page {
    id: page

    allowedOrientations: Orientation.All

    SilicaFlickable {
        PullDownMenu {
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
            MenuItem {
                text: qsTr("Preferences")
                //onClicked: {}
            }
            MenuItem {
                text: qsTr("Refresh")
                onClicked: HafenschauProvider.refresh()
            }
        }

        anchors.fill: parent

        SlideshowView {
            id: slideShow
            anchors.fill: parent

            model: HafenschauProvider.newsModel()

            delegate: BackgroundItem {
                id: delegate

                anchors.fill: parent

                Image {
                    id: backgroundImage
                    source: image

                    fillMode: Image.PreserveAspectCrop
                    anchors.fill: parent

                    BusyIndicator {
                        size: BusyIndicatorSize.Medium
                        anchors.centerIn: backgroundImage
                        running: backgroundImage.status != Image.Ready
                    }
                }

                Label {
                    text: (index + 1) + " | " + HafenschauProvider.newsModel().newsCount()
                    font.pixelSize: Theme.fontSizeMedium
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    padding: Theme.paddingMedium
                }
            }

            Component.onCompleted: currentIndex = 0
        }
    }
}

