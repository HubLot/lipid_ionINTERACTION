tmpDIRname=ORANGE_26na_DENStmp
mkdir $tmpDIRname
cd $tmpDIRname
trajname=/wrk/ollilas1/POPCdata/POPCorange/POPCnacl/26NaCl/popcRUN1-2.xtc
tprname=/wrk/ollilas1/POPCdata/POPCorange/POPCnacl/26NaCl/popcRUN2.tpr
mappingFILE=/wrk/ollilas1/POPCdata/POPCorange/mappingPOPCorange.txt
outFILE=../../Data/POPC/NaCl/ORANGE/26na/LIPIDdensity.xvg
starttime=20000
LIPIDname=$(grep M_POPC_M $mappingFILE | awk '{printf "%5s\n",$2}')
LIPIDindexNR=$(echo q | make_ndx -f $tprname | grep $LIPIDname | awk '{if(NR==1)print $1}')
NAname=$(grep M_NA_M $mappingFILE | awk '{printf " %5s\n",$2}')
echo $NAname
NAindexNR=$(echo q | make_ndx -f $tprname | grep " NA" | awk '{if(NR==1)print $1}')
CLindexNR=$(echo q | make_ndx -f $tprname | grep " CL" | awk '{if(NR==1)print $1}')
echo $LIPIDindexNR System | trjconv -f $trajname -s $tprname -fit progressive -o ANALtraj.xtc -b $starttime
#Ztrans=$(tail -n 1 $groFILE | awk '{print $3/2}')
#Ztrans=-1
#echo System | trjconv -f FITtraj.xtc -s $tprname -trans 0 0 $Ztrans -o ANALtraj.xtc
echo $LIPIDindexNR $NAindexNR $CLindexNR | g_density -f ANALtraj.xtc -s $tprname -dens number -o densNC.xvg -xvg none -sl 100 -ng 3
echo System | trjconv -f ANALtraj.xtc -s $tprname -o INBOXtraj.xtc -pbc mol
echo $LIPIDindexNR | g_traj -f INBOXtraj.xtc -s $tprname -ox com.xvg -com -xvg none
Zcom=$(cat com.xvg | awk '{sumZ=sumZ+$4; sum=sum+1}END{print sumZ/sum}')
cat densNC.xvg | awk -v Zcom=$Zcom '{print $1-Zcom" "$2" "$3" "$4}' > $outFILE
ls $tmpDIRname/*
rmdir $tmpDIRname

