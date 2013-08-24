TEMPLATE = app
TARGET = AppCSXCAD
CONFIG += debug_and_release

VERSION = 0.1.3

# add git revision
GITREV = $$system(git describe --tags)
isEmpty(GITREV):GITREV=$$VERSION
DEFINES += GIT_VERSION=\\\"$$GITREV\\\"

MOC_DIR = moc
OBJECTS_DIR = obj
QT += core gui xml

# remove unnecessary webkit define
DEFINES -= QT_WEBKIT

exists(localPathes.pri) {
    include(localPathes.pri)
}

win32 {
    isEmpty(WIN32_LIB_ROOT) {
        WIN32_LIB_ROOT = ..
    }

    #CSXCAD
    isEmpty(CSXCAD_ROOT) {
        CSXCAD_ROOT = $$WIN32_LIB_ROOT/CSXCAD
    }
    INCLUDEPATH += $$CSXCAD_ROOT/include/CSXCAD
    LIBS += -L$$CSXCAD_ROOT/lib -lCSXCAD0

    #QCSXCAD
    isEmpty(QCSXCAD_ROOT) {
        QCSXCAD_ROOT = $$WIN32_LIB_ROOT/QCSXCAD
    }
    INCLUDEPATH += $$QCSXCAD_ROOT/include/QCSXCAD
    LIBS += -L$$QCSXCAD_ROOT/lib -lQCSXCAD0
}

unix { 
    #CSXCAD
    isEmpty(CSXCAD_ROOT) {
        CSXCAD_ROOT = /usr
    } else {
        QMAKE_LFLAGS += \'-Wl,-rpath,$$CSXCAD_ROOT/lib\'
    }
    INCLUDEPATH += $$CSXCAD_ROOT/include/CSXCAD
    LIBS += -L$$CSXCAD_ROOT/lib -lCSXCAD

    #QCSXCAD
    isEmpty(QCSXCAD_ROOT) {
     QCSXCAD_ROOT = /usr
    } else {
        QMAKE_LFLAGS += \'-Wl,-rpath,$$QCSXCAD_ROOT/lib\'
    }
    INCLUDEPATH += $$QCSXCAD_ROOT/include/QCSXCAD
    LIBS += -L$$QCSXCAD_ROOT/lib -lQCSXCAD

    #vtk
    isEmpty(VTK_LIBRARYPATH) {
        #unnecessary by default
    } else {
        LIBS+=-L$$VTK_LIBRARYPATH
        QMAKE_LFLAGS += \'-Wl,-rpath,$$VTK_LIBRARYPATH\'
    }
}

HEADERS += AppCSXCAD.h
SOURCES += AppCSXCAD.cpp \
    main.cpp
FORMS += 
RESOURCES += 

QMAKE_CXXFLAGS_DEBUG = -O0 -g




#
# create tar file
#
tarball.target = tarball
tarball.commands = git archive --format=tar --prefix=AppCSXCAD-$$VERSION/ HEAD | bzip2 > AppCSXCAD-$${VERSION}.tar.bz2

QMAKE_EXTRA_TARGETS += tarball


#
# INSTALL
#
isEmpty(PREFIX) {
    PREFIX = /usr/local
}
install.target = install
install.commands = mkdir -p \"$$PREFIX/bin\"
unix:install.commands += && cp -at \"$$PREFIX/bin/\" AppCSXCAD AppCSXCAD.sh
win32:install.commands += && cp -at \"$$PREFIX/bin/\" release/AppCSXCAD.exe

QMAKE_EXTRA_TARGETS += install


#
# create .PHONY target
#
phony.target = .PHONY
phony.depends = $$QMAKE_EXTRA_TARGETS
QMAKE_EXTRA_TARGETS += phony
