import QtQuick 2.0
import Sailfish.Silica 1.0
import Sailfish.WebView 1.0
import Sailfish.WebEngine 1.0

WebViewPage {
    property string url

    id: page

    allowedOrientations: Orientation.All

    WebView {
        anchors.fill: parent
        active: true
        url: page.url
    }

    Component.onCompleted: {
        WebEngine.addObserver("clipboard:setdata")
        WebEngine.onRecvObserve.connect(function(message, data) {
            if (message == "clipboard:setdata" && !data.private) {
                console.log("Clipboard contents: " + data.data);
            }
        })
    }
}
