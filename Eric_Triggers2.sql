-- After Insert Trip, add fare to Driver’s annual fare earned

SET SERVEROUTPUT ON;
CREATE OR REPLACE TRIGGER addFare

AFTER INSERT
ON TRIP
FOR EACH ROW
DECLARE
	v_oldfare	DRIVER.annual_fare_rating.%TYPE;
	v_newfare	DRIVER.annual_fare_rating.%TYPE;
	v_driverID	DRIVER.driver_id%TYPE;
	v_driver	DRIVER%ROWTYPE;
	v_fare		TRIP.fare.%TYPE;
	
BEGIN
	v_driverID := :new.driver_id;
	
	SELECT *
	INTO v_driverID
	FROM DRIVER
	WHERE driver_id = v_driverID;
	
	v_oldfare := v.driver.annual_fare_rating;
	v_newfare := v_oldfare + v_fare;
	
	UPDATE DRIVER SET annual_fare_rating = v_newfare
	WHERE driver_id = v_driverID;