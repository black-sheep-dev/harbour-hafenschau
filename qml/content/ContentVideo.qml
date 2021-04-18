import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nubecula.harbour.hafenschau 1.0

BackgroundItem {
    property ContentItemVideo item

    x: Theme.horizontalPageMargin
    width: parent.width - 2*x
    height: headerImage.height + labelTitle.height + separatorBottom.height + 2 * columnVideo.spacing

    Column {
        id: columnVideo
        width: parent.width
        spacing: Theme.paddingMedium

        Image {
            id: headerImage
            source: item.image.length > 0 ? item.image : "qrc:///images/video_dummy"
            cache: true
            smooth: true


            width: parent.width
            fillMode: Image.PreserveAspectCrop

            BusyIndicator {
                size: BusyIndicatorSize.Medium
                anchors.centerIn: headerImage
                running: headerImage.status === Image.Loading
            }

            Image {
                anchors.centerIn: parent
                source: "image://theme/icon-l-play"
            }

            onStatusChanged: if (status === Image.Error) source = "qrc:///images/dummy_image"
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
