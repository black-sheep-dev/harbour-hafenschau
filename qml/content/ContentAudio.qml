import QtQuick 2.0
import Sailfish.Silica 1.0

import QtMultimedia 5.6

import org.nubecula.harbour.hafenschau 1.0

BackgroundItem {
    property bool playing: false
    property ContentItemAudio item

    x: Theme.horizontalPageMargin
    width: parent.width - 2*x
    height: headerImage.height + labelTitle.height  + labelText.height + separatorBottom.height + 3 * columnVideo.spacing

    Column {
        id: columnVideo
        width: parent.width
        spacing: Theme.paddingMedium

        Image {
            id: headerImage
            source: item.image > 0 ? item.image : "qrc:/images/audiograph"
            cache: true
            smooth: true


            width: parent.width
            //height: width * 0.75
            fillMode: Image.PreserveAspectCrop

            BusyIndicator {
                size: BusyIndicatorSize.Medium
                anchors.centerIn: headerImage
                running: headerImage.status === Image.Loading
            }

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

