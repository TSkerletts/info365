--This File contains Creates Table statements for PickUP
-- Class: INFO365
-- Term: Fall 2016

--You'll probably get an error if the table hasn't been created yet. That's fine!

DROP TABLE FRIENDS CASCADE CONSTRAINTS;
DROP TABLE RESERVATION CASCADE CONSTRAINTS;
DROP TABLE LOCATION CASCADE CONSTRAINTS;
DROP TABLE TRIP CASCADE CONSTRAINTS;
DROP TABLE LOYALTY_PROGRAM CASCADE CONSTRAINTS;
DROP TABLE INCIDENT CASCADE CONSTRAINTS;
DROP TABLE VEHICLE CASCADE CONSTRAINTS;
DROP TABLE DRIVER CASCADE CONSTRAINTS;
DROP TABLE PICKUPCUSTOMERS CASCADE CONSTRAINTS;

CREATE TABLE PICKUPCUSTOMERS(
	customer_id			NUMBER(5) PRIMARY KEY NOT NULL,
	first_name 			VARCHAR(55) NOT NULL,
	last_name 			VARCHAR(55) NOT NULL,
	--ranking 			NUMBER(10),
	credit_card_number 		NUMBER(16),
	credit_card_name 		VARCHAR(110),
	expiration_date 		DATE,
	location  			VARCHAR(225),
	city				VARCHAR(50),
	CONSTRAINT Cfullname UNIQUE (first_name, last_name));

CREATE TABLE FRIENDS(
	facebook_username		VARCHAR(110) PRIMARY KEY NOT NULL,
	customer_id			NUMBER(5) NOT NULL,
	address				VARCHAR(250),
	status				VARCHAR(7),
	current_location		VARCHAR(20),
	CONSTRAINT FcustomerID
		FOREIGN KEY (customer_id)
		REFERENCES PICKUPCUSTOMERS(customer_id) ON DELETE CASCADE,
	CONSTRAINT check_status CHECK (status IN('online','offline', 'incab')));

CREATE TABLE VEHICLE(
	vehicle_id			NUMBER(5) PRIMARY KEY NOT NULL,
	make				VARCHAR(20),
	type				VARCHAR(10),
	model				VARCHAR(20),
	year				NUMBER(4),
	inspection_status		VARCHAR(4) NOT NULL,
	plate_number			VARCHAR(15) NOT NULL,
	CONSTRAINT plate UNIQUE (plate_number),
	CONSTRAINT check_istatus CHECK (inspection_status IN('pass', 'fail')));

CREATE TABLE DRIVER(
	driver_id			NUMBER(5) PRIMARY KEY NOT NULL,
	first_name			VARCHAR(55) NOT NULL,
	last_name			VARCHAR(55) NOT NULL,
	cumulative_rating		NUMBER(3),
	annual_fare_earned		NUMBER(7,2),
	vehicle_id			NUMBER(5) NOT NULL,		
	CONSTRAINT DvehicleID
		FOREIGN KEY (vehicle_id)
		REFERENCES VEHICLE(vehicle_id) ON DELETE CASCADE,
	CONSTRAINT one_vehicle UNIQUE (vehicle_id));


CREATE TABLE RESERVATION(
	reservation_id			NUMBER(5) PRIMARY KEY NOT NULL,
	customer_id			NUMBER(5) NOT NULL,
	driver_id			NUMBER(5) NOT NULL,
	expiration_time			TIMESTAMP,
	reservation_date		DATE,
	start_time			TIMESTAMP,
	CONSTRAINT RcustomerID
		FOREIGN KEY (customer_id)
		REFERENCES PICKUPCUSTOMERS(customer_id) ON DELETE CASCADE,
	CONSTRAINT RdriverID
		FOREIGN KEY (driver_id)
		REFERENCES DRIVER(driver_id) ON DELETE CASCADE,
	CONSTRAINT only_one_reservation UNIQUE(reservation_id,customer_id,driver_id));
	

CREATE TABLE LOCATION(
	gps_id				NUMBER(5) PRIMARY KEY NOT NULL,
	customer_id			NUMBER(5) NOT NULL,
	latitude			NUMBER(3,5),
	longitude			NUMBER(3,5),
	timestamp			TIMESTAMP,
	CONSTRAINT LcustomerID
		FOREIGN KEY (customer_id)
		REFERENCES PICKUPCUSTOMERS(customer_id) ON DELETE CASCADE,
	CONSTRAINT one_place_at_a_time UNIQUE(customer_id,timestamp,longitude,latitude));

CREATE TABLE TRIP(
	trip_id				NUMBER(5) PRIMARY KEY NOT NULL,
	reservation_id			NUMBER(5) NOT NULL,
	driver_id			NUMBER(5) NOT NULL,
	customer_id			NUMBER(5) NOT NULL,
	starting_location		VARCHAR(20),
	destination_location		VARCHAR(20),
	start_time			TIMESTAMP,
	end_time			TIMESTAMP,
	CONSTRAINT TcustomerID
		FOREIGN KEY (customer_id)
		REFERENCES PICKUPCUSTOMERS(customer_id) ON DELETE CASCADE,
	CONSTRAINT TdriverID
		FOREIGN KEY (driver_id)
		REFERENCES DRIVER(driver_id) ON DELETE CASCADE,
	CONSTRAINT TreservationID
		FOREIGN KEY (reservation_id)
		REFERENCES RESERVATION(reservation_id) ON DELETE CASCADE,
	CONSTRAINT one_reservation_one_trip UNIQUE(reservation_id,trip_id,start_time,end_time));
	

CREATE TABLE LOYALTY_PROGRAM(
	loyalty_id			NUMBER(5) PRIMARY KEY NOT NULL,
	customer_id			NUMBER(5) NOT NULL,
	driver_preferences		VARCHAR(250),
	vehicle_preferences		VARCHAR(250),
	loyalty_points			NUMBER(5),
	available_perks			VARCHAR(250),
	CONSTRAINT LYcustomerID
		FOREIGN KEY (customer_id)
		REFERENCES PICKUPCUSTOMERS(customer_id) ON DELETE CASCADE,
	CONSTRAINT oneloyalty_id UNIQUE(customer_id,loyalty_id));

CREATE TABLE INCIDENT(
	incident_id			NUMBER(5) PRIMARY KEY NOT NULL,
	driver_id			NUMBER(5) NOT NULL,
	customer_id			NUMBER(5),
	police_report_number		NUMBER(8) NOT NULL,
	insurance_company		VARCHAR(110),
	insurance_name			VARCHAR(110),
	insurance_number		NUMBER(5),
	CONSTRAINT IcustomerID
		FOREIGN KEY (customer_id)
		REFERENCES PICKUPCUSTOMERS(customer_id) ON DELETE CASCADE,
	CONSTRAINT IdriverID
		FOREIGN KEY (driver_id)
		REFERENCES DRIVER(driver_id) ON DELETE CASCADE,
	CONSTRAINT one_police_report UNIQUE(police_report_number));






