#!/bin/bash

### Evaluate these at each run ###
# n_core and n_env have to be the same for both the stars #
#scfdir=/work/kkadam/scf_runs/m63
scfdir=/work/kkadam/lonely_runs/s1
sim=run5
#out_dir=/work/kkadam/mf_hydro_sim
out_dir=/work/kkadam/lonely_runs
message="non-rotating continuous polytrope off center" 
hydro_dir=/home/kkadam/codes/mf_hydro/
walltime=12:00:00
pin=1.5
bipoly=.true.
#numr=258
numr=130
numz=130
numr_procs=16
numz_procs=16
ppn=20
#number of orbits
dragtime=0.0
#fraction of AM removed/orbit
reallyadrag=0.00
num_species=5

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

nc1=${arr[0]}
ne1=${arr[1]}
nc2=${arr[2]}
ne2=${arr[3]}
scfr=${arr[4]}
scfz=${arr[5]}
numphi=${arr[6]}
omega=${arr[7]}
kappac1=${arr[8]}
kappae1=${arr[9]}
kappac2=${arr[10]}
kappae2=${arr[11]}
rho_c1d=${arr[12]}
rho_1d=${arr[13]} 
rho_c2e=${arr[14]}
rho_2e=${arr[15]}
pres_d=${arr[16]}
pres_e=${arr[17]}
numr_deltar=${arr[18]}
com=${arr[19]}
separator=$(echo "-1 $com" | awk '{printf "%f", $1 * $2}')
#separator=`echo "x=-1.0*$com; if(x<1) print 0; x"| bc`
#separator=`echo "scale=10; (-1.0)*$com"|bc`


### Write the convertpar.h file ###
sed -i -e '2,34d' $fn

sed -i "2i\       integer, parameter :: scfr = $scfr" $fn
sed -i "3i\       integer, parameter :: scfz = $scfz" $fn
sed -i "4i\       integer, parameter :: numphi = $numphi" $fn
sed -i "5i\       integer, parameter :: numr_deltar = $numr_deltar     !Equatorial radius of single star" $fn
sed -i "6i\       double precision, parameter :: deltar_parameter = 1.5   !1.5 for single star, 3 for binary" $fn
sed -i "7i\ " $fn
sed -i "8i\       double precision, parameter :: omega = $omega" $fn
sed -i "9i\       double precision, parameter :: pin = $pin" $fn
sed -i "10i\       double precision, parameter :: kappac1 = $kappac1" $fn
sed -i "11i\       double precision, parameter :: kappae1 = $kappae1" $fn
sed -i "12i\       double precision, parameter :: kappac2 = $kappac2" $fn
sed -i "13i\       double precision, parameter :: kappae2 = $kappae2" $fn
sed -i "14i\       double precision, parameter :: rho_c1d = $rho_c1d" $fn
sed -i "15i\       double precision, parameter :: rho_1d = $rho_1d" $fn
sed -i "16i\       double precision, parameter :: rho_c2e = $rho_c2e" $fn
sed -i "17i\       double precision, parameter :: rho_2e = $rho_2e" $fn
sed -i "18i\       double precision, parameter :: pres_d = $pres_d" $fn
sed -i "19i\       double precision, parameter :: pres_e = $pres_e" $fn
sed -i "20i\       double precision, parameter :: L1 = 0.0" $fn
sed -i "21i\       double precision, parameter :: nc1 = $nc1" $fn
sed -i "22i\       double precision, parameter :: ne1 = $ne1" $fn
sed -i "23i\       double precision, parameter :: nc2 = $nc2" $fn
sed -i "24i\       double precision, parameter :: ne2 = $ne2" $fn
sed -i "25i\ " $fn
sed -i "26i\       logical, parameter :: bipoly = $bipoly" $fn
sed -i "27i\       logical, parameter :: binary_system =.true." $fn
sed -i "28i\ " $fn
sed -i "29i\!Gridsize of the hydro code (output)" $fn
sed -i "30i\       integer, parameter :: numr = $numr" $fn
sed -i "31i\       integer, parameter :: numz = $numz" $fn
sed -i "32i\ " $fn
sed -i "33i\       integer, parameter :: numr_procs = $numr_procs" $fn
sed -i "34i\       integer, parameter :: numz_procs = $numz_procs" $fn

### Move the template dir and run the interpol code ###
#if [ -d template ]; then
#  chmod 755 template 
#  rm -r template
#fi

make cl
make

### Make runhydro.h file ###
sed -i -e '1,13d' $rn

sed -i "1i\       integer, parameter :: numr = $numr" $rn
sed -i "2i\       integer, parameter :: numz = $numz" $rn
sed -i "3i\       integer, parameter :: numphi = $numphi" $rn
sed -i "4i\       integer, parameter :: oldnumr = $numr_deltar" $rn
sed -i "5i\       double precision, parameter :: deltar_parameter = 1.5   !1.5 for single star" $rn
sed -i "6i\       double precision, parameter :: reallyadrag =  $reallyadrag !fraction of AM removed/orbit" $rn
sed -i "7i\       double precision, parameter :: dragtime = $dragtime !number of orbits" $rn
sed -i "8i\       double precision, parameter :: separator = $separator  !-ve of CoM from the SCF" $rn
sed -i "9i\ " $rn
sed -i "10i\       integer, parameter :: num_species = $num_species" $rn
sed -i "11i\ " $rn
sed -i "12i\       integer, parameter :: numr_procs = $numr_procs" $rn
sed -i "13i\       integer, parameter :: numz_procs = $numz_procs" $rn


### Make firststart.sh and readme files ###
sed -i -e '3d' firststart.sh
sed -i "3i\hydro_dir=$hydro_dir  " firststart.sh
echo $message > readme


### batchscript and unscramble files ###
#declare -i nodes
rem=`echo $(( ($numr_procs*$numz_procs)%$ppn ))`

if [ "$rem" -gt "0" ]
then
   nodes=`echo $(( $numr_procs*$numz_procs/$ppn+1 ))`
else 
   nodes=`echo $(( $numr_procs*$numz_procs/$ppn ))`
fi

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
cp $scfdir/model_details template/additional_data
cp $scfdir/autoread.dat template/additional_data
#cp $scfdir/iteration_log template/additional_data
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

