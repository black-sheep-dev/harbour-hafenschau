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
            spacing: Theme.paddingMedium

            PageHeader {
                title: qsTr("Developer Settings")
            }

            TextSwitch {
                id: saveNewsDataSwitch
                x: Theme.horizontalPageMargin
                width: page.width - 2*x
                text: qsTr("Developer mode")
                description: qsTr("When active some developer options are available inside the app")

                onCheckedChanged: config.developerMode = checked


                Component.onCompleted: checked = config.developerMode
            }
        }
    }
}
