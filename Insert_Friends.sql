--Clear table

DELETE FRIENDS CASCADE;

--Insert statements for Friends table

INSERT INTO FRIENDS VALUES(
'official tjay', 00001, '8880 Market Street', 'incab', '13N 40E');

INSERT INTO FRIENDS VALUES(
'greg phil', 00001, '1980 Market Street', 'online', '40.55N 140W');

INSERT INTO FRIENDS VALUES(
'pod vader', 00002, 'LittleTown KOP', 'incab', '4.455N 40E');

INSERT INTO FRIENDS VALUES(
'anne droidd', 00002, '5980 Chestnut Street', 'online', '13.2455N 40E');

INSERT INTO FRIENDS VALUES(
'manya troublesome', 00002, '1880 Strawberry Avenue', 'online', '13.2455N 40E');

INSERT INTO FRIENDS(facebook_username, customer_id, address, status) VALUES(
'eric lerry', 00003, '9900 Chestnut Street', 'offline');

INSERT INTO FRIENDS(facebook_username, customer_id, address, status) VALUES(
'britney LovezCandy', 00004, '1880 Walnut Street', 'offline');

INSERT INTO FRIENDS(facebook_username, customer_id, address, status) VALUES(
'eJ deathByCrushing', 00004, 'Prountney Street', 'offline');

INSERT INTO FRIENDS(facebook_username, customer_id, address, status) VALUES(
'eric thomas', 00005, 'WestChester', 'offline');

INSERT INTO FRIENDS(facebook_username, customer_id, address, status) VALUES(
'Tom reiling', 00006, '9900 Chestnut Street', 'offline');

INSERT INTO FRIENDS(facebook_username, customer_id, address, status) VALUES(
'Richard White', 00007, 'Lawnsdorne Avenue', 'offline');

INSERT INTO FRIENDS VALUES(
'asian flare', 00007, 'Willingboro', 'incab', '15.37N 50.44E');

INSERT INTO FRIENDS VALUES(
'Nina Heinsworth', 00009, '1990 bluewaters hill', 'online', '40.55N 140W');

INSERT INTO FRIENDS VALUES(
'Rachael Lovely', 00011, 'LittleTown KOP', 'incab', '4.455N 20E');

INSERT INTO FRIENDS VALUES(
'Anonymous Ninja', 00011, '3rd Avenue and Revelton drive', 'online', '13.12N 34E');

INSERT INTO FRIENDS VALUES(
'Naomi Schwartz', 00011, 'ABC hill', 'online', '12.4455N 90W');

INSERT INTO FRIENDS(facebook_username, customer_id, status) VALUES(
'Charlie Richmond', 000012, 'offline');

INSERT INTO FRIENDS(facebook_username, customer_id, status) VALUES(
'George Squirrels', 000013, 'offline');

INSERT INTO FRIENDS(facebook_username, customer_id, status) VALUES(
'Leo Yoda', 000014, 'online');

INSERT INTO FRIENDS(facebook_username, customer_id, status) VALUES(
'Super Mario', 000016, 'online');