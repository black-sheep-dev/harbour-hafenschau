import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    property int fillMode: Image.PreserveAspectCrop
    property string placeholderUrl: "/usr/share/harbour-hafenschau/images/dummy_image.png"
    property alias source: remoteImage.source

    width: parent.width
    height: remoteImage.status === Image.Ready ?
                (width / remoteImage.sourceSize.width * remoteImage.sourceSize.height) :
                (width / placeholderImage.sourceSize.width * placeholderImage.sourceSize.height)

    Image {
        visible: parent.status !== Image.Ready
        id: placeholderImage

        anchors.fill: parent
        fillMode: parent.fillMode

        source: placeholderUrl

        BusyIndicator {
            size: BusyIndicatorSize.Medium
            anchors.centerIn: parent
            running: remoteImage.status === Image.Loading
        }
    }

    Image {
        id: remoteImage

        anchors.fill: parent

        fillMode: parent.fillMode

        asynchronous: true
        cache: true
        smooth: true
    }
}


