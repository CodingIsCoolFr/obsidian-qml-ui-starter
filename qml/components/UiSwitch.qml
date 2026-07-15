import QtQuick
import QtQuick.Controls.Basic

Switch {
    id: control
    required property QtObject theme
    implicitWidth: 44
    implicitHeight: 24
    hoverEnabled: true
    background: Item {}
    contentItem: Item {}

    indicator: Rectangle {
        anchors.centerIn: parent
        width: 42
        height: 22
        radius: 11
        color: control.checked
               ? (control.theme.mode === "dark" ? "#5b5e64" : control.theme.accent)
               : (control.theme.mode === "light" ? "#d3d8e2" : "#24262a")
        border.width: control.activeFocus || control.hovered ? 2 : 1
        border.color: control.checked
                      ? (control.theme.mode === "dark" ? "#8b8e95" : control.theme.accent)
                      : (control.hovered ? control.theme.muted : control.theme.border)
        Behavior on color { ColorAnimation { duration: 120 } }

        Rectangle {
            width: 16
            height: 16
            radius: 8
            y: 3
            x: control.checked ? parent.width - width - 3 : 3
            color: control.checked ? "#f4f4f5" : (control.theme.mode === "light" ? "#ffffff" : "#777a81")
            border.width: 1
            border.color: control.checked ? "#ffffff" : control.theme.border
            Behavior on x { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }
            Behavior on color { ColorAnimation { duration: 120 } }
        }
    }
}
