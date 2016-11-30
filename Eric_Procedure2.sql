-- Function : Search Driver ID: if the vehicleID doesn't match anything in the current database, return "Driver doesn't exist", else return search results.


CREATE OR REPLACE PROCEDURE searchDriverID(p_driverID IN NUMBER, p_fname OUT VARCHAR, p_lname OUT VARCHAR)
	AS
	
	v_driverINFO DRIVER%ROWTYPE;
	
	

BEGIN

/* Reconize and check for the uner input of a driver's ID number with the database.*/
SELECT * into v_driverINFO from DRIVER
WHERE driver_id = p_driverID;

IF NOT NULL v_driverINFO then

p_fname := v_driverINFO.first_name;
p_lname := v_driverINFO.last_name;

END IF;

END searchDriverID;
/
