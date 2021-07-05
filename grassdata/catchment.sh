#!/bin/bash
# Purpose: Demo script to learn GRASS environment using a hydrology example 
# Source: https://xycarto.com/2020/05/03/basic-grass-gis-with-bash/

# set base path
outDir=grassdata/GRASS_ENV/PERMANENT/JM

# Set raster as variable
raster=${outDir}/JM.tif

# Set a base name for the data. This is used to demonstrate that normal BASH commands
# can be used in this process, along side GRASS
# I think this line is taking the 'JM' from our raster and removing the .tif
rasterName=$( basename $raster | sed 's/.tif//g' )

# Import raster data
r.in.gdal input=$raster output=$rasterName --overwrite

# Set region. IMPORTANT so GRASS knows where the data is located.
# This region is set for the duration of the following commands
g.region rast=$rastName

# Fill sinks
fillDEM=${rasterName}_filldem
directionDEM=${rasterName}_directiondem
areasDEM=${rasterName}_areasDEM
r.fill.dir input=$rasterName output=$fillDEM direction=$directionDEM areas=$areasDEM --overwrite

# Export a raster for viewing
areaOut=${outDir}/${raster}_areas.tif
r.out.gdal input=$areasDEM output=$areaOut

# Run watershed operation on fill sink raster
threshold=100000
accumulation=${rasterName}_accumulation
drainage=${rasterName}_drainage
stream=${rasterName}_stream
basin=${rasterName}_basin
r.watershed elevation=$fillDEM threshold=$threshold accumulation=$accumulation drainage=$drainage stream=$stream basin=$basin --overwrite

# Convert Basin (watershed) to vector format
basinVect=${rasterName}_basinVect
r.to.vect input=$basin output=$basinVect type=area column=bnum --overwrite

# Export catchment to vector format
basinVectOut=${outDir}/Output/${rasterName}_basinVectOut.shp
v.out.ogr input=$basinVect output=$basinVectOut type=area format=ESRI_Shapefile --overwrite
