#!/bin/bash
#               GMT EXAMPLE 37
#               $Id: example_37.sh 17711 2017-03-17 20:55:30Z pwessel $
#
# Purpose:      Illustrate 2-D FFT and coherence between gravity and bathymetry grids
# GMT modules:  psbasemap, psxy, makecpt, grdfft, grdimage, grdinfo
# Unix progs:   rm
#
#grdcut earth_relief_01m.grd -R145/200/-39/0 -Gvvtc_relief.nc
#grdcut vvtc_grav.grd -R145/200/-39/0 -Gvvtc_grav.nc
#grdcut vvtc_grav.grd -R14/28/2/11.5 -Gvvtcs_grav.nc

exec bash

# Step-3. Extract subsets of img/grd files in Mercator or Geographic format
gmt grdcut GEBCO_2019.nc -R14/28/2/11.5 -Gcf_relief.nc
gmt grdconvert n00e00/w001001.adf geoid_CF.grd
gmt img2grd grav_27.1.img -R14/28/2/11.5 -Ggrav_CF.grd -T1 -I1 -E -S0.1 -V
gmt img2grd curv_27.1.img -R14/28/2/11.5 -Ggravvert_CF.grd -T1 -I1 -E -S0.1 -V
gmt grdcut EMAG2_V2.grd -R14/28/2/11.5 -Gcf_mag.nc
gmt grdcut @earth_wdmam_03m -R14/28/2/11.5 -Gcf_mag_wdmam.nc
#grdinfo grav_CF.grd
# Minimum=-85.213, Maximum=114.237, Mean=-6.166, StdDev=17.711
#grdinfo gravvert_CF.grd
# Minimum=-100.418, Maximum=116.835, Mean=-0.126, StdDev=8.658

#
# gmt grdfft grav_CF.grd gravvert_CF.grd -E+wk+n -Na+d+wtmp > cross_spectra.txt
gmt grdfft cf_mag_wdmam.nc cf_relief.nc -E+wk+n -Na+d+wtmp > cross_spectra1.txt

gmt set FONT_TITLE 12p GMT_FFT kiss
gmt makecpt -Crainbow -T212/1820 > z.cpt # topo
gmt makecpt -Crainbow -T-40/40 > g.cpt # geoid
gmt makecpt -Cjet.cpt -T-40/40 > c.cpt # grav
gmt makecpt -Chaxby.cpt -T-85/80 > d.cpt # vert grav
gmt makecpt -Cwysiwyg.cpt -T-1000/512 > m.cpt # EMAG2
gmt makecpt -Cmag -T-933/375 > n.cpt # WDMAM

ps=Coherency_CF.ps
#----------------->
# map 1 lower left
gmt grdimage cf_relief.nc -R14/28/2/11.5 \
    -I+a0+nt1 -JM5.5c -Cz.cpt -P -K -X1.474i -Y1i > $ps
gmt psbasemap -R14/28/2/11.5 -JM5.5c \
    -Ba -BWSne+t"IGPP Global Earth Relief"  \
    -UBL/-5p/-40p \
    --MAP_TITLE_OFFSET=0.1c -O -K >> $ps
#----------------->
# map 2 lower right
gmt grdimage geoid_CF.grd -R14/28/2/11.5 \
    -I+a0+nt1 -JM5.5c -Cg.cpt -O -K -X3.25i >> $ps
gmt psbasemap -R14/28/2/11.5 -JM5.5c \
    --MAP_TITLE_OFFSET=0.1c -Ba -BWSne+t"Geoid model EGM2008" -O -K  >> $ps
#----------------->
# map 3 upper left
gmt grdimage gravvert_CF.grd -R14/28/2/11.5 -I+a0+nt1 -JM5.5c \
    -Cc.cpt -O -K -X-3.25i -Y7.2c >> $ps
gmt psbasemap -R14/28/2/11.5 -JM5.5c -Ba \
    -BWSne+t"Vertical gravity gradient" \
    --MAP_TITLE_OFFSET=0.1c -O -K >> $ps
#----------------->
# map 4 upper right
gmt grdimage grav_CF.grd -R14/28/2/11.5 -I+a0+nt1 -JM5.5c -Cd.cpt -O -K -X3.25i >> $ps
gmt psbasemap -R14/28/2/11.5 -JM5.5c -Ba -BWSne+t"Free-air gravity anomaly" \
    --MAP_TITLE_OFFSET=0.1c -O -K >> $ps
#----------------->
# map 5 upper left EMAG2
gmt grdimage cf_mag.nc -R14/28/2/11.5 -I+a0+nt1 -JM5.5c \
    -Cm.cpt -O -K -X-3.25i -Y7.2c >> $ps
gmt psbasemap -R14/28/2/11.5 -JM5.5c -Ba -BWSne+t"EMAG2 for CAR" \
    --MAP_TITLE_OFFSET=0.1c -O -K >> $ps
# Bangui magnetic anomaly
gmt psbasemap -R -J -D18/5/22/7r -F+pthickest,white -O -K >> $ps
#----------------->
# map 6 upper right
gmt grdimage cf_mag_wdmam.nc -R14/28/2/11.5 -I+a0+nt1 -JM5.5c -Cn.cpt -O -K -X3.25i >> $ps
# Bangui magnetic anomaly
gmt psbasemap -R -J -D18/5/22/7r -F+pthickest,white -O -K >> $ps
gmt psbasemap -R145/200/-39/0 -JM5.5c -Ba -BWSne+t"WDMAM for CAR" \
    --MAP_TITLE_OFFSET=0.1c -O -K >> $ps
#----------------->
# график
gmt psxy -R3/100/0/1 -JX14.0cl/3.5c -Bxg3f1a2+u" mGal" \
    -Byafg0.2+l"Coherency@+2@+" \
    -BWSnE+t"Coherency between vertical gravity gradient and free-air gravity anomaly" \
    -X-3.25i -Y7.0c cross_spectra.txt -i0,15 -W0.1p -O -K >> $ps
gmt psxy -R -J cross_spectra.txt -i0,15,16 -Sc0.075i -Gred -W0.25p -Ey -O -K >> $ps
#gmt psxy -R -J -T -O -K >> $ps
#
# Step-11. Add GMT logo
gmt logo -Dx3.25i/-2.2i+o-2.0c/-17.5c+w2c -O >> $ps
# Step-15. Convert to image file using GhostScript
gmt psconvert Coherency_CF.ps -A1.0c -E720 -Tj -Z
# Unix
# rm -f cross.txt *_tmp.nc ?.cpt bbox
