CREATE DATABASE IF NOT EXISTS `TrainDatabase`;
USE `TrainDatabase`;

CREATE TABLE IF NOT EXISTS Train (
	TrainID INT,
    Color VARCHAR(50),
    PRIMARY KEY (TrainID)
);

-- TrainSchedule table
CREATE TABLE IF NOT EXISTS TrainSchedule (
    transitLineName VARCHAR(50),
    Train INT,
    Origin VARCHAR(50),
    Destination VARCHAR(50), 
    departDate DATETIME,
    arrivalDate DATETIME,
    totalTravelTime INT,
    fare FLOAT,
    stopCount INT,
    PRIMARY KEY (transitLineName, Train),
    FOREIGN KEY (Train) REFERENCES Train(TrainID)
);

-- TrainStation table
CREATE TABLE IF NOT EXISTS TrainStation (
    stationID INT,
    name VARCHAR(50),
    cityName VARCHAR(50),
    state VARCHAR(50),
    PRIMARY KEY (stationID));

-- TrainStops table
CREATE TABLE IF NOT EXISTS TrainStops (
    transitLineName VARCHAR(50),
    Train INT,
    stationID INT,
    stopOrder INT,
    arrivalTime DATETIME,
    departureTime DATETIME,
    FOREIGN KEY (transitLineName) REFERENCES TrainSchedule(transitLineName),
    FOREIGN KEY (Train) REFERENCES Train(TrainID),
    FOREIGN KEY (stationID) REFERENCES TrainStation(stationID)
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
    Train INT,
    Origin VARCHAR(50),
    Destination VARCHAR(50),
    departDate DATETIME,
    arrivalDate DATETIME,
    fare FLOAT,
    Passenger VARCHAR(50),
    totalFare FLOAT,
    ReservationDate DATE,
    PRIMARY KEY (Number),
    FOREIGN KEY (emailAddress) REFERENCES Customer(emailAddress),
    FOREIGN KEY (transitLineName) REFERENCES TrainSchedule(transitLineName),
    FOREIGN KEY (Train) REFERENCES Train(TrainID)
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
	reportID INT,
    emailAddress VARCHAR(50),
    issueDescription VARCHAR(1000),
    response VARCHAR(1000),
    PRIMARY KEY (reportID),
    FOREIGN KEY (emailAddress) REFERENCES Customer (emailAddress)
);

INSERT INTO `Customer` VALUES 
('hi@gmail.com', 'hey', 'hello', 'cust1', 'pass123'),
('bye@gmail.com', 'by', 'bo', 'lol', 'pass321'),
('sample@gmail.com', 'funny', 'guy', 'haha', 'pass321');


INSERT INTO `Employee` VALUES 
('111-11-1111', 'john', 'doe', 'admin', 'pass123', "Admin"),
('111-21-1112', 'jane', 'doe', 'employeeem', 'pass123', "Employee");

INSERT INTO `TrainStation` VALUES
(1, 'Trenton', 'Trenton', 'New Jersey'),
(12, 'NB', 'New Brunswick', 'New Jersey'),
(13, 'Edison', 'Edison', 'New Jersey'),
(14, 'Metuchen', 'Metuchen', 'New Jersey'),
(15, 'NYC', 'New York City', 'New York');

INSERT INTO `Train` VALUES
(101, 'Blue'),
(202, 'Red');

INSERT INTO `TrainSchedule` VALUES
('Northeast', 101, 'Trenton', 'New York City', '2024-12-10 03:48:00', '2024-12-10 05:21:00', 90, 50.0, 5),
('NortheastReversed', 202, 'New York City', 'Trenton', '2024-12-10 03:48:00', '2024-12-10 05:21:00', 100, 55.0, 5),
('Northeast2', 101, 'Trenton', 'New York City', '2024-12-10 03:49:00', '2024-12-10 05:21:00', 90, 51.0, 5),
('Northeast3', 101, 'Trenton', 'New York City', '2024-12-10 03:50:00', '2024-12-10 05:21:00', 90, 52.0, 5),
('Northeast4', 101, 'Trenton', 'New York City', '2024-12-10 03:51:00', '2024-12-10 05:21:00', 90, 53.0, 5),
('Northeast5', 101, 'Trenton', 'New York City', '2024-12-10 03:52:00', '2024-12-10 05:21:00', 90, 54.0, 5);


INSERT INTO `TrainStops` VALUES
('Northeast', 101, 1, 1, '2024-12-10 03:48:00', '2024-12-10 03:48:00'),
('Northeast', 101, 12, 2, '2024-12-10 03:48:00', '2024-12-10 03:48:00'),
('Northeast', 101, 13, 3, '2024-12-10 03:48:00', '2024-12-10 03:48:00'),
('Northeast', 101, 14, 4, '2024-12-10 03:48:00', '2024-12-10 03:48:00'),
('Northeast', 101, 15, 5, '2024-12-10 03:48:00', '2024-12-10 03:48:00'),
('NortheastReversed', 101, 15, 1, '2024-12-10 03:48:00', '2024-12-10 03:48:00'),
('NortheastReversed', 101, 14, 2, '2024-12-10 03:48:00', '2024-12-10 03:48:00'),
('NortheastReversed', 101, 13, 3, '2024-12-10 03:48:00', '2024-12-10 03:48:00'),
('NortheastReversed', 101, 12, 4, '2024-12-10 03:48:00', '2024-12-10 03:48:00'),
('NortheastReversed', 101, 1, 5, '2024-12-10 03:48:00', '2024-12-10 03:48:00'),
('Northeast2', 101, 1, 1, '2024-12-10 03:48:00', '2024-12-10 03:48:00'),
('Northeast2', 101, 12, 2, '2024-12-10 03:48:00', '2024-12-10 03:48:00'),
('Northeast2', 101, 15, 3, '2024-12-10 03:48:00', '2024-12-10 03:48:00'),
('Northeast3', 101, 1, 1, '2024-12-10 03:48:00', '2024-12-10 03:48:00'),
('Northeast3', 101, 15, 2, '2024-12-10 03:48:00', '2024-12-10 03:48:00'),
('Northeast4', 101, 1, 1, '2024-12-10 03:48:00', '2024-12-10 03:48:00'),
('Northeast4', 101, 12, 2, '2024-12-10 03:48:00', '2024-12-10 03:48:00'),
('Northeast4', 101, 13, 3, '2024-12-10 03:48:00', '2024-12-10 03:48:00'),
('Northeast4', 101, 15, 4, '2024-12-10 03:48:00', '2024-12-10 03:48:00'),
('Northeast5', 101, 1, 1, '2024-12-10 03:48:00', '2024-12-10 03:48:00'),
('Northeast5', 101, 15, 2, '2024-12-10 03:48:00', '2024-12-10 03:48:00');

INSERT INTO `Reservation` VALUES
(1, 'hi@gmail.com', 'Northeast', 101, 'Trenton', 'Metuchen', '2024-12-10 03:48:00', '2024-12-10 05:48:00', 40.0, 'Billy', 40.0, '2023-12-10'),
(2, 'hi@gmail.com', 'Northeast', 101, 'Trenton', 'Metuchen', '2024-12-10 03:48:00', '2024-12-10 05:48:00', 40.0, 'Billy', 40.0, '2024-12-10'),
(3, 'hi@gmail.com', 'NortheastReversed', 202, 'Trenton', 'Metuchen', '2024-12-10 03:48:00', '2024-12-10 05:48:00', 40.0, 'Billy', 40.0, '2024-12-10'),
(4, 'hi@gmail.com', 'Northeast', 101, 'Trenton', 'Metuchen', '2024-12-10 03:48:00', '2024-12-10 05:48:00', 40.0, 'Billy', 40.0, '2024-12-10'),
(6, 'bye@gmail.com', 'Northeast', 101, 'Trenton', 'Metuchen', '2024-12-10 03:48:00', '2024-12-10 05:48:00', 40.0, 'Tommy', 40.0, '2024-11-10'),
(7, 'bye@gmail.com', 'Northeast2', 101, 'Trenton', 'Metuchen', '2024-12-10 03:48:00', '2024-12-10 05:48:00', 40.0, 'Tommy', 40.0, '2024-11-10'),
(8, 'bye@gmail.com', 'Northeast5', 101, 'Trenton', 'Metuchen', '2024-12-10 03:48:00', '2024-12-10 05:48:00', 40.0, 'Tommy', 43.0, '2024-11-10'),
(9, 'bye@gmail.com', 'Northeast2', 101, 'Trenton', 'Metuchen', '2024-12-10 03:48:00', '2024-12-10 05:48:00', 40.0, 'Tommy', 44.0, '2024-11-10'),
(10, 'bye@gmail.com', 'Northeast3', 101, 'Trenton', 'Metuchen', '2024-12-10 03:48:00', '2024-12-10 05:48:00', 40.0, 'Tommy', 45.0, '2024-11-10'),
(11, 'bye@gmail.com', 'Northeast4', 101, 'Trenton', 'Metuchen', '2024-12-10 03:48:00', '2024-12-10 05:48:00', 40.0, 'Tommy', 46.0, '2024-10-10'),
(12, 'bye@gmail.com', 'Northeast4', 101, 'Trenton', 'Metuchen', '2024-12-10 03:48:00', '2024-12-10 05:48:00', 40.0, 'Tommy', 47.0, '2024-10-10'),
(13, 'hi@gmail.com', 'NortheastReversed', 202, 'Trenton', 'Metuchen', '2024-12-10 03:48:00', '2024-12-10 05:48:00', 40.0, 'Billy', 40.0, '2024-10-10'),
(14, 'sample@gmail.com', 'NortheastReversed', 202, 'Trenton', 'Metuchen', '2024-12-10 03:48:00', '2024-12-10 05:48:00', 40.0, 'Tom', 500.0, '2024-9-10');

INSERT INTO `CustomerIssues` VALUES
(1, 'sample@gmail.com', 'why is the trains slow', 'because they are');


