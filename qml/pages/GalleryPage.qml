import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nubecula.harbour.hafenschau 1.0

Page {
    property GalleryModel model

    id: page

    allowedOrientations: Orientation.All

    SilicaFlickable {
        anchors.fill: parent

        SlideshowView {
            id: view
            anchors.fill: parent

            itemWidth: parent.width / 2

            model: model

            delegate: Image {
                id: imageItem
                source: image
                cache: true
                smooth: true

                width: parent.width
                fillMode: Image.PreserveAspectCrop

                BusyIndicator {
                    size: BusyIndicatorSize.Medium
                    anchors.centerIn: imageItem
                    running: imageItem.status != Image.Ready
                }
            }
        }
    }
}
