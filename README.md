# Building-footprints-upload-to-PostgreSQL-with-Python
Goal is to make one table of building footprints for whole of US - process automation.  Python and GDAL need to be installed in this process.



# Install GDAL on WIN 10 64bit

https://www.gisinternals.com/release.php

https://download.gisinternals.com/sdk/downloads/release-1900-x64-gdal-2-4-4-mapserver-7-4-3/gdal-204-1900-x64-core.msi

# After installation, it is necessary to add a path


![image1_new](https://user-images.githubusercontent.com/39372009/139333254-7fa31608-0b18-4ff7-acbc-804fdb582077.jpeg)

![image2_new](https://user-images.githubusercontent.com/39372009/139333282-1a791e44-4607-47f7-88ea-f6357db6a5fd.jpeg)

# After installing Python and GDAL, it is necessary to install libraries

1. fill in the script with the necessary data
2. the order in which the scripts are run (it is also necessary to set the function to Postgres - function.sql for example)
	- download_unzip
	- upload_to_postgres
	- run_function
