import QtQuick 2.0
import Sailfish.Silica 1.0

import QtMultimedia 5.6

Page {
    property string url

    id: page

    allowedOrientations: Orientation.All

    SilicaFlickable {
        anchors.fill: parent

        Item {
            MediaPlayer {
                id: mediaplayer
                source: url
            }

            VideoOutput {
                anchors.fill: parent
                source: mediaplayer
            }

            MouseArea {
                id: playArea
                anchors.fill: parent
                onPressed: mediaplayer.play();
            }
        }
    }
}

