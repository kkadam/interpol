#!/bin/bash
#This script automatically prepares input-dir, output-dir 
#and the fort.7 file for a restart of the simulation. 
#It also creates a new hydro executable in the specified 
#directory. This hydro file has to be manually copied in
#the work-dir.

### Specify sim number and hydro-dir ###
sim=1
hydro_dir=/work/kkadam/bipoly_hydro

cwd=$(pwd)

### Move pbs_out file ###
declare -i prev
prev=$sim-1

if [ -e pbs_out ]; then
  mv pbs_out pbs_out$prev
fi


### Move output-dir and make new one ###
mv output output$prev
mkdir output
mkdir output/conts output/data output/unscramble


### Move input-dir and make new ones ###
if [ -e input/conts ]; then
  mv input/conts input/conts$prev
fi
mkdir input/conts


### Get the last timestep from output/conts-dir ###
contlist=( output$prev/conts/fort.13.* )
#echo ${contlist[@]}
declare -i m
m=${#contlist[@]}-1
#echo $m
str=lastfile
str=lastime

if [ $sim -eq 1 ]; then
  lastfile=${contlist[$m-1]}
else
  lastfile=${contlist[$m]}
fi
lastime=${lastfile:22}
echo "Last timestep is- $lastime"


### Copy the continuation files ###
cp output$prev/conts/fort.13.$lastime input/conts
cp output$prev/conts/fort.12.$lastime.* input/conts


### Edit the fort.7 file ###
  cp run/fort.7 run/fort.7.$prev
  sed -i -e '1d' run/fort.7
  sed -i "1i\           1           1" run/fort.7

  sed -i -e '2d' run/fort.7
  sed -i "2i\        $lastime         910001         100" run/fort.7 


### Get the hydro file* ###
### *This script replaces particular line,
# so if you edit setup_frac.F90 file
# the code might break ###
cp additional_data/runhydro.h $hydro_dir
cd $hydro_dir
make clean
sf=setup_frac.F90

sed -i -e '283d' $sf
sed -i "283i\ conts_template = \'input/conts/fort.12.$lastime.\'" $sf

sed -i -e '653d' $sf
sed -i "653i\ open(unit=9, file=\'input/conts/fort.13.$lastime\', &" $sf

make 
cd $cwd
cp $hydro_dir/hydro .
echo "The run is ready for restart. Like a boass."


