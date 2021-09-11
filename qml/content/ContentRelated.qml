import QtQuick 2.0
import Sailfish.Silica 1.0

import "../components/"

Item {
    property var item

    width: parent.width
    height: columnHeader.height + columnList.height

    Column {
        id: columnHeader
        width: parent.width
        spacing: Theme.paddingMedium

        Separator {
            x: Theme.horizontalPageMargin
            width: parent.width - 2*x
            color: Theme.highlightBackgroundColor
        }

        Label {
            x: Theme.horizontalPageMargin
            width: parent.width - 2*x

            font.pixelSize: Theme.fontSizeMedium
            wrapMode: Text.WordWrap

            color: Theme.highlightColor

            text: qsTr("More on the subject")
        }
    }

    Column {
        id: columnList
        width: parent.width
        anchors.top: columnHeader.bottom

        Repeater {
            model: item

            BackgroundItem {
                width: parent.width
                height: Theme.itemSizeHuge

                Row {
                    id: contentRow
                    x: Theme.horizontalPageMargin
                    width: parent.width - 2*x
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.topMargin: Theme.paddingSmall
                    anchors.bottomMargin: Theme.paddingSmall
                    spacing: Theme.paddingMedium

                    RemoteImage {
                        id: thumbnailImage
                        anchors.verticalCenter: parent.verticalCenter
                        x: Theme.horizontalPageMargin
                        width: Theme.itemSizeHuge * 0.8
                        height: width

                        source: modelData.teaserImage.videoweb1x1l.imageurl
                        placeholderUrl: "/usr/share/harbour-hafenschau/images/dummy_thumbnail.png"

                        Image {
                            visible: modelData.type === "video"
                            anchors.centerIn: parent
                            source: "image://theme/icon-m-play"
                        }
                    }

                    Column {
                        width: parent.width - thumbnailImage.width - parent.spacing
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: Theme.paddingSmall

                        Label {
                            visible: modelData.type !== "video"

                            text: modelData.topline

                            x: Theme.paddingMedium
                            width: parent.width - 2*x
                            wrapMode: Text.WordWrap

                            font.pixelSize: Theme.fontSizeSmall
                        }
                        Label {
                            text: modelData.title

                            x: Theme.paddingMedium
                            width: parent.width - 2*x
                            wrapMode: Text.WordWrap

                            font.pixelSize: Theme.fontSizeMedium
                            color: Theme.highlightColor
                        }
                    }
                }

                Separator {
                    id: separatorBottom
                    visible: index < (item.length - 1)
                    anchors.bottom: parent.bottom
                    x: Theme.horizontalPageMargin
                    width: parent.width - 2*x
                    color: Theme.primaryColor
                }

                onClicked: {
                    if (modelData.type === "video") {
                        pageStack.animatorPush(Qt.resolvedUrl("../pages/VideoPlayerPage.qml"), {
                                           title: modelData.title,
                                           streams: modelData.streams
                                       })
                    } if (modelData.type === "webview") {
                        if (settings.internalWebView) {
                            pageStack.animatorPush(Qt.resolvedUrl("../pages/WebViewPage.qml"), {url: modelData.detailsweb })
                        } else {
                            Qt.openUrlExternally(modelData
                                                 .detailsweb)
                        }
                    } else {
                        pageStack.animatorPush(Qt.resolvedUrl("../pages/ReaderPage.qml"), {link: modelData.details})
                    }
                }
            }
        }
    }
}

