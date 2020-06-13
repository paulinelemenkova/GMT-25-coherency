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
#grdcut vvtc_grav.grd -R162.5/181.5/-24/-6.0 -Gvvtcs_grav.nc

# Step-3. Extract subsets of img/grd files in Mercator or Geographic format
grdcut earth_relief_01m.grd -R145/200/-39/0 -Gau_relief.nc

grdcut earth_relief_01m.grd -R162.5/181.5/-24/-6.0 -Gvvtc_relief.nc
grdcut geoid.egm96.grd -R162.5/181.5/-24/-6.0 -Gvvtc_geo.nc
img2grd grav_27.1.img -R162.5/181.5/-24/-6.0 -Gvvtc_grav.grd -T1 -I1 -E -S0.1 -V
img2grd grav_27.1.img -R145/200/-39/0 -Gau_geo.grd -T1 -I1 -E -S0.1 -V
img2grd curv_27.1.img -R162.5/181.5/-24/-6.0 -Gvvtc_curv.grd -T1 -I1 -E -S0.01 -V
#grdcut GEBCO_2019.nc -R145/200/-39/0 -Gvvtc_grav.nc
#
#grdinfo vvtcs_relief.nc
#grdinfo vvtc_grav.nc
#grdinfo vvtc_grav.grd
gmt grdfft vvtc_grav.grd vvtc_curv.grd -E+wk+n -Na+d+wtmp > cross_spectra.txt
#gmt dimfilter vvtc_relief.nc -Gvvtc_relief_f.nc -Fm600 -D4 \
#   -Nl6 -R162.5/181.5/-24/-6.0 -I0.5 -V -T

ps=Coherency.ps
gmt set FONT_TITLE 12p
    MAP_TITLE_OFFSET=0.1c
    MAP_GRID_PEN_PRIMARY thinnest,-
    GMT_FFT kiss
#
gmt makecpt -Crainbow -T-8800/1500 > z.cpt
gmt makecpt -Crainbow -T23/68 > g.cpt
#
# карта 1 внизу слева
gmt grdimage vvtc_relief.nc -R162.5/181.5/-24/-6.0 \
    -I+a0+nt1 -JM5.5c -Cz.cpt -P -K -X1.474i -Y1i > $ps
gmt psbasemap -R162.5/181.5/-24/-6.0 -JM5.5c \
    -Ba -BWSne+t"ETOPO1 bathymetry"  \
    -UBL/-5p/-40p \
    --MAP_TITLE_OFFSET=0.1c -O -K >> $ps
#
# карта 2 внизу справа
gmt grdimage vvtc_geo.nc -R162.5/181.5/-24/-6.0 \
    -I+a0+nt1 -JM5.5c -Cg.cpt -O -K -X3.25i >> $ps
gmt psbasemap -R162.5/181.5/-24/-6.0 -JM5.5c \
    --MAP_TITLE_OFFSET=0.1c -Ba -BWSne+t"Geoid model EGM96" -O -K  >> $ps
#
#grdinfo vvtc_curv.grd
#grdinfo vvtc_grav.nc
gmt makecpt -Cdrywet.cpt -T-27/42 > c.cpt
#gmt makecpt -Cwysiwyg -T-313/472 > v.cpt
#
# карта 3 вверху слева
gmt grdimage vvtc_curv.grd -R162.5/181.5/-24/-6.0 -I+a0+nt1 -JM5.5c \
    -Cc.cpt -O -K -X-3.25i -Y7.2c >> $ps
gmt psbasemap -R162.5/181.5/-24/-6.0 -JM5.5c -Ba \
    -BWSne+t"Satellite derived vertical gravity gradient" \
    --MAP_TITLE_OFFSET=0.1c -O -K >> $ps
# карта 4 вверху справа
gmt grdimage vvtc_grav.nc -R162.5/181.5/-24/-6.0 -I+a0+nt1 -JM5.5c -CGMT_haxby -O -K -X3.25i >> $ps
gmt psbasemap -R162.5/181.5/-24/-6.0 -JM5.5c -Ba -BWSne+t"Free-air gravity anomaly" \
    --MAP_TITLE_OFFSET=0.1c -O -K >> $ps
#
# карта 5 вверху слева
gmt grdimage au_relief.nc -R145/200/-39/0 -I+a0+nt1 -JM5.5c \
-Cjet.cpt -O -K -X-3.25i -Y7.2c >> $ps
gmt psbasemap -R145/200/-39/0 -JM5.5c -Ba -BWSne+t"ETOPO1: detrened and extended" \
    --MAP_TITLE_OFFSET=0.1c -O -K >> $ps
# Study area
gmt psbasemap -R -J -D162.5/-24/181.5/-6.0r -F+pthickest,red -O -K >> $ps
# карта 6 вверху справа
gmt grdimage au_geo.grd -R145/200/-39/0 -I+a0+nt1 -JM5.5c -Cpanoply.cpt -O -K -X3.25i >> $ps
# Study area
gmt psbasemap -R -J -D162.5/-24/181.5/-6.0r -F+pthickest,red -O -K >> $ps
gmt psbasemap -R145/200/-39/0 -JM5.5c -Ba -BWSne+t"Free-air gravity: detrened and extended" \
    --MAP_TITLE_OFFSET=0.1c -O -K >> $ps
#
# график
gmt psxy -R3/100/0/1 -JX14.0cl/3.5c -Bxg3f1a2+u" mGal" \
    -Byafg0.2+l"Coherency@+2@+" \
    -BWSnE+t"Coherency between vertical gravity gradient and free-air gravity" \
    -X-3.25i -Y7.0c cross_spectra.txt -i0,15 -W0.1p -O -K >> $ps
gmt psxy -R -J cross_spectra.txt -i0,15,16 -Sc0.075i -Gred -W0.25p -Ey -O -K >> $ps
#gmt psxy -R -J -T -O -K >> $ps
#
# Step-11. Add GMT logo
gmt logo -Dx3.25i/-2.2i+o-2.0c/-17.5c+w2c -O >> $ps
# Step-15. Convert to image file using GhostScript
gmt psconvert Coherency.ps -A1.0c -E720 -Tj -Z
# Unix
# rm -f cross.txt *_tmp.nc ?.cpt bbox
