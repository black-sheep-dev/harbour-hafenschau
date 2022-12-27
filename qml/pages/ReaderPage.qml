import QtQuick 2.0
import Sailfish.Silica 1.0

import "../components/"

import "../."

Page {
    property bool busy: false
    property string link: ""
    property var news: undefined
    property bool ready: false

    function checkForUpdate() {
        busy = true
        Api.request(news.updateCheckUrl, function (data, status) {
            busy = false

            if (status !== 200) {
                return
            }

            if (data === "true") refresh()
        })
    }

    function refresh() {
        busy = true
        console.log(link)
        Api.request(link.length > 0 ? link : news.details, function (data, status) {
            busy = false

            if (status !== 200) {
                notify.show(qsTr("Failed to fetch news"))
                return
            }

            news = data
        })
    }


    id: page

    allowedOrientations: Orientation.All

    onNewsChanged: {
        ready = true
        refreshContent()
    }

    PageBusyIndicator {
        running: busy && !ready
    }

    SilicaFlickable {
        PullDownMenu {
            busy: busy

            MenuItem {
                visible: config.developerMode

                text: qsTr("Show raw data")
                onClicked: pageStack.push(Qt.resolvedUrl("DataReaderPage.qml"), { text: JSON.stringify(news, null, '\t') });
            }

            MenuItem {
                text: qsTr("Refresh")
                onClicked: refresh()
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
        }

        PushUpMenu {
            busy: busy
            visible: news.hasOwnProperty("comments")

            MenuItem {
                text: qsTr("Comments")
                onClicked: pageStack.push(Qt.resolvedUrl("CommentsListPage.qml"), {link: news.comments})
            }
        }

        anchors.fill: parent
        contentHeight: headerImage.height + columnHeader.height + columnContent.height + bottomSpacer.height

        RemoteImage {
            id: headerImage

            opacity: !ready ? 0:1

            Behavior on opacity {
                FadeAnimation { duration: 150 }
            }

            anchors.left: parent.left
            anchors.right: parent.right

            source: news.teaserImage.videowebl.imageurl
        }

        Column {
            id: columnHeader

            opacity: !ready ? 0:1

            Behavior on opacity {
                FadeAnimation { duration: 500 }
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

            opacity: !ready ? 0:1

            Behavior on opacity {
                FadeAnimation { duration: 1000 }
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

//        ViewPlaceholder {
//            enabled: newsRequest.error > 0
//            text: qsTr("Failed to load news")
//            hintText: qsTr("Check your internet connection")
//        }
    }

    function refreshContent() {
        for(var i = columnContent.children.length; i > 0; i--) {
            columnContent.children[i-1].destroy()
        }

        if (news === undefined) return

        if (!news.hasOwnProperty("content")) return

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
                if (config.developerMode) component = Qt.createComponent("../content/ContentUnkown.qml")
            }

            if (component.status !== Component.Ready)
                console.log("NOT READY")

            var obj = component.createObject(columnContent, { item: item })
        }
    }

    Component.onCompleted: {
        if (link.length > 0) {
            console.log("link available")
            refresh()
            return
        }

        if (news !== undefined) {
            ready = true
            refreshContent()
            checkForUpdate()
        }
    }
}
