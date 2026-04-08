import QtQuick.Controls

ComboBox {
    palette {
        text: textColor
        base: editable ? backgroundColor : lightColor
        highlight: lightColor
        button: lightColor
        mid: mediumColor
        dark: textColor
        buttonText: textColor
        highlightedText: textColor
        window: backgroundColor
        midlight: lightColor
        light: lighterColor
    }
}