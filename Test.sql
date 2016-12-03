SET SERVEROUTPUT ON;

DECLARE
	v_driver_id DRIVER.driver_id%TYPE;
        v_driver_fare DRIVER.annual_fare_earned%TYPE;
        v_driver_commission DRIVER.annual_fare_earned%TYPE;
BEGIN


-- Test trg_check_severity

	INSERT INTO INCIDENT VALUES(90001, 10005, 00019, 12305648, 'AAA', 'Premium', 56882, 5);
	INSERT INTO INCIDENT VALUES(90002, 10005, 00006, 12305891, 'AAA', 'Premium', 56882, 5);

	proc_audit_drivers();

-- Test trg_add_points

	INSERT INTO TRIP VALUES(82126, 30021, 10004, 00009, 'December 15th, 2016', 'December 15th, 2004', '15-DEC-2016 08:11:00 AM', '15-DEC-2004 08:11:00 AM', 3.50);

-- Test func_highest_loyalty

	DBMS_OUTPUT.PUT_LINE('Customer ' || func_highest_loyalty() || ' is our most appreciated loyal customer.');

-- Test func_calc_commission
	v_driver_id := 10015;
	
	SELECT annual_fare_earned INTO v_driver_fare
	FROM DRIVER
	WHERE driver_id = v_driver_id;

	v_driver_commission := func_calc_commission(v_driver_id);

	DBMS_OUTPUT.PUT_LINE('Driver ' || v_driver_id || ' brought in a total fare of ' || v_driver_fare || ' this year and earned ' || v_driver_commission || ' as commission.');
END;
/



--This Tests the p_givebonus Procedure which will increases the annual fare of the driver with max trips by 5%, and return the new fare


DECLARE
v_driverFirstName		Driver.first_name%TYPE;
v_driverLastName		Driver.last_name%TYPE;
v_popularDriverId		Driver.driver_id%TYPE;
v_newFare			Driver.annual_Fare_earned%TYPE;
v_oldFare			Driver.annual_Fare_earned%TYPE;
BEGIN

	Select Max(driver_id) 
	INTO v_popularDriverId
	FROM (Select Count(Driver_Id), Driver_Id
		FROM TRIP
		GROUP BY Driver_Id) Trip;

	giveBonus(v_popularDriverId, v_driverFirstName, v_driverLastName, v_oldFare, v_newFare);

		DBMS_OUTPUT.PUT_LINE(v_driverFirstName||' '||v_driverLastName||' fare has been increased from '||v_oldFare||' to '||v_newFare);
END;
/



--This Tests the p_punishDriver Procedure which will decrease the annual fare of the driver with max incidents by 10%, and return the new fare


DECLARE
v_driverFirstName		Driver.first_name%TYPE;
v_driverLastName		Driver.last_name%TYPE;
v_DriverId			Driver.driver_id%TYPE;
v_newFare			Driver.annual_Fare_earned%TYPE;
v_oldFare			Driver.annual_Fare_earned%TYPE;
BEGIN

	Select Max(driver_id) 
	INTO v_DriverId
	FROM (Select Count(Driver_Id), Driver_Id
		FROM INCIDENT
		GROUP BY Driver_Id) INCIDENT;

	punishDriver(v_DriverId, v_driverFirstName, v_driverLastName, v_oldFare, v_newFare);

		DBMS_OUTPUT.PUT_LINE( 'Due to having too many incidents '||v_driverFirstName||' '||v_driverLastName||' fare has been decreased from '||v_oldFare||' to '||v_newFare);
END;
/


--This Tests the p_addToLoyalty that adds customers who have a certain amount of trips to the loyalty program 


DECLARE
v_FirstName		PickupCustomers.first_name%TYPE;
v_LastName		PickupCustomers.last_name%TYPE;
v_customerId		PickupCustomers.customer_id%TYPE;
v_newLoyaltyId		LOYALTY_PROGRAM.customer_id%TYPE;
CURSOR c_priorityCustomers IS
	SELECT count(customer_id), customer_id 
	FROM TRIP
	GROUP BY customer_id
	HAVING COUNT(customer_id)>3;
v_customerInfo		c_priorityCustomers%ROWTYPE;
BEGIN
	Open c_priorityCustomers;
	LOOP
		FETCH c_priorityCustomers INTO v_customerInfo;
		EXIT WHEN c_priorityCustomers%NOTFOUND;
		v_customerId := v_customerInfo.customer_id;
		addToLoyalty(v_customerId, v_FirstName,v_LastName, v_newLoyaltyId);
		DBMS_OUTPUT.PUT_LINE( 'Customer '||v_FirstName||' '||v_LastName||' has been added to the Loyalty Program!. New Loyalty ID :'|| v_newLoyaltyId);
	
END LOOP;
CLOSE c_priorityCustomers;

END;
/




-- This Tests the checkinsurance_biur Trigger which checks if there is insurance information before insert/update incident else gives an error
UPDATE INCIDENT
SET insurance_company = NULL
WHERE incident_id = 30003;


-- This Tests the checkinspectionstatus_bir Trigger which checks if the inspection status is passes else gives error
INSERT INTO VEHICLE VALUES(021, 'ACURA', '4 door car', 'ilx', 2012, 'fail','FWK412');


-- This Tests the addToFare_air Trigger that adds 80% trip fare to the drivers annual fare after insert on trip

INSERT INTO TRIP VALUES (60021, 30021, 10001, 00001, '20001', '20008', '01-NOV-2016 12:00:00 PM', '01-NOV-2016 12:10:00 PM', 8.00);


-- This Tests the searchDriverID Procedure, which collects a drivers Id and returns the cumulative rating on that driver if they exists else gives an error
DECLARE
 v_first_name 	driver.first_name%TYPE;
 v_last_name 	driver.last_name%TYPE;
 v_driverID 	driver.driver_id%TYPE;
 v_cumRating	driver.cumulative_rating%TYPE;
 
 BEGIN
	SELECT driver_id 
	into v_driverID
	FROM DRIVER
	where last_name LIKE '%Smith%' AND first_name LIKE '%Rogers%';
 
searchDriverID(v_driverID, v_first_name, v_last_name, v_cumRating);
DBMS_OUTPUT.PUT_LINE ('Driver: '||v_first_name||' '|| v_last_name|| ', has rating: '||v_cumRating);

 
 
END;
/


--Test addmoreTime procedure, which collects a reservation_id and add 10 minutes to the reservation time. 
DECLARE
v_reservationId  Reservation.reservation_id%TYPE;

BEGIN
	SELECT reservation_id 
	INTO v_reservationId
	FROM Reservation 
	Where customer_id =00010;

	addmoreTime(v_reservationId);
END;
/


--Test Trigger checkcreditcards_bir should raise an error if insert statement doesnt meet triggers excpectations.
INSERT INTO PICKUPCUSTOMERS VALUES(00021,'Jen', 'Jackson', 3456345339987098, 'JEN JACKSON', TO_DATE(20171007, 'YYYYMMDD'), '5510 Lawnsdowne', 'Philadelphia');

--Test Trigger checkfriends_air should return information on friends online
INSERT INTO RESERVATION VALUES (30023, 00011, 10001, '01-NOV-2016 12:15:00 PM', '01-NOV-2016', '01-NOV-2016 12:00:00 PM');


--Test Trigger reducerating_air should reduce driver rating and display new rating
INSERT INTO INCIDENT VALUES (30500, 10011, 00003, 10000020, 'GEICO', 'INCIDENT #1', 41110, 3);

--Test Trigger checkcities_bir should raise an error if The city of the new customer doesnt exist in the database
INSERT INTO PICKUPCUSTOMERS VALUES(00022,'Janett', 'French', 3456345339987098, 'JANE FRENCH', TO_DATE(20181007, 'YYYYMMDD'), '8920 Lawnsdowne', 'DC');