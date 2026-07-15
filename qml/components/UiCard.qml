import QtQuick

Rectangle {
    id: card
    required property QtObject theme
    property int padding: 18
    default property alias contentData: content.data

    radius: 15
    color: theme.surface
    border.color: theme.border

    Item {
        id: content
        anchors.fill: parent
        anchors.margins: card.padding
    }
}
