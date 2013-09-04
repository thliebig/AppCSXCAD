#!/bin/bash

BIN_PATH=`dirname $0`

# unset the library search path
# Matlab sets it to point to an old libc
export LD_LIBRARY_PATH=

# Important! If you get a vtk error like this:
# ERROR: In /builddir/build/BUILD/VTK/Rendering/vtkXOpenGLRenderWindow.cxx, line 404
# vtkXOpenGLRenderWindow (0xbe2980): Could not find a decent visual
# you need to uncomment the next line:
# export LIBGL_ALWAYS_INDIRECT=y

$BIN_PATH/AppCSXCAD $@
