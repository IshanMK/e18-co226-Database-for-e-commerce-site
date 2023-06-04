/*
CO226 Database Project
Group 03 - eMart
    E/18/028 - Ariyawansha P.H.J.U.
    E/18/173 - Kasthuripitiya K.A.I.M.
    E/18/285 - Ranasinghe S.M.T.S.C.
*/

/*
=================================
        Creating Tables
=================================
*/

/*=========================================CREATING THE DATABASE=========================================================== */ 
DROP DATABASE IF EXISTS emart;
CREATE DATABASE emart;
USE emart;

/*=========================================CREATING THE USER TABLE========================================================= */ 
 
 CREATE TABLE USER
(UserID INT PRIMARY KEY NOT NULL,
FirstName VARCHAR(30) NOT NULL,
LastName VARCHAR(30) NOT NULL,
Email VARCHAR(50) NOT NULL,
NIC VARCHAR(12) NOT NULL,
PASSWORD VARCHAR(20) NOT NULL,
Address VARCHAR(100) NOT NULL,
UserType ENUM('Customer', 'Employee'))
ENGINE = INNODB;


CREATE TABLE TelephoneNumber
(UserID INT REFERENCES USER(UserID) ON UPDATE CASCADE ON DELETE CASCADE,
TelephoneNumber DECIMAL(10) NOT NULL)
ENGINE = INNODB;


CREATE TABLE CUSTOMER
(UserID INT REFERENCES USER(UserID) ON UPDATE CASCADE ON DELETE CASCADE,
PostalCode DECIMAL(5) NOT NULL)
ENGINE = INNODB;


CREATE TABLE EMPLOYEE
(UserID INT REFERENCES USER(UserID) ON UPDATE CASCADE ON DELETE CASCADE,
Occupation ENUM('Driver', 'Doctor'))
ENGINE = INNODB;
 
 /*=========================================CREATING THE PRODUCT TABLE========================================================= */ 

CREATE TABLE PRODUCT
(ProductID INT NOT NULL PRIMARY KEY,
Product_Name VARCHAR(40),
Price DECIMAL(10,2) NOT NULL,
Product_Type ENUM('CLOTHING_AND_SHOES', 'FOOD_AND_BEVERAGES', 'GROCERY_ITEM', 'PHARMACEUTICAL_PRODUCT','HOME_APPLIENCES'))
ENGINE = INNODB;

CREATE TABLE CLOTHING_AND_SHOES
(ProductID INT NOT NULL REFERENCES PRODUCT(ProductID) ON UPDATE CASCADE ON DELETE CASCADE,
Item_Type ENUM('Ladies', 'Gents', 'Kids'),
Item_Size ENUM('Small', 'Medium', 'Large', 'XL'),
Types ENUM('CLOTHS', 'SHOES'))
ENGINE = INNODB;

CREATE TABLE FOOD
(ProductID INT NOT NULL REFERENCES PRODUCT(ProductID) ON UPDATE CASCADE ON DELETE CASCADE,
Food_Type ENUM('Bakery items', 'Snacks', 'Diary Products'))
ENGINE = INNODB;

CREATE TABLE BEVERAGE
(ProductID INT NOT NULL REFERENCES PRODUCT(ProductID) ON UPDATE CASCADE ON DELETE CASCADE,
BEVERAGE_Type ENUM('Hot', 'Cool'))
ENGINE = INNODB;

CREATE TABLE GROCERY_ITEM
(ProductID INT NOT NULL REFERENCES PRODUCT(ProductID) ON UPDATE CASCADE ON DELETE CASCADE,
GroceryType ENUM('Fruit and vegetables', 'Cereals', 'Fish and Meat', 'Stationaries'))
ENGINE = INNODB;

CREATE TABLE HOME_APPLIENCES
(ProductID INT NOT NULL REFERENCES PRODUCT(ProductID) ON UPDATE CASCADE ON DELETE CASCADE,
Types ENUM('Electronic' , 'Furniture'),
ItemType ENUM('Kitchen' , 'Home'))
ENGINE = INNODB;

CREATE TABLE PHARMACEUTICAL_ITEMS
(ProductID INT NOT NULL REFERENCES PRODUCT(ProductID) ON UPDATE CASCADE ON DELETE CASCADE,
ItemType ENUM('FirstAid' , 'Skin & HairCare' , 'PainRelief' , 'Lifestyle & Wellbeing' , 'Cough & Cold Relief'))
ENGINE = INNODB;


/*=========================================CREATING THE PAYMENT DETAIL TABLE========================================================= */ 
CREATE TABLE Payment_detail
(userID INT NOT NULL REFERENCES USER(userID) ON UPDATE CASCADE ON DELETE CASCADE,
paymentType ENUM('Bank' , 'Card'))
ENGINE = INNODB;

CREATE TABLE BANK
(userID INT NOT NULL REFERENCES Payment_detail(userID) ON UPDATE CASCADE ON DELETE CASCADE,
BranchName VARCHAR(50) NOT NULL,
BankName VARCHAR(50) NOT NULL,
AccountNumber DECIMAL(20) NOT NULL)
ENGINE = INNODB;

CREATE TABLE CARD
(userID INT NOT NULL REFERENCES Payment_detail(userID) ON UPDATE CASCADE ON DELETE CASCADE,
CardNumber DECIMAL(16) NOT NULL,
NameOnTheCard VARCHAR(50) NOT NULL,
ExpireDate CHAR(5) NOT NULL,
CVV INT NOT NULL)
ENGINE = INNODB;

/*=========================================CREATING THE SERVICE TABLE========================================================= */ 
CREATE TABLE SERVICE
(ReceiptNo INT PRIMARY KEY NOT NULL,
ServiceDate DATE NOT NULL,
ServiceType ENUM('E-Health', 'Taxi', 'Tow', 'Delivery'))
ENGINE = INNODB;


CREATE TABLE eHealth
(ReceiptNo INT NOT NULL REFERENCES SERVICE(ReceiptNo),
PatientID INT NOT NULL REFERENCES CUSTOMER(UserID) ON UPDATE CASCADE ON DELETE CASCADE,
DoctorID INT NOT NULL REFERENCES EMPLOYEE(UserID) ON UPDATE CASCADE ON DELETE CASCADE)
ENGINE = INNODB;


CREATE TABLE Taxi
(ReceiptNo INT NOT NULL REFERENCES SERVICE(ReceiptNo),
CustomerID INT NOT NULL REFERENCES CUSTOMER(UserID) ON UPDATE CASCADE ON DELETE CASCADE,
DriverID INT NOT NULL REFERENCES EMPLOYEE(UserID) ON UPDATE CASCADE ON DELETE CASCADE,
VehicleType ENUM('ThreeWheel', 'Car', 'Van'))
ENGINE = INNODB;


CREATE TABLE Tow
(ReceiptNo INT NOT NULL REFERENCES SERVICE(ReceiptNo),
CustomerID INT NOT NULL REFERENCES CUSTOMER(UserID) ON UPDATE CASCADE ON DELETE CASCADE,
DriverID INT NOT NULL REFERENCES EMPLOYEE(UserID) ON UPDATE CASCADE ON DELETE CASCADE)
ENGINE = INNODB;


CREATE TABLE Delivery
(ReceiptNo INT NOT NULL REFERENCES SERVICE(ReceiptNo),
CustomerID INT NOT NULL REFERENCES CUSTOMER(UserID) ON UPDATE CASCADE ON DELETE CASCADE,
DriverID INT NOT NULL REFERENCES EMPLOYEE(UserID) ON UPDATE CASCADE ON DELETE CASCADE,
VehicleType ENUM('ThreeWheel', 'Car', 'Van'),
BillNo INT REFERENCES BUYS(BillNo))
ENGINE = INNODB;

/*=========================================CREATING THE RELATION TABLEs========================================================= */ 
/*|||||||||||||GETS|||||||||||||*/
CREATE TABLE Gets
(CustomerID INT NOT NULL,
ReceiptNo INT NOT NULL);

/*Trigger For E-Health Solutions*/
DELIMITER //
CREATE TRIGGER Get_Service_1
    AFTER INSERT ON eHealth
    FOR EACH ROW
BEGIN
    INSERT INTO Gets
    SET
        CustomerID = NEW.PatientID,
        ReceiptNo = NEW.ReceiptNo;
END //
DELIMITER ;

/*Trigger For Taxi Solutions*/
DELIMITER //
CREATE TRIGGER Get_Service_2
    AFTER INSERT ON Taxi
    FOR EACH ROW
BEGIN
    INSERT INTO Gets
    SET
        CustomerID = NEW.CustomerID,
        ReceiptNo = NEW.ReceiptNo;
END //
DELIMITER ;

/*Trigger For Tow Solutions*/
DELIMITER //
CREATE TRIGGER Get_Service_3
    AFTER INSERT ON Tow
    FOR EACH ROW
BEGIN
    INSERT INTO Gets
    SET
        CustomerID = NEW.CustomerID,
        ReceiptNo = NEW.ReceiptNo;
END //
DELIMITER ;

/*Trigger For Delivery Solutions*/
DELIMITER //
CREATE TRIGGER Get_Service_4
    AFTER INSERT ON Delivery
    FOR EACH ROW
BEGIN
    INSERT INTO Gets
    SET
        CustomerID = NEW.CustomerID,
        ReceiptNo = NEW.ReceiptNo;
END //
DELIMITER ;

/*|||||||||||||BUYS|||||||||||||*/
CREATE TABLE Buys
(BillNo INT PRIMARY KEY NOT NULL,
CustomerID INT NOT NULL REFERENCES CUSTOMER(UserID),
BillValue DECIMAL(12,2) NOT NULL)
ENGINE = INNODB;

CREATE TABLE Product_ID
(BillNo INT NOT NULL REFERENCES Buys(BillNo) ON UPDATE CASCADE,
ProductID INT NOT NULL REFERENCES Product(ProductID) ON UPDATE CASCADE)
ENGINE = INNODB;



/*
=================================
        Populating Tables
=================================
*/

USE eMart;

/*||||||||||||||||||||||||||||||||||||USER SECTION||||||||||||||||||||||||||||||||||||||||||||*/
/* Populating User table */
INSERT INTO USER (UserID, FirstName, LastName, Email, NIC, PASSWORD, Address, UserType) VALUES
(1000, 'Lakshan', 'Wijekoon', 'lakwije1998@gmail.com', '982345876V', 'KWije1998', 'E/18,Kota Watunu Wewa,Anuradhapura', 'Employee'),
(1001, 'Avishka', 'Sahan', 'freefireAS@gmail.com', '902355876V', 'AsahanOnFire', '69/1,Fire Villa,Avissawella', 'Employee'),
(1002, 'Melba', 'Hall', 'letitia_oberbrunn@gmail.com', '802334576V', 'oberbrunn', '201 4th Cross Street,', 'Employee'),
(1003, 'William', 'Baum', 'dallin1999@yahoo.com', '6523345876V', 'dallin1999', 'No.182, Kulamullaa,Waikkal', 'Employee'),
(1004, 'Eddie', 'Haynes', 'kurtis_oreil@gmail.com', '9423345876V', 'kurtis_oreil', '316 Old Moor Street,Colombo', 'Employee'),
(1005, 'Kristopher', 'Rubin', 'nolan.howel6@gmail.com', '806545876V', 'nolan.howel6', '130 Maliban Street,Colombo', 'Employee'),
(1006, 'Joseph', 'Evans', 'bridget_kun@gmail.com', '9502353476V', 'bridget_kun', '102 1/2 Panchikawatte Road,Colombo', 'Employee'),
(1007, 'Matt', 'Schaffer', 'alyce1973@yahoo.com', '702355876V', 'alyce1973', ' No. 83, Carmel Mawatha, Hendalawaththa', 'Customer'),
(1008, 'Richard', 'Major', 'israel1988@hotmail.com', '902367876V', 'israel1988', '53 A/9 Keyzer Street,Rathnapura', 'Customer'),
(1009, 'Mary', 'Pierce', 'hayden.leusch@yahoo.com', '922665876V', 'hayden.leusch', '81-1/21 Prince Street,Kegalle', 'Customer'),
(1010, 'Barbara', 'Painter', 'imani_ferr5@gmail.com', '532355876V', 'imani_ferr5', '244 Dam Street,Hambanthota', 'Customer'),
(1011, 'Jason', 'Cunningham', 'elia.stam2@hotmail.com', '852223876V', 'elia.stam2', '250, De Soysa road, Moratumulla', 'Customer'),
(1012, 'Floy', 'Hofstetter', 'dangelo_schmi@hotmail.com', '767855876V', 'dangelo_schmi', '106 New Moor Street,Ampara', 'Customer'),
(1013, 'Mary', 'Lakey', 'jeie_hand2005@yahoo.com', '822355876V', 'jeie_hand2005', '106 New Moor Street,Ampara', 'Customer'),
(1014, 'Gary', 'Erickson', 'dominic1994@gmail.com', '472453876V', 'Adominic1994', '91/2 2nd Cross Street,Gampaha', 'Customer'),
(1015, 'Maria', 'Robinson', 'morgan2010@hotmail.com', '852355876V', 'morgan2010', ' 310/20, LUMBINI GARDNS, Kadawatha', 'Customer'),
(1016, 'Thomas', 'Hoyos', 'sydney1975@gmail.com', '432355876V', 'sydney1975', '165, DIPPITIGODA ROAD, Dalugama', 'Customer'),
(1017, 'Amy', 'McCutchen', 'zechariah2009@hotmail.com', '642379876V', 'zechariah2009', '127/10, Old Kandy Road,Kelaniya', 'Customer'),
(1018, 'Carroll', 'Blackledge', 'alisa.kilba@gmail.com', '632455876V', 'alisa.kilba', '308 Sea Street, Galle', 'Customer'),
(1019, 'Raymond', 'Thornton', 'maiya.schneid@gmail.com', '704255876V', 'maiya.schneid', '152 Messenger Street,Avissawella', 'Customer'),
(1020, 'Krystal', 'Otto', 'tina.adam10@yahoo.com', '792345876V', 'tina.adam10', 'NO 108A,MAYA AVENUE, Mathara', 'Customer');

/* Populating Telephone_No */
INSERT INTO TelephoneNumber (UserID, TelephoneNumber) VALUES
(1000, 0715825645),
(1000, 0724496730),
(1001, 0738754731),
(1001, 0763965354),
(1002, 0768721420),
(1003, 0767727297),
(1003, 0782422985),
(1003, 0784889569),
(1004, 0784199808),
(1004, 0784056541),
(1005, 0781078218),
(1005, 0729813802),
(1006, 0732232786),
(1007, 0720477680),
(1008, 0767782452),
(1009, 0755620631),
(1010, 0759604237),
(1011, 0742317663),
(1011, 0768219213),
(1012, 0787838603),
(1013, 0717638743),
(1014, 0789116164),
(1015, 0710465891),
(1015, 0785223068),
(1016, 0718509323),
(1016, 0758436052),
(1017, 0793793399),
(1017, 0717152502),
(1018, 0769616494),
(1018, 0712996147),
(1019, 0768753067),
(1019, 0715909677),
(1020, 0775138160);

/* Populating CUSTOMER table */
INSERT INTO CUSTOMER (UserID, PostalCode) VALUES
(1007, 61170),
(1008, 20160),
(1009, 21170),
(1010, 81560),
(1011, 67544),
(1012, 44482),
(1013, 30029),
(1014, 94298),
(1015, 14172),
(1016, 58439),
(1017, 21196),
(1018, 28780),
(1019, 85069),
(1020, 20220);

/* Populating EMPLOYEE table */
INSERT INTO EMPLOYEE(UserID,Occupation) VALUES
(1000,'Driver'),
(1001,'Doctor'),
(1002,'Driver'),
(1003,'Doctor'),
(1004,'Driver'),
(1005,'Driver'),
(1006,'Doctor');


/*||||||||||||||||||||||||||||||||||||PAYMENT DETAIL SECTION||||||||||||||||||||||||||||||||||||||||||||*/
/* Populating Payment_detail table */
INSERT INTO Payment_detail (UserID, PaymentType) VALUES
(1000, 'Bank'),
(1001, 'Bank'),
(1002, 'Bank'),
(1003, 'Bank'),
(1004, 'Bank'),
(1005, 'Bank'),
(1006, 'Bank'),
(1007, 'Card'),
(1008, 'Card'),
(1009, 'Card'),
(1010, 'Card'),
(1011, 'Card'),
(1012, 'Card'),
(1013, 'Card'),
(1014, 'Card'),
(1015, 'Card'),
(1016, 'Card'),
(1017, 'Card'),
(1018, 'Card'),
(1019, 'Card'),
(1010, 'Card'),
(1020, 'Card');

/* Populating BANK table */
INSERT INTO BANK (UserID, BankName, BranchName, AccountNumber) VALUES
(1000, 'Nations Trust Bank', 'Peradeniya', 25364458652100570250),
(1001, 'Bank of Ceylon', 'Grandpass', 60789193362097419137),
(1002, 'Peoples Bank', 'Nugegoda', 66607255336218090836),
(1003, 'Peoples Bank', 'Negambo', 15597405276758623061),
(1004, 'Hatton National Bank', 'Kegalle', 22262257389063837960),
(1005, 'Hatton National Bank', 'Matara', 02372643311539982501),
(1006, 'National Savings Bank', 'Jaffna', 56987819474808188853);

/* Populating CARD table */
INSERT INTO CARD(userID,CardNumber,NameOnTheCard,ExpireDate,CVV) VALUES
(1007,4535904623123456,'Matt Schaffer' ,'04/26',607),
(1008,4536994623123456,'Richard Major' ,'07/27',420),
(1009,4535904623123456,'Mary Pierce' ,'03/26',302),
(1010,4535904523123456,'Barbara Painter' ,'07/26',401),
(1011,4535344623123456,'Jason Cunningham' ,'08/25',500),
(1012,4535894623123456,'Floy Hofstetter' ,'02/23',499),
(1013,4535444623123456,'Mary Lakey' ,'01/23',202),
(1014,4535964623123456,'Gary Erickson' ,'04/24',302),
(1015,4535774623123456,'Maria Robinson' ,'08/25',123),
(1016,4535304623123456,'Thomas Hoyos' ,'11/26',234),
(1017,4535124623123456,'Amy McCutchen' ,'09/27',345),
(1018,4535884623123456,'Carroll Blackledge' ,'08/23',789),
(1019,4535554623123456,'Raymond Thornton' ,'10/25',980),
(1020,4535334623123456,'Krystal Otto' ,'11/26',134);


/*||||||||||||||||||||||||||||||||||||PRODUCT SECTION||||||||||||||||||||||||||||||||||||||||||||*/
/* Populating PRODUCT TABLE */
INSERT INTO PRODUCT(ProductID,Product_Name,Price,Product_Type) VALUES
(2000,'Ladies Blouse',1200.00,'CLOTHING_AND_SHOES'),
(2001,'Gents Shoes',1800.00,'CLOTHING_AND_SHOES'),
(2002,'Kids Denim',1000.00,'CLOTHING_AND_SHOES'),
(2003,'Gents Boots',2100.00,'CLOTHING_AND_SHOES'),
(2004,'Ladies Skirt',900.00,'CLOTHING_AND_SHOES'),
(2200,'Prima Bread',100.00,'FOOD_AND_BEVERAGES'),
(2201,'Chocloate Biscuit Munchee',120.00,'FOOD_AND_BEVERAGES'),
(2202,'Tiara Cake',200.00,'FOOD_AND_BEVERAGES'),
(2203,'Highland Ice Cream 2L',450.00,'FOOD_AND_BEVERAGES'),
(2204,'Sandwich',250.00,'FOOD_AND_BEVERAGES'),
(2250,'Tea',40.00,'FOOD_AND_BEVERAGES'),
(2251,'Ice Coffee',120.00,'FOOD_AND_BEVERAGES'),
(2252,'Hot Black Coffee',180.00,'FOOD_AND_BEVERAGES'),
(2253,'MilkShake',200.00,'FOOD_AND_BEVERAGES'),
(2254,'Cappucino',240.00,'FOOD_AND_BEVERAGES'),
(2300, 'Mango 1KG',120.00,'GROCERY_ITEM'),
(2301, 'Pumpkin 1KG',180.00,'GROCERY_ITEM'),
(2302, 'Chillies 100G',100.00,'GROCERY_ITEM'),
(2303, 'Beans 500G',200.00,'GROCERY_ITEM'),
(2304, 'Watermelon 1KG',250.00,'GROCERY_ITEM'),
(2305, 'Apple 500G',150.00,'GROCERY_ITEM'),
(2306, 'Biraha Chicken 1KG',800.00,'GROCERY_ITEM'),
(2307, 'Tuna Fish 1KG',1600.00,'GROCERY_ITEM'),
(2308, 'EGG',30.00,'GROCERY_ITEM'),
(2309, 'Soya 1KG',120.00,'GROCERY_ITEM'),
(2310, 'Oats 500G',320.00,'GROCERY_ITEM'),
(2311, 'Atlas 400Pages CR',300.00,'GROCERY_ITEM'),
(2312, 'Atlas Blue Pen',10.00,'GROCERY_ITEM'),
(2313, 'Richard Ruler',20.00,'GROCERY_ITEM'),
(2400, 'Singer Blender', 4000.00,'HOME_APPLIENCES'),
(2401, 'LG Refrigerator', 80000.00,'HOME_APPLIENCES'),
(2402, 'LG Electric Oven', 70000.00,'HOME_APPLIENCES'),
(2403, 'Samsung 32INCH Smart TV', 100000.00,'HOME_APPLIENCES'),
(2404, 'LG Home Theatre', 240000.00,'HOME_APPLIENCES'),
(2405, 'Damro Cooking Table', 8000.00,'HOME_APPLIENCES'),
(2406, 'Damro Plate Rack', 12000.00,'HOME_APPLIENCES'),
(2407, 'Wooden Master Bed', 30000.00,'HOME_APPLIENCES'),
(2408, 'Damro SofaSet', 65000.00,'HOME_APPLIENCES'),
(2500, 'Dettol Plaster 10 Pack',80.00,'PHARMACEUTICAL_PRODUCT'),
(2501, 'NSK Cotton Wool',100.00,'PHARMACEUTICAL_PRODUCT'),
(2502, 'LakWije Bandage',100.00,'PHARMACEUTICAL_PRODUCT'),
(2503, 'LakWije FirstAid Box',2000.00,'PHARMACEUTICAL_PRODUCT'),
(2504, 'Penadol Tab 500mg',150.00,'PHARMACEUTICAL_PRODUCT'),
(2505, 'Siddhalepa Balm 25G',240.00,'PHARMACEUTICAL_PRODUCT'),
(2506, 'Iodex Balm 25G',100.00,'PHARMACEUTICAL_PRODUCT'),
(2507, 'Sandisuda Balm',8000.00,'PHARMACEUTICAL_PRODUCT'),
(2508, 'Sunsilk Shampoo 200ml',280.00,'PHARMACEUTICAL_PRODUCT'),
(2509, 'Ponds Face Wash 180ml',270.00,'PHARMACEUTICAL_PRODUCT'),
(2510, 'Link Osupen 50G',180.00,'PHARMACEUTICAL_PRODUCT'),
(2511, 'Siddalepa Pinas Oil 30ml',130.00,'PHARMACEUTICAL_PRODUCT'),
(2512, 'Link Paspanguwa',130.00,'PHARMACEUTICAL_PRODUCT'),
(2513, 'Strepsils Cool',350.00,'PHARMACEUTICAL_PRODUCT'),
(2514, 'Link Samahan 4G x 30',900.00,'PHARMACEUTICAL_PRODUCT');

/* Populating CLOTHING AND SHOES TABLE */
INSERT INTO CLOTHING_AND_SHOES(ProductID,Item_Type,Item_Size,Types) VALUES
(2000,'Ladies','Small','CLOTHS'),
(2001,'Gents','Medium','SHOES'),
(2002,'Kids','Small','CLOTHS'),
(2003,'Gents','XL','SHOES'),
(2004,'Ladies','Large','CLOTHS');

/* Populating FOOD TABLE */
INSERT INTO FOOD(ProductID,Food_Type) VALUES
(2200,'Bakery items'),
(2201,'Snacks'),
(2202,'Bakery items'),
(2203,'Diary Products'),
(2204,'Bakery items');

/* Populating BEVERAGE TABLE */
INSERT INTO BEVERAGE(ProductID,BEVERAGE_Type) VALUES
(2250,'Hot'),
(2251,'Cool'),
(2252,'Hot'),
(2253,'Cool'),
(2254,'Hot');

/* Populating GROCERY_ITEM TABLE */
INSERT INTO GROCERY_ITEM (ProductID, GroceryType) VALUES
(2300, 'Fruit and Vegetables'),
(2301, 'Fruit and Vegetables'),
(2302, 'Fruit and Vegetables'),
(2303, 'Fruit and Vegetables'),
(2304, 'Fruit and Vegetables'),
(2305, 'Fruit and Vegetables'),
(2306, 'Fish and Meat'),
(2307, 'Fish and Meat'),
(2308, 'Fish and Meat'),
(2309, 'Cereals'),
(2310, 'Cereals'),
(2311, 'Stationaries'),
(2312, 'Stationaries'),
(2313, 'Stationaries');

/* Populating PHARMACEUTICAL_PRODUCT TABLE */
INSERT INTO PHARMACEUTICAL_ITEMS (ProductID, ItemType) VALUES
(2500, 'FirstAid'),
(2501, 'FirstAid'),
(2502, 'FirstAid'),
(2503, 'FirstAid'),
(2504, 'PainRelief'),
(2505, 'PainRelief'),
(2506, 'PainRelief'),
(2507, 'PainRelief'),
(2508, 'Skin & HairCare'),
(2509, 'Skin & HairCare'),
(2510, 'Lifestyle & Wellbeing'),
(2511, 'Lifestyle & Wellbeing'),
(2512, 'Lifestyle & Wellbeing'),
(2513, 'Cough & Cold Relief'),
(2514, 'Cough & Cold Relief');

/* Populating HOME_APPLIENCE TABLE */
INSERT INTO HOME_APPLIENCES(ProductID, Types, ItemType) VALUES
(2400, 'Electronic', 'Kitchen'),
(2401, 'Electronic', 'Kitchen'),
(2402, 'Electronic', 'Kitchen'),
(2403, 'Electronic', 'Home'),
(2404, 'Electronic', 'Home'),
(2405, 'Furniture', 'Kitchen'),
(2406, 'Furniture', 'Kitchen'),
(2407, 'Furniture', 'Home'),
(2408, 'Electronic', 'Home');


/*||||||||||||||||||||||||||||||||||||SERVICE SECTION||||||||||||||||||||||||||||||||||||||||||||*/
/* Populating SERVICE TABLE */
INSERT INTO SERVICE (ReceiptNo, ServiceDate, ServiceType) VALUES
(3000, '2022-01-21','E-Health'),
(3001, '2022-01-25', 'E-Health'),
(3002, '2022-01-26', 'E-Health'),
(3003, '2022-01-26', 'E-Health'),
(3004, '2022-01-27', 'E-Health'),
(3005, '2022-01-28', 'E-Health'),
(3006, '2022-01-30', 'E-Health'),
(3100, '2022-01-20', 'Taxi'),
(3101, '2022-01-20', 'Taxi'),
(3102, '2022-01-22', 'Taxi'),
(3103, '2022-01-26', 'Taxi'),
(3104, '2022-01-27', 'Taxi'),
(3105, '2022-01-28', 'Taxi'),
(3106, '2022-01-30', 'Taxi'),
(3107, '2022-01-30', 'Taxi'),
(3108, '2022-01-31', 'Taxi'),
(3200, '2022-01-20', 'Tow'),
(3201, '2022-01-26', 'Tow'),
(3202, '2022-01-26', 'Tow'),
(3203, '2022-01-30', 'Tow'),
(3500, '2022-01-20', 'Delivery'),
(3501, '2022-01-22', 'Delivery'),
(3502, '2022-01-23', 'Delivery'),
(3503, '2022-01-25', 'Delivery'),
(3504, '2022-01-28', 'Delivery');

/* Populating E-HEALTH_SOLUTION TABLE */
INSERT INTO eHealth (ReceiptNo, PatientID, DoctorID) VALUES
(3000, 1012, 1006),
(3001, 1015, 1006),
(3002, 1010, 1006),
(3003, 1009, 1003),
(3004, 1002, 1003),
(3005, 1005, 1001),
(3006, 1007, 1001);

/* Populating TAXI TABLE */
INSERT INTO Taxi (ReceiptNo, CustomerID, DriverID, VehicleType) VALUES
(3100, 1015, 1005, 'Car'),
(3101, 1008, 1004, 'Car'),
(3102, 1020, 1000, 'Van'),
(3103, 1013, 1005, 'Van'),
(3104, 1016, 1000, 'Car'),
(3105, 1009, 1000, 'Car'),
(3106, 1008, 1002, 'ThreeWheel'),
(3107, 1011, 1002, 'Car'),
(3108, 1019, 1004, 'ThreeWheel');

/* Populating TOW TABLE */
INSERT INTO Tow (ReceiptNo, CustomerID, DriverID) VALUES
(3200, 1016, 1002),
(3201, 1015, 1002),
(3202, 1020, 1000),
(3203, 1008, 1002);

/* Populating DELIVARY TABLE */
INSERT INTO Delivery (ReceiptNo, CustomerID, DriverID, VehicleType, BillNo) VALUES
(3500, 1010, 1003, 'ThreeWheel', 10000),
(3501, 1012, 1005, 'ThreeWheel', 10001),
(3502, 1014, 1005, 'ThreeWheel', 10002),
(3503, 1018, 1003, 'Van', 10003),
(3504, 1019, 1000, 'Van', 10004);

/*||||||||||||||||||||||||||||||||||||RELATION TABLES||||||||||||||||||||||||||||||||||||||||||||*/
/* Populating buys table */
INSERT INTO Buys (BillNo, CustomerID, BillValue) VALUES
(10000, 1010, 1300.00),
(10001, 1012, 370.00),
(10002, 1014, 3140.00),
(10003, 1018, 100000.00),
(10004, 1019, 240000.00);

/* Populating PRODUCT ID Table  */
INSERT INTO Product_ID (BillNo, ProductID) VALUES
(10000, 2302),
(10000, 2304),
(10000, 2310),
(10000, 2508),
(10000, 2513),
(10001, 2300),
(10001, 2305),
(10001, 2302),
(10002, 2503),
(10002, 2505),
(10002, 2514),
(10003, 2403),
(10004, 2404);