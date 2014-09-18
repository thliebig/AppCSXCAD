
PROJECT( AppCSXCAD CXX)

cmake_minimum_required(VERSION 2.8)

# default
set(VERSION "v0.1.5")

# add git revision
IF(EXISTS ${PROJECT_SOURCE_DIR}/.git )
  FIND_PACKAGE(Git)
  # Get the latest abbreviated commit hash of the working branch
  execute_process(
    COMMAND ${GIT_EXECUTABLE} describe --tags
    WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
    OUTPUT_VARIABLE GITREV
  )
  set(VERSION ${GITREV})
  string(STRIP ${VERSION} VERSION)
  message(STATUS "Found Git repository, ${PROJECT_NAME} version tag: ${VERSION}")
ENDIF()

ADD_DEFINITIONS(-DGIT_VERSION=\"${VERSION}\")


# TODO handle Qt5
FIND_PACKAGE( Qt4 4.6.3 REQUIRED QtCore QtGui QtXml)

INCLUDE( ${QT_USE_FILE} )


find_package(VTK REQUIRED)

if("${VTK_MAJOR_VERSION}" EQUAL 5)
  set( vtk_LIBS
    QVTK
  )
endif()


if("${VTK_MAJOR_VERSION}" EQUAL 6)
  set( vtk_LIBS
    vtkGUISupportQt
  )
endif()

if(VTK_FOUND)
	message(STATUS "Found package VTK. Using " ${VTK_USE_FILE})
    include(${VTK_USE_FILE})
else(VTK_FOUND)
    message(FATAL_ERROR "VTK not found. Please set VTK_DIR.")
endif(VTK_FOUND)

INCLUDE_DIRECTORIES (${VTK_INCLUDE_DIR})

#message(status "VTK selected: ${vtk_LIBS}")
#message(status "VTK all libs: ${VTK_LIBRARIES}")

#
# files that have Q_OBJECT need to be MOC'ed
# TODO use newer automoc with Qt5
SET(MOC_HDRS AppCSXCAD.h)

#
# headers that need to be moc'ed
#
QT4_WRAP_CPP( MOC_SRCS ${MOC_HDRS} )

SET(SOURCES
  main.cpp
  AppCSXCAD.cpp
)

INCLUDE_DIRECTORIES( ${QCSXCAD_SOURCE_DIR} ) # find 'QCSXCAD.h
INCLUDE_DIRECTORIES( ${CSXCAD_SOURCE_DIR}/src ) #find ContinuousStructure.h

ADD_EXECUTABLE( AppCSXCAD MACOSX_BUNDLE WIN32
  ${SOURCES}
  ${MOC_SRCS}
)

# TODO check for QVTK again?
TARGET_LINK_LIBRARIES( AppCSXCAD
  CSXCAD
  QCSXCAD
  ${vtk_LIBS}
)

#
# Install the application.
# On Mac the bundle is also installed into bin.
#
INSTALL(TARGETS AppCSXCAD
    BUNDLE DESTINATION bin COMPONENT Runtime
    RUNTIME DESTINATION bin COMPONENT Runtime
)

INSTALL(FILES AppCSXCAD.sh DESTINATION bin )

# TODO tarball

