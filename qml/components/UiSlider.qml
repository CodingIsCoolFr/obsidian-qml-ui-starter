import QtQuick
import QtQuick.Controls.Basic

Slider {
    id: control
    required property QtObject theme
    implicitHeight: 26

    background: Rectangle {
        x: control.leftPadding
        y: control.topPadding + control.availableHeight / 2 - height / 2
        width: control.availableWidth
        height: 5
        radius: 3
        color: control.theme.border
        Rectangle {
            width: control.visualPosition * parent.width
            height: parent.height
            radius: parent.radius
            color: control.theme.accent
        }
    }

    handle: Rectangle {
        x: control.leftPadding + control.visualPosition * (control.availableWidth - width)
        y: control.topPadding + control.availableHeight / 2 - height / 2
        width: 17
        height: 17
        radius: 9
        color: control.theme.accent
        border.width: 2
        border.color: control.theme.mode === "dark" ? "#71717a" : control.theme.surface
    }
}
