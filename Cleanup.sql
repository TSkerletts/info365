-- Drops tables and functions, procedures, and triggers
-- There may be a typo in here

DROP TRIGGER checkcreditcards_bir;
DROP TRIGGER checkfriends_air;
DROP TRIGGER reducerating_air;
DROP TRIGGER checkcity_bir;
DROP TRIGGER checkinsurance_biur;
DROP TRIGGER checkinspectionstatus_bir;
DROP TRIGGER addDriverFare_air
DROP TRIGGER trg_add_points
DROP PROCEDURE giveBonus;
DROP PROCEDURE punishDriver;
DROP PROCEDURE addToLoyalty;
DROP PROCEDURE searchDriverID;
DROP PROCEDURE addmoreTime;
DROP PROCEDURE proc_audit_drivers;
DROP FUNCTION func_highest_loyalty;
DROP FUNCTION func_calc_commission;

DROP TABLE INCIDENT;
DROP TABLE LOYALTY_PROGRAM;
DROP TABLE TRIP;
DROP TABLE LOCATION;
DROP TABLE RESERVATION;
DROP TABLE DRIVER;
DROP TABLE VEHICLE;
DROP TABLE FRIENDS;
DROP TABLE PICKUPCUSTOMERS;