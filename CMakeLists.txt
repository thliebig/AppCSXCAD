
# define build type
IF( DEFINED CMAKE_BUILD_TYPE )
  SET( CMAKE_BUILD_TYPE ${CMAKE_BUILD_TYPE} CACHE STRING "Set to either \"Release\" or \"Debug\"" )
ELSE()
  SET( CMAKE_BUILD_TYPE Release CACHE STRING "Set to either \"Release\" or \"Debug\"" )
ENDIF()

PROJECT( AppCSXCAD CXX C)

# In CMake 4, 3.10 is deprecated and 3.5 has been removed.
# use 3.0...3.10 so all of these versions are acceptable as min. version.
# https://cmake.org/cmake/help/latest/command/cmake_minimum_required.html
cmake_minimum_required(VERSION 3.0...3.10)

if (UNIX)
    set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC" )
endif()

# not supported any more by cmake 4.0?
# if(POLICY CMP0020)
#   cmake_policy(SET CMP0020 OLD)
# endif()

IF(EXISTS ${PROJECT_SOURCE_DIR}/localConfig.cmake)
   include(${PROJECT_SOURCE_DIR}/localConfig.cmake)
ENDIF()

# default
set(VERSION "v0.2.3")

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
  set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib${LIB_SUFFIX}")
endif()
if(APPLE AND NOT CMAKE_INSTALL_NAME_DIR)
  set(CMAKE_INSTALL_NAME_DIR "${CMAKE_INSTALL_PREFIX}/lib${LIB_SUFFIX}")
endif()
if(UNIX AND ENABLE_RPATH)
  set(CMAKE_SKIP_BUILD_RPATH FALSE)
  set(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
  set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
endif()

# Set locations of extra CMake modules
SET(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${openEMS_SOURCE_DIR}/cmake/Modules/")

# CSXCAD
# $ cmake -DCSXCAD_ROOT_DIR=~/opt/openEMS .
# SET(CSXCAD_ROOT_DIR ~/opt/openEMS)
find_library(CSXCAD_LIBRARIES 
  NAMES CSXCAD
  HINTS ${CSXCAD_ROOT_DIR}/lib${LIB_SUFFIX}
  NO_CMAKE_FIND_ROOT_PATH
)
message(STATUS "CSXCAD_LIBRARIES: ${CSXCAD_LIBRARIES}" )
#TODO test if CSXCADs was found
find_path(CSXCAD_INCLUDE_DIR 
    NAMES ContinuousStructure.h 
    HINTS ${CSXCAD_ROOT_DIR}/include
    PATH_SUFFIXES "CSXCAD" ${CSXCAD_INCLUDE_DIR}
    NO_CMAKE_FIND_ROOT_PATH
)
message(STATUS "CSXCAD_INCLUDE_DIR: ${CSXCAD_INCLUDE_DIR}" )
INCLUDE_DIRECTORIES( ${CSXCAD_INCLUDE_DIR} ) 


# QCSXCAD
# $ cmake -DQCSXCAD_ROOT_DIR=~/opt/openEMS .
# SET(QCSXCAD_ROOT_DIR ~/opt/openEMS)
find_library(QCSXCAD_LIBRARIES 
  NAMES QCSXCAD
  HINTS ${QCSXCAD_ROOT_DIR}/lib${LIB_SUFFIX}
  NO_CMAKE_FIND_ROOT_PATH
)
message(STATUS "QCSXCAD_LIBRARIES: ${QCSXCAD_LIBRARIES}" )
#TODO test if QCSXCADs was found
find_path(QCSXCAD_INCLUDE_DIR 
    NAMES QCSXCAD.h 
    HINTS ${QCSXCAD_ROOT_DIR}/include
    PATH_SUFFIXES "QCSXCAD" ${QCSXCAD_INCLUDE_DIR}
    NO_CMAKE_FIND_ROOT_PATH
)
message(STATUS "QCSXCAD_INCLUDE_DIR: ${QCSXCAD_INCLUDE_DIR}" )
INCLUDE_DIRECTORIES( ${QCSXCAD_INCLUDE_DIR} ) 

# hdf5
find_package(HDF5 COMPONENTS C HL REQUIRED)
INCLUDE_DIRECTORIES (${HDF5_INCLUDE_DIRS})

# Both Qt6 support and the variable VTK_QT_VERSION are introduced in vTK
# 9.1. Below VTK 9, we don't know the Qt version used by VTK, so we make
# a guess and hope for the best. Since Qt6 is not officially supported
# before 9.1, we guess Qt4 or Qt5.
# https://gitlab.kitware.com/vtk/vtk/-/merge_requests/7483
if (NOT DEFINED VTK_QT_VERSION)
    FIND_PACKAGE(Qt4 COMPONENTS QtCore QUIET)
    if (Qt4_FOUND)
        SET(VTK_QT_VERSION "4")
    else()
        SET(VTK_QT_VERSION "5")
    # Probably no need to check for Qt6 here, since Qt6 is only supported by VTK 9.1+
    # which exposes VTK_QT_VERSION
    endif()
    message(
      WARNING
      "VTK_QT_VERSION is unsupported before VTK 9.1, "
      "a guess has been made: Qt ${VTK_QT_VERSION}. "
      "Use -DVTK_QT_VERSION=number to override!"
    )
endif()

# vtk
find_package(VTK COMPONENTS vtkCommonCore QUIET)
if (${VTK_VERSION} VERSION_GREATER "9")
    find_package(VTK REQUIRED COMPONENTS
      CommonCore IOXML InteractionWidgets RenderingLOD GUISupportQt
      NO_MODULE
    )
else()
    find_package(VTK REQUIRED COMPONENTS
      vtkCommonCore vtkIOXML vtkInteractionWidgets vtkRenderingLOD vtkGUISupportQt
      NO_MODULE
    )
    include(${VTK_USE_FILE})
endif()

message(STATUS "Found package VTK. Using " ${VTK_VERSION})
INCLUDE_DIRECTORIES(${VTK_INCLUDE_DIR})

# Qt
set(CMAKE_AUTOMOC ON)
if(VTK_QT_VERSION VERSION_GREATER "5")
    FIND_PACKAGE(Qt6 COMPONENTS Core Widgets Xml REQUIRED)
    set(QT_LIBRARIES Qt6::Core Qt6::Widgets Qt6::Xml)
elseif(${VTK_VERSION} VERSION_GREATER "6" AND VTK_QT_VERSION VERSION_GREATER "4")
    FIND_PACKAGE(Qt5 COMPONENTS Core Widgets Xml REQUIRED)
    set(QT_LIBRARIES Qt5::Core Qt5::Widgets Qt5::Xml)
else()
    FIND_PACKAGE(Qt4 REQUIRED QtCore QtGui QtXml)
    INCLUDE( ${QT_USE_FILE} )
    INCLUDE_DIRECTORIES(${QT_INCLUDES})
endif()

message(STATUS "Found package VTK. Using version " ${VTK_VERSION})

SET(SOURCES
  main.cpp
  AppCSXCAD.cpp
)

ADD_EXECUTABLE( AppCSXCAD ${SOURCES} )

TARGET_LINK_LIBRARIES( AppCSXCAD
  ${CSXCAD_LIBRARIES}
  ${QCSXCAD_LIBRARIES}
  ${HDF5_LIBRARIES}
  ${HDF5_HL_LIBRARIES}
  ${VTK_LIBRARIES}
  ${QT_LIBRARIES}
)

#
# Install the application.
# On Mac the bundle is also installed into bin.
#
INSTALL(TARGETS AppCSXCAD
    BUNDLE DESTINATION bin COMPONENT Runtime
    RUNTIME DESTINATION bin COMPONENT Runtime
)

if (UNIX)
    INSTALL(FILES AppCSXCAD.sh 
        DESTINATION bin 
        PERMISSIONS OWNER_WRITE OWNER_READ GROUP_READ WORLD_READ OWNER_EXECUTE GROUP_EXECUTE WORLD_EXECUTE)
endif ()

# TODO tarball

