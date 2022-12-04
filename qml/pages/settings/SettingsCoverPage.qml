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

            width: parent.width
            spacing: Theme.paddingMedium

            PageHeader {
                title: qsTr("Cover Settings")
            }

            TextSwitch {
                id: coverShowSwitch
                x: Theme.horizontalPageMargin
                width: page.width - 2*x
                text: qsTr("Show news directly")
                description: qsTr("Open news instead of news list when pressing cover.")

                onCheckedChanged: config.coverShowNews = checked
                Component.onCompleted: checked = config.coverShowNews
            }

            TextSwitch {
                id: coverSwitch
                x: Theme.horizontalPageMargin
                width: page.width - 2*x
                text: qsTr("Switch Cover")
                description: qsTr("Turns on automatic switch of cover pages in a defined interval.")

                onCheckedChanged: config.coverSwitch = checked
                Component.onCompleted: checked = config.coverSwitch
            }

            TextField {
                id: coverSwitchInterval
                x: Theme.horizontalPageMargin
                width: page.width - 2*x
                inputMethodHints: Qt.ImhDigitsOnly

                validator: IntValidator {
                    bottom: 0
                }

                label: qsTr("Update interval (msec)")
                description: qsTr("Update interval for cover page switch")

                onTextChanged: config.coverSwitchInterval = text
                Component.onCompleted: text = config.coverSwitchInterval
            }
        }
    }
}
