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
            width: parent.width



            spacing: Theme.paddingMedium

            PageHeader {
                title: qsTr("Auto Refresh Settings")
            }

            Label {
                x: Theme.horizontalPageMargin
                width: page.width - 2*x

                color: Theme.highlightColor
                wrapMode: Text.Wrap

                text: qsTr("Manage automatic news refresh in a defined interval")
            }

            ComboBox {
                id: refreshModeComboBox
                width: parent.width
                label: qsTr("Refresh Mode")

                menu: ContextMenu {
                    MenuItem { text: qsTr("Off") }
                    MenuItem { text: qsTr("%n Second(s)", "", 30) }
                    MenuItem { text: qsTr("%n Minute(s)", "", 2.5) }
                    MenuItem { text: qsTr("%n Minute(s)", "", 5) }
                    MenuItem { text: qsTr("%n Minute(s)", "", 15) }
                    MenuItem { text: qsTr("%n Minute(s)", "", 30) }
                    MenuItem { text: qsTr("%n Minute(s)", "", 60) }
                }

                onCurrentIndexChanged: {
                    HafenschauProvider.autoRefresh = currentIndex
                    if (currentIndex === 0) notificationSwitch.checked = false
                }

                Component.onCompleted: currentIndex = HafenschauProvider.autoRefresh
            }

            TextSwitch {
                id: notificationSwitch
                enabled: refreshModeComboBox.currentIndex !== 0

                x: Theme.horizontalPageMargin
                width: parent.width - 2*x

                text: qsTr("Notification")
                description: qsTr("Enable notification if breaking news is available")

                onCheckedChanged: HafenschauProvider.notification = checked

                Component.onCompleted: checked = HafenschauProvider.notification
            }
        }
    }

    onStatusChanged: if (status === PageStatus.Deactivating) HafenschauProvider.saveSettings()
}
