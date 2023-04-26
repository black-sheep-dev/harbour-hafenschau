import QtQuick 2.0
import Sailfish.Silica 1.0

import "../components/"
import "../js/helper.js" as Helper

BackgroundItem {
    property var item

    width: parent.width
    height: columnVideo.height

    Column {
        id: columnVideo
        x: Theme.horizontalPageMargin
        width: parent.width - 2*x
        spacing: Theme.paddingMedium

        RemoteImage {
            source: item.teaserImage.imageVariants["16x9-" + Helper.getPreferredImageSize16x9(width)]
            placeholderUrl: "/usr/share/harbour-hafenschau/images/video_dummy.png"

            Image {
                anchors.centerIn: parent
                source: "image://theme/icon-l-play"
            }
        }

        Label {
            width: parent.width

            font.pixelSize: Theme.fontSizeSmall
            wrapMode: Text.WordWrap

            color: Theme.highlightColor

            text: item.title
        }

        Separator {
            width: parent.width
            color: Theme.highlightBackgroundColor
        }
    }

    onClicked: pageStack.push(Qt.resolvedUrl("../pages/VideoPlayerPage.qml"), {streams: item.streams, title: item.title})
}
