import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Window 2.2
import QtQuick.Layouts 1.2
import QtQuick.Extras 1.4

ApplicationWindow {
    id: applicationWindow1
    visible: true
    width: 800
    height: 480
    opacity: 1
    minimumHeight: 0
    maximumWidth: 800
    title: qsTr("Nukkekoti")

    property variant win;

    Talo {
        id: talo1
        x: 0
        y: -200
        width: 0
        height: 0
        z: 2
    }

    Image {
        id: image1
        x: 0
        y: 0
        width: 800
        height: 480
        z: 1
        source: "taustakuva.png"

        Button {
            id: button1
            x: 686
            y: 0
            width: 114
            height: 51
            text: qsTr("Sulje")
            onClicked: Qt.quit()
        }
    }
}

