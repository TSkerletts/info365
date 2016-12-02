--Give Drivers with most trips a bonus

--This Procedure collects a driver id, increases the annual fare by 5%, and returns the new fare
CREATE OR REPLACE PROCEDURE giveBonus (
p_populardriver	IN NUMBER,
p_driverfname OUT VARCHAR,
p_driverlname OUT VARCHAR,
p_driveroldannualfare OUT NUMBER,
p_drivernewannualfare OUT NUMBER
)
AS


BEGIN
	SELECT first_name,last_name,annual_fare_earned
	INTO p_driverfname,p_driverlname,p_driveroldannualfare
	FROM DRIVER
	WHERE driver_id = p_populardriver;

	p_drivernewannualfare := p_driveroldannualfare + (0.05*p_driveroldannualfare);

	UPDATE Driver SET 
	annual_fare_earned = p_drivernewannualfare
	WHERE driver_id = p_populardriver;

END;
/






--This Procedure collects a driver with most incidents and reduce annual fare by 10%
CREATE OR REPLACE PROCEDURE punishDriver (
p_notoriousdriver IN NUMBER,
p_driverfname OUT VARCHAR,
p_driverlname OUT VARCHAR,
p_driveroldannualfare OUT NUMBER,
p_drivernewannualfare OUT NUMBER
)
AS


BEGIN
	SELECT first_name,last_name,annual_fare_earned
	INTO p_driverfname,p_driverlname,p_driveroldannualfare
	FROM DRIVER
	WHERE driver_id = p_notoriousdriver;

	p_drivernewannualfare := p_driveroldannualfare - (0.1*p_driveroldannualfare);

	UPDATE Driver SET 
	annual_fare_earned = p_drivernewannualfare
	WHERE driver_id = p_notoriousdriver;

END;
/





--  This Procedure collects Id of customers with a certain amount of trips, and add them to the loyalty program.
CREATE OR REPLACE PROCEDURE addToLoyalty(
p_customerId IN NUMBER,
p_customerfname OUT VARCHAR,
p_customerlname OUT VARCHAR,
p_newId	IN OUT NUMBER
)
AS

v_maxId			LOYALTY_PROGRAM.customer_id%TYPE;


BEGIN
	SELECT first_name,last_name
	INTO p_customerfname, p_customerlname
	FROM PICKUPCUSTOMERS
	WHERE customer_id = p_customerId;


	SELECT max(customer_id)
	INTO v_maxId
	FROM LOYALTY_PROGRAM;

	p_newId := v_maxId+1;

	INSERT INTO LOYALTY_PROGRAM (loyalty_id, customer_Id, vehicle_preferences, available_perks) VALUES (p_newId,p_customerId, '4 door car',  'Next Trip is Free');

END;
/




--Before Insert/Update on incident if severity >2 and there’s no insurance informamtion, give an error.

CREATE OR REPLACE TRIGGER checkinsurance_biur
BEFORE INSERT OR UPDATE
ON Incident
FOR EACH ROW
DECLARE
	e_noinsurance				EXCEPTION;	


BEGIN
	IF :new.severity > 2 AND (:new.insurance_company IS NULL OR :new.insurance_name IS NULL OR :new.insurance_number IS NULL) THEN
		Raise e_noinsurance;
	END IF;
		
EXCEPTION
	WHEN e_noinsurance THEN
	RAISE_APPLICATION_ERROR(-20005, 'Complete Insurance Information is required for this severity incident.');


END;
/




--Before insert new customer check if city matches any of the cities already in the customers table, else give an error.
Set SERVEROUTPUT on;
CREATE OR REPLACE TRIGGER checkinspectionstatus_bir
BEFORE INSERT 
ON VEHICLE
FOR EACH ROW
DECLARE
	e_failedInspection				EXCEPTION;	


BEGIN
	IF :new.inspection_status ='fail' THEN
		Raise e_failedInspection;
	END IF;
		
EXCEPTION
	WHEN e_failedInspection THEN
	RAISE_APPLICATION_ERROR(-20004, 'This vehicle can not be reqistered, Vehicle Must Pass inspection');


END;
/



--After insert Trip, add 80% of the fare to drivers annual fare earned.
SET SERVEROUTPUT ON;
CREATE OR REPLACE TRIGGER addDriverFare_air
AFTER INSERT 
ON TRIP
FOR EACH ROW
DECLARE
v_driverId		Driver.driver_id%TYPE;
v_currentFare		Driver.annual_fare_earned%TYPE;
v_newFare		Trip.fare%TYPE;

BEGIN

v_driverId := :new.driver_id;
SELECT annual_fare_earned
INTO v_currentFare
FROM DRIVER
WHERE driver_id = v_driverId;

v_newFare := v_currentFare + (0.8 * :new.fare);

UPDATE DRIVER
SET annual_fare_earned = v_newFare
WHERE driver_id = v_driverId;


DBMS_OUTPUT.PUT_LINE('Fare has been added. The drivers new fare is: '|| v_newFare);


END;
/




-- Function : Search Driver ID: if the vehicleID doesn't match anything in the current database, return "Driver doesn't exist", else return search results.


CREATE OR REPLACE PROCEDURE searchDriverID(
p_driverID IN NUMBER, 
p_fname OUT VARCHAR, 
p_lname OUT VARCHAR,
p_cumrating OUT NUMBER
)
	AS
	
	v_driverINFO DRIVER%ROWTYPE;
	
	

BEGIN


SELECT * into v_driverINFO from DRIVER
WHERE driver_id = p_driverID;

IF  v_driverINFO.driver_id IS NOT NULL then

	

	p_fname := v_driverINFO.first_name;
	p_lname := v_driverINFO.last_name;
	p_cumrating := v_driverINFO.cumulative_rating;


END IF;


END;
/


--  This Procedure collects a reservation Id and adds 10 mins to the reservation time
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE addmoreTime(
p_reservationId IN NUMBER
)
AS
v_oldexpirationtime Reservation.expiration_time%TYPE;
v_newexpirationtime Reservation.expiration_time%TYPE;


BEGIN
	SELECT expiration_time
	INTO v_oldexpirationtime
	FROM Reservation
	WHERE reservation_id = p_reservationId;

	v_newexpirationtime := v_oldexpirationtime + numToDsInterval(10,'minute');
	
	UPDATE Reservation
	SET expiration_time = v_newexpirationtime
	WHERE reservation_id = p_reservationId;

DBMS_OUTPUT.PUT_LINE('Reservation Expiration time has been updated from '||v_oldexpirationtime||' to '|| v_newexpirationtime);
END;
/

