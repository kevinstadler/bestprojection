#!/bin/sh

IN="/Volumes/Samsung USB/Geodata/Natural Earth/HYP_50M_SR_W/HYP_50M_SR_W.tif"
OUT="shrunk.tif"
if [ ! -f "$OUT" ]; then
  gdal_translate -outsize 25% 25% -r bilinear "$IN" "$OUT"
fi

PROJ="EPSG:3857"
NAME="mercator"

#PROJ="+proj=cea +lat_ts=45"
#NAME="gallpeters"

PROJ="+proj=cea +lat_ts=37.5"
NAME="hobodyer"

PROJ="ESRI:53009"
NAME="mollweide"
gdalwarp -dstalpha -t_srs "$PROJ" -r bilinear -ts 640 0 -to OGR_ENABLE_PARTIAL_REPROJECTION=TRUE -overwrite "$OUT" "$NAME.tif"
gdal_rasterize -b 1 2 3 -burn 161 90 90 "/Volumes/Samsung USB/Geodata/Natural Earth/ne_10m_graticules_15.shp" "$NAME.tif"
convert "$NAME.tif" "$NAME.png"
