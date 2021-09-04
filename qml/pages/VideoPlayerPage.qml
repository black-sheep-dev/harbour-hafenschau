import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.KeepAlive 1.2

import QtMultimedia 5.6

import org.nubecula.harbour.hafenschau 1.0

Page {
    property alias title: titleLabel.text
    property var streams
    property bool showOverlay: false

    id: page

    allowedOrientations: Orientation.All

    DisplayBlanking { preventBlanking: true }

    SilicaFlickable {
        anchors.fill: parent

        MediaPlayer {         
            id: videoPlayer
            autoPlay: true

            source: {
                if (settings.videoQualityAdaptive && streams.hasOwnProperty("adaptivestreaming")) return streams.adaptivestreaming

                switch (settings.videoQuality) {
                case VideoQuality.Low:
                    return streams.h264s

                case VideoQuality.Medium:
                    return streams.h264m

                case VideoQuality.High:
                    return streams.h264xl

                default:
                    return streams.h264m
                }
            }
        }

        Rectangle {
            anchors.fill: output
            color: "black"
        }

        Rectangle {
            id: titleRect
            color: "#000000CC"
            y: showOverlay ? 0 : -height
            width: parent.width
            height: titleLabel.height + Theme.paddingMedium

            Label {
                id: titleLabel
                x: Theme.horizontalPageMargin
                width: parent.width - 2*x
                anchors.verticalCenter: parent.verticalCenter
                wrapMode: Text.Wrap
            }

            Behavior on y {
                NumberAnimation {
                    duration: 100
                    easing.type: Easing.InOutQuad
                }
            }
        }

        VideoOutput {
            id: output
            anchors.top: titleRect.bottom
            anchors.bottom: controlRect.top
            width: parent.width
            source: videoPlayer

            MouseArea {
                id: playArea
                anchors.fill: parent

                onPressed: showOverlay = !showOverlay
            }

            IconButton {
                visible: showOverlay
                anchors.centerIn: parent
                icon.source: videoPlayer.playbackState === MediaPlayer.PlayingState ? "image://theme/icon-l-pause" : "image://theme/icon-l-play"

                onClicked: videoPlayer.playbackState === MediaPlayer.PlayingState ? videoPlayer.pause() : videoPlayer.play()
            }
        }

        Rectangle {
            id: controlRect
            y: showOverlay ? parent.height - height : parent.height + progressSlider.height / 2
            width: parent.width
            height: Theme.iconSizeMedium

            color: "#000000CC"

            Row {
                anchors.right: parent.right
                anchors.rightMargin: Theme.paddingSmall
                anchors.verticalCenter: parent.verticalCenter
                spacing: Theme.paddingSmall

                Label {
                    text: new Date(videoPlayer.position).toISOString().substr(14, 5)
                }

                Label {
                    text: "/"
                }

                Label {
                    text: new Date(videoPlayer.duration).toISOString().substr(14, 5)
                }
            }

            Slider {
                id: progressSlider

                anchors.topMargin: -height / 2

                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter

                width: parent.width + 5 * Theme.paddingLarge - 16

                minimumValue: 0
                maximumValue: videoPlayer.duration
                stepSize: 1000
                value: 0
                handleVisible: true

                onReleased: videoPlayer.seek(value)
            }

            Behavior on y {
                NumberAnimation {
                    duration: 100
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }

    Connections {
        target: videoPlayer
        onPositionChanged: progressSlider.value = videoPlayer.position
    }
}
