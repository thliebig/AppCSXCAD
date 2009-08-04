#!/bin/bash

clear 

DEVEL_PATH=/home/thorsten/devel
export DEVEL_PATH

if [ -n "$LD_LIBRARY_PATH" ]
then
   LD_LIBRARY_PATH=${DEVEL_PATH}/CSXCAD:${DEVEL_PATH}/QCSXCAD:${DEVEL_PATH}/tinyxml:${DEVEL_PATH}/fparser:${LD_LIBRARY_PATH}
else
   LD_LIBRARY_PATH=${DEVEL_PATH}/CSXCAD:${DEVEL_PATH}/QCSXCAD:${DEVEL_PATH}/tinyxml:${DEVEL_PATH}/fparser
fi
export LD_LIBRARY_PATH

echo "Setup Library path"
echo $LD_LIBRARY_PATH

echo "Run AppCSXCAD"

/home/thorsten/devel/AppCSXCAD/AppCSXCAD
