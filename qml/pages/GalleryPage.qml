import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nubecula.harbour.hafenschau 1.0

import "../components/"

Page {
    property GalleryModel model

    id: page

    allowedOrientations: Orientation.All

    SlideshowView {
        id: view
        anchors.fill: parent

        itemHeight: parent.height
        itemWidth: parent.width

        model: page.model

        delegate: Rectangle {
            anchors.fill: parent

            RemoteImage {
               id: imageItem
               source: image
            }
        }
    }
}
