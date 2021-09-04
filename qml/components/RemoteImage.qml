import QtQuick 2.0
import Sailfish.Silica 1.0

Image {
    property string placeholderUrl: "/usr/share/harbour-hafenschau/images/dummy_image.png"

    id: remoteImage
    width: parent.width
    height: 9 / 16 * parent.width
    sourceSize.width: width
    sourceSize.height: height

    fillMode: Image.PreserveAspectCrop

    asynchronous: true
    cache: true
    smooth: true

    Image {
        visible: parent.status !== Image.Ready
        id: placeholderImage

        anchors.centerIn: parent
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop

        source: placeholderUrl

        BusyIndicator {
            size: BusyIndicatorSize.Medium
            anchors.centerIn: parent
            running: remoteImage.status === Image.Loading
        }
    }
}
