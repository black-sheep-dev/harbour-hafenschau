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

            width: page.width
            spacing: Theme.paddingMedium

            PageHeader {
                title: qsTr("Developer Settings")
            }

            TextSwitch {
                id: saveNewsDataSwitch
                x: Theme.horizontalPageMargin
                width: page.width - 2*x
                text: qsTr("Save news api data")
                description: qsTr("When activated an option to save the raw api data is available in pulldown menu on every reader page.")
                             + "\n"
                             + qsTr("The data is stored in Documents folder on the device.")
                             + "\n"
                             + qsTr("When there is a problem with displaying a special news, provide this data on GitHub as an issue to help fixing it. An additional screenshot helps too!")

                onCheckedChanged: {
                    if (checked)
                        settings.developerOptions |= DeveloperOption.SaveNews
                    else
                        settings.developerOptions &= ~DeveloperOption.SaveNews
                }


                Component.onCompleted: checked = (settings.developerOptions & DeveloperOption.SaveNews) === DeveloperOption.SaveNews
            }

            TextSwitch {
                id: showUnkownContentSwitch
                x: Theme.horizontalPageMargin
                width: page.width - 2*x
                text: qsTr("Show unkown content")
                description: qsTr("If enabled unkown content items are displayed in the reader page.")

                onCheckedChanged: {
                    if (checked)
                        settings.developerOptions |= DeveloperOption.ShowUnkownContent
                    else
                        settings.developerOptions &= ~DeveloperOption.ShowUnkownContent
                }


                Component.onCompleted: checked = (settings.developerOptions & DeveloperOption.ShowUnkownContent) === DeveloperOption.ShowUnkownContent
            }
        }
    }
}
