import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.KeepAlive 1.2

import "../../."

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
                    switch (currentIndex) {
                    case 0:
                        config.autoRefresh = 0
                        break

                    case 1:
                        config.autoRefresh = BackgroundJob.ThirtySeconds
                        break

                    case 2:
                        config.autoRefresh = BackgroundJob.TwoAndHalfMinutes
                        break

                    case 3:
                        config.autoRefresh = BackgroundJob.FiveMinutes
                        break

                    case 4:
                        config.autoRefresh = BackgroundJob.FifteenMinutes
                        break

                    case 5:
                        config.autoRefresh = BackgroundJob.ThirtyMinutes
                        break

                    case 6:
                        config.autoRefresh = BackgroundJob.OneHour
                        break

                    default:
                        config.autoRefresh = 0
                        break
                    }

                    if (currentIndex === 0) notificationSwitch.checked = false
                }

                Component.onCompleted: {
                    switch (config.autoRefresh) {
                    case BackgroundJob.ThirtySeconds:
                        currentIndex = 1
                        break

                    case BackgroundJob.TwoAndHalfMinutes:
                        currentIndex = 2
                        break

                    case BackgroundJob.FiveMinutes:
                        currentIndex = 3
                        break

                    case BackgroundJob.FifteenMinutes:
                        currentIndex = 4
                        break

                    case BackgroundJob.ThirtyMinutes:
                        currentIndex = 5
                        break

                    case BackgroundJob.OneHour:
                        currentIndex = 6
                        break

                    default:
                        currentIndex = 0
                        break
                    }
                }
            }

            TextSwitch {
                id: notificationSwitch
                enabled: refreshModeComboBox.currentIndex !== 0

                x: Theme.horizontalPageMargin
                width: parent.width - 2*x

                text: qsTr("Notification")
                description: qsTr("Enable notification if breaking news is available")

                onCheckedChanged: config.notify = checked

                Component.onCompleted: checked = config.notify
            }
        }
    }
}
