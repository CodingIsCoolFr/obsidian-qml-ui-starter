import QtQuick
import QtCore

QtObject {
    id: root

    property Settings store: Settings {
        id: settings
        category: "Appearance"
        property string mode: "dark"
        property string customCanvas: "obsidian"
        property color customAccent: "#d4d4d8"
        property color customBackground: "#08090a"
        property color customSidebar: "#0c0d0f"
        property color customSurface: "#121316"
        property color customBorder: "#2b2d31"
        property color customText: "#f4f4f5"
        property color customMuted: "#a1a1aa"
    }

    property alias mode: settings.mode
    property alias customCanvas: settings.customCanvas
    property alias customAccent: settings.customAccent
    property alias customBackground: settings.customBackground
    property alias customSidebar: settings.customSidebar
    property alias customSurface: settings.customSurface
    property alias customBorder: settings.customBorder
    property alias customText: settings.customText
    property alias customMuted: settings.customMuted

    readonly property color accent: mode === "dark" ? "#d4d4d8" : (mode === "light" ? "#6d4df4" : customAccent)
    readonly property color background: mode === "dark" ? "#08090a" : (mode === "light" ? "#f4f7fc" : customBackground)
    readonly property color sidebar: mode === "dark" ? "#0c0d0f" : (mode === "light" ? "#e8edf7" : customSidebar)
    readonly property color surface: mode === "dark" ? "#121316" : (mode === "light" ? "#ffffff" : customSurface)
    readonly property color border: mode === "dark" ? "#2b2d31" : (mode === "light" ? "#cbd5e7" : customBorder)
    readonly property color text: mode === "dark" ? "#f4f4f5" : (mode === "light" ? "#17213a" : customText)
    readonly property color muted: mode === "dark" ? "#a1a1aa" : (mode === "light" ? "#60708f" : customMuted)
    readonly property color selected: mode === "dark" ? "#1c1d21" : (mode === "light" ? "#ddd5ff" : Qt.tint(surface, Qt.rgba(accent.r, accent.g, accent.b, 0.18)))
    readonly property color hover: mode === "light" ? "#e3e8f2" : Qt.tint(surface, Qt.rgba(accent.r, accent.g, accent.b, 0.10))
    readonly property color navHover: mode === "light" ? "#dce3f1" : Qt.tint(sidebar, Qt.rgba(accent.r, accent.g, accent.b, 0.12))
    readonly property color accentText: accent.hslLightness > 0.58 ? "#111113" : "#ffffff"
    readonly property color success: "#4ade80"
    readonly property color warning: "#fbbf24"
    readonly property color danger: "#fb7185"
    readonly property color info: "#60a5fa"

    function setPreset(name) {
        mode = name
    }

    function setColor(key, value) {
        mode = "custom"
        if (key !== "accent") customCanvas = "custom"
        switch (key) {
        case "accent": customAccent = value; break
        case "background": customBackground = value; break
        case "sidebar": customSidebar = value; break
        case "surface": customSurface = value; break
        case "border": customBorder = value; break
        case "text": customText = value; break
        case "muted": customMuted = value; break
        }
    }

    function colorFor(key) {
        switch (key) {
        case "accent": return customAccent
        case "background": return customBackground
        case "sidebar": return customSidebar
        case "surface": return customSurface
        case "border": return customBorder
        case "text": return customText
        case "muted": return customMuted
        }
        return "#000000"
    }

    function blend(left, right, amount) {
        return Qt.rgba(left.r * (1 - amount) + right.r * amount,
                       left.g * (1 - amount) + right.g * amount,
                       left.b * (1 - amount) + right.b * amount, 1)
    }

    function applyCanvas(style) {
        mode = "custom"
        customCanvas = style
        if (style === "obsidian") {
            customBackground = "#08090a"
            customSidebar = "#0c0d0f"
            customSurface = "#121316"
            customBorder = "#2b2d31"
            customText = "#f4f4f5"
            customMuted = "#a1a1aa"
        } else if (style === "graphite") {
            customBackground = "#111214"
            customSidebar = "#151619"
            customSurface = "#1b1d21"
            customBorder = "#363940"
            customText = "#f4f4f5"
            customMuted = "#a7a7b0"
        } else if (style === "tint") {
            var ink = Qt.rgba(0.018, 0.027, 0.05, 1)
            customBackground = blend(ink, customAccent, 0.06).toString()
            customSidebar = blend(ink, customAccent, 0.10).toString()
            customSurface = blend(ink, customAccent, 0.14).toString()
            customBorder = blend(ink, customAccent, 0.30).toString()
            customText = "#f8fafc"
            customMuted = "#94a3b8"
        }
    }

    function resetStudio() {
        customAccent = "#d4d4d8"
        customCanvas = "obsidian"
        applyCanvas("obsidian")
    }

    function linearChannel(value) {
        return value <= 0.03928 ? value / 12.92 : Math.pow((value + 0.055) / 1.055, 2.4)
    }

    function luminance(value) {
        return 0.2126 * linearChannel(value.r) + 0.7152 * linearChannel(value.g) + 0.0722 * linearChannel(value.b)
    }

    function contrastRatio(first, second) {
        var high = Math.max(luminance(first), luminance(second))
        var low = Math.min(luminance(first), luminance(second))
        return (high + 0.05) / (low + 0.05)
    }
}
