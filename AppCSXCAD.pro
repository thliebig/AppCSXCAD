TEMPLATE = app
TARGET = AppCSXCAD
CONFIG += debug_and_release
VERSION = 0.1.0
MOC_DIR = moc
OBJECTS_DIR = obj
QT += core \
    gui
win32 {
INCLUDEPATH += ..\QCSXCAD
LIBS += ..\QCSXCAD\release\QCSXCAD.dll
INCLUDEPATH += . \
    ..\CSXCAD
LIBS += ..\CSXCAD\release\CSXCAD.dll
}
unix { 
    INCLUDEPATH += ../CSXCAD \
        ../QCSXCAD    
    LIBS += -L../QCSXCAD -lQCSXCAD \
        -L../CSXCAD -lCSXCAD \
        -L../tinyxml -ltinyxml \
	-L../fparser -lfparser
}
HEADERS += AppCSXCAD.h
SOURCES += AppCSXCAD.cpp \
    main.cpp
FORMS += 
RESOURCES += 
CONFIG += release
