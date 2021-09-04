import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.DBus 2.0

import org.nubecula.harbour.hafenschau 1.0

import "../components/"

CoverBackground {
    Timer {
        id: timer
        interval: settings.coverSwitchInterval
        repeat: true
        running: settings.coverSwitch

        onTriggered: view.incrementCurrentIndex()
    }

//    DBusInterface {
//        id: dbusInterface

//        service: "harbour.hafenschau.service"
//        iface: "harbour.hafenschau.service"
//        path: "/harbour/hafenschau/service"
//    }

    SlideshowView {
        id: view
        anchors.fill: parent

        model: mainModel

        delegate: Rectangle {
            property variant delegateData: model

            anchors.fill: parent
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


    CoverActionList {
        id: coverAction

//        CoverAction {
//            iconSource: "image://theme/icon-cover-search"
////            onTriggered: dbusInterface.call("open", mainModel.data(view.currentIndex, NewsListModel.DetailsRole))
//            onTriggered: {
//                console.log(view.count)
//                console.log(view.currentItem.delegateData.details)
//            }
//        }

        CoverAction {
            iconSource: "image://theme/icon-cover-refresh"
            onTriggered: mainModel.checkForUpdate()
        }

        CoverAction {
            iconSource: "image://theme/icon-cover-next"
            onTriggered: view.incrementCurrentIndex()
        }
    }
}
