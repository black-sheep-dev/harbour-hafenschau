import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    allowedOrientations: Orientation.All

    SilicaFlickable {
        anchors.fill: parent

        contentHeight: column.height

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge

            PageHeader {
                title: qsTr("Webview Settings")
            }

            TextSwitch {
                id: internalWebviewSwitch
                x: Theme.horizontalPageMargin
                width: page.width - 2*x
                text: qsTr("Internal Webview")
                description: qsTr("When deactivated the web content will be opened in the extarnal browser instead of the internal webview.")

                onCheckedChanged:  settings.internalWebView = checked

                Component.onCompleted: checked = settings.internalWebView
            }

        }
    }
}
