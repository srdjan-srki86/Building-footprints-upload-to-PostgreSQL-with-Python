"""Srdjan Stancic - 08/02/2021"""
'upload data from local to Postgres'

import os

connection = r"host=localhost port=5432 dbname=*** user=*** password=***"
schema = "location_team"
target_shp = r"***\buildings.shp"
cmd = r'start cmd /k ogr2ogr -f "PostgreSQL" PG:"%s" -lco SCHEMA=%s "%s" ' \
          r'-nln building_footprint_raw -t_srs "EPSG:4326" -overwrite -progress -lco OVERWRITE=YES ' \
          r'-overwrite -progress --config PG_USE_COPY YES -nlt PROMOTE_TO_MULTI -lco GEOMETRY_NAME=geom ' \
          r'-lco precision=NO' \
          % (connection, schema, target_shp)
os.system(cmd)

print("You have successfully uploaded the file to postgres - Chicago building footprints")




