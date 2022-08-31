import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.DBus 2.0
import Nemo.Notifications 1.0
import Nemo.Configuration 1.0
import Nemo.KeepAlive 1.2
import MeeGo.Connman 0.2

import "pages"

import "."

import org.nubecula.harbour.hafenschau 1.0

ApplicationWindow
{
    id: root

    property int currentCoverIndex: 0

    function refreshActiveRegions() {
        if (settings.regions.length === 0) return
        var regions = settings.regions.split(',')
        regions.map(Number)
        Global.activeRegions = regions.filter(function(value, index, arr) {
            return value > 0
        })
    }

    Connections {
        target: Global
        onActiveRegionsChanged: {
            var regions = Global.activeRegions
            if (regions.length > 0) {
                regions.map(String)
                settings.regions = regions.join(',')
            } else {
                settings.regions = ""
            }
            mainModel.refresh()
        }
    }

    DataWriter { id: dataWriter }


    ApiRequest {
        id: mainModelRequest
        query: "https://www.tagesschau.de/api2/homepage/"

        onFinished: mainModel.setData(result)
    }

    ApiRequest {
        id: checkForUpdateRequest

        onFinished: mainModel.checkUpdateCount(result)
    }

    NewsListModel {
        property bool error: false
        property bool loading: mainModelRequest.loading || checkForUpdateRequest.loading
        property string newStoriesCountLink: ""

        id: mainModel

        function refresh(cached) {
            if (cached === undefined)
                cached = false

            mainModelRequest.cached = cached
            api.request(mainModelRequest)
        }

        function checkForUpdate() {
            if (newStoriesCountLink.length === 0) {
                refresh(false)
                return
            }

            checkForUpdateRequest.query = newStoriesCountLink
            api.request(checkForUpdateRequest)
        }

        function checkUpdateCount(data) {
            if (data === undefined) refresh(false)

            const keys = Object.keys(data)
            keys.forEach(function(key) {
                if (data[key] > 0) {
                    refresh(false)
                }
            })
        }

        function setData(data) {
            newStoriesCountLink = data.newStoriesCountLink
            mainModel.setItems(data.news)

            if (Global.activeRegions.length === 0) return

            // notify if breaking news
            if (settings.notify) {
                data.news.forEach(function(news) {
                    if (news.breakingNews) breakingNewsNotification.notify(news)
                })
            }

            const regionalNews = []
            const ids = []

            data.regional.forEach(function(news) {
                const id = news.sophoraId

                news.regionIds.forEach(function(region) {

                    if ( Global.activeRegions.indexOf(String(region)) >= 0 && ids.indexOf(id) < 0 ) {
                        regionalNews.push(news)
                        ids.push(id)
                    }
                })
            })

            mainModel.addItems(regionalNews)
        }
    }

    Notification {
        function show(message) {
            replacesId = 0
            previewSummary = ""
            previewBody = message
            icon = "/usr/share/icons/hicolor/86x86/apps/" + appId + ".png"
            publish()
        }

        id: notification
        appName: "Hafenschau"
        expireTimeout: 3000
    }

    Notification {
        property var notifiedNews: []

        function notify(news) {
            if (notifiedNews.indexOf(news.sophoraId) >= 0) return

            summary = news.title
            subText = news.firstSentence
            body = news.firstSentence
            icon = "/usr/share/icons/hicolor/86x86/apps/" + appId + ".png"
            remoteActions = [{
                name: "default",
                service: "org.nubecula.hafenschau",
                path: "/",
                iface: "org.nubecula.hafenschau",
                method: "open",
                arguments: [news.details]
            }]

            notifiedNews.push(news.sophoraId)
            publish()
        }

        id: breakingNewsNotification
        appName: "Hafenschau"
    }

    ConfigurationGroup {
        id: settings
        path: "/apps/harbour-hafenschau"
        synchronous: true

        property int autoRefresh: 0
        property int commentsSortOrder: Qt.AscendingOrder
        property bool coverShowNews: true
        property bool coverSwitch: true
        property int coverSwitchInterval: 10000
        property int developerOptions: 0
        property bool internalWebView: true
        property bool notify: false
        property string regions: ""
        property int videoQuality: VideoQuality.Medium
        property bool videoQualityAdaptive: true

        onRegionsChanged: refreshActiveRegions()
    }

    BackgroundJob {
        enabled: settings.autoRefresh > 0
        frequency: settings.autoRefresh

        onTriggered: {
            mainModel.checkForUpdate()
            finished()
        }
    }

    initialPage: Component { StartPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations

    Component.onCompleted: refreshActiveRegions()

    onVisibleChanged: {
        if (!visible || !settings.coverShowNews) return

        pageStack.push(Qt.resolvedUrl("pages/ReaderPage.qml"), {
                           link: mainModel.newsDetails(currentCoverIndex)
                       })
    }
}
