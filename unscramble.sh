#!/bin/bash
### This script automatically unscrambles the 
# simulation data in the output directory.
# Make sure to run this before the restart.sh. ###


### Specify the unscramble.F90 location  ###
unsc_dir=/work/kkadam/binary_hydro_sim
str=unscfile
unscfile=unscramble_p2.F90

echo "Unscrambling...."


### Get the first/ last timestep from drive.out ###
str=line
str=firsrframe

line=$(echo `grep -m 1 frnum output/drive.out `)
firstframe=${line:8:5}
line=$(echo `grep frnum output/drive.out | tail -1`)
lastframe=${line:8:5}


### Copy unscramble file and modify ### 
cp additional_data/runhydro.h output/data
cp $unsc_dir/$unscfile output/data
cd output/data

sed -i -e '26d' $unscfile
sed -i "26i\ startfrm = $firstframe " $unscfile

sed -i -e '27d' $unscfile
sed -i "27i\ endfrm = $lastframe" $unscfile


### Run the unscramble and clean up ###
ifort -o unsc $unscfile
./unsc
rm unsc*
rm runhydro.h

cd ../unscramble
ls den*>fileslist
cd ../..


echo "The first timestep was: $firstframe"
echo "The last timestep was: $lastframe"
echo "Unscrambling is Done. Like a Boass."
