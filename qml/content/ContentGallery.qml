import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nubecula.harbour.hafenschau 1.0

BackgroundItem {
    property ContentItemGallery item

    width: parent.width
    height: headerImage.height + labelTitle.height + separatorBottom.height + 2 * columnBox.spacing

    Column {
        id: columnBox
        x: Theme.horizontalPageMargin
        width: parent.width - 2*x
        spacing: Theme.paddingMedium

        Image {
            id: headerImage
            source: item.model().itemAt(0).image
            cache: true
            smooth: true

            width: parent.width
            height: sourceSize.height * parent.width / sourceSize.width

            BusyIndicator {
                size: BusyIndicatorSize.Medium
                anchors.centerIn: headerImage
                running: headerImage.status === Image.Loading
            }

            onStatusChanged: if (status === Image.Error) source = "/usr/share/harbour-hafenschau/images/dummy_image.png"
        }

        Label {
            id: labelTitle
            width: parent.width

            font.pixelSize: Theme.fontSizeSmall
            wrapMode: Text.WordWrap
            color: Theme.highlightColor

            text: item.model().itemAt(0).title
        }

        Separator {
            id: separatorBottom
            width: parent.width
            color: Theme.highlightBackgroundColor
        }
    }

    //onClicked: pageStack.push(Qt.resolvedUrl("../pages/GalleryPage.qml"), {model: item.model})
}
