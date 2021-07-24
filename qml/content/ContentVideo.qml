import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nubecula.harbour.hafenschau 1.0

import "../components/"

BackgroundItem {
    property ContentItemVideo item

    width: parent.width
    height: headerImage.height + labelTitle.height + separatorBottom.height + 2 * columnVideo.spacing

    Column {
        id: columnVideo
        x: Theme.horizontalPageMargin
        width: parent.width - 2*x
        spacing: Theme.paddingMedium

        RemoteImage {
            id: headerImage

            source: item.image
            placeholderUrl: "/usr/share/harbour-hafenschau/images/video_dummy.png"

            Image {
                anchors.centerIn: parent
                source: "image://theme/icon-l-play"
            }
        }

        Label {
            id: labelTitle
            width: parent.width

            font.pixelSize: Theme.fontSizeSmall
            wrapMode: Text.WordWrap

            color: Theme.highlightColor

            text: item.title
        }

        Separator {
            id: separatorBottom
            width: parent.width
            color: Theme.highlightBackgroundColor
        }
    }

    onClicked: pageStack.push(Qt.resolvedUrl("../pages/VideoPlayerPage.qml"), {url: item.stream})
}
