import QtQuick
import QtQuick.Controls.Basic

Rectangle {
    id: badge
    required property QtObject theme
    property string text: "Ready"
    property color tone: theme.success

    implicitWidth: label.implicitWidth + 24
    implicitHeight: 28
    radius: 9
    color: Qt.rgba(tone.r, tone.g, tone.b, 0.12)
    border.color: Qt.rgba(tone.r, tone.g, tone.b, 0.38)

    Label {
        id: label
        anchors.centerIn: parent
        text: badge.text
        color: badge.tone
        font.pixelSize: 11
        font.weight: Font.DemiBold
    }
}
