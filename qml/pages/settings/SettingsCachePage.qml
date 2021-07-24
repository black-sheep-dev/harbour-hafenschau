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
                title: qsTr("Cache Settings")
            }

            ProgressCircle {
                id: cacheUsage

                width: parent.width * 0.5
                height: width
                anchors.horizontalCenter: parent.horizontalCenter
                borderWidth: 0.1 * width

                progressValue: HafenschauProvider.cacheSize() / 50000000

                Label {
                    anchors.centerIn: parent

                    text: Math.round(HafenschauProvider.cacheSize() / 1000000) + "/50 MB"
                }
            }

            ButtonLayout {
                width: parent.width

                Button {
                    text: qsTr("Reset")
                    onClicked: HafenschauProvider.clearCache()
                }
            }
        }
    }
}
