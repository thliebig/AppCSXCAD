TEMPLATE = app
TARGET = AppCSXCAD
QT += core \
    gui
INCLUDEPATH += ..\QCSXCAD
LIBS += ..\QCSXCAD\release\QCSXCAD.dll
INCLUDEPATH += . \
    ..\CSXCAD

LIBS += ..\CSXCAD\release\CSXCAD.dll
HEADERS += AppCSXCAD.h
SOURCES += AppCSXCAD.cpp \
    main.cpp
FORMS += 
RESOURCES += 
CONFIG += release
