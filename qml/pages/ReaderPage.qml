import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nubecula.harbour.hafenschau 1.0

import "../components/"
import "../content/"

Page {
    property News news

    id: page

    allowedOrientations: Orientation.All

    SilicaFlickable {
        PullDownMenu {
            MenuItem {
                visible: (HafenschauProvider.developerOptions & HafenschauProvider.DevOptSaveNews) === HafenschauProvider.DevOptSaveNews

                text: qsTr("Save news data")
                onClicked: HafenschauProvider.saveNews(news)
            }

            MenuItem {
                text: qsTr("Refresh")
                onClicked: HafenschauProvider.refreshNews(news)
            }

            MenuItem {
                visible: news.comments.length > 0
                text: qsTr("Show Comments")
                onClicked: pageStack.push(Qt.resolvedUrl("CommentsListPage.qml"), {link: news.comments})
            }
        }

        PushUpMenu {
            visible: news.comments.length > 0
            MenuItem {
                text: qsTr("Show Comments")
                onClicked: pageStack.push(Qt.resolvedUrl("CommentsListPage.qml"), {link: news.comments})
            }
        }

        anchors.fill: parent

        contentHeight: headerImage.height + columnHeader.height + columnContent.height

        RemoteImage {
            id: headerImage

            anchors.left: parent.left
            anchors.right: parent.right

            source: news.image

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

            LinkedLabel {
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

            Component.onCompleted: refreshContent()
        }

        VerticalScrollDecorator {}
    }

    Connections {
        target: HafenschauProvider
        onInternalLinkAvailable: pageStack.push(Qt.resolvedUrl("ReaderPage.qml"), { news: news })
    }

    Connections {
        target: news
        onChanged: refreshContent()
    }

    function refreshContent() {
        console.log("refresh content")

        for(var i = columnContent.children.length; i > 0; i--) {
            columnContent.children[i-1].destroy()
        }

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
            } else if (item.contentType === ContentItem.HtmlEmbed) {
                component = Qt.createComponent("../content/ContentHtmlEmbed.qml")
            } else {
                if ((HafenschauProvider.developerOptions & HafenschauProvider.DevOptShowUnkownContent) !== HafenschauProvider.DevOptShowUnkownContent)
                    continue

                component = Qt.createComponent("../content/ContentUnkown.qml")
            }

            if (component.status !== Component.Ready)
                console.log("NOT READY")

            var obj = component.createObject(columnContent, {item: item})
        }
    }
}
