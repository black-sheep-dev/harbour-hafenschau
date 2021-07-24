import QtQuick 2.0
import Sailfish.Silica 1.0

import QtMultimedia 5.6

import org.nubecula.harbour.hafenschau 1.0

import "../components/"

BackgroundItem {
    property bool playing: false
    property ContentItemAudio item

    width: parent.width
    height: headerImage.height + labelTitle.height  + labelText.height + separatorBottom.height + 3 * columnVideo.spacing

    Column {
        id: columnVideo
        x: Theme.horizontalPageMargin
        width: parent.width - 2*x
        spacing: Theme.paddingMedium

        RemoteImage {
            id: headerImage

            source: item.image
            placeholderUrl: "/usr/share/harbour-hafenschau/images/audiograph.png"

            Image {
                anchors.centerIn: parent
                source: playing ? "image://theme/icon-l-pause" : "image://theme/icon-l-play"
            }

            Slider {
                anchors.bottom: headerImage.bottom
                width: parent.width
                minimumValue: 0
                maximumValue: audioPlayer.duration
                stepSize: 1000
                value: audioPlayer.position

                onExited: audioPlayer.seek(value)
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

