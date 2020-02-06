#!/bin/bash

IN="/Volumes/Samsung USB/Geodata/Natural Earth/HYP_50M_SR_W/HYP_50M_SR_W.tif"
OUT="shrunk.tif"
if [ ! -f "$OUT" ]; then
	gdal_translate -outsize 50% 50% -r cubic "$IN" "$OUT"
fi

WIDTH=1000
render () {
	gdalwarp -dstalpha -r cubic -t_srs "$2" -ts $WIDTH 0 -overwrite "$OUT" "$1.tif"
	#-to OGR_ENABLE_PARTIAL_REPROJECTION=TRUE

	# https://gis.stackexchange.com/questions/111927/crop-and-reproject-shapefile-based-on-geotiff-sample
	ogr2ogr -t_srs "$2"	--config OGR_ENABLE_PARTIAL_REPROJECTION TRUE "graticules.shp" "/Volumes/Samsung USB/Geodata/Natural Earth/ne_10m_graticules_15.shp"

	gdal_rasterize -b 1 2 3 -burn 161 90 90 "graticules.shp" "$1.tif"
	convert "$1.tif" "$1.png"
}

render mercator "EPSG:3857"
render gallpeters "+proj=cea +lat_ts=45"
render hobodyer "+proj=cea +lat_ts=37.5"
render mollweide "+proj=moll +lon_0=0 +x_0=0 +y_0=0 +a=6371000 +b=6371000 +units=m +no_defs"
render goode "+proj=igh +lat_0=0 +lon_0=0 +datum=WGS84 +units=m +no_defs"
