import QtQuick 2.0
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Layouts 1.2
import QtQuick.Extras 1.4
import QtMultimedia 5.5
import QtTest 1.1

Item {
    id: housest
    property var lampotesti: 24
    property var ovi_tila_auki: false
    property var valoisuus_temp: 0

    function ovi_hallinta(value)
    {

        if(value == 1)
        {
            ovi_tila_auki = true;
            ovi_auki.visible = true;
            ovi_kiinni.visible = false;
        }
        else if(value == 2)
        {
            ovi_tila_auki = false;
            ovi_auki.visible = false;
            ovi_kiinni.visible = true;
        }
        else
        {
            if (ovi_tila_auki == true)
            {
                ovi_auki.visible = true;
                ovi_kiinni.visible = false;
            }
            else if (ovi_tila_auki == false)
            {
                ovi_auki.visible = false;
                ovi_kiinni.visible = true;
            }
        }
    }

    function lux_muunnos(rawADC)
    {
        var Vout = rawADC * 0.0048828125;
        var lux = 500/(10*((5-Vout)/Vout));

        return lux;
    }

    Connections {
        target: reader
        onSendToQml: {
            //(int temp_keittio, int temp_ulko, int temp_pesuhuone, int hum_pesuhuone, int kast_pesuhuone, int valoisuus,int co2,int b);
            gauge_keittio.value = temp_keittio
            gauge_ulko.value = temp_ulko
            gauge_pesuhuone_lampo.value = temp_pesuhuone
            gauge_pesuhuone_kosteus.value = hum_pesuhuone
            gauge_pesuhuone_kastepiste.value = kast_pesuhuone
            text_olohuone_valoisuus.text = parseInt(lux_muunnos(valoisuus))
            pimennys.opacity = -0.002*lux_muunnos(valoisuus)+1
        }
    }

    Rectangle {
        id: house
        x: 100
        y: 265
        width: 600
        height: 400
        color: "#391d01"
        opacity: 1
        z: 1

        Rectangle {
            id: rec_keittio
            x: 464
            y: 162
            width: 185
            height: 185
            color: "#ffffff"
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 12

            MouseArea {
                id: keittio_hiiri
                anchors.fill: parent
                z: 2
                onClicked: {
                    housest.state = 'st_keittio' }
            }

            Text {
                id: keittio_text
                y: 16
                text: qsTr("Keittiö")
                z: 1
                visible: true
                anchors.horizontalCenterOffset: 0
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 12
            }

            Image {
                id: image1
                anchors.fill: parent
                fillMode: Image.Stretch
                sourceSize.width: 0
                source: "keittio2.jpg"
            }

            Rectangle {
                id: rectangle3
                x: 254
                y: 2
                width: 200
                height: 200
                color: "#ffffff"
                opacity: 0

                Gauge {
                    id: gauge_keittio
                    anchors.fill: parent
                    opacity: 0
                }
            }

            Label {
                id: label4
                x: 314
                y: 40
                text: qsTr("Label")
                opacity: 0
            }
        }

        Rectangle {
            id: rec_eteinen
            x: 232
            y: 162
            width: 185
            height: 185
            color: "#00000000"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 12

            Item {
                id: ulkolampotila
                x: 43
                y: 85
                width: 200
                height: 200
                opacity: 0

                Gauge {
                    id: gauge_ulko
                    anchors.fill: parent
                    opacity: 0
                    maximumValue: 50
                    minimumValue: -40
                }

                Rectangle {
                    id: rectangle1
                    color: "#ffffff"
                    anchors.fill: parent
                    opacity: 0
                }
            }

            MouseArea {
                id: eteishiiri
                anchors.fill: parent
                z: 1
                onClicked: {
                    housest.state = 'st_eteinen' }
            }

            Text {
                id: eteinen_text
                y: 16
                text: qsTr("Eteinen")
                z: 2
                visible: true
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 12
            }

            Image {
                id: image2
                anchors.fill: parent
                clip: false
                fillMode: Image.PreserveAspectFit
                source: "eteinen.png"
            }

            Image {
                id: ovi_auki
                anchors.bottomMargin: 2
                anchors.right: parent.right
                anchors.rightMargin: -5
                anchors.left: parent.left
                anchors.leftMargin: -1
                opacity: 1
                anchors.bottom: parent.bottom
                anchors.top: parent.top
                visible: false
                anchors.topMargin: 4
                source: "ovi_auki.png"
            }

            Image {
                id: ovi_kiinni
                visible: true
                opacity: 1
                anchors.topMargin: -5
                anchors.fill: parent
                source: "ovi_kiinni.png"
            }

        }

        Rectangle {
            id: rec_olohuone
            x: 0
            y: 180
            width: 185
            height: 185
            color: "#fce20c"
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 12

            Item {
                id: valaistus_olohuone
                x: 281
                y: 81
                width: 200
                height: 200
                opacity: 0

                Text {
                    id: text2
                    x: 19
                    text: qsTr("Text")
                    anchors.fill: parent
                    font.pixelSize: 12
                    opacity: 0
                }

                Rectangle {
                    id: rectangle4
                    color: "#ffffff"
                    anchors.fill: parent
                    opacity: 0
                }

                Text {
                    id: text_olohuone_valoisuus
                    opacity: 0
                    font.pixelSize: 12
                }


            }

            MouseArea {
                id: olohuone_hiiri
                anchors.rightMargin: 0
                anchors.bottomMargin: 0
                anchors.leftMargin: 0
                anchors.topMargin: 0
                visible: true
                anchors.fill: parent
                z: 1
                onClicked: {
                    housest.state = 'st_olohuone' }
            }

            Text {
                id: olohuone_text
                y: 16
                text: qsTr("Olohuone")
                z: 1
                visible: true
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 12
            }

            Image {
                id: image3
                fillMode: Image.Stretch
                anchors.fill: parent
                source: "olkkari.jpg"
            }

            Rectangle {
                id: pimennys
                color: "#000000"
                anchors.fill: parent
                opacity: 0
            }





        }

        Rectangle {
            id: rec_pesuhuone
            x: 464
            width: 185
            height: 185
            color: "#001db2"
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.topMargin: 6

            MouseArea {
                id: pesuhuone_hiiri
                anchors.fill: parent
                z: 1
                onClicked: {
                    housest.state = 'st_pesuhuone' }
            }

            Text {
                id: pesuhuone_text
                y: 16
                text: qsTr("Pesuhuone")
                z: 1
                visible: true
                anchors.horizontalCenterOffset: 0
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 12
            }

            Image {
                id: image4
                anchors.fill: parent
                source: "pesuhuone.jpg"
            }

            Item {
                id: kastepiste_pesuhuone
                width: 200
                height: 200
                opacity: 0

                Rectangle {
                    id: rectangle5
                    color: "#ffffff"
                    anchors.fill: parent
                    opacity: 0
                }

                CircularGauge {
                    id: gauge_pesuhuone_kastepiste
                    anchors.fill: parent
                    opacity: 0
                }

                Label {
                    id: label6
                    text: qsTr("Label")
                    opacity: 0
                }
            }

            Item {
                id: kosteus_pesuhuone
                x: 0
                y: 0
                width: 200
                height: 200
                opacity: 0

                Label {
                    id: label1
                    text: qsTr("Label")
                    opacity: 0
                }

                CircularGauge {
                    id: gauge_pesuhuone_kosteus
                    anchors.fill: parent
                    opacity: 0
                }

                Rectangle {
                    id: hum_bg
                    color: "#ffffff"
                    anchors.fill: parent
                    opacity: 0
                }


            }

            Item {
                id: lampo_pesuhuone
                width: 200
                height: 200
                opacity: 0

                Rectangle {
                    id: pesuhuone_temp_bg
                    x: -76
                    y: -22
                    color: "#ffffff"
                    anchors.fill: parent
                    opacity: 0
                }

                Label {
                    id: label2
                    text: qsTr("Label")
                    opacity: 0
                }

                Gauge {
                    id: gauge_pesuhuone_lampo
                    x: -76
                    y: -22
                    anchors.fill: parent
                    opacity: 0
                }


            }






        }

        Rectangle {
            id: rec_ylatasanne
            x: 232
            width: 185
            height: 185
            color: "#03f839"
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 7

            MouseArea {
                id: tasanne_hiiri
                anchors.fill: parent
                z: 1
                onClicked: {
                    housest.state = 'st_ylatasanne' }
            }

            Text {
                id: ylatasanne_text
                x: 83
                y: 16
                text: qsTr("Ylätasanne")
                z: 2
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 12
            }

            Image {
                id: image6
                anchors.fill: parent
                z: 0
                source: "tasanne.jpg"
            }
        }

        Rectangle {
            id: rec_makkari
            x: 0
            y: 0
            width: 185
            height: 185
            color: "#0bb7f9"
            anchors.left: parent.left
            anchors.leftMargin: 11
            anchors.top: parent.top
            anchors.topMargin: 6

            Rectangle {
                id: rec_co2
                width: 200
                height: 200
                color: "#ffffff"
                opacity: 0

                CircularGauge {
                    id: gauge_makuuhuone_co2
                    anchors.fill: parent
                    opacity: 0
                }

                Label {
                    id: label5
                    text: qsTr("Label")
                    opacity: 0
                }
            }

            Text {
                id: makkari_text
                x: 111
                y: 16
                height: 15
                text: qsTr("Makkari")
                z: 1
                visible: true
                anchors.horizontalCenterOffset: 1
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 12
            }

            Text {
                id: makkari_temp_text
                x: 121
                y: 79
                text: qsTr("Text")
                z: 1
                textFormat: Text.PlainText
                opacity: 0
                font.pixelSize: 12
            }

            MouseArea {
                id: makkari_hiiri
                anchors.fill: parent
                enabled: true
                clip: false
                visible: true
                antialiasing: false
                z: 3
                onClicked: {
                    housest.state = 'st_makkari' }
            }

            Image {
                id: image5
                anchors.fill: parent
                source: "makkari.jpg"
            }

            Rectangle {
                id: rec_lampo
                y: 37
                width: 46
                height: 71
                color: "#5e5858"
                z: 4
                opacity: 0

                Gauge {
                    id: gauge_makuuhuone_lampo
                    y: 0
                    anchors.fill: parent
                    maximumValue: 40
                    opacity: 1

                }

                Label {
                    id: label3
                    text: qsTr("Label")
                    opacity: 0
                }
            }



        }



        anchors.horizontalCenterOffset: 0
    }

    Text {
        id: text1
        x: 305
        y: 521
        text: qsTr("Text")
        opacity: 0
        font.pixelSize: 12
    }
    states: [
        State {
            name: "st_makkari"

            PropertyChanges {
                target: rec_makkari
                width: 450
                height: 450
                anchors.leftMargin: 34
                anchors.topMargin: 18
                anchors.rightMargin: 464
            }

            PropertyChanges {
                target: rec_ylatasanne
                x: 695
                y: 0
                width: 450
                height: 450
                anchors.topMargin: 18
                anchors.horizontalCenterOffset: 351
                visible: true
            }

            PropertyChanges {
                target: rec_pesuhuone
                width: 0
                height: 0
                visible: false
            }

            PropertyChanges {
                target: rec_olohuone
                y: 445
                width: 400
                height: 400
                anchors.leftMargin: 45
                anchors.bottomMargin: -365
                visible: false
            }

            PropertyChanges {
                target: rec_eteinen
                x: 695
                y: 445
                width: 450
                height: 100
                anchors.rightMargin: 0
                anchors.horizontalCenterOffset: 351
                anchors.bottomMargin: -65
                visible: false
            }

            PropertyChanges {
                target: rec_keittio
                width: 0
                height: 0
                visible: false
            }

            PropertyChanges {
                target: makkari_text
                anchors.horizontalCenterOffset: 0
                anchors.leftMargin: 315
                anchors.verticalCenterOffset: 0
                anchors.rightMargin: 355
            }

            PropertyChanges {
                target: makkari_temp_text
                x: 34
                y: 30
                text: qsTr("Lämpötila")
                opacity: 1
            }

            PropertyChanges {
                target: makkari_hiiri
                x: 0
                width: 696
                height: 324
                z: 2
                anchors.leftMargin: 0
                anchors.bottomMargin: 0
                anchors.rightMargin: 0
                onClicked: housest.state = ""
            }

            PropertyChanges {
                target: house
                x: 0
                y: 200
                width: 800
                height: 480
                anchors.horizontalCenterOffset: 0
            }

            PropertyChanges {
                target: olohuone_hiiri
                height: 118
                z: 5
                visible: true
                anchors.rightMargin: 145
                anchors.bottomMargin: 209
                anchors.leftMargin: 145
                anchors.topMargin: 95
            }

            PropertyChanges {
                target: eteishiiri
                anchors.rightMargin: 0
                anchors.leftMargin: 0
                anchors.bottomMargin: 56
                anchors.topMargin: -56
            }

            PropertyChanges {
                target: image5
                z: 3
            }

            PropertyChanges {
                target: image3
                anchors.bottomMargin: -302
                anchors.rightMargin: 8
                anchors.leftMargin: -8
                anchors.topMargin: 302
            }

            PropertyChanges {
                target: gauge_makuuhuone_lampo
                value: temp_olohuone
                anchors.topMargin: 27
                maximumValue: 40
                opacity: 1
            }

            PropertyChanges {
                target: rec_lampo
                x: 20
                y: 16
                width: 56
                height: 270
                color: "#453a3a"
                anchors.rightMargin: 348
                anchors.leftMargin: 66
                anchors.bottomMargin: 66
                z: 4
                opacity: 0.8
            }

            PropertyChanges {
                target: label3
                x: 1
                y: 8
                color: "#d4d4d4"
                text: qsTr("Temp(ºC)")
                font.pointSize: 10
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.family: "Arial"
                opacity: 1
            }

            PropertyChanges {
                target: rec_co2
                x: 242
                y: 16
                width: 200
                height: 253
                color: "#453a3a"
                z: 5
                opacity: 0.9
            }

            PropertyChanges {
                target: gauge_makuuhuone_co2
                width: 241
                height: 238
                anchors.topMargin: 30
                anchors.bottomMargin: 0
                anchors.rightMargin: 0
                anchors.leftMargin: 0
                opacity: 1
            }

            PropertyChanges {
                target: label5
                width: 60
                height: 24
                color: "#d4d4d4"
                text: qsTr("CO2 (%)")
                anchors.rightMargin: 0
                anchors.bottomMargin: 0
                anchors.leftMargin: 0
                anchors.topMargin: 0
                opacity: 1
            }
        },
        State {
            name: "st_ylatasanne"

            PropertyChanges {
                target: rec_ylatasanne
                x: 0
                width: 450
                height: 450
                visible: true
                anchors.leftMargin: 0
                anchors.topMargin: 18
                anchors.rightMargin: 464
            }

            PropertyChanges {
                target: makkari_hiiri
                width: 0
                height: 0
                anchors.rightMargin: 0
            }

            PropertyChanges {
                target: rec_makkari
                width: 450
                height: 450
                anchors.topMargin: 18
                anchors.leftMargin: -310
                visible: true
            }

            PropertyChanges {
                target: rec_keittio
                x: 796
                y: 374
                width: 0
                height: 0
                anchors.rightMargin: 0
                anchors.bottomMargin: 0
                visible: true
            }

            PropertyChanges {
                target: rec_eteinen
                y: 400
                width: 450
                height: 80
                anchors.horizontalCenterOffset: 0
                anchors.bottomMargin: 0
                visible: false
            }

            PropertyChanges {
                target: rec_olohuone
                y: 527
                width: 65
                height: 80
                anchors.leftMargin: -23
                anchors.bottomMargin: -127
                visible: false
            }

            PropertyChanges {
                target: rec_pesuhuone
                x: 666
                y: 0
                width: 450
                height: 450
                anchors.topMargin: 18
                anchors.rightMargin: -316
                visible: true
            }

            PropertyChanges {
                target: olohuone_text
                y: 12
                anchors.horizontalCenterOffset: 1
                enabled: true
            }

            PropertyChanges {
                target: tasanne_hiiri
                height: 324
                onClicked: housest.state = ""
            }

            PropertyChanges {
                target: makkari_text
                x: 0
                y: 37
                width: 50
                height: 15
                anchors.horizontalCenterOffset: 0
            }

            PropertyChanges {
                target: eteinen_text
                y: 22
                anchors.horizontalCenterOffset: 1
            }

            PropertyChanges {
                target: ylatasanne_text
                x: 291
                y: 38
            }

            PropertyChanges {
                target: house
                x: 0
                y: 200
                width: 800
                height: 480
            }

            PropertyChanges {
                target: keittio_hiiri
                width: 56
            }

            PropertyChanges {
                target: image1
                width: 0
                height: 324
                anchors.rightMargin: 0
                anchors.bottomMargin: 0
                anchors.leftMargin: 0
                anchors.topMargin: 0
                sourceSize.height: 400
                sourceSize.width: 600
                fillMode: Image.PreserveAspectCrop
            }

            PropertyChanges {
                target: pesuhuone_hiiri
                width: 6
                anchors.leftMargin: 0
            }

            PropertyChanges {
                target: eteishiiri
                width: 1440
                z: 5
                anchors.bottomMargin: 0
                anchors.topMargin: 0
                anchors.rightMargin: 0
                anchors.leftMargin: 0
            }

            PropertyChanges {
                target: olohuone_hiiri
                visible: true
                anchors.bottomMargin: -95
                anchors.rightMargin: 108
                anchors.leftMargin: -108
                anchors.topMargin: 95
            }

            PropertyChanges {
                target: pesuhuone_temp_bg
                x: 67
                y: 87
                width: 60
                height: 274
                color: "#554e4e"
                opacity: 1
            }

            PropertyChanges {
                target: gauge_pesuhuone_lampo
                x: 0
                y: 36
                width: 60
                height: 238
                maximumValue: 80
                opacity: 1
                anchors.rightMargin: -7
                anchors.leftMargin: 0
            }

            PropertyChanges {
                target: label2
                width: 60
                height: 30
                color: "#ffffff"
                text: qsTr("Temp(ºC)")
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.family: "Arial"
                font.pointSize: 10
                wrapMode: Text.WordWrap
                opacity: 1
            }
        },
        State {
            name: "st_pesuhuone"

            PropertyChanges {
                target: pesuhuone_hiiri
                height: 324
                onClicked: housest.state = ""
            }
            PropertyChanges {
                target: rec_keittio
                x: 330
                y: 394
                width: 450
                height: 450
                anchors.rightMargin: 20
                anchors.bottomMargin: -364
                visible: false
            }

            PropertyChanges {
                target: rec_eteinen
                y: 559
                width: 142
                height: 80
                anchors.horizontalCenterOffset: -471
                anchors.bottomMargin: -159
                visible: false
            }

            PropertyChanges {
                target: rec_olohuone
                width: 0
                height: 0
            }

            PropertyChanges {
                target: rec_pesuhuone
                x: 0
                width: 450
                height: 450
                anchors.topMargin: 18
                anchors.rightMargin: 20
            }

            PropertyChanges {
                target: rec_ylatasanne
                y: 0
                width: 450
                height: 450
                anchors.topMargin: 18
                anchors.horizontalCenterOffset: -332
            }

            PropertyChanges {
                target: rec_makkari
                width: 0
                height: 0
            }

            PropertyChanges {
                target: makkari_text
                visible: false
            }

            PropertyChanges {
                target: tasanne_hiiri
                width: 1420
                anchors.rightMargin: 0
                anchors.bottomMargin: 0
                anchors.leftMargin: 0
                anchors.topMargin: 0
                visible: true
            }

            PropertyChanges {
                target: olohuone_text
                visible: false
            }

            PropertyChanges {
                target: eteinen_text
                visible: false
            }

            PropertyChanges {
                target: keittio_text
                visible: true
            }

            PropertyChanges {
                target: ylatasanne_text
                width: 66
                height: 40
                visible: true
            }

            PropertyChanges {
                target: house
                x: 0
                y: 200
                width: 800
                height: 480
            }

            PropertyChanges {
                target: keittio_hiiri
                height: 4500
                anchors.bottomMargin: -72
                anchors.topMargin: 72
                anchors.leftMargin: 0
                anchors.rightMargin: 0
            }

            PropertyChanges {
                target: image1
                y: 0
                width: 4500
                height: 7680
                anchors.rightMargin: 0
                anchors.leftMargin: 0
                anchors.topMargin: 72
                visible: true
                anchors.bottomMargin: 0
            }

            PropertyChanges {
                target: eteishiiri
                width: 141
                anchors.bottomMargin: 0
                anchors.rightMargin: 0
                anchors.leftMargin: 0
                anchors.topMargin: 0
            }

            PropertyChanges {
                target: pesuhuone_temp_bg
                x: 67
                y: 87
                width: 60
                height: 274
                color: "#554e4e"
                visible: true
                opacity: 0.9
            }

            PropertyChanges {
                target: gauge_pesuhuone_lampo
                x: 66
                y: 110
                width: 60
                height: 238
                anchors.topMargin: 20
                anchors.bottomMargin: 0
                z: 2
                anchors.rightMargin: 0
                anchors.leftMargin: 0
                maximumValue: 80
                value: 0
                opacity: 1
            }

            PropertyChanges {
                target: gauge_pesuhuone_kosteus
                x: 308
                y: 211
                width: 134
                height: 128
                z: 2
                anchors.rightMargin: 0
                anchors.bottomMargin: 0
                anchors.leftMargin: 0
                anchors.topMargin: 27
                opacity: 1
            }

            PropertyChanges {
                target: hum_bg
                x: 319
                y: 189
                width: 123
                height: 156
                color: "#555353"
                opacity: 0.9
            }

            PropertyChanges {
                target: label1
                width: 112
                height: 22
                color: "#ffffff"
                text: qsTr("Kosteus (%)")
                anchors.bottomMargin: 1
                z: 1
                font.pointSize: 14
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                opacity: 1
            }

            PropertyChanges {
                target: label2
                width: 60
                height: 17
                color: "#ffffff"
                text: qsTr("Temp(ºC)")
                anchors.rightMargin: 102
                anchors.leftMargin: -76
                anchors.topMargin: -22
                horizontalAlignment: Text.AlignHCenter
                z: 1
                verticalAlignment: Text.AlignVCenter
                font.pointSize: 10
                font.family: "Arial"
                opacity: 1
            }

            PropertyChanges {
                target: lampo_pesuhuone
                x: 19
                y: 82
                width: 60
                height: 200
                opacity: 1
            }

            PropertyChanges {
                target: kosteus_pesuhuone
                x: 298
                y: 298
                width: 144
                height: 144
                opacity: 1
            }

            PropertyChanges {
                target: kastepiste_pesuhuone
                x: 146
                y: 298
                width: 141
                height: 144
                opacity: 1
            }

            PropertyChanges {
                target: rectangle5
                color: "#555353"
                opacity: 0.9
            }

            PropertyChanges {
                target: gauge_pesuhuone_kastepiste
                anchors.topMargin: 27
                opacity: 1
            }

            PropertyChanges {
                target: label6
                color: "#ffffff"
                text: qsTr("Kastepiste")
                font.pointSize: 14
                opacity: 1
            }
        },
        State {
            name: "st_olohuone"

            PropertyChanges {
                target: olohuone_hiiri
                height: 324
                visible: true
                anchors.rightMargin: 0
                anchors.bottomMargin: 0
                anchors.leftMargin: 0
                anchors.topMargin: 0
                onClicked: housest.state = ""
            }

            PropertyChanges {
                target: rec_keittio
                x: 464
                y: 162
                width: 0
                height: 0
                visible: false
            }

            PropertyChanges {
                target: rec_eteinen
                y: 15
                width: 450
                height: 450
                anchors.horizontalCenterOffset: 331
                anchors.bottomMargin: 15
                visible: true
            }

            PropertyChanges {
                target: rec_olohuone
                y: 18
                width: 450
                height: 450
                anchors.bottomMargin: 12
                anchors.leftMargin: 20
            }

            PropertyChanges {
                target: rec_pesuhuone
                width: 0
                height: 0
                visible: false
            }

            PropertyChanges {
                target: rec_ylatasanne
                x: 0
                y: 0
                width: 0
                height: 5
                anchors.topMargin: -49
                anchors.horizontalCenterOffset: 401
                visible: true
            }

            PropertyChanges {
                target: rec_makkari
                width: 0
                height: 0
                anchors.topMargin: -145
                anchors.leftMargin: 20
                visible: true
            }

            PropertyChanges {
                target: house
                x: 0
                y: 200
                width: 800
                height: 480
            }

            PropertyChanges {
                target: eteishiiri
                width: 4570
                height: 450
                anchors.rightMargin: 0
            }

            PropertyChanges {
                target: makkari_hiiri
                width: 6770
                anchors.bottomMargin: 0
                anchors.rightMargin: 0
                anchors.leftMargin: 0
                anchors.topMargin: 0
            }

            PropertyChanges {
                target: image5
                z: 4
                visible: true
            }

            PropertyChanges {
                target: image6
                z: 3
            }

            PropertyChanges {
                target: rectangle4
                x: 250
                y: 250
                color: "#404040"
                anchors.rightMargin: 0
                anchors.bottomMargin: 0
                anchors.leftMargin: 0
                anchors.topMargin: 0
                opacity: 0.9
            }

            PropertyChanges {
                target: text2
                x: 50
                y: 60
                width: 100
                height: 25
                color: "#ffffff"
                text: qsTr("Valoisuus (lx):")
                anchors.bottomMargin: 0
                anchors.topMargin: 0
                z: 4
                anchors.leftMargin: 0
                anchors.rightMargin: 38
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 15
                opacity: 1
            }

            PropertyChanges {
                target: valaistus_olohuone
                x: 120
                y: 37
                width: 211
                height: 19
                z: 4
                opacity: 1
            }

            PropertyChanges {
                target: text1
                x: 302
                y: 517
                width: 106
                height: 23
                opacity: 1
            }

            PropertyChanges {
                target: text_olohuone_valoisuus
                x: 108
                y: 0
                width: 99
                height: 18
                color: "#ffffff"
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 15
                opacity: 1
            }

            PropertyChanges {
                target: pimennys
                x: 90
                y: 145
                color: "#000000"
                opacity: 0
            }

            PropertyChanges {
                target: ovi_kiinni
                anchors.topMargin: -10
            }
        },
        State {
            name: "st_eteinen"

            PropertyChanges {
                target: eteishiiri
                height: 324
                anchors.rightMargin: 0
                anchors.bottomMargin: 0
                anchors.leftMargin: 0
                anchors.topMargin: 0
                onClicked: housest.state = ""
            }
            PropertyChanges {
                target: rec_keittio
                x: 665
                y: 15
                width: 450
                height: 450
                anchors.rightMargin: -315
                anchors.bottomMargin: 15
                visible: true
            }

            PropertyChanges {
                target: rec_olohuone
                y: 15
                width: 450
                height: 450
                anchors.leftMargin: -317
                anchors.bottomMargin: 15
                visible: true
            }

            PropertyChanges {
                target: rec_pesuhuone
                x: 734
                width: 0
                height: 0
                anchors.topMargin: -85
                anchors.rightMargin: 0
                visible: true
            }

            PropertyChanges {
                target: rec_ylatasanne
                y: 0
                width: 0
                height: 0
                anchors.topMargin: 0
                anchors.horizontalCenterOffset: 0
                visible: true
            }

            PropertyChanges {
                target: rec_makkari
                width: 0
                height: 0
                anchors.topMargin: -96
                anchors.leftMargin: 0
                visible: true
            }

            PropertyChanges {
                target: rec_eteinen
                x: 0
                y: 15
                width: 450
                height: 450
                anchors.horizontalCenterOffset: 0
                anchors.bottomMargin: 15
            }

            PropertyChanges {
                target: house
                x: 0
                y: 200
                width: 800
                height: 480
            }

            PropertyChanges {
                target: keittio_hiiri
                width: 678
                height: 34
                z: 3
                anchors.topMargin: 0
                anchors.bottomMargin: 0
                anchors.leftMargin: 0
            }

            PropertyChanges {
                target: image1
                width: 0
                height: 0
                anchors.rightMargin: 0
                anchors.topMargin: 0
                anchors.bottomMargin: 0
            }

            PropertyChanges {
                target: olohuone_hiiri
                width: 65
            }

            PropertyChanges {
                target: tasanne_hiiri
                anchors.bottomMargin: 0
                anchors.rightMargin: 0
                anchors.leftMargin: 0
                anchors.topMargin: 0
            }

            PropertyChanges {
                target: image6
                z: 3
                visible: true
            }

            PropertyChanges {
                target: image5
                z: 4
            }

            PropertyChanges {
                target: ovi_auki
                anchors.topMargin: 10
            }

            PropertyChanges {
                target: ovi_kiinni
                anchors.rightMargin: -11
                anchors.leftMargin: -10
                anchors.topMargin: -8
                visible: true
            }

            PropertyChanges {
                target: rectangle4
                x: 250
                y: 250
                color: "#686565"
                opacity: 1
            }

            PropertyChanges {
                target: text2
                x: 62
                y: 62
                width: 77
                height: 17
                color: "#ffffff"
                text: qsTr("Valaistus (lx)")
                opacity: 1
            }

            PropertyChanges {
                target: ylatasanne_text
                y: -33
                anchors.horizontalCenterOffset: 8
            }

            PropertyChanges {
                target: eteinen_text
                y: 40
                color: "#ededed"
                anchors.horizontalCenterOffset: 1
            }

            PropertyChanges {
                target: ulkolampotila
                x: 49
                y: 40
                width: 60
                height: 235
                z: 3
                opacity: 1
            }

            PropertyChanges {
                target: gauge_ulko
                anchors.rightMargin: 0
                maximumValue: 50
                minimumValue: -40
                value: 0.02
                z: 2
                opacity: 1
            }

            PropertyChanges {
                target: rectangle1
                color: "#716f6f"
                z: 1
                opacity: 0.9
            }
        },
        State {
            name: "st_keittio"

            PropertyChanges {
                target: keittio_hiiri
                width: 6967
                height: 324
                onClicked: housest.state = ""
            }
            PropertyChanges {
                target: rec_eteinen
                y: 12
                width: 450
                height: 450
                anchors.horizontalCenterOffset: -347
                anchors.bottomMargin: 18
                visible: true
            }

            PropertyChanges {
                target: rec_keittio
                x: 315
                y: 12
                width: 450
                height: 450
                anchors.bottomMargin: 20
                anchors.rightMargin: 35
            }

            PropertyChanges {
                target: rec_olohuone
                width: 0
                height: 0
                visible: false
            }

            PropertyChanges {
                target: rec_pesuhuone
                x: 321
                width: 450
                height: 100
                anchors.topMargin: -182
                anchors.rightMargin: 29
                visible: false
            }

            PropertyChanges {
                target: rec_ylatasanne
                y: 0
                width: 0
                height: 0
                anchors.topMargin: -46
                anchors.horizontalCenterOffset: -359
                visible: true
            }

            PropertyChanges {
                target: rec_makkari
                width: 0
                height: 0
                visible: false
            }

            PropertyChanges {
                target: house
                x: 0
                y: 200
                width: 800
                height: 480
            }

            PropertyChanges {
                target: pesuhuone_hiiri
                height: 100
                anchors.rightMargin: 0
                anchors.bottomMargin: 0
                anchors.leftMargin: 0
                anchors.topMargin: 0
                visible: true
            }

            PropertyChanges {
                target: rectangle3
                x: 255
                y: 0
                width: 55
                height: 145
                color: "#797979"
                opacity: 1
            }

            PropertyChanges {
                target: gauge_keittio
                opacity: 1
                value: temp_keittio
            }

            PropertyChanges {
                target: label4
                text: qsTr("Temp(ºC)")
                font.family: "Arial"
                font.pointSize: 10
                opacity: 1
            }
        }
    ]

}

