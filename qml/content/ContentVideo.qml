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
            source: item.image
            cache: true
            smooth: true


            width: parent.width
            fillMode: Image.PreserveAspectCrop

            BusyIndicator {
                size: BusyIndicatorSize.Medium
                anchors.centerIn: headerImage
                running: headerImage.status != Image.Ready
            }

            Image {
                anchors.centerIn: parent
                source: "image://theme/icon-l-opaque-play"
            }
        }

        Label {
            id: labelTitle
            width: parent.width

            font.pixelSize: Theme.fontSizeMedium
            wrapMode: Text.WordWrap

            text: item.title
        }

        Separator {
            id: separatorBottom
            width: parent.width
            color: Theme.highlightBackgroundColor
        }
    }

    //onClicked: pageStack.push(Qt.resolvedUrl("../pages/VideoPlayerPage.qml"), {url: item.stream})
}
