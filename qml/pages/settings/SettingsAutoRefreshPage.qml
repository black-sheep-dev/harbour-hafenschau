import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.KeepAlive 1.2

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
                    switch (currentIndex) {
                    case 0:
                        settings.autoRefresh = 0
                        break

                    case 1:
                        settings.autoRefresh = BackgroundJob.ThirtySeconds
                        break

                    case 2:
                        settings.autoRefresh = BackgroundJob.TwoAndHalfMinutes
                        break

                    case 3:
                        settings.autoRefresh = BackgroundJob.FiveMinutes
                        break

                    case 4:
                        settings.autoRefresh = BackgroundJob.FifteenMinutes
                        break

                    case 5:
                        settings.autoRefresh = BackgroundJob.ThirtyMinutes
                        break

                    case 6:
                        settings.autoRefresh = BackgroundJob.OneHour
                        break

                    default:
                        settings.autoRefresh = 0
                        break
                    }

                    if (currentIndex === 0) notificationSwitch.checked = false
                }

                Component.onCompleted: {
                    switch (settings.autoRefresh) {
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

                onCheckedChanged: settings.notify = checked

                Component.onCompleted: checked = settings.notify
            }
        }
    }
}
