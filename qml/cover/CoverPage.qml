import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.DBus 2.0

import org.nubecula.harbour.hafenschau 1.0

import "../components/"

CoverBackground {
    property int currentIndex: 0
    property News currentNews: model.newsAt(0)
    property NewsModel model: HafenschauProvider.newsModel(NewsModel.Homepage)

    function increment() {
        if (currentIndex < (model.rowCount() - 1))
            currentIndex++
        else
            currentIndex = 0

        currentNews = HafenschauProvider.newsModel(NewsModel.Homepage).newsAt(currentIndex)
    }

    onCurrentNewsChanged: imageDelegate.source = currentNews.portrait

    Connections {
        target: model
        onNewsChanged: {
            currentIndex = 0
            currentNews = model.newsAt(currentIndex)
        }
    }

    Timer {
        id: timer
        interval: HafenschauProvider.coverSwitchInterval
        repeat: true
        running: HafenschauProvider.coverSwitch

        onTriggered: increment()
    }

    DBusInterface {
        id: dbusInterface

        service: "harbour.hafenschau.service"
        iface: "harbour.hafenschau.service"
        path: "/harbour/hafenschau/service"
    }

    Rectangle {
        anchors.fill: parent
        color: "#000000"

        RemoteImage {
            id: imageDelegate
            anchors.fill: parent
            anchors.centerIn: parent
            fillMode: Image.PreserveAspectCrop

            opacity: 0.5

            source: currentNews.portrait
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
                text: currentNews.title
                font.bold: true
                wrapMode: Text.WordWrap
                font.pixelSize: Theme.fontSizeSmall
            }

            Label {
                x: Theme.horizontalPageMargin
                width: parent.width - 2*x
                text: currentNews.firstSentence
                wrapMode: Text.WordWrap
                font.pixelSize: Theme.fontSizeExtraSmall
            }
        }
    }

    CoverActionList {
        id: coverAction

        CoverAction {
            iconSource: "image://theme/icon-cover-search"
            onTriggered: dbusInterface.call("open", currentNews.details)
        }

        CoverAction {
            iconSource: "image://theme/icon-cover-refresh"
            onTriggered: HafenschauProvider.refresh(NewsModel.Homepage)
        }

        CoverAction {
            iconSource: "image://theme/icon-cover-next"
            onTriggered: increment()
        }
    }
}
