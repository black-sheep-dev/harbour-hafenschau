import QtQuick 2.0
import Sailfish.Silica 1.0
import Sailfish.WebView 1.0

Page {
    property string url

    id: page

    allowedOrientations: Orientation.All

    WebView {
        anchors.fill: parent
        active: true
        url: page.url
    }
}
