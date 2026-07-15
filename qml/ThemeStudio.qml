import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import "components"

Dialog {
    id: dialog
    required property QtObject theme

    title: "Theme Studio"
    modal: true
    anchors.centerIn: parent
    width: Math.min(parent ? parent.width - 56 : 900, 900)
    height: Math.min(parent ? parent.height - 48 : 680, 680)
    padding: 18
    standardButtons: Dialog.NoButton
    closePolicy: Popup.CloseOnEscape

    property bool advanced: false
    property bool mixerVisible: false
    property string colorTarget: "accent"
    property color originalColor: "#d4d4d8"
    property real pickerHue: 0
    property real pickerSaturation: 0
    property real pickerLightness: 0.83
    readonly property color pickerColor: Qt.hsla(pickerHue, pickerSaturation, pickerLightness, 1)
    readonly property real contrastScore: theme.contrastRatio(theme.text, theme.surface)

    function openMixer(key) {
        colorTarget = key
        originalColor = theme.colorFor(key)
        pickerHue = originalColor.hslHue < 0 ? 0 : originalColor.hslHue
        pickerSaturation = originalColor.hslSaturation
        pickerLightness = originalColor.hslLightness
        mixerVisible = true
    }

    function applyMixer() {
        theme.setColor(colorTarget, pickerColor.toString())
    }

    function colorTitle(key) {
        switch (key) {
        case "accent": return "Accent"
        case "background": return "Background"
        case "sidebar": return "Sidebar"
        case "surface": return "Surface"
        case "border": return "Border"
        case "text": return "Primary text"
        case "muted": return "Muted text"
        }
        return "Color"
    }

    background: Rectangle {
        radius: 18
        color: dialog.theme.surface
        border.color: dialog.theme.border
    }

    contentItem: ColumnLayout {
        spacing: 14

        RowLayout {
            Layout.fillWidth: true
            ColumnLayout {
                spacing: 2
                Label { text: "Appearance"; color: dialog.theme.text; font.pixelSize: 25; font.bold: true }
                Label { text: "Pick a preset or build a reusable custom palette."; color: dialog.theme.muted; font.pixelSize: 11 }
            }
            Item { Layout.fillWidth: true }
            Label {
                text: (dialog.contrastScore >= 4.5 ? "✓ " : "⚠ ") + dialog.contrastScore.toFixed(1) + ":1 contrast"
                color: dialog.contrastScore >= 4.5 ? dialog.theme.success : dialog.theme.warning
                font.pixelSize: 11
                font.bold: true
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 10
            Repeater {
                model: [
                    { key: "dark", title: "Obsidian", caption: "Neutral true dark", bg: "#08090a", mark: "#d4d4d8" },
                    { key: "light", title: "Daylight", caption: "Clean light", bg: "#f4f7fc", mark: "#6d4df4" },
                    { key: "custom", title: "Studio", caption: "Your saved palette", bg: dialog.theme.customBackground, mark: dialog.theme.customAccent }
                ]
                Button {
                    id: preset
                    required property var modelData
                    Layout.fillWidth: true
                    implicitHeight: 72
                    hoverEnabled: true
                    onClicked: dialog.theme.setPreset(modelData.key)
                    contentItem: RowLayout {
                        spacing: 10
                        Rectangle {
                            width: 42; height: 42; radius: 11
                            color: preset.modelData.bg
                            border.color: dialog.theme.mode === preset.modelData.key ? preset.modelData.mark : dialog.theme.border
                            Rectangle { width: 17; height: 5; radius: 3; color: preset.modelData.mark; x: 7; y: 8 }
                            Rectangle { width: 25; height: 14; radius: 4; color: preset.modelData.mark; opacity: 0.28; anchors.right: parent.right; anchors.rightMargin: 6; anchors.bottom: parent.bottom; anchors.bottomMargin: 7 }
                        }
                        ColumnLayout {
                            spacing: 2
                            Label { text: preset.modelData.title; color: dialog.theme.text; font.bold: true }
                            Label { text: preset.modelData.caption; color: dialog.theme.muted; font.pixelSize: 10 }
                        }
                        Item { Layout.fillWidth: true }
                        Label { text: dialog.theme.mode === preset.modelData.key ? "✓" : ""; color: dialog.theme.accent; font.bold: true; font.pixelSize: 16 }
                    }
                    background: Rectangle {
                        radius: 12
                        color: dialog.theme.mode === preset.modelData.key ? dialog.theme.selected : (preset.hovered ? dialog.theme.hover : dialog.theme.background)
                        border.width: dialog.theme.mode === preset.modelData.key ? 2 : 1
                        border.color: dialog.theme.mode === preset.modelData.key ? dialog.theme.accent : dialog.theme.border
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 132
            radius: 14
            color: dialog.theme.background
            border.color: dialog.theme.border
            clip: true
            RowLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 12
                Rectangle {
                    Layout.preferredWidth: 120
                    Layout.fillHeight: true
                    radius: 10
                    color: dialog.theme.sidebar
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 7
                        Label { text: "PROJECT NAME"; color: dialog.theme.text; font.bold: true; font.pixelSize: 10 }
                        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 26; radius: 7; color: dialog.theme.selected; Label { anchors.centerIn: parent; text: "Dashboard"; color: dialog.theme.accent; font.pixelSize: 9 } }
                        Label { text: "Components"; color: dialog.theme.muted; font.pixelSize: 9 }
                        Label { text: "Settings"; color: dialog.theme.muted; font.pixelSize: 9 }
                        Item { Layout.fillHeight: true }
                        Rectangle { width: 7; height: 7; radius: 4; color: dialog.theme.success }
                    }
                }
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 8
                    RowLayout {
                        Layout.fillWidth: true
                        Label { text: "Live theme preview"; color: dialog.theme.text; font.bold: true }
                        Item { Layout.fillWidth: true }
                        Rectangle { width: 64; height: 25; radius: 7; color: dialog.theme.accent; Label { anchors.centerIn: parent; text: "Action"; color: dialog.theme.accentText; font.bold: true; font.pixelSize: 9 } }
                    }
                    RowLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        spacing: 8
                        Repeater {
                            model: [
                                { label: "ACTIVE USERS", value: "1,284", note: "+12.4%" },
                                { label: "SYSTEM STATUS", value: "Healthy", note: "All services ready" }
                            ]
                            Rectangle {
                                required property var modelData
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                radius: 9
                                color: dialog.theme.surface
                                border.color: dialog.theme.border
                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 9
                                    Label { text: modelData.label; color: dialog.theme.muted; font.pixelSize: 8; font.bold: true }
                                    Label { text: modelData.value; color: dialog.theme.text; font.bold: true; font.pixelSize: 13 }
                                    Label { text: modelData.note; color: modelData.label === "SYSTEM STATUS" ? dialog.theme.success : dialog.theme.accent; font.pixelSize: 8 }
                                }
                            }
                        }
                    }
                }
            }
        }

        UiCard {
            visible: dialog.theme.mode === "custom"
            theme: dialog.theme
            padding: 10
            Layout.fillWidth: true
            Layout.preferredHeight: 94
            ColumnLayout {
                anchors.fill: parent
                spacing: 8
                RowLayout {
                    Layout.fillWidth: true
                    Label { text: "1  Pick an accent"; color: dialog.theme.text; font.bold: true; Layout.preferredWidth: 116 }
                    Repeater {
                        model: ["#3b82f6", "#22c55e", "#06b6d4", "#f97316", "#ec4899", "#a855f7", "#facc15"]
                        Button {
                            required property string modelData
                            implicitWidth: 28; implicitHeight: 28
                            onClicked: dialog.theme.setColor("accent", modelData)
                            contentItem: Item {}
                            background: Rectangle {
                                radius: 9
                                color: modelData
                                border.width: dialog.theme.customAccent.toString().toLowerCase() === modelData ? 3 : 1
                                border.color: dialog.theme.customAccent.toString().toLowerCase() === modelData ? dialog.theme.text : dialog.theme.border
                            }
                        }
                    }
                    UiButton { theme: dialog.theme; text: "Mix custom"; compact: true; onClicked: dialog.openMixer("accent") }
                    Item { Layout.fillWidth: true }
                }
                RowLayout {
                    Layout.fillWidth: true
                    Label { text: "2  Pick a canvas"; color: dialog.theme.text; font.bold: true; Layout.preferredWidth: 116 }
                    Repeater {
                        model: [{ key: "obsidian", title: "Obsidian" }, { key: "graphite", title: "Graphite" }, { key: "tint", title: "Accent tint" }]
                        UiButton {
                            required property var modelData
                            theme: dialog.theme
                            text: modelData.title
                            compact: true
                            primary: dialog.theme.customCanvas === modelData.key
                            onClicked: dialog.theme.applyCanvas(modelData.key)
                        }
                    }
                    Item { Layout.fillWidth: true }
                    UiButton { theme: dialog.theme; text: dialog.advanced ? "Hide advanced" : "Advanced colors"; compact: true; onClicked: dialog.advanced = !dialog.advanced }
                }
            }
        }

        UiCard {
            visible: dialog.theme.mode === "custom" && dialog.mixerVisible
            theme: dialog.theme
            Layout.fillWidth: true
            Layout.preferredHeight: 138
            RowLayout {
                anchors.fill: parent
                spacing: 14
                Rectangle {
                    Layout.preferredWidth: 82
                    Layout.fillHeight: true
                    radius: 10
                    color: dialog.pickerColor
                    border.color: dialog.theme.text
                    Label { anchors.horizontalCenter: parent.horizontalCenter; anchors.bottom: parent.bottom; anchors.bottomMargin: 9; text: dialog.pickerColor.toString(); color: dialog.pickerLightness > 0.55 ? "#07101d" : "#ffffff"; font.pixelSize: 9; font.bold: true }
                }
                GridLayout {
                    Layout.fillWidth: true
                    columns: 2
                    columnSpacing: 10
                    rowSpacing: 5
                    Label { text: "Editing " + dialog.colorTitle(dialog.colorTarget); color: dialog.theme.text; font.bold: true; Layout.columnSpan: 2 }
                    Label { text: "Hue"; color: dialog.theme.muted; font.pixelSize: 10; Layout.preferredWidth: 70 }
                    UiSlider { theme: dialog.theme; Layout.fillWidth: true; value: dialog.pickerHue; onMoved: { dialog.pickerHue = value; dialog.applyMixer() } }
                    Label { text: "Saturation"; color: dialog.theme.muted; font.pixelSize: 10 }
                    UiSlider { theme: dialog.theme; Layout.fillWidth: true; value: dialog.pickerSaturation; onMoved: { dialog.pickerSaturation = value; dialog.applyMixer() } }
                    Label { text: "Brightness"; color: dialog.theme.muted; font.pixelSize: 10 }
                    UiSlider { theme: dialog.theme; Layout.fillWidth: true; value: dialog.pickerLightness; onMoved: { dialog.pickerLightness = value; dialog.applyMixer() } }
                }
                ColumnLayout {
                    UiButton { theme: dialog.theme; text: "Keep"; compact: true; onClicked: dialog.mixerVisible = false }
                    UiButton { theme: dialog.theme; text: "Undo"; compact: true; onClicked: { dialog.theme.setColor(dialog.colorTarget, dialog.originalColor); dialog.mixerVisible = false } }
                }
            }
        }

        ScrollView {
            id: paletteScroll
            visible: dialog.theme.mode === "custom" && dialog.advanced
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
            GridLayout {
                width: paletteScroll.availableWidth
                columns: 2
                columnSpacing: 10
                rowSpacing: 10
                Repeater {
                    model: [
                        { key: "accent", label: "Accent", hint: "Actions and highlights" },
                        { key: "background", label: "Background", hint: "Main canvas" },
                        { key: "sidebar", label: "Sidebar", hint: "Navigation rail" },
                        { key: "surface", label: "Surface", hint: "Cards and dialogs" },
                        { key: "border", label: "Border", hint: "Structure and dividers" },
                        { key: "text", label: "Primary text", hint: "Headings and values" },
                        { key: "muted", label: "Muted text", hint: "Descriptions and labels" }
                    ]
                    UiCard {
                        required property var modelData
                        theme: dialog.theme
                        padding: 10
                        Layout.fillWidth: true
                        Layout.preferredHeight: 76
                        RowLayout {
                            anchors.fill: parent
                            spacing: 10
                            Button {
                                implicitWidth: 44; implicitHeight: 44
                                onClicked: dialog.openMixer(modelData.key)
                                contentItem: Item {}
                                background: Rectangle { radius: 11; color: dialog.theme.colorFor(modelData.key); border.color: dialog.theme.text }
                            }
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2
                                Label { text: modelData.label; color: dialog.theme.text; font.bold: true; font.pixelSize: 11 }
                                Label { text: modelData.hint; color: dialog.theme.muted; font.pixelSize: 9 }
                                TextField {
                                    Layout.fillWidth: true
                                    implicitHeight: 25
                                    text: dialog.theme.colorFor(modelData.key).toString()
                                    color: dialog.theme.text
                                    selectByMouse: true
                                    font.pixelSize: 10
                                    validator: RegularExpressionValidator { regularExpression: /^#[0-9a-fA-F]{6}$/ }
                                    onEditingFinished: if (acceptableInput) dialog.theme.setColor(modelData.key, text)
                                    background: Rectangle { radius: 6; color: dialog.theme.surface; border.color: parent.activeFocus ? dialog.theme.accent : dialog.theme.border }
                                }
                            }
                        }
                    }
                }
            }
        }

        Item { visible: !paletteScroll.visible; Layout.fillHeight: true }

        RowLayout {
            Layout.fillWidth: true
            UiButton { visible: dialog.theme.mode === "custom"; theme: dialog.theme; text: "Reset studio"; onClicked: { dialog.theme.resetStudio(); dialog.advanced = false; dialog.mixerVisible = false } }
            Label { visible: dialog.theme.mode === "custom" && dialog.contrastScore < 4.5; text: "Increase text/surface contrast for easier reading."; color: dialog.theme.warning; font.pixelSize: 10 }
            Item { Layout.fillWidth: true }
            UiButton { theme: dialog.theme; text: "Done"; onClicked: dialog.close() }
        }
    }
}
