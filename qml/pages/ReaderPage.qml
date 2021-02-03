import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nubecula.harbour.hafenschau 1.0

import "../content/"

Page {
    property News news

    id: page

    allowedOrientations: Orientation.All

    SilicaFlickable {
        PullDownMenu {
            visible: (HafenschauProvider.developerOptions & HafenschauProvider.DevOptSaveNews) === HafenschauProvider.DevOptSaveNews

            MenuItem {
                visible: (HafenschauProvider.developerOptions & HafenschauProvider.DevOptSaveNews) === HafenschauProvider.DevOptSaveNews

                text: qsTr("Save news data")
                onClicked: HafenschauProvider.saveNews(news)
            }
        }

        PushUpMenu {
            visible: news.comments.length > 0
            MenuItem {
                text: qsTr("Show Comments")
                onClicked: pageStack.push(Qt.resolvedUrl("CommentsListPage.qml"), {link: news.comments})
            }
        }

        Timer {
            id: refreshTimer
            interval: 1000
            repeat: false

            onTriggered: refreshContentLayout()
        }

        anchors.fill: parent

        contentHeight: headerImage.height + columnHeader.height + columnContent.height

        Image {
            visible: news.image.length > 0

            id: headerImage
            source: news.image
            cache: true
            smooth: true

            anchors.left: parent.left
            anchors.right: parent.right

            fillMode: Image.PreserveAspectCrop

            BusyIndicator {
                size: BusyIndicatorSize.Medium
                anchors.centerIn: headerImage
                running: headerImage.status != Image.Ready
            }

            Image {
                x: Theme.paddingLarge
                y: Theme.paddingMedium

                source: news.brandingImage
            }
        }


        Column { 
            id: columnHeader

            anchors.top: headerImage.bottom
            width: parent.width
            spacing: Theme.paddingMedium

            Item {
                height: Theme.paddingMedium
                width: 1
            }

            Label {
                x: Theme.horizontalPageMargin
                width: parent.width - 2*x
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeTiny
                font.italic: true
                color: Theme.highlightColor

                text: "© https://tagesschau.de"

                onLinkActivated: pageStack.push(Qt.resolvedUrl("../dialogs/OpenExternalUrlDialog.qml"), {url: link })
            }

            Label {
                x: Theme.horizontalPageMargin
                width: parent.width - 2*x

                wrapMode: Text.WordWrap

                font.pixelSize: Theme.fontSizeMedium

                text: news.topline
            }

            Label {
                x: Theme.horizontalPageMargin
                width: parent.width - 2*x

                font.pixelSize: Theme.fontSizeLarge
                font.bold: true
                color: Theme.highlightColor

                wrapMode: Text.WordWrap

                text: news.title
            }

            Row {
                x: Theme.horizontalPageMargin
                width: parent.width - 2*x

                spacing: Theme.paddingMedium

                Label {
                    text: qsTr("Time:")

                    font.pixelSize: Theme.fontSizeExtraSmall
                    color: Theme.highlightColor
                }

                Label {
                    text: news.date.toLocaleString()

                    font.pixelSize: Theme.fontSizeExtraSmall
                }
            }

            Item {
                height: Theme.paddingMedium
                width: 1
            }
        }

        Column {
            id: columnContent

            anchors.top: columnHeader.bottom
            width: parent.width

            spacing: Theme.paddingLarge

            Component.onCompleted: {

                for (var i=0; i < news.contentItemsCount(); i++) {
                    var item = news.contentItemAt(i)

                    if (item === undefined)
                        continue

                    var component

                    if (item.contentType === ContentItem.Headline) {
                        component = Qt.createComponent("../content/ContentHeadline.qml")
                    } else if (item.contentType === ContentItem.Text) {
                        component = Qt.createComponent("../content/ContentText.qml")
                    } else if (item.contentType === ContentItem.Box) {
                        component = Qt.createComponent("../content/ContentBox.qml")
                    } else if (item.contentType === ContentItem.Video) {
                        component = Qt.createComponent("../content/ContentVideo.qml")
                    } else if (item.contentType === ContentItem.Gallery) {
                        component = Qt.createComponent("../content/ContentGallery.qml")
                    } else if (item.contentType === ContentItem.List) {
                        component = Qt.createComponent("../content/ContentList.qml")
                    } else if (item.contentType === ContentItem.Quotation) {
                        component = Qt.createComponent("../content/ContentQuotation.qml")
                    } else if (item.contentType === ContentItem.Related) {
                        component = Qt.createComponent("../content/ContentRelated.qml")
                    } else if (item.contentType === ContentItem.Audio) {
                        component = Qt.createComponent("../content/ContentAudio.qml")
                    } else if (item.contentType === ContentItem.Social) {
                        component = Qt.createComponent("../content/ContentSocial.qml")
                    } else {
                        continue
                    }

                    if (component.status !== Component.Ready)
                        console.log("NOT READY")

                    var obj = component.createObject(columnContent, {item: item})

                    columnContent.height = columnContent.height + columnContent.spacing + obj.height
                }
                refreshTimer.start()
            }
        }

        VerticalScrollDecorator {}
    }

    Connections {
        target: HafenschauProvider
        onInternalLinkAvailable: pageStack.push(Qt.resolvedUrl("ReaderPage.qml"), { news: news })
    }

    function refreshContentLayout() {
        columnContent.height = columnContent.childrenRect.height + Theme.paddingLarge
    }

    onOrientationChanged: refreshTimer.start()
}
