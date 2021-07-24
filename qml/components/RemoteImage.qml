import QtQuick 2.0
import Sailfish.Silica 1.0

Image {
    property string placeholderUrl: "/usr/share/harbour-hafenschau/images/dummy_image.png"

    width: parent.width
    height: sourceSize.height * width / sourceSize.width

    fillMode: Image.PreserveAspectCrop

    cache: true
    smooth: true

    Image {
        visible: parent.status !== Image.Ready
        id: placeholderImage

        width: parent.width
        fillMode: parent.fillMode

        source: placeholderUrl

        BusyIndicator {
            size: BusyIndicatorSize.Medium
            anchors.centerIn: parent
            running: parent.status === Image.Loading
        }
    }
}
