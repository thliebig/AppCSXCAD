#!/bin/bash

DEVEL_PATH=$(dirname $0)/..

export LD_LIBRARY_PATH=

$DEVEL_PATH/AppCSXCAD/AppCSXCAD $@
