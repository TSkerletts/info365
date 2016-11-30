-- Before Insert Vehicle, if Vehicle’s inspection status returns “fail”, return an error.

CREATE OR REPLACE TRIGGER checkVehicle_bir

BEFORE INSERT
ON VEHICLE
FOR EACH ROW
DECLARE
	v_failedvehicle		EXCEPTION;
	v_inspectionstatus	VEHICLE.inspection_status%TYPE;
	
	
BEGIN
	IF :new.inspection_status = 'fail' THEN
		RAISE v_failedvehicle;
	END IF;
	
EXCEPTION
	WHEN v_failedvehicle THEN
		RAISE_APPLICATION_ERROR (-20011, 'Vehicle inspection status failed,' );
		
END;
/



	
	
