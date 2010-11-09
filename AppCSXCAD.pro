TEMPLATE = app
TARGET = AppCSXCAD
CONFIG += debug_and_release

# add git revision as AppCSXCAD version
QMAKE_CXXFLAGS += -DCSXCAD_VERSION=\\\"`git describe --tags`\\\"

VERSION = 0.1.0

MOC_DIR = moc
OBJECTS_DIR = obj
QT += core \
	gui xml
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
QMAKE_LFLAGS += \'-Wl,-rpath,\$$ORIGIN/../CSXCAD\'
QMAKE_LFLAGS += \'-Wl,-rpath,\$$ORIGIN/../QCSXCAD\'
QMAKE_LFLAGS += \'-Wl,-rpath,\$$ORIGIN/../fparser\'
QMAKE_LFLAGS += \'-Wl,-rpath,\$$ORIGIN/../tinyxml\'
}
HEADERS += AppCSXCAD.h
SOURCES += AppCSXCAD.cpp \
    main.cpp
FORMS += 
RESOURCES += 

QMAKE_CXXFLAGS_DEBUG = -O0 -g
