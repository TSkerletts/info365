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
Set SERVEROUTPUT on;
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
Set SERVEROUTPUT on;
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
Set SERVEROUTPUT on;
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