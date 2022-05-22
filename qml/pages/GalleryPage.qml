import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nubecula.harbour.hafenschau 1.0

import "../components/"

Page {
    property alias items: view.model

    id: page

    allowedOrientations: Orientation.All

    SilicaFlickable {
        anchors.fill: parent

        SlideshowView {
            id: view
            anchors.fill: parent

            itemHeight: parent.height
            itemWidth: parent.width

            clip: true

            delegate: Item {
                anchors.fill: parent

                RemoteImage {
                    anchors.centerIn: parent
                    source: modelData.videowebl.imageurl
                }
            }
        }

        Column {
            x:  Theme.horizontalPageMargin
            width: parent.width - 2*x
            anchors.topMargin: Theme.paddingMedium
            anchors.top: parent.top
            spacing: Theme.paddingMedium

            Label {
                width: parent.width

                wrapMode: Text.Wrap
                text: items[view.currentIndex].title
            }
            Label {
                visible: items[view.currentIndex].copyright.length > 0
                width: parent.width
                font.pixelSize: Theme.fontSizeExtraSmall
                text: "© " + items[view.currentIndex].copyright
            }
        }

        Label {
            anchors.bottomMargin: Theme.paddingMedium
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter

            font.pixelSize: Theme.fontSizeLarge
            text: (view.currentIndex + 1) + " / " + items.length
        }
    }
}
