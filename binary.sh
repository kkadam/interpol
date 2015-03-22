#!/bin/bash

### Evaluate these at each run ###
# n_core and n_env ahve to be the same for both the stars #
scfdir=/work/kkadam/scf_staging/m4
out_dir=sim9
message="test"
hydro_dir=/home/kkadam/codes/bipoly_hydro
walltime=02:00:00
pin=1.5
bipoly=.true.
numr=162
numz=98
numr_procs=8
numz_procs=8
ppn=8
#number of orbits
dragtime=1.6
#% of AM removed/orbit
reallyadrag=1.0e-2


### Import parameters from the binary SCF ###
datastr=`cat $scfdir/autoread.dat`
arr=($datastr)
#echo ${#arr[@]}
#echo ${arr[@]}

fn=convertpar.h
rn=runhydro.h

scfr=${arr[4]}
scfz=${arr[5]}
numphi=${arr[6]}
numr_deltar=$scfr
omega=${arr[7]}
kappa1=${arr[9]}
kappa2=${arr[11]}
kappac1=${arr[8]}
kappac2=${arr[10]}
rho1i=${arr[12]} 
rho2i=${arr[13]}

np1=${arr[0]}
np2=${arr[1]}


### Write the convertpar.h file ###
sed -i -e '2,27d' $fn

sed -i "2i\       integer, parameter :: scfr = $scfr" $fn
sed -i "3i\       integer, parameter :: scfz = $scfz" $fn
sed -i "4i\       integer, parameter :: numphi = $numphi" $fn
sed -i "5i\       integer, parameter :: numr_deltar = $numr_deltar     !Equatorial radius of single star" $fn
sed -i "6i\       integer, parameter :: deltar_parameter = 3.0   !1.5 for single star, 3 for binary" $fn
sed -i "7i\ " $fn
sed -i "8i\       double precision, parameter :: omega = $omega" $fn
sed -i "9i\       double precision, parameter :: pin = $pin" $fn
sed -i "10i\       double precision, parameter :: kappa1 = $kappa1" $fn
sed -i "11i\       double precision, parameter :: kappa2 = $kappa2" $fn
sed -i "12i\       double precision, parameter :: kappac1 = $kappac1" $fn
sed -i "13i\       double precision, parameter :: kappac2 = $kappac2" $fn
sed -i "14i\       double precision, parameter :: rho_c1 = $rho1i" $fn
sed -i "15i\       double precision, parameter :: rho_c2 = $rho2i" $fn
sed -i "16i\       double precision, parameter :: np1 = $np1" $fn
sed -i "17i\       double precision, parameter :: np2 = $np2" $fn
sed -i "18i\ " $fn
sed -i "19i\       logical, parameter :: bipoly = $bipoly" $fn
sed -i "20i\       logical, parameter :: binary_system =.true." $fn
sed -i "21i\ " $fn
sed -i "22i\!Gridsize of the hydro code (output)" $fn
sed -i "23i\       integer, parameter :: numr = $numr" $fn
sed -i "24i\       integer, parameter :: numz = $numz" $fn
sed -i "25i\ " $fn
sed -i "26i\       integer, parameter :: numr_procs = $numr_procs" $fn
sed -i "27i\       integer, parameter :: numz_procs = $numz_procs" $fn

### Move the template dir and run the interpol code ###
if [ -d template ]; then
  chmod 755 template 
  rm -r template
fi


mkdir template
mkdir template/input template/additional_data template/run template/output
mkdir template/input/conts
mkdir template/output/data template/output/conts template/output/unscramble

cp $scfdir/density.bin . 

make cl
make
./conv


### Make runhydro.h file ###
sed -i -e '1,10d' $rn

sed -i "1i\       integer, parameter :: numr = $numr" $rn
sed -i "2i\       integer, parameter :: numz = $numz" $rn
sed -i "3i\       integer, parameter :: numphi = $numphi" $rn
sed -i "4i\       integer, parameter :: oldnumr = $numr_deltar" $rn
sed -i "5i\       double precision, parameter :: deltar_parameter = 3.0   !1.5 for single star" $rn
sed -i "6i\       double precision, parameter :: reallyadrag =  $reallyadrag !% of AM removed/orbit" $rn
sed -i "7i\       double precision, parameter :: dragtime = $dragtime !number of orbits" $rn
sed -i "8i\ " $rn
sed -i "9i\       integer, parameter :: numr_procs = $numr_procs" $rn
sed -i "10i\       integer, parameter :: numz_procs = $numz_procs" $rn


### Make firststart.sh and readme files ###
sed -i -e '3d' firststart.sh
sed -i "3i\hydro_dir=$hydro_dir  " firststart.sh
echo $message > readme

### Copy additional_data files ###
cp convertpar.h template/additional_data
cp $scfdir/runscf.h template/additional_data
cp $scfdir/init template/additional_data
cp $scfdir/model_details_100000 template/additional_data
cp $scfdir/autoread.dat template/additional_data
cp runhydro.h template/additional_data
cp firststart.sh template
cp readme template 

### batchscript and unscramble files ###
#declare -i nodes
nodes=`echo "scale=0; (($numr_procs*$numz_procs)/8)"|bc`
total_procs=`echo "scale=0; ($numr_procs*$numz_procs)"|bc`

sed -i -e '4d;5d;8d;14d' batchscript

sed -i "4i\#PBS -l nodes=$nodes:ppn=$ppn" batchscript
sed -i "5i\#PBS -l walltime=$walltime" batchscript
sed -i "8i\#PBS -N $out_dir" batchscript
sed -i "14i\mpirun_rsh -np $total_procs -hostfile \$PBS_NODEFILE <location_of_hydro_exec>" batchscript

cp batchscript template
cp unscramble.sh template


### Change dir name ###
if [ -d $out_dir ]; then
  chmod 775 $out_dir
  rm -r $out_dir
fi
mv template $out_dir

echo " All files in directory $out_dir, Like a boass."
echo " ============================================================="

