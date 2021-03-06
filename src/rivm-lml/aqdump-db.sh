#!/bin/bash
# Dumps all aq data in Postgres from LML and other projects.
#
. options.sh

outdir=/var/www/sensors.geonovum.nl/site/aqdump

/bin/rm -rf ${outdir}
mkdir -p ${outdir}/lml/shape
mkdir -p ${outdir}/lml/csv
mkdir -p ${outdir}/smartemission/shape
mkdir -p ${outdir}/smartemission/csv

components="nh3 no no2 so2 o3 pm10 pm25 co"
time_slice_sql=" where sample_time >=  '2015-08-15' AND sample_time < '2015-08-18'"
# components="nh3 co"
for comp in $components
do
  # Full dump files
  outfile=${outdir}/lml/shape/lml-${comp}.shp
  sql="SELECT * FROM rivm_lml.v_measurements_$comp"
  pg="host=${PGHOST} user=${PGUSER} dbname=sensors password=${PGPASSWORD}"
  echo "shapefile gen"
  ogr2ogr -f "ESRI Shapefile" ${outfile}  PG:"${pg}" -sql "$sql" -fieldTypeToString DateTime

  echo "csv gen"
  outfile=${outdir}/lml/csv/lml-${comp}.csv
  ogr2ogr -f CSV ${outfile}  PG:"${pg}" -sql "$sql" -lco GEOMETRY=AS_XY -fieldTypeToString DateTime

  # Small sample files  (couple of days data)
  outfile=${outdir}/lml/shape/lml-${comp}-small.shp
  sql="SELECT * FROM rivm_lml.v_measurements_$comp ${time_slice_sql}"
  pg="host=${PGHOST} user=${PGUSER} dbname=sensors password=${PGPASSWORD}"
  echo "shapefile small gen"
  ogr2ogr -f "ESRI Shapefile" ${outfile}  PG:"${pg}" -sql "$sql" -fieldTypeToString DateTime

  echo "csv small gen"
  outfile=${outdir}/lml/csv/lml-${comp}-small.csv
  ogr2ogr -f CSV ${outfile}  PG:"${pg}" -sql "$sql" -lco GEOMETRY=AS_XY -fieldTypeToString DateTime

done

components="no2 co o3"
for comp in $components
do
  outfile=${outdir}/smartemission/shape/smartem-${comp}.shp
  sql="SELECT * FROM smartem.v_measurements_$comp"
  pg="host=${PGHOST} user=${PGUSER} dbname=sensors password=${PGPASSWORD}"
  ogr2ogr -f "ESRI Shapefile" ${outfile}  PG:"${pg}" -sql "$sql" -fieldTypeToString DateTime

  outfile=${outdir}/smartemission/csv/smartem-${comp}.csv
  ogr2ogr -f CSV ${outfile}  PG:"${pg}" -sql "$sql" -lco GEOMETRY=AS_XY -fieldTypeToString DateTime
done

pushd ${outdir}
/opt/bin/zipdir lml ${outdir}/lml.zip
/opt/bin/zipdir smartemission ${outdir}/smartemission.zip
popd
