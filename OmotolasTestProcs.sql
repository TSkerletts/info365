--Test Trigger checkcreditcards_bir should raise an error if insert statement doesnt meet triggers excpectations.
INSERT INTO PICKUPCUSTOMERS VALUES(00021,'Jen', 'Jackson', 3456345339987098, 'JEN JACKSON', TO_DATE(20171007, 'YYYYMMDD'), '5510 Lawnsdowne', 'Philadelphia');

--Test Trigger checkfriends_air should return information on friends online
INSERT INTO RESERVATION VALUES (30023, 00011, 10001, '01-NOV-2016 12:15:00 PM', '01-NOV-2016', '01-NOV-2016 12:00:00 PM');


--Test Trigger reducerating_air should reduce driver rating and display new rating
INSERT INTO INCIDENT VALUES (30006, 10011, 00003, 10000020, 'GEICO', 'INCIDENT #1', 41110, 3);

--Test Trigger checkcities_bir should raise an error if The city of the new customer doesnt exist in the database
INSERT INTO PICKUPCUSTOMERS VALUES(00022,'Janett', 'French', 3456345339987098, 'JANE FRENCH', TO_DATE(20181007, 'YYYYMMDD'), '8920 Lawnsdowne', 'DC');