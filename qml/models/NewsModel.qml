import QtQuick 2.0

import "../."

ListModel {
    property bool busy: false
    property string url: ""
    property string nextPage: ""
    property string newStoriesCountLink: ""

    id: listModel

    signal updated()

    function refresh() {
        if (newStoriesCountLink.length === 0) {
            fetch()
            return
        }

        Api.request(newStoriesCountLink, function(data, status) {
            if (status !== 200) {
                fetch()
                return
            }


            if (data.tagesschau > 0) {
                fetch()
                return
            }

            const regions = JSON.parse(config.activeRegions)

            regions.forEach(function(region) {
                if (data.response[region] > 0) {
                    fetch()
                    return
                }
            })

            notify.show(qsTr("No updates available"))
        })
    }

    function fetch() {
        busy = true
        Api.request(url, function (data, status) {
            busy = false

            if (status !== 200) {
                notify.show(qsTr("Failed to fetch news"))
                return
            }

            if (data.hasOwnProperty("newStoriesCountLink")) newStoriesCountLink = data.newStoriesCountLink


            const items
            if (data.hasOwnProperty("regional")) {
                const regions = JSON.parse(config.activeRegions)

                const regionalNews = []
                const ids = []

                data.regional.forEach(function(news) {
                    const id = news.sophoraId

                    news.regionIds.forEach(function(region) {

                        if ( regions.indexOf(region) >= 0 && ids.indexOf(id) < 0 ) {
                            regionalNews.push(news)
                            ids.push(id)
                        }
                    })
                })

                items = data.news.concat(regionalNews)
            } else if (data.hasOwnProperty("channels")) {
                items = data.channels
            } else {
                items = data.news
            }

            listModel.clear()
            items.forEach(function(item) { listModel.append(item) })
            listModel.updated()

            if (data.hasOwnProperty("nextPage")) nextPage = data.nextPage
        })
    }

    function loadMore() {
        if (nextPage.length === 0) return
        busy = true
        Api.request(nextPage, function (data, status) {
            if (status !== 200) {
                notify.show(qsTr("Failed to fetch more news"))
                return
            }

            data.news.forEach(function(item) { listModel.append(item) })

            nextPage = data.nextPage
        })
    }
}
