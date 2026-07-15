import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

Button {
    id: control
    required property QtObject theme
    property bool selected: false
    property string iconText: "•"

    Layout.fillWidth: true
    implicitHeight: 44
    leftPadding: 14
    rightPadding: 14
    hoverEnabled: true

    contentItem: RowLayout {
        spacing: 11
        Text { text: control.iconText; color: control.selected ? control.theme.accent : control.theme.muted; font.pixelSize: 14 }
        Text {
            Layout.fillWidth: true
            text: control.text
            color: control.selected ? control.theme.text : control.theme.muted
            font.pixelSize: 14
            font.weight: control.selected ? Font.DemiBold : Font.Normal
        }
    }

    background: Rectangle {
        radius: 9
        color: control.selected ? control.theme.selected : (control.hovered ? control.theme.navHover : "transparent")
        border.width: control.activeFocus ? 1 : 0
        border.color: control.theme.accent
        Behavior on color { ColorAnimation { duration: 120 } }
    }
}
