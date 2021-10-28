BEGIN

DROP TABLE IF EXISTS chicago_city_il_building_footprint_raw_temp;
CREATE TEMP TABLE chicago_city_il_building_footprint_raw_temp
AS TABLE location_team.chicago_city_il_building_footprint_raw;

-- Delete buildings without geometry

DELETE FROM chicago_city_il_building_footprint_raw_temp
WHERE geom is NULL;

-- Delete buildings with bad geometry

DELETE FROM chicago_city_il_building_footprint_raw_temp
WHERE NOT ST_IsValid(geom);

-- If the transform table exists, then get the data_source_id then update the ref table.

if (SELECT to_regclass('location_team.chicago_city_il_building_footprint_transform') is not NULL) then
	UPDATE location_team.c2f_location_data_source_ref
		SET last_modified_by=current_user, last_modified_date=current_timestamp
		WHERE id = (SELECT DISTINCT data_source_id FROM location_team.chicago_city_il_building_footprint_transform);
	raise notice 'Transform table found. Updating record.';

else
	raise notice 'Transform table NOT found. Inserting new record.';
	INSERT INTO location_team.c2f_location_data_source_ref(
		data_type,
		jurisdiction_name,
		jurisdiction_level, -- City/County/State/...
		data_source_name,
		data_source_url,
		api_end_point, -- url for the geojson/shp/gpkg/etc.
		api_end_point_type, -- file format
		data_source_hierarchy, -- 2 = city, 3 = county, 6 = state
		first_entered_by,
		first_entered_date,
		last_modified_by,
		last_modified_date,
		sp_name,
		raw_table_name
		)
		VALUES ('building footprint',
				'Chicago, IL',
				'City',
				'Chicago Data Portal',
				'https://data.cityofchicago.org/Buildings/Building-Footprints-current-/hz9b-7nh8',
				'https://data.cityofchicago.org/api/geospatial/hz9b-7nh8?method=export&format=GeoJSON',
				'geojson',
				2,
				current_user,
				current_timestamp,
				current_user,
				current_timestamp,
				'location_team.chicago_city_il_building_footprint_transform()',
				'location_team.chicago_city_il_building_footprint_raw'
			   );
end if;

--------------------------------------------

-- Create table

DROP TABLE IF EXISTS location_team.chicago_city_il_building_footprint_transform;
CREATE TABLE location_team.chicago_city_il_building_footprint_transform(
	    LIKE dataset.md_building_footprint including all);


INSERT INTO location_team.chicago_city_il_building_footprint_transform
	(
	data_source_id,
	city_id,
	state_id,
	country_id,
	sq_feet,
	num_of_story,
	bldg_class,
	latitude,
	longitude,
	geom,
	geom_centroid_inside
	)
	SELECT distinct on (geom) n.* from
		(
		SELECT
		ref.id,
		r."Id" as city_id,
		r."StateId" as state_id,
		223 as country_id,
		a.bldg_sq_fo,
		a.stories,
		(case
		 when stories > 1 then 'M'
			else 'S'
		END) as bldg_class,
		ROUND(ST_Y(st_pointonsurface(ST_Transform(a.geom, 4326)))::numeric, 6) AS latitude,
		ROUND(ST_X(st_pointonsurface(ST_Transform(a.geom, 4326)))::numeric, 6) AS longitude,
		a.geom,
		st_pointonsurface(a.geom) as geom_centroid_inside

		FROM location_team.c2f_location_data_source_ref as ref, chicago_city_il_building_footprint_raw_temp as a

	LEFT JOIN dataset.c2f_us_city_boundary AS b
	ON ST_Intersects(a.geom, b.geom)

	LEFT JOIN (
		select c."Id", s."StateId", c."Name", s."Abbrev" from fd_mysql.city_local c, fd_mysql.state_local s
			where c."StateId" = s."StateId" and c.country_id = 223) as r
	on b.c2f_city = r."Name" and b.c2f_state = r."Abbrev"

	where ref.data_type = 'building footprint' and jurisdiction_name = 'Chicago, IL') as n;


DROP TABLE IF EXISTS chicago_city_il_building_footprint_raw_temp;
ALTER TABLE location_team.chicago_city_il_building_footprint_transform OWNER TO role_gis_analysts_createtable;
END;
