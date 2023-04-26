import QtQuick 2.0
import Sailfish.Silica 1.0

import QtMultimedia 5.6

import "../components/"
import "../js/helper.js" as Helper

BackgroundItem {
    property bool playing: false
    property var item

    width: parent.width
    height: columnAudio.height

    Column {
        id: columnAudio
        x: Theme.horizontalPageMargin
        width: parent.width - 2*x
        spacing: Theme.paddingMedium

        Item {
            width: parent.width
            height: headerImage.height + progressSlider.height

            RemoteImage {
                id: headerImage

                source: item.teaserImage === undefined ? "/usr/share/harbour-hafenschau/images/audiograph.png" : item.teaserImage.imageVariants["16x9-" + Helper.getPreferredImageSize16x9(width)]
                placeholderUrl: "/usr/share/harbour-hafenschau/images/audiograph.png"

                Image {
                    anchors.centerIn: parent
                    source: playing ? "image://theme/icon-l-pause" : "image://theme/icon-l-play"
                }
            }

            Rectangle {
                anchors.top: headerImage.bottom
                width: parent.width
                height: Theme.iconSizeMedium

                color: "black"

                Row {
                    anchors.right: parent.right
                    anchors.rightMargin: Theme.paddingSmall
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: Theme.paddingSmall

                    Label {
                        text: new Date(audioPlayer.position).toISOString().substr(14, 5)
                    }

                    Label {
                        text: "/"
                    }

                    Label {
                        text: new Date(audioPlayer.duration).toISOString().substr(14, 5)
                    }
                }
            }

            Slider {
                id: progressSlider

                anchors.topMargin: -height / 2

                anchors.top: headerImage.bottom
                anchors.horizontalCenter: parent.horizontalCenter

                width: parent.width + 5 * Theme.paddingLarge - 16

                minimumValue: 0
                maximumValue: audioPlayer.duration
                stepSize: 1000
                value: 0
                handleVisible: true

                onReleased: audioPlayer.seek(value)
            }
        }

        Label {
            id: labelTitle
            width: parent.width

            font.pixelSize: Theme.fontSizeMedium
            wrapMode: Text.WordWrap
            color: Theme.highlightColor

            text: item.title
        }

        Label {
            id: labelText
            width: parent.width

            font.pixelSize: Theme.fontSizeSmall
            wrapMode: Text.WordWrap

            text: item.text
        }

        Separator {
            id: separatorBottom
            width: parent.width
            color: Theme.highlightBackgroundColor
        }
    }

    MediaPlayer {
        id: audioPlayer
        source: item.stream

        onError: console.log(errorString)
    }

    Connections {
        target: audioPlayer
        onPositionChanged: progressSlider.value = audioPlayer.position
    }

    onClicked: {
        if (playing) {
            playing = false
            audioPlayer.pause()
        } else {
            playing = true
            audioPlayer.play()
        }
    }
}

