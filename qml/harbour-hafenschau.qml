import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.DBus 2.0
import Nemo.KeepAlive 1.2
import Nemo.Configuration 1.0
import Nemo.Notifications 1.0
import QtQml.Models 2.2

import "models"
import "pages"

import "."

ApplicationWindow
{
    id: root

    property int currentCoverIndex: 0

    NewsModel {
        id: mainNews
        url: "https://www.tagesschau.de/api2/homepage"
    }

    ConfigurationGroup {
        id: config
        path: "/apps/harbour-hafenschau"
        synchronous: true

        property string activeRegions: "[]"
        property int autoRefresh: 0
        property int commentsSortOrder: Qt.AscendingOrder
        property bool coverShowNews: true
        property bool coverSwitch: true
        property int coverSwitchInterval: 10000
        property bool developerMode: false
        property bool internalWebView: true
        property bool notify: false
        property int videoQuality: 1
        property bool videoQualityAdaptive: true

        onActiveRegionsChanged: console.log(activeRegions)
    }

    Notification {
        function show(message) {
            replacesId = 0
            previewSummary = ""
            previewBody = message
            icon = "/usr/share/icons/hicolor/86x86/apps/harbour-" + Qt.application.name + ".png"
            publish()
        }

        id: notify
        appName: qsTr("Hafenschau")
    }

//    Notification {
//        property var notifiedNews: []

//        function notify(news) {
//            if (notifiedNews.indexOf(news.sophoraId) >= 0) return

//            summary = news.title
//            subText = news.firstSentence
//            body = news.firstSentence
//            icon = "/usr/share/icons/hicolor/86x86/apps/" + appId + ".png"
//            remoteActions = [{
//                name: "default",
//                service: "org.nubecula.hafenschau",
//                path: "/",
//                iface: "org.nubecula.hafenschau",
//                method: "open",
//                arguments: [news.details]
//            }]

//            notifiedNews.push(news.sophoraId)
//            publish()
//        }

//        id: breakingNewsNotification
//        appName: "Hafenschau"
//    }

    BackgroundJob {
        enabled: config.autoRefresh > 0
        frequency: config.autoRefresh

        onTriggered: {
            mainModel.refresh()
            finished()
        }
    }

    initialPage: Component { StartPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations

    Component.onCompleted: mainNews.refresh()

    onVisibleChanged: {
        if (!visible || !config.coverShowNews) return

        pageStack.push(Qt.resolvedUrl("pages/ReaderPage.qml"), {
                           link: mainNews.items[currentCoverIndex].details
                       })
    }
}
