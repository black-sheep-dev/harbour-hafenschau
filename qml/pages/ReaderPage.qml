import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nubecula.harbour.hafenschau 1.0

import "../components/"

Page {
    property bool error: false
    property string link
    property bool loading: true
    property var news
    property string updateCheckUrl

    function checkForUpdate() {
        error = false

        if (updateCheckUrl === undefined) {
            refresh(false)
            return
        }

        api.request(updateCheckUrl, updateCheckUrl, false)
    }

    function refresh(cached) {
        error = false
        api.request(link, link, cached)
    }

    id: page

    allowedOrientations: Orientation.All

    PageBusyIndicator {
        running: loading && news === undefined
    }

    SilicaFlickable {
        PullDownMenu {
            MenuItem {
                visible: settings.developerOptions & DeveloperOption.SaveNews

                text: qsTr("Save news data")
                onClicked: dataWriter.saveNews(news)
            }

            MenuItem {
                text: qsTr("Refresh")
                onClicked: checkForUpdate()
            }

            MenuItem {
                visible: news.hasOwnProperty("shareURL")
                text: qsTr("Copy link to clipboard")
                onClicked: Clipboard.text = news.shareURL
            }

            MenuItem {
                visible: news.hasOwnProperty("comments")
                text: qsTr("Comments")
                onClicked: pageStack.push(Qt.resolvedUrl("CommentsListPage.qml"), {link: news.comments})
            }

            busy: loading
        }

        PushUpMenu {
            visible: news.hasOwnProperty("comments")
            MenuItem {
                text: qsTr("Comments")
                onClicked: pageStack.push(Qt.resolvedUrl("CommentsListPage.qml"), {link: news.comments})
            }
        }

        visible: !loading

        anchors.fill: parent
        contentHeight: headerImage.height + columnHeader.height + columnContent.height + bottomSpacer.height

        opacity: (loading && news === undefined) ? 0.0 : 1.0

        Behavior on opacity { FadeAnimation {} }

        ViewPlaceholder {
            enabled: error && !loading
            text: qsTr("Failed to load news")
            hintText: qsTr("Check your internet connection")
        }

        RemoteImage {
            id: headerImage

            visible: !error
            opacity: news === undefined ? 0:1

            Behavior on opacity {
                FadeAnimation {}
            }

            anchors.left: parent.left
            anchors.right: parent.right

            source: news.teaserImage.videowebl.imageurl
        }

        Column {
            id: columnHeader

            visible: !error
            opacity: news === undefined ? 0:1

            Behavior on opacity {
                FadeAnimation {}
            }

            anchors.top: headerImage.bottom
            x: Theme.horizontalPageMargin
            width: parent.width - 2*x
            spacing: Theme.paddingLarge

            Item {
                height: Theme.paddingSmall
                width: 1
            }

            LinkedLabel {
                width: parent.width

                font.pixelSize: Theme.fontSizeTiny
                font.italic: true
                plainText: "© https://tagesschau.de"
                linkColor: Theme.highlightColor
            }

            Label {
                width: parent.width

                wrapMode: Text.WordWrap
                font.pixelSize: Theme.fontSizeSmall
                text: news.topline
            }

            Label {
                width: parent.width

                font.pixelSize: Theme.fontSizeLarge
                font.bold: true
                color: Theme.highlightColor

                wrapMode: Text.WordWrap

                text: news.title
            }

            Row {
                width: parent.width

                spacing: Theme.paddingMedium

                Label {
                    text: qsTr("Time:")

                    font.pixelSize: Theme.fontSizeExtraSmall
                    color: Theme.highlightColor
                }

                Label {
                    text: new Date(news.date).toLocaleString()

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

            visible: !error
            opacity: news === undefined ? 0:1

            Behavior on opacity {
                FadeAnimation {}
            }

            anchors.top: columnHeader.bottom
            width: parent.width

            spacing: Theme.paddingLarge
        }

        Item {
            id: bottomSpacer

            anchors.top: columnContent.bottom
            height: Theme.paddingMedium
            width: 1
        }
    }

    Component.onCompleted: refresh(true)

    Connections {
        target: api
        onRequestFailed: {
            if (page.link !== id) return

            notification.show(qsTr("Failed to load news"))
            loading = false
            page.error = true
        }
        onRequestFinished: {
            if (page.link !== id) return

            page.news = data

            if (data.hasOwnProperty("updateCheckUrl")) page.updateCheckUrl = data.updateCheckUrl
            loading = false
            refreshContent()
        }
        onRequestFinishedWithRawData: {
            if (page.updateCheckUrl !== id) return
            if (data === "true") refresh(false)
        }
    }

    function refreshContent() {
        for(var i = columnContent.children.length; i > 0; i--) {
            columnContent.children[i-1].destroy()
        }

        var count = news.content.length
        for(var j = 0; j < count; j++) {
            var item = news.content[j]

            var component

            if (item.type === "headline") {
                component = Qt.createComponent("../content/ContentHeadline.qml")
            } else if (item.type === "text") {
                component = Qt.createComponent("../content/ContentText.qml")
            } else if (item.type === "box") {
                component = Qt.createComponent("../content/ContentBox.qml")
                item = item.box
            } else if (item.type === "related") {
                component = Qt.createComponent("../content/ContentRelated.qml")
                item = item.related
            } else if (item.type === "video") {
                component = Qt.createComponent("../content/ContentVideo.qml")
                item = item.video
            } else if (item.type === "audio") {
                component = Qt.createComponent("../content/ContentAudio.qml")
                item = item.audio
            } else if (item.type === "list") {
                component = Qt.createComponent("../content/ContentList.qml")
                item = item.list
            } else if (item.type === "quotation") {
                component = Qt.createComponent("../content/ContentQuotation.qml")
                item = item.quotation
            } else if (item.type === "image_gallery") {
                component = Qt.createComponent("../content/ContentGallery.qml")
                item = item.gallery
            } else if (item.type === "socialmedia") {
                component = Qt.createComponent("../content/ContentSocial.qml")
                item = item.social
            } else if (item.type === "htmlEmbed") {
                component = Qt.createComponent("../content/ContentHtmlEmbed.qml")
                item = item.htmlEmbed
            } else if (item.type === "webview") {
                component = Qt.createComponent("../content/ContentWebview.qml")
                item = item.webview
            } else {
                if (!(settings.developerOptions & DeveloperOption.ShowUnkownContent))
                    continue

                component = Qt.createComponent("../content/ContentUnkown.qml")
            }

            if (component.status !== Component.Ready)
                console.log("NOT READY")

            var obj = component.createObject(columnContent, {item: item})
        }
    }
}
