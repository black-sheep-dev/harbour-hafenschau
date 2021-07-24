import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nubecula.harbour.hafenschau 1.0

import "../components/"

BackgroundItem {
    property ContentItemGallery item

    width: parent.width
    height: headerImage.height + labelTitle.height + separatorBottom.height + 2 * columnBox.spacing

    Column {
        id: columnBox
        x: Theme.horizontalPageMargin
        width: parent.width - 2*x
        spacing: Theme.paddingMedium

        RemoteImage {
            id: headerImage
            source: item.model().itemAt(0).image
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
