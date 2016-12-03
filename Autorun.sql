--AUTORUN.SQL

--Created On 2-12-2016

--For PickUP Database

--By: Hao-Min Chen, Omotola Akeredolu, Tom Skerletts, Gary Hu


--This script automatically runs commands that create and populates the tables, creates and tests procedures, deletes all tables and functions.

SPOOL autorun.lst;


Pause About to Create tables for the database. The tables are: PickUpCustomers, Friends, Vehicle, Driver, Reservation, Location, Trip, Loyalty_Program, and Incident. Ensure your database doesnt have any tables with these names. <PRESS ENTER TO CONTINUE>
@Create.sql;


Pause About to Insert Values into the tables. <PRESS ENTER TO CONTINUE>
@Insert.sql;



Pause Creating Procedures, Triggers, and functions. Comments in the CreateProcs.sql script will explain what each procedure does. <PRESS ENTER TO CONTINUE>
@Create_Procs.sql



Pause Testing all functions, and triggers. Results of each test wil be shown on the screen. Output will also be spooled to test.lst. <PRESS ENTER TO CONTINUE>
@Test.sql




Pause Cleaning up the database. All tables, functions, triggers, etc, will be removed. <PRESS ENTER TO CONTINUE>
@Cleanup.sql



SPOOL OFF;