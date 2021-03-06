#!/bin/bash
cwd=$(pwd)
hydro_dir=/home/kkadam/codes/mf_constant_gamma/  

cp additional_data/runhydro.h $hydro_dir
cd $hydro_dir
make clean
make

cd $cwd
cp $hydro_dir/hydro .

sed -i "s:<location_of_hydro_exec>:$cwd/hydro:g" batchscript

echo "If you see hydro file, you're ready to start the simulation!"
