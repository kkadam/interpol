#!/bin/bash

### Evaluate these at each run ###
# n_core and n_env have to be the same for both the stars #
scfdir=/work/kkadam/scf_runs/m66
sim=sim34
out_dir=/work/kkadam/prep_scf
message="q=0.36 bibi, m66"
hydro_dir=/home/kkadam/codes/bipoly_hydro
walltime=48:00:00
pin=1.5
bipoly=.true.
numr=258
numz=130
numr_procs=8
numz_procs=8
ppn=8
#number of orbits
dragtime=1.6
#% of AM removed/orbit
reallyadrag=0.0


### Import parameters from the binary SCF ###
if [ -f $scfdir/autoread.dat ] && [ -f $scfdir/density.bin ]; then
   datastr=`cat $scfdir/autoread.dat`
   arr=($datastr)
else 
   echo " ============================================================="
   echo " File autoread.dat or density.bin is missing!! " 
   echo " ============================================================="
   exit
fi

#echo ${#arr[@]}
#echo ${arr[@]}

fn=convertpar.h
rn=runhydro.h

np1=${arr[0]}
np2=${arr[1]}


scfr=${arr[4]}
scfz=${arr[5]}
numphi=${arr[6]}
omega=${arr[7]}
kappac1=${arr[8]}
kappa1=${arr[9]}
kappac2=${arr[10]}
kappa2=${arr[11]}
rho_c1d=${arr[12]}
rho_1d=${arr[13]} 
rho_c2e=${arr[14]}
rho_2e=${arr[15]}
pres_d=${arr[16]}
pres_e=${arr[17]}
L1=${arr[18]}
numr_deltar=$scfr


### Write the convertpar.h file ###
sed -i -e '2,32d' $fn

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
sed -i "14i\       double precision, parameter :: rho_c1d = $rho_c1d" $fn
sed -i "15i\       double precision, parameter :: rho_1d = $rho_1d" $fn
sed -i "16i\       double precision, parameter :: rho_c2e = $rho_c2e" $fn
sed -i "17i\       double precision, parameter :: rho_2e = $rho_2e" $fn
sed -i "18i\       double precision, parameter :: pres_d = $pres_d" $fn
sed -i "19i\       double precision, parameter :: pres_e = $pres_e" $fn
sed -i "20i\       double precision, parameter :: L1 = $L1" $fn
sed -i "21i\       double precision, parameter :: np1 = $np1" $fn
sed -i "22i\       double precision, parameter :: np2 = $np2" $fn
sed -i "23i\ " $fn
sed -i "24i\       logical, parameter :: bipoly = $bipoly" $fn
sed -i "25i\       logical, parameter :: binary_system =.true." $fn
sed -i "26i\ " $fn
sed -i "27i\!Gridsize of the hydro code (output)" $fn
sed -i "28i\       integer, parameter :: numr = $numr" $fn
sed -i "29i\       integer, parameter :: numz = $numz" $fn
sed -i "30i\ " $fn
sed -i "31i\       integer, parameter :: numr_procs = $numr_procs" $fn
sed -i "32i\       integer, parameter :: numz_procs = $numz_procs" $fn

### Move the template dir and run the interpol code ###
#if [ -d template ]; then
#  chmod 755 template 
#  rm -r template
#fi

make cl
make

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


### batchscript and unscramble files ###
#declare -i nodes
nodes=`echo "scale=0; (($numr_procs*$numz_procs)/8)"|bc`
total_procs=`echo "scale=0; ($numr_procs*$numz_procs)"|bc`

sed -i -e '4d;5d;8d;14d' batchscript

sed -i "4i\#PBS -l nodes=$nodes:ppn=$ppn" batchscript
sed -i "5i\#PBS -l walltime=$walltime" batchscript
sed -i "8i\#PBS -N $sim" batchscript
sed -i "14i\mpirun_rsh -np $total_procs -hostfile \$PBS_NODEFILE <location_of_hydro_exec>" batchscript



cwd=$(pwd)

cd $out_dir

if [ -d template ]; then
  chmod 755 template 
  rm -r template
fi

mkdir template
mkdir template/input template/additional_data template/run template/output
mkdir template/input/conts
mkdir template/output/data template/output/conts template/output/unscramble

cp $scfdir/density.bin . 
cp $scfdir/pressure.bin .
cp $cwd/conv .
cp $cwd/convertpar.h .

./conv

### Copy additional_data files ###
cp $cwd/convertpar.h template/additional_data
cp $cwd/firststart.sh template
cp $cwd/readme template
cp $cwd/batchscript template
cp $cwd/unscramble.sh template
cp $cwd/runhydro.h template/additional_data

cp $scfdir/readme template/additional_data/readme_scf
sed -i "2i\ $scfdir" template/additional_data/readme_scf
cp $scfdir/runscf.h template/additional_data
cp $scfdir/init template/additional_data
cp $scfdir/model_details_100000 template/additional_data
cp $scfdir/autoread.dat template/additional_data
cp $scfdir/iteration_log template/additional_data
cp $out_dir/star1 template/additional_data
cp $out_dir/star2 template/additional_data
cp $out_dir/star1o template/additional_data
cp $out_dir/star2o template/additional_data


### Change dir name ###
if [ -d $sim ]; then
  chmod 775 $sim
  rm -r $sim
fi
mv template $sim

echo " All files in directory $out_dir/$sim, Like a boass."
echo " ============================================================="

