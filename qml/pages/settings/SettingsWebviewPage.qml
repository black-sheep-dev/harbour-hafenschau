import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nubecula.harbour.hafenschau 1.0

Page {
    id: page

    allowedOrientations: Orientation.All

    SilicaFlickable {
        anchors.fill: parent

        contentHeight: column.height

        Column {
            id: column

            x: Theme.horizontalPageMargin

            width: page.width - 2 * x
            spacing: Theme.paddingLarge

            PageHeader {
                title: qsTr("Webview Settings")
            }

            TextSwitch {
                id: internalWebviewSwitch
                text: qsTr("Internal Webview")
                description: qsTr("When deactivated the web content will be opened in the extarnal browser instead of the internal webview.")

                onCheckedChanged:  HafenschauProvider.internalWebView = checked

                Component.onCompleted: checked = HafenschauProvider.internalWebView
            }

        }
    }

    onStatusChanged: if (status === PageStatus.Deactivating) HafenschauProvider.saveSettings()
}
