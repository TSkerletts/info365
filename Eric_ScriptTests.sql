-- Test script for Eric_Triggers.sql
-- It is testing checkVehicle_bir
INSERT INTO VEHICLE VALUES(021, 'Toyota', '2 door car', '370Z', 2014, 'fail','MNY-4588');

-- Test script Eric_Procedure2.sql
-- It is testing searchDriverID
SET SERVEROUTPUT ON;


DECLARE
 v_first_name 	driver.first_name%TYPE;
 v_last_name 	driver.last_name%TYPE;
 v_driverID 	driver.driver_id%TYPE;
 
 BEGIN
 
 SELECT driver_id from DRIVER
 into v_driverID
 where last_name = 'Smith' AND first_name = 'Rogers';
 
 searchDriverID(v_driverID, v_first_name, v_last_name);
 DBMS_OUTPUT.PUT_LINE (v_first_name||' '|| v_last_name);
 
 
 END;
 /