import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import QtCore
import "components"

ApplicationWindow {
    id: window
    width: 1180
    height: 760
    minimumWidth: 940
    minimumHeight: 640
    visible: true
    title: "Obsidian UI Starter"
    color: theme.background

    Theme { id: theme }

    property int currentPage: 0
    property string toastMessage: ""

    Settings {
        id: demoSettings
        category: "DemoControls"
        property bool notificationsEnabled: true
        property bool automaticSync: false
        property real density: 0.62
    }

    palette.window: theme.background
    palette.windowText: theme.text
    palette.highlight: theme.accent
    palette.highlightedText: theme.accentText
    palette.placeholderText: theme.muted
    palette.text: theme.text
    palette.base: theme.surface
    palette.button: theme.surface
    palette.buttonText: theme.text
    palette.light: theme.hover
    palette.midlight: theme.hover
    palette.mid: theme.border
    palette.dark: theme.background
    palette.shadow: theme.background
    palette.link: theme.accent

    function notify(message) {
        toastMessage = message
        toast.open()
        toastTimer.restart()
    }

    component PageHeading: ColumnLayout {
        property string title: "Page title"
        property string subtitle: "A short explanation goes here."
        spacing: 4
        Label { text: parent.title; color: theme.text; font.pixelSize: 31; font.bold: true }
        Label { text: parent.subtitle; color: theme.muted; font.pixelSize: 12 }
    }

    component MetricCard: UiCard {
        id: metricCard
        required property QtObject palette
        property string eyebrow: "METRIC"
        property string value: "0"
        property string detail: "No change"
        property color detailColor: palette.muted
        theme: palette
        Layout.fillWidth: true
        Layout.preferredHeight: 126
        ColumnLayout {
            anchors.fill: parent
            spacing: 7
            Label { text: metricCard.eyebrow; color: metricCard.palette.muted; font.pixelSize: 10; font.bold: true; font.letterSpacing: 0.7 }
            Label { text: metricCard.value; color: metricCard.palette.text; font.pixelSize: 28; font.bold: true }
            Label { text: metricCard.detail; color: metricCard.detailColor; font.pixelSize: 11 }
            Item { Layout.fillHeight: true }
            Rectangle {
                Layout.fillWidth: true
                height: 3
                radius: 2
                color: Qt.rgba(metricCard.detailColor.r, metricCard.detailColor.g, metricCard.detailColor.b, 0.22)
                Rectangle { width: parent.width * 0.68; height: parent.height; radius: parent.radius; color: metricCard.detailColor }
            }
        }
    }

    ThemeStudio {
        id: themeStudio
        theme: theme
    }

    Component.onCompleted: {
        if (Qt.application.arguments.indexOf("--custom-theme") >= 0)
            theme.mode = "custom"
        if (Qt.application.arguments.indexOf("--theme-studio") >= 0)
            themeStudio.open()
    }

    Popup {
        id: toast
        x: window.width - width - 28
        y: window.height - height - 28
        width: Math.min(360, toastLabel.implicitWidth + 44)
        height: 48
        padding: 0
        closePolicy: Popup.NoAutoClose
        background: Rectangle { radius: 12; color: theme.surface; border.color: theme.border }
        contentItem: RowLayout {
            anchors.fill: parent
            anchors.margins: 12
            Rectangle { width: 9; height: 9; radius: 5; color: theme.success }
            Label { id: toastLabel; Layout.fillWidth: true; text: window.toastMessage; color: theme.text; font.pixelSize: 11 }
        }
    }
    Timer { id: toastTimer; interval: 2400; onTriggered: toast.close() }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            Layout.preferredWidth: 238
            Layout.fillHeight: true
            color: theme.sidebar
            border.color: theme.border

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 18
                spacing: 9

                RowLayout {
                    Layout.fillWidth: true
                    Layout.bottomMargin: 20
                    Rectangle {
                        width: 38; height: 38; radius: 11
                        color: theme.selected
                        border.color: theme.border
                        Label { anchors.centerIn: parent; text: "O"; color: theme.accent; font.bold: true; font.pixelSize: 17 }
                    }
                    ColumnLayout {
                        spacing: 0
                        Label { text: "PROJECT NAME"; color: theme.text; font.pixelSize: 14; font.bold: true }
                        Label { text: "UI starter"; color: theme.muted; font.pixelSize: 10 }
                    }
                    Item { Layout.fillWidth: true }
                }

                UiNavButton { theme: theme; text: "Dashboard"; iconText: "●"; selected: window.currentPage === 0; onClicked: window.currentPage = 0 }
                UiNavButton { theme: theme; text: "Components"; iconText: "◇"; selected: window.currentPage === 1; onClicked: window.currentPage = 1 }
                UiNavButton { theme: theme; text: "Settings"; iconText: "⚙"; selected: window.currentPage === 2; onClicked: window.currentPage = 2 }

                Item { Layout.fillHeight: true }

                UiCard {
                    theme: theme
                    Layout.fillWidth: true
                    Layout.preferredHeight: 92
                    padding: 13
                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 5
                        RowLayout {
                            Rectangle { width: 8; height: 8; radius: 4; color: theme.success }
                            Label { text: "Starter ready"; color: theme.text; font.bold: true; font.pixelSize: 11 }
                        }
                        Label { text: "Replace mock data with your own models and services."; color: theme.muted; font.pixelSize: 9; wrapMode: Text.WordWrap; Layout.fillWidth: true }
                    }
                }

                UiButton { theme: theme; text: "Theme Studio"; Layout.fillWidth: true; onClicked: themeStudio.open() }
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 72
                color: theme.background
                border.color: theme.border
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 28
                    anchors.rightMargin: 28
                    Label { text: ["Overview", "Component library", "Application settings"][window.currentPage]; color: theme.muted; font.pixelSize: 11 }
                    Item { Layout.fillWidth: true }
                    StatusBadge { theme: theme; text: "Demo data"; tone: theme.info }
                    UiButton { theme: theme; text: "Theme Studio"; compact: true; onClicked: themeStudio.open() }
                    Rectangle {
                        width: 36; height: 36; radius: 18; color: theme.selected; border.color: theme.border
                        Label { anchors.centerIn: parent; text: "YN"; color: theme.accent; font.bold: true; font.pixelSize: 10 }
                    }
                }
            }

            StackLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                currentIndex: window.currentPage

                ScrollView {
                    id: dashboardScroll
                    clip: true
                    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                    ColumnLayout {
                        width: dashboardScroll.availableWidth
                        spacing: 18
                        anchors.margins: 28

                        Item { Layout.preferredHeight: 10 }
                        PageHeading { title: "Dashboard"; subtitle: "A clean shell with useful example states and zero product logic." }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 14
                            MetricCard { palette: theme; eyebrow: "ACTIVE USERS"; value: "1,284"; detail: "+12.4% this month"; detailColor: theme.success }
                            MetricCard { palette: theme; eyebrow: "OPEN TASKS"; value: "18"; detail: "6 due today"; detailColor: theme.warning }
                            MetricCard { palette: theme; eyebrow: "SYSTEM HEALTH"; value: "99.9%"; detail: "All services operational"; detailColor: theme.info }
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 14

                            UiCard {
                                theme: theme
                                Layout.fillWidth: true
                                Layout.preferredHeight: 248
                                ColumnLayout {
                                    anchors.fill: parent
                                    spacing: 12
                                    RowLayout {
                                        Layout.fillWidth: true
                                        ColumnLayout {
                                            spacing: 2
                                            Label { text: "Quick actions"; color: theme.text; font.pixelSize: 18; font.bold: true }
                                            Label { text: "Buttons are wired to harmless example notifications."; color: theme.muted; font.pixelSize: 10 }
                                        }
                                        Item { Layout.fillWidth: true }
                                        StatusBadge { theme: theme; text: "Ready"; tone: theme.success }
                                    }
                                    Rectangle { Layout.fillWidth: true; height: 1; color: theme.border }
                                    RowLayout {
                                        Layout.fillWidth: true
                                        UiButton { theme: theme; text: "Create item"; primary: true; onClicked: window.notify("Created an example item") }
                                        UiButton { theme: theme; text: "Save changes"; onClicked: window.notify("Example settings saved") }
                                        UiButton { theme: theme; text: "Delete"; danger: true; onClicked: window.notify("Nothing was deleted—this is a demo") }
                                        Item { Layout.fillWidth: true }
                                    }
                                    Item { Layout.fillHeight: true }
                                    RowLayout {
                                        Layout.fillWidth: true
                                        ColumnLayout {
                                            Layout.fillWidth: true
                                            Label { text: "Automatic sync"; color: theme.text; font.bold: true; font.pixelSize: 12 }
                                            Label { text: "A persistent example switch."; color: theme.muted; font.pixelSize: 10 }
                                        }
                                        UiSwitch { theme: theme; checked: demoSettings.automaticSync; onToggled: demoSettings.automaticSync = checked }
                                    }
                                    RowLayout {
                                        Layout.fillWidth: true
                                        Label { text: "Interface density"; color: theme.text; font.pixelSize: 11 }
                                        UiSlider { theme: theme; Layout.fillWidth: true; from: 0; to: 1; value: demoSettings.density; onMoved: demoSettings.density = value }
                                        Label { text: Math.round(demoSettings.density * 100) + "%"; color: theme.muted; font.pixelSize: 10; Layout.preferredWidth: 36 }
                                    }
                                }
                            }

                            UiCard {
                                theme: theme
                                Layout.preferredWidth: 335
                                Layout.preferredHeight: 248
                                ColumnLayout {
                                    anchors.fill: parent
                                    spacing: 10
                                    Label { text: "Recent activity"; color: theme.text; font.pixelSize: 18; font.bold: true }
                                    Repeater {
                                        model: [
                                            { time: "12:41", title: "Theme updated", note: "Custom palette saved", tone: theme.success },
                                            { time: "12:32", title: "Project created", note: "Starter initialized", tone: theme.info },
                                            { time: "12:18", title: "Review needed", note: "Example warning state", tone: theme.warning }
                                        ]
                                        Rectangle {
                                            required property var modelData
                                            Layout.fillWidth: true
                                            Layout.preferredHeight: 48
                                            radius: 9
                                            color: theme.background
                                            RowLayout {
                                                anchors.fill: parent
                                                anchors.margins: 9
                                                Rectangle { width: 8; height: 8; radius: 4; color: modelData.tone }
                                                ColumnLayout {
                                                    Layout.fillWidth: true
                                                    spacing: 1
                                                    Label { text: modelData.title; color: theme.text; font.pixelSize: 10; font.bold: true }
                                                    Label { text: modelData.note; color: theme.muted; font.pixelSize: 9 }
                                                }
                                                Label { text: modelData.time; color: theme.muted; font.pixelSize: 9 }
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        Item { Layout.preferredHeight: 12 }
                    }
                }

                ScrollView {
                    id: componentsScroll
                    clip: true
                    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                    ColumnLayout {
                        width: componentsScroll.availableWidth
                        spacing: 18
                        anchors.margins: 28
                        Item { Layout.preferredHeight: 10 }
                        PageHeading { title: "Components"; subtitle: "Copy these controls into any page and bind them to your own data." }

                        UiCard {
                            theme: theme
                            Layout.fillWidth: true
                            Layout.preferredHeight: 164
                            ColumnLayout {
                                anchors.fill: parent
                                spacing: 12
                                Label { text: "Buttons"; color: theme.text; font.pixelSize: 18; font.bold: true }
                                RowLayout {
                                    UiButton { theme: theme; text: "Primary action"; primary: true; onClicked: window.notify("Primary action") }
                                    UiButton { theme: theme; text: "Secondary"; onClicked: window.notify("Secondary action") }
                                    UiButton { theme: theme; text: "Destructive"; danger: true; onClicked: window.notify("Destructive example") }
                                    UiButton { theme: theme; text: "Disabled"; enabled: false }
                                    Item { Layout.fillWidth: true }
                                }
                            }
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 14
                            UiCard {
                                theme: theme
                                Layout.fillWidth: true
                                Layout.preferredHeight: 232
                                ColumnLayout {
                                    anchors.fill: parent
                                    spacing: 13
                                    Label { text: "Inputs and controls"; color: theme.text; font.pixelSize: 18; font.bold: true }
                                    TextField {
                                        Layout.fillWidth: true
                                        placeholderText: "Example text field"
                                        color: theme.text
                                        selectByMouse: true
                                        background: Rectangle { radius: 8; color: theme.background; border.color: parent.activeFocus ? theme.accent : theme.border }
                                    }
                                    RowLayout {
                                        Layout.fillWidth: true
                                        Label { text: "Notifications"; color: theme.text; Layout.fillWidth: true }
                                        UiSwitch { theme: theme; checked: demoSettings.notificationsEnabled; onToggled: demoSettings.notificationsEnabled = checked }
                                    }
                                    RowLayout {
                                        Layout.fillWidth: true
                                        Label { text: "Value"; color: theme.text }
                                        UiSlider { theme: theme; Layout.fillWidth: true; value: 0.72 }
                                    }
                                    ProgressBar {
                                        Layout.fillWidth: true
                                        value: 0.68
                                        background: Rectangle { implicitHeight: 7; radius: 4; color: theme.border }
                                        contentItem: Item { Rectangle { width: parent.width * parent.parent.visualPosition; height: 7; radius: 4; color: theme.accent } }
                                    }
                                }
                            }

                            UiCard {
                                theme: theme
                                Layout.fillWidth: true
                                Layout.preferredHeight: 232
                                ColumnLayout {
                                    anchors.fill: parent
                                    spacing: 13
                                    Label { text: "Status language"; color: theme.text; font.pixelSize: 18; font.bold: true }
                                    Flow {
                                        Layout.fillWidth: true
                                        spacing: 8
                                        StatusBadge { theme: theme; text: "Healthy"; tone: theme.success }
                                        StatusBadge { theme: theme; text: "Attention"; tone: theme.warning }
                                        StatusBadge { theme: theme; text: "Unavailable"; tone: theme.danger }
                                        StatusBadge { theme: theme; text: "Information"; tone: theme.info }
                                    }
                                    Rectangle { Layout.fillWidth: true; height: 1; color: theme.border }
                                    Label { text: "Use status color sparingly. Keep most surfaces neutral so important states remain obvious."; color: theme.muted; font.pixelSize: 11; wrapMode: Text.WordWrap; Layout.fillWidth: true }
                                }
                            }
                        }
                        Item { Layout.preferredHeight: 12 }
                    }
                }

                ScrollView {
                    id: settingsScroll
                    clip: true
                    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                    ColumnLayout {
                        width: settingsScroll.availableWidth
                        spacing: 18
                        anchors.margins: 28
                        Item { Layout.preferredHeight: 10 }
                        PageHeading { title: "Settings"; subtitle: "A neutral example page for application-level preferences." }

                        UiCard {
                            theme: theme
                            Layout.fillWidth: true
                            Layout.preferredHeight: 188
                            ColumnLayout {
                                anchors.fill: parent
                                spacing: 12
                                RowLayout {
                                    Layout.fillWidth: true
                                    ColumnLayout {
                                        spacing: 3
                                        Label { text: "Appearance"; color: theme.text; font.pixelSize: 18; font.bold: true }
                                        Label { text: "Current preset: " + (theme.mode === "dark" ? "Obsidian" : (theme.mode === "light" ? "Daylight" : "Studio")); color: theme.muted; font.pixelSize: 10 }
                                    }
                                    Item { Layout.fillWidth: true }
                                    UiButton { theme: theme; text: "Open Theme Studio"; primary: true; onClicked: themeStudio.open() }
                                }
                                Rectangle { Layout.fillWidth: true; height: 1; color: theme.border }
                                Label { text: "Theme choices and custom palette values persist automatically through Qt Settings. Rename the organization and application identifiers in src/main.cpp before using this starter for a real product."; color: theme.muted; font.pixelSize: 11; wrapMode: Text.WordWrap; Layout.fillWidth: true }
                            }
                        }

                        UiCard {
                            theme: theme
                            Layout.fillWidth: true
                            Layout.preferredHeight: 176
                            ColumnLayout {
                                anchors.fill: parent
                                spacing: 13
                                Label { text: "Application preferences"; color: theme.text; font.pixelSize: 18; font.bold: true }
                                RowLayout {
                                    Layout.fillWidth: true
                                    ColumnLayout { Layout.fillWidth: true; Label { text: "Enable notifications"; color: theme.text; font.bold: true; font.pixelSize: 11 } Label { text: "Persistent example preference"; color: theme.muted; font.pixelSize: 9 } }
                                    UiSwitch { theme: theme; checked: demoSettings.notificationsEnabled; onToggled: demoSettings.notificationsEnabled = checked }
                                }
                                RowLayout {
                                    Layout.fillWidth: true
                                    ColumnLayout { Layout.fillWidth: true; Label { text: "Automatic sync"; color: theme.text; font.bold: true; font.pixelSize: 11 } Label { text: "Connect this to your own service later"; color: theme.muted; font.pixelSize: 9 } }
                                    UiSwitch { theme: theme; checked: demoSettings.automaticSync; onToggled: demoSettings.automaticSync = checked }
                                }
                            }
                        }
                        Item { Layout.preferredHeight: 12 }
                    }
                }
            }
        }
    }
}
