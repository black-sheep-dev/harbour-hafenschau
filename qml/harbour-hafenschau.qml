import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.DBus 2.0

import "pages"

import org.nubecula.harbour.hafenschau 1.0

ApplicationWindow
{
    initialPage: Component { StartPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations

    Component.onCompleted: HafenschauProvider.initialize()

    DBusAdaptor {
            service: "harbour.hafenschau.service"
            iface: "harbour.hafenschau.service"
            path: "/harbour/hafenschau/service"
            xml: '\
      <interface name="harbour.hafenschau.service">
        <method name="open">
            <arg name="news" type="s" direction="in"
            </arg>
        </method>
      </interface>'

            function open(news) {
                __silica_applicationwindow_instance.activate()
                pageStack.push(Qt.resolvedUrl("pages/ReaderPage.qml"), {
                                    news: HafenschauProvider.newsById(news)
                               })
            }
        }
}
