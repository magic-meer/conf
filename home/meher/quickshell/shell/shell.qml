import Quickshell
import Quickshell.Wayland
import QtQuick

ShellRoot {
    PanelWindow {
        anchors.top: true
        implicitHeight: 25
        color: "#1a1b26"

        Text {
            anchors.centerIn: parent
            text: "hellooo!!!"
            color: "#a9b1d6"
            font.pixelSize: 14
        }
    }
}
