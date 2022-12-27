import QtQuick 2.0

import "../."

ListModel {
    property bool busy: false
    property bool commentsAllowed: false
    property int count: 0
    property string link: ""
    property string details: ""
    property string detailsWeb: ""
    property int sortOrder: Qt.AscendingOrder

    id: listModel

    function refresh() {
        if (details.length > 0) {
            fetch()
            return
        }

        busy = true
        Api.request(link, function (data, status) {
            busy = false
            if (status !== 200) {
                return
            }

            count = data.count
            commentsAllowed = data.commentsAllowed
            details = data.details
            detailsWeb = data.detailsWeb

            fetch()
        })
    }

    function fetch() {
        busy = true
        Api.request(details, function(data, status) {
            busy = false
            if (status !== 200) {
                notify.show(qsTr("Failed to fetch comments"))
                return
            }

            const items

            if (sortOrder === Qt.AscendingOrder) {
                items = data.Items
            } else {
                items = data.Items.sort(compare)
            }

            listModel.clear()
            items.forEach(function(item) { listModel.append(item) })
        })
    }

    function compare(a, b) {
        const da = new Date(a.Beitragsdatum)
        const db = new Date(b.Beitragsdatum)

        if (sortOrder === Qt.AscendingOrder) {
            return da - db
        } else {
            return db - da
        }
    }

    onSortOrderChanged: fetch()
}
