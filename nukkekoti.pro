TEMPLATE = app

CONFIG += c++11

QT += qml quick widgets

SOURCES += main.cpp \
    thingspeakreader.cpp \
    src/httpclient.cpp \
    src/qthingspeak.cpp \
    src/strlib.cpp \
    src/tcpsocket.cpp \
    src/thingspeakclient.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

DISTFILES += \
Talo.qml
   /Home/simo/Pictures/640x320_6425_MG2_Main_Menu_2d_landscape_background_picture_image_digital_art.jpg

INCLUDEPATH += src

HEADERS += \
    thingspeakreader.h \
    src/httpclient.h \
    src/qthingspeak.h \
    src/strlib.h \
    src/tcpsocket.h \
    src/thingspeakclient.h

target.path
