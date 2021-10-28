'Srdjan Stancic - 08/02/2021'
'run function'

import psycopg2

con = psycopg2.connect(database="***", user="***", password="***", host="localhost", port="5432")
print("Connected successfully")

#Open a cursor
cur = con.cursor()

# Execute a function
cur.execute("SELECT location_team.chicago_building_footprint_transform();")

cur.close()
con.commit()
con.close()

# Transform table
print("You have successfully transform table - Chicago building footprints -")