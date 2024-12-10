CREATE DATABASE IF NOT EXISTS `TrainDatabase`;
USE `TrainDatabase`;

-- TrainSchedule table
CREATE TABLE IF NOT EXISTS TrainSchedule (
    transitLineName VARCHAR(50),
    Train VARCHAR(50),
    Origin VARCHAR(50),
    Destination VARCHAR(50),
    departDate DATE,
    arrivalDate DATE,
    travelTime VARCHAR(50),
    stopsAmount INT,
    fare FLOAT,
    PRIMARY KEY (transitLineName, Train)
);

-- hasTrainStation table
CREATE TABLE IF NOT EXISTS hasTrainStation (
    transitLineName VARCHAR(50),
    stationID INT,
    name VARCHAR(50),
    cityName VARCHAR(50),
    state VARCHAR(50),
    PRIMARY KEY (stationID, transitLineName),
    FOREIGN KEY (transitLineName) REFERENCES TrainSchedule(transitLineName)
);

-- TrainStops table
CREATE TABLE IF NOT EXISTS TrainStops (
    transitLineName VARCHAR(50),
    Train VARCHAR(50),
    stopOrder INT,
    stationID INT,
    PRIMARY KEY (transitLineName, Train, stopOrder),
    FOREIGN KEY (transitLineName, Train) REFERENCES TrainSchedule(transitLineName, Train),
    FOREIGN KEY (stationID) REFERENCES hasTrainStation(stationID)
);

-- Customer table
CREATE TABLE IF NOT EXISTS Customer (
    emailAddress VARCHAR(50),
    lastName VARCHAR(50),
    firstName VARCHAR(50),
    username VARCHAR(50),
    password VARCHAR(50),
    PRIMARY KEY (emailAddress)
);

-- Reservation table
CREATE TABLE IF NOT EXISTS Reservation (
    Number INT,
    emailAddress VARCHAR(50),
    transitLineName VARCHAR(50),
    Train VARCHAR(50),
    Origin VARCHAR(50),
    Destination VARCHAR(50),
    departDate DATE,
    arrivalDate DATE,
    fare FLOAT,
    Passenger VARCHAR(50),
    totalFare FLOAT,
    PRIMARY KEY (Number),
    FOREIGN KEY (emailAddress) REFERENCES Customer(emailAddress),
    FOREIGN KEY (transitLineName, Train)
        REFERENCES TrainSchedule(transitLineName, Train)
);

-- Employees table
CREATE TABLE IF NOT EXISTS Employee (
    SSN CHAR(11),
    lastName VARCHAR(50),
    firstName VARCHAR(50),
    username VARCHAR(50),
    password VARCHAR(50),
    role ENUM('Admin', 'Employee'),
    PRIMARY KEY (SSN)
);

-- CustomerIssues table
CREATE TABLE IF NOT EXISTS CustomerIssues (
    emailAddress VARCHAR(50),
    issueDescription VARCHAR(1000),
    response VARCHAR(1000),
    salesRepSSN CHAR(11),
    PRIMARY KEY (emailAddress, salesRepSSN),
    FOREIGN KEY (emailAddress) REFERENCES Customer(emailAddress),
    FOREIGN KEY (salesRepSSN) REFERENCES Employee(SSN)
);

INSERT INTO `Customer` VALUES 
('hi@gmail.com', 'hey', 'hello', 'cust1', 'pass123');

INSERT INTO `Employee` VALUES 
('111-11-1111', 'john', 'doe', 'admin', 'pass123', "Admin"),
('111-21-1112', 'jane', 'doe', 'employeeem', 'pass123', "Employee");

