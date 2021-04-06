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
            spacing: Theme.paddingMedium

            PageHeader {
                title: qsTr("Cover Settings")
            }

            TextSwitch {
                id: coverSwitch
                text: qsTr("Switch Cover")
                description: qsTr("Turns on automatich switch of cover pages in a defined interval.")


                onCheckedChanged: HafenschauProvider.coverSwitch = checked


                Component.onCompleted: checked = HafenschauProvider.coverSwitch
            }

            TextField {
                id: coverSwitchInterval
                width: parent.width
                inputMethodHints: Qt.ImhDigitsOnly

                validator: IntValidator {
                    bottom: 0
                }

                label: qsTr("Update interval")
                description: qsTr("Update interval for cover page switch")

                onTextChanged: HafenschauProvider.coverSwitchInterval = text

                Component.onCompleted: text = HafenschauProvider.coverSwitchInterval
            }
        }
    }

    onStatusChanged: if (status === PageStatus.Deactivating) HafenschauProvider.saveSettings()
}
