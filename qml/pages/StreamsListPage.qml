import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nubecula.harbour.hafenschau 1.0

import "../components/"

Page {
    id: page

    allowedOrientations: Orientation.All

    SilicaListView {
        id: listView

        model: ListModel {
            ListElement {
                title: "Tagesschau 24";
                description: qsTr("Broadcasting of information and news programmes, reports, documentaries and talk programmes")
                icon: "https://www.tagesschau.de/res/assets/image/favicon/favicon-96x96.png"
                url: "https://tagesschau-lh.akamaihd.net/i/tagesschau_3@66339/master.m3u8"
            }
            ListElement {
                title: "Tagesschau Events";
                description: qsTr("Livestream of events")
                icon: "https://www.tagesschau.de/res/assets/image/favicon/favicon-96x96.png"
                url: "http://tagesschau-lh.akamaihd.net/i/tagesschau_2@119232/master.m3u8"
            }
            ListElement {
                title: "Das Erste";
                description: qsTr("Live TV stream")
                icon: "https://www.tagesschau.de/res/assets/image/favicon/favicon-96x96.png"
                url: "https://derste247livede.akamaized.net/hls/live/658317/daserste_de/master.m3u8"
            }
            ListElement {
                title: "Bundestag/Parlamentsfernsehen";
                description: qsTr("Livestream of parliamentary sessions")
                icon: "https://www.bundestag.de/resource/blob/710792/1412e3a264dedb70095c5662743aee3e/adler-data.png"
                url: "https://bttv-live-z.r53.cdn.tv1.eu/13014bundestag-hk1/_definst_/live/video/hk1_de.smil/playlist.m3u8"
            }
//            ListElement {
//                title: "Phoenix";
//                description: qsTr("Livestream of events")
//                icon: "https://www.phoenix.de/apple-touch-icon-precomposed.png"
//                url: "https://zdf-hls-19.akamaized.net/hls/live/2016502/de/high/master.m3u8"
//            }
        }

        anchors.fill: parent
        header: PageHeader {
            title: qsTr("Livestreams")
        }

        delegate: ListItem {
            id: delegate
            width: parent.width
            contentHeight: contentRow.height + 2*Theme.paddingSmall

            Row {
                id: contentRow

                x: Theme.horizontalPageMargin
                width: parent.width - 2*x

                RemoteImage {
                    id: itemIcon
                    anchors.top: parent.top
                    anchors.topMargin: Theme.paddingSmall

                    width: Theme.itemSizeLarge
                    height: Theme.itemSizeLarge

                    source: icon
                }

                Item {
                    width:Theme.paddingMedium
                    height:1
                }

                Column {
                    id: data
                    width: parent.width - itemIcon.width - Theme.paddingSmall
                    anchors.top: parent.top
                    anchors.topMargin: Theme.paddingSmall
                    spacing: Theme.paddingSmall

                    Label {  
                        width: parent.width
                        text: title
                        color: pressed ? Theme.secondaryHighlightColor:Theme.highlightColor
                        font.pixelSize: Theme.fontSizeMedium
                    }
                    Label {
                        width: parent.width
                        text: description
                        color: pressed ? Theme.secondaryColor:Theme.primaryColor
                        font.pixelSize: Theme.fontSizeSmall
                        wrapMode: Text.Wrap
                    }
                }
            }

            onClicked: pageStack.push(Qt.resolvedUrl("VideoPlayerPage.qml"), {
                                                  title: model.title,
                                                  livestream: model.url
                                              })
        }

        VerticalScrollDecorator {}
    }
}



