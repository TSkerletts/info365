--Before Insert Customer, if Customer credit card is expired, give an error
CREATE OR REPLACE TRIGGER checkcreditcards_bir
BEFORE INSERT 
ON PickupCustomers
FOR EACH ROW
DECLARE
	e_expiredcreditcard EXCEPTION;	

BEGIN
	IF :new.expiration_date < Trunc(SYSDATE) THEN
		RAISE e_expiredcreditcard;
	END IF;

EXCEPTION
	WHEN e_expiredcreditcard THEN
		RAISE_APPLICATION_ERROR (-20002, 'Attempted Customer Entry failed, '||:new.first_name
		||' '||:new.last_name||' Credit card expired!'
);
END;
/






-- After insert Reservvations, check and return information on any friend that is also online.

CREATE OR REPLACE TRIGGER checkfriends_air
AFTER INSERT 
ON Reservation
FOR EACH ROW
DECLARE
	v_customerId		Reservation.customer_Id%TYPE;	
	
	CURSOR c_friends IS
	SELECT *
	FROM FRIENDS
	WHERE customer_id = v_customerId
	AND status = 'online';
	
	v_friendsList		c_friends%ROWTYPE;

BEGIN
	v_customerId := :new.customer_id;
	OPEN c_friends;
		LOOP
			FETCH c_friends INTO v_friendsList;
			EXIT WHEN c_friends%NOTFOUND;
			
				DBMS_OUTPUT.PUT_LINE(v_friendsList.facebook_username||' is '||						v_friendsList.status);
			
			
		END LOOP;
	CLOSE c_friends;	
END;
/




-- After Insert Incident, driver associated with incident gets a reduction to their rating..

CREATE OR REPLACE TRIGGER reducerating_air
AFTER INSERT 
ON Incident
FOR EACH ROW
DECLARE
	v_oldrating		Driver.cumulative_rating%TYPE;	
	v_newrating		Driver.cumulative_rating%TYPE;
	v_driverId		Incident.driver_id%TYPE;
	v_driver		Driver%ROWTYPE;
	
	
BEGIN
	v_driverId := :new.driver_id;

	SELECT *
	INTO v_driver
	FROM Driver
	WHERE driver_id = v_driverid;
	
	v_oldrating := v_driver.cumulative_rating;
	v_newrating := v_oldrating - 10;

	UPDATE DRIVER SET cumulative_rating = v_newrating
	WHERE driver_id = v_driverId;

	DBMS_OUTPUT.PUT_LINE (v_driver.first_name||' '||v_driver.last_name||' rating reduced 	from '||v_oldrating||' to'||v_newrating);
END;
/

--Before insert new customer check if city matches any of the cities already in the customers table, else give an error.

CREATE OR REPLACE TRIGGER checkcity_bir
BEFORE INSERT 
ON PICKUPCUSTOMERS
FOR EACH ROW
DECLARE
	e_unoperational				EXCEPTION;	
	v_newCity				PickupCustomers.city%TYPE;
	v_citycovered				BOOLEAN;	
	CURSOR c_cities IS
		SELECT DISTINCT City
		FROM PickupCustomers
		WHERE city = v_newCity;
	
	v_allCities				c_cities%ROWTYPE;
BEGIN
	v_newCity := :new.city;
	v_citycovered := false;
	OPEN c_cities;
		LOOP
			FETCH c_cities INTO v_allCities;
			EXIT WHEN c_cities%NOTFOUND;
			v_citycovered := true;
		END LOOP;
	CLOSE c_cities;
	
	IF NOT v_citycovered THEN
		Raise e_unoperational;
	END IF;
		
EXCEPTION
	WHEN e_unoperational THEN
	RAISE_APPLICATION_ERROR(-20003,'We apologise but Our Cabs do not operate in '||:new.city);


END;
/

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



-- Returns the customer ID  with the highest number of loyalty points
-- Will return the customer with a lower loyalty ID as they've been in the program longer
CREATE OR REPLACE FUNCTION func_highest_loyalty
RETURN NUMBER
IS
	v_customer_id LOYALTY_PROGRAM.customer_id%TYPE;
	v_loyalty_id LOYALTY_PROGRAM.loyalty_id%TYPE;
BEGIN
	SELECT MIN(loyalty_id) INTO v_loyalty_id
	FROM LOYALTY_PROGRAM
	WHERE loyalty_points = (SELECT MAX(loyalty_points)
				FROM LOYALTY_PROGRAM);

	SELECT customer_id INTO v_customer_id
	FROM LOYALTY_PROGRAM
	WHERE loyalty_id = v_loyalty_id;

	RETURN v_customer_id;
END;
/


-- Takes a driver ID and calculates their annual commission they should be paid based on their annual fare

CREATE OR REPLACE FUNCTION func_calc_commission(p_driver_id IN NUMBER)
RETURN NUMBER
IS
	v_commission DRIVER.annual_fare_earned%TYPE;
BEGIN
	SELECT annual_fare_earned INTO v_commission
	FROM DRIVER
	WHERE driver_id = p_driver_id;

	v_commission := v_commission * 0.333;

	RETURN v_commission;
END;
/


-- Removes drivers from the database given they have enough incidents

CREATE OR REPLACE PROCEDURE proc_audit_drivers
AS
	v_total_severity NUMBER(2);
	v_driver_id DRIVER.driver_id%TYPE;

	CURSOR driver_ids IS
		SELECT driver_id
		FROM DRIVER;
BEGIN
	OPEN driver_ids;
	LOOP
		FETCH driver_ids INTO v_driver_id;
		EXIT WHEN driver_ids%NOTFOUND;

		SELECT SUM(severity) INTO v_total_severity
		FROM INCIDENT
		WHERE driver_id = v_driver_id;

		IF v_total_severity >= 10 THEN
			DELETE FROM DRIVER
			WHERE driver_id = v_driver_id;
			DBMS_OUTPUT.PUT_LINE('Driver ' || v_driver_id || ' dropped from program due to sustained traffic incidents.');
		END IF;
	END LOOP;
END;
/


-- After Insert Trip, check if Customer is in Loyalty Program
-- If so, add points to their account

CREATE OR REPLACE TRIGGER trg_add_points
	AFTER INSERT ON TRIP
	FOR EACH ROW
DECLARE
	v_old_points LOYALTY_PROGRAM.loyalty_points%TYPE;
BEGIN
	SELECT loyalty_points INTO v_old_points
	FROM LOYALTY_PROGRAM
	WHERE customer_id = :new.customer_id;
 
	UPDATE LOYALTY_PROGRAM
	SET loyalty_points = v_old_points + 100
	WHERE customer_id = :new.customer_id;

	IF SQL%NOTFOUND THEN
		DBMS_OUTPUT.PUT_LINE('Customer not in loyalty proram, no points added to account.');
	ELSE
		DBMS_OUTPUT.PUT_LINE('100 points added to Customer ' || :new.customer_id || '''s loyalty program account.');
	END IF;
END;
/
