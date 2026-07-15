import QtQuick
import QtQuick.Controls.Basic

Button {
    id: control
    required property QtObject theme
    property bool primary: false
    property bool danger: false
    property bool compact: false

    implicitHeight: compact ? 32 : 40
    implicitWidth: Math.max(94, contentItem.implicitWidth + 30)
    leftPadding: 15
    rightPadding: 15
    hoverEnabled: true

    contentItem: Text {
        text: control.text
        color: control.primary ? control.theme.accentText : (control.danger ? control.theme.danger : control.theme.text)
        font.weight: Font.DemiBold
        font.pixelSize: control.compact ? 11 : 12
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    background: Rectangle {
        radius: 9
        color: control.primary
               ? (control.down ? Qt.darker(control.theme.accent, 1.22) : (control.hovered ? Qt.lighter(control.theme.accent, 1.08) : control.theme.accent))
               : (control.down ? control.theme.selected : (control.hovered ? control.theme.hover : control.theme.surface))
        border.width: control.activeFocus ? 2 : 1
        border.color: control.danger ? control.theme.danger : (control.activeFocus ? control.theme.accent : control.theme.border)
        opacity: control.enabled ? 1 : 0.45
        Behavior on color { ColorAnimation { duration: 120 } }
    }
}
