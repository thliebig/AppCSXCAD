#!/bin/bash

DEVEL_PATH=$(dirname $0)/..
export DEVEL_PATH

#if [ -n "$LD_LIBRARY_PATH" ]; then
#   export LD_LIBRARY_PATH=${DEVEL_PATH}/CSXCAD:${DEVEL_PATH}/QCSXCAD:${DEVEL_PATH}/tinyxml:${DEVEL_PATH}/fparser:${LD_LIBRARY_PATH}
#else
   export LD_LIBRARY_PATH=${DEVEL_PATH}/CSXCAD:${DEVEL_PATH}/QCSXCAD:${DEVEL_PATH}/tinyxml:${DEVEL_PATH}/fparser
#fi

echo "Setup Library path"
echo $LD_LIBRARY_PATH

echo "Run AppCSXCAD"

$DEVEL_PATH/AppCSXCAD/AppCSXCAD $@
