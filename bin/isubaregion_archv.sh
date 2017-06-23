#!/bin/bash

iscan=15
usage="
   This routine will use an existing mapping from this region to a new region to create
   a new archive file from the archives files given as argument(s).

   To use this routine, you must have already created a mapping, and placed it under subregion
   dir with the correct name  (run_isuba_gmapi.sh aims to do this for you).

   Usage:
      $(basename $0) [-s iscan]  new_experiment_path archive1 archive2 ....

   Example:
      $(basename $0) /work/$USER/hycom/TP4a0.12/expt_03.1 archv.2013_003_12.a archv.2013_004.a
      $(basename $0) -s $iscan /work/$USER/hycom/TP4a0.12/expt_03.1 archv.2013_003_12.a

   Optional argument 'iscan' has default value of 15. This is the distance that will be scanned on
   this region grid to find  a sea point for the new region grid points.
"
options=$(getopt -o s:  -- "$@")
[ $? -lt 3 ] || {
    echo "Incorrect options provided"
    exit 1
}
eval set -- "$options"
while true; do
    case "$1" in
    -s)
       shift;
       iscan=$1
        ;;
    --)
        shift
        break
        ;;
    esac
    shift
done

if [ $# -lt 2 ] ; then
   echo -e "$usage"
   exit
fi

# Must be in expt dir to run this script
if [ -f EXPT.src ] ; then
   export BASEDIR=$(cd .. && pwd)
else
   echo "Could not find EXPT.src. This script must be run in expt dir"
   exit 1
fi
export BINDIR=$(cd $(dirname $0) && pwd)/
export STARTDIR=$(pwd)
source ${BASEDIR}/REGION.src || { echo "Could not source ${BASEDIR}/REGION.src" ; exit 1 ; }
source ./EXPT.src || { echo "Could not source ./EXPT.src" ; exit 1 ; }
source ${BINDIR}/common_functions.sh || { echo "Could not source ${BINDIR}/common_functions.sh" ; exit 1 ; }

# Explore provided input path to get target region 
thisexpt=$X
newexptpath=$1
newregionpath=$(dirname $newexptpath)
echo "new experiment path $newexptpath"
echo "new region path $newregionpath"
source ${newregionpath}/REGION.src || { echo "Could not source ${newregionpath}/REGION.src" ; exit 1 ; }
source ${newexptpath}//EXPT.src || { echo "Could not source ${newexptpath}/EXPT.src" ; exit 1 ; }
shift 1

NR=$R
NX=$X
NE=$E
NT=$T
source ${BASEDIR}/REGION.src || { echo "Could not source ${BASEDIR}/REGION.src" ; exit 1 ; }
source ${BASEDIR}/expt_$thisexpt/EXPT.src || { echo "Could not source ${BASEDIR}/expt_$thisexpt/EXPT.src" ; exit 1 ; }
echo "This region name    :$R"
echo "This experiment     :$X"
echo "This experiment topo:$T"
echo "New  region name    :$NR"
echo "New  experiment     :$NX"
echo "New  experiment topo:$NT"


target_dir=$BASEDIR/subregion/${E}/${NR}_${NE}/
mkdir -p $target_dir || { echo "Could not create ${target_dir}" ; exit 1 ; }
target_dir=$(cd ${target_dir} && pwd)/
echo "Target dir = ${target_dir}"
export SCRATCH=${target_dir}/SCRATCH
[ ! -d $SCRATCH ] && mkdir -p $SCRATCH

# Get regional.grid of target region
target_grid=$NR.regional.grid
tmp=$newregionpath/topo/regional.grid
cp ${tmp}.a $SCRATCH/${target_grid}.a || { echo "Could not get ${tmp}.a file " ; exit 1 ; }
cp ${tmp}.b $SCRATCH/${target_grid}.b || { echo "Could not get ${tmp}.b file " ; exit 1 ; }

# Get topo file of target
target_topo=$(topo_file $NR $NT)
tmp=$newregionpath/topo/$target_topo
cp $tmp.a $SCRATCH/${target_topo}.a || { echo "Could not get $tmp.a " ; exit 1 ; }
cp $tmp.b $SCRATCH/${target_topo}.b || { echo "Could not get $tmp.b " ; exit 1 ; }

# Get topo file of source
source_topo=$(topo_file $R $T)
tmp=$BASEDIR/topo/$source_topo
cp $tmp.a $SCRATCH/${source_topo}.a || { echo "Could not get $tmp.a " ; exit 1 ; }
cp $tmp.b $SCRATCH/${source_topo}.b || { echo "Could not get $tmp.b " ; exit 1 ; }

# Get gmap file
#target_gmap=$NR.gmap
target_gmap=$(gmap_file $NR)
tmp=$BASEDIR/subregion/${target_gmap}
echo "New  region gmap file:$target_gmap"
if [ ! -f $tmp.a -o ! -f  $BASEDIR/$tmp.b ] ; then
   cp $tmp.a $SCRATCH/${target_gmap}.a
   cp $tmp.b $SCRATCH/${target_gmap}.b
else 
   echo "Could not get gmap files $tmp.a and  $tmp.b " 
   exit 1
fi

# Get dimensions from target region
cd $SCRATCH || { echo "Could not cd to $SCRATCH" ; exit 1 ; }
#echo blkdat_get ${target_grid}.b 
target_idm=$(blkdat_get ${target_grid}.b idm)
target_jdm=$(blkdat_get ${target_grid}.b jdm)


echo
echo
echo "Now processing archive files and interpolating to target grid"

logfile=$SCRATCH/isubaregion.log
touch $logfile && rm $logfile
for source_archv in $@ ; do
   echo "***"

   my_source_archv=$(echo $STARTDIR/$source_archv |  sed "s/\.[ab]$//")
   echo "Processing $my_source_archv"

   if [ ! -f ${my_source_archv}.a -o ! -f ${my_source_archv}.b ] ; then
      echo "Source file ${my_source_archv}.[ab] does not exist"
      exit 1
   fi
   target_archv=$(basename $my_source_archv)
   touch ${target_archv}.a && rm ${target_archv}.a
   touch ${target_archv}.b && rm ${target_archv}.b


#c --- 'flnm_reg'  = target sub-region grid       filename
#c --- 'flnm_map'  = target sub-region grid map   filename
#c --- 'flnm_top'  = target bathymetry filename, or 'NONE'
#c --- 'flnm_tin'  = input  bathymetry filename, or 'NONE'
#c --- 'flnm_in'   = input  archive    filename
#c --- 'flnm_out'  = output archive    filename
#c --- 'cline_out' = output title line (replaces preambl(5))
#c --- 'idm   ' = longitudinal array size
#c --- 'jdm   ' = latitudinal  array size
#c --- 'smooth' = smooth interface depths (0=F,1=T)
#c --- 'iscan ' = How many grid points to search for landfill process
prog=${HYCOM_ALL}/subregion/src/isubaregion
echo "Running $prog."
echo "Log can be found in $logfile"
#cat << EOF # For diag
${prog} >> $logfile <<EOF
${target_grid}.a
${target_gmap}.a
${target_topo}.a
${source_topo}.a
${my_source_archv}.a
${target_archv}.a
test
  ${target_idm}    'idm   '                                                               
  ${target_jdm}    'jdm   '    
    0    'iceflg'    
    0    'smooth'    
   $iscan   'iscan '    
EOF


   if [ ! -f ${target_archv}.a -o ! -f ${target_archv}.b ] ; then
      echo "Error : New file ${target_archv}.[ab] does not exist"
      echo "This is probably due to errors during extrapolation. Check log file $logfile"
      exit 1
   else 
      echo "Moving ${target_archv}.[ab] to ${target_dir}"
      mv ${target_archv}.* ${target_dir}
   fi
   

done


echo "Normal exit"
exit 0
