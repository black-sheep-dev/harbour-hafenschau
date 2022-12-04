import QtQuick 2.0

import "../."

Item {
    property bool busy: false
    property bool commentsAllowed: false
    property int count: 0
    property string link: ""
    property string details: ""
    property string detailsWeb: ""
    property int sortOrder: Qt.AscendingOrder

    property var items: []

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

            if (sortOrder === Qt.AscendingOrder) {
                items = data.Items
            } else {
                items = data.Items.sort(compare)
            }
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

    onSortOrderChanged: items = items.sort(compare)
}
