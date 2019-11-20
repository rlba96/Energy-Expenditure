#!/usr/bin/env python
import sqlite3

print("BITalino Database")

# Database
database = "data.db"

database = sqlite3.connect(database)
cursor = database.cursor()


print("")
print("Configurations:")

cursor.execute("Select * from Configuration")
for config in cursor.fetchall():
    print(config)

print("")
print("Data:")

cursor.execute("Select * from Data")
for data in cursor.fetchall():
    print(data)

