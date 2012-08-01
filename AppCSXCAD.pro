TEMPLATE = app
TARGET = AppCSXCAD
CONFIG += debug_and_release

# add git revision
GITREV = $$system(git describe --tags)
DEFINES += GIT_VERSION=\\\"$$GITREV\\\"

VERSION = 0.1.1

MOC_DIR = moc
OBJECTS_DIR = obj
QT += core gui xml

win32 {
    INCLUDEPATH += ../QCSXCAD
    LIBS += -L../QCSXCAD/release -lQCSXCAD0
    INCLUDEPATH += ../CSXCAD
    LIBS += -L../CSXCAD/release -lCSXCAD0
}

unix { 
    INCLUDEPATH += ../CSXCAD \
		../QCSXCAD
    LIBS += -L../QCSXCAD -lQCSXCAD \
        -L../CSXCAD -lCSXCAD \
        -lfparser
        INCLUDEPATH += /usr/include/QCSXCAD \
                       /usr/include/CSXCAD
QMAKE_LFLAGS += \'-Wl,-rpath,\$$ORIGIN/../CSXCAD\'
QMAKE_LFLAGS += \'-Wl,-rpath,\$$ORIGIN/../QCSXCAD\'
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
install.target = install
install.commands = mkdir -p \"$(INSTALL_ROOT)/usr/bin\"
install.commands += && cp -at \"$(INSTALL_ROOT)/usr/bin/\" AppCSXCAD AppCSXCAD.sh

QMAKE_EXTRA_TARGETS += install


#
# create .PHONY target
#
phony.target = .PHONY
phony.depends = $$QMAKE_EXTRA_TARGETS
QMAKE_EXTRA_TARGETS += phony
