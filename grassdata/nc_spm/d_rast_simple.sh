#!/bin/sh
# Purpose: Script to set computational region to a raster map
# Usage: d.rast.region rastermap

g.region rast=$1
d.erase
d.rast $1
exit 0
