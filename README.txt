README.txt

Created On 2-12-2016

For PickUP Database

By: Hao-Min Chen, Omotola Akeredolu, Tom Skerletts, Gary Hu

----------------------------------------------------------------------------------------------



This document describes the scripts to create, test, and delete the Pickup Database

and provides instructions for using these scripts.


==============================================================================================
					
					Script Descriptions

1. Create.sql - This script creates the 9 tables required for the pickup database. The Tables are named PickUpCustomers, Friends, Vehicle, Driver, Reservation, Location, Trip, Loyalty_Program, and Incident.  At the top of the script there are drop statements to drop the tables before creating them to avoid errors.



2. Insert.sql - This script contains insert statements to populate all tables in the pickup database.



3. Autorun.sql - This script runs automatically runs through all set up and cleanup phases. Output will be spooled to autorun.lst



4. Test.sql - This script contains several sql and pl/sql statememts that test all procedures and triggers created with the Create_Procs.sql script. 


5. Create_Procs.sql - This script creates all procedures and triggers for our database. The script doesnt spool a file, but there are comments within it to explain what each procedur does.



6. Cleanup.sql - This script deletes all tables, procedures, functions and triggers for the pickup database.


==============================================================================================
					
					Using the Scripts

[Note: You can create the database manually by following the steps below, or automatically using Autorun.sql. Output will be spooled to autorun.lst
]

1. Setting up the database
	
	Database set up requires two main scripts:

	1.1 Create.sql - This script is run with the @Create.sql command in the ssh shell
	1.2 Insert.sql - This script is run with the @Insert.sql command in the ssh shell


2. Setting and Testing up Procedures, Functions and Triggers



	2.2 Test.sql - This script is run with the @Test.sql command in the ssh shell. All output will spooled to test.lst file




3. Cleanup
