
# define build type
IF( DEFINED CMAKE_BUILD_TYPE )
  SET( CMAKE_BUILD_TYPE ${CMAKE_BUILD_TYPE} CACHE STRING "Set to either \"Release\" or \"Debug\"" )
ELSE()
  SET( CMAKE_BUILD_TYPE Release CACHE STRING "Set to either \"Release\" or \"Debug\"" )
ENDIF()

PROJECT( AppCSXCAD CXX)

cmake_minimum_required(VERSION 2.8)

IF(EXISTS ${PROJECT_SOURCE_DIR}/localConfig.cmake)
   include(${PROJECT_SOURCE_DIR}/localConfig.cmake)
ENDIF()

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

#
# Set up RPATH for the project
#
option(ENABLE_RPATH "Enable rpath support on Linux and Mac" ON)
if(NOT CMAKE_INSTALL_RPATH)
  set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib")
endif()
if(APPLE AND NOT CMAKE_INSTALL_NAME_DIR)
  set(CMAKE_INSTALL_NAME_DIR "${CMAKE_INSTALL_PREFIX}/lib")
endif()
if(UNIX AND ENABLE_RPATH)
  set(CMAKE_SKIP_BUILD_RPATH FALSE)
  set(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
  set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
endif()

# Set locations of extra CMake modules
SET(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${openEMS_SOURCE_DIR}/cmake/Modules/")

# CSXCAD
# $ cmake -D CSXCAD_ROOT_DIR=~/opt/openEMS .
# SET(CSXCAD_ROOT_DIR ~/opt/openEMS)
find_library(CSXCAD_LIBRARIES NAMES CSXCAD
  HINTS
  ${CSXCAD_ROOT_DIR}/lib
)
message(STATUS "CSXCAD: ${CSXCAD_LIBRARIES}" )
#TODO test if CSXCADs was found
INCLUDE_DIRECTORIES( ${CSXCAD_ROOT_DIR}/include/CSXCAD )

# QCSXCAD
# $ cmake -D QCSXCAD_ROOT_DIR=~/opt/openEMS .
# SET(QCSXCAD_ROOT_DIR ~/opt/openEMS)
find_library(QCSXCAD_LIBRARIES NAMES QCSXCAD
  HINTS
  ${QCSXCAD_ROOT_DIR}/lib
)
message(STATUS "QCSXCAD: ${QCSXCAD_LIBRARIES}" )
#TODO test if QCSXCADs was found
INCLUDE_DIRECTORIES( ${QCSXCAD_ROOT_DIR}/include/QCSXCAD )

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

ADD_EXECUTABLE( AppCSXCAD MACOSX_BUNDLE WIN32
  ${SOURCES}
  ${MOC_SRCS}
)

# TODO check for QVTK again?
TARGET_LINK_LIBRARIES( AppCSXCAD
  ${CSXCAD_LIBRARIES}
  ${QCSXCAD_LIBRARIES}
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

