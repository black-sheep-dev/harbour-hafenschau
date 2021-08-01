import QtQuick 2.0
import Sailfish.Silica 1.0

Image {
    property string placeholderUrl: "/usr/share/harbour-hafenschau/images/dummy_image.png"

    width: parent.width
    height: {
        if (status === Image.Ready) {
            sourceSize.height * width / sourceSize.width
        } else {
            placeholderImage.sourceSize.height * placeholderImage.width / placeholderImage.sourceSize.width
        }
    }

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

    function reload() {
        var orig = source
        source = "/usr/share/harbour-hafenschau/images/dummy_image.png"
        orig = source
    }
}
