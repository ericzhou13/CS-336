DROP TABLE IF EXISTS `logins`;
CREATE TABLE `logins` (
  `username` varchar(50) NOT NULL DEFAULT '',
  `password` varchar(50) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `logins` VALUES 
('customer1','password1','customer'),
('customer2','password2','customer'),
('employee1','password1','employee'),
('admin1','12345','admin');

-- Table: GetLogin
DROP TABLE IF EXISTS `GetLogin`;
CREATE TABLE GetLogin (
	Username VARCHAR(50) NOT NULL,
    SSN VARCHAR(50),
    Email VARCHAR(100),
    PRIMARY KEY(Username, SSN, Email),
    FOREIGN KEY (Username) REFERENCES logins(username),
    FOREIGN KEY (SSN) REFERENCES Employees(SSN),
    FOREIGN KEY (Email) REFERENCES Customer(Email)
);

INSERT INTO GetLogin (Username, SSN, Email) VALUES 
('customer1', NULL, 'ericzhou@gmail.com'),
('customer2', NULL, 'ParagGupta@gmail.com'),
('admin1', '222-222-2222', NULL),
('employee1', '111-111-1111', NULL);


-- Table: Employees
DROP TABLE IF EXISTS `Employees`;
CREATE TABLE Employees (
    SSN VARCHAR(12) PRIMARY KEY,
    Username VARCHAR(50) NOT NULL,
    Password VARCHAR(50) NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL
);

INSERT INTO `Employees` VALUES 
('111-111-1111', 'JohnDoe@gmail.com', 'password', 'John', 'Doe'),
('222-222-2222', 'JaneDoe@gmail.com', 'password', 'Jane', 'Doe');

-- Table: CustomerRepresentative
DROP TABLE IF EXISTS `CustomerRepresentative`;
CREATE TABLE CustomerRepresentative (
    SSN VARCHAR(12) PRIMARY KEY,
    FOREIGN KEY (SSN) REFERENCES Employees(SSN)
);

INSERT INTO `CustomerRepresentative` VALUES 
('111-111-1111');

-- Table: Manager
DROP TABLE IF EXISTS `Manager`;
CREATE TABLE Manager (
    SSN VARCHAR(12) PRIMARY KEY,
    FOREIGN KEY (SSN) REFERENCES Employees(SSN)
);

INSERT INTO `Manager` VALUES 
('222-222-2222');

-- Table: Customer
DROP TABLE IF EXISTS `Customer`;
CREATE TABLE Customer (
    Email VARCHAR(100) PRIMARY KEY,
    Username VARCHAR(50) NOT NULL,
    Password VARCHAR(50) NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL
);

INSERT INTO `Customer` VALUES
('JustinGuo@gmail.com', 'JustinGuo', 'password111', 'Justin', 'Guo'),
('EricZhou@gmail.com', 'EricZhou', 'password222', 'Eric', 'Zhou'),
('ParagGupta@gmail.com', 'ParagGupta', 'password333', 'Parag', 'Gupta'),
('JoshuaPae@gmail.com', 'JoshuaPae', 'password444', 'Joshua', 'Pae');

-- Table: Train
DROP TABLE IF EXISTS `Train`;
CREATE TABLE Train (
    TrainID INT PRIMARY KEY
);

INSERT INTO `Train` VALUES
(1234);

-- Table: Stations
DROP TABLE IF EXISTS `Stations`;
CREATE TABLE Stations (
    StationID INT PRIMARY KEY,
    City VARCHAR(50) NOT NULL,
    State VARCHAR(50) NOT NULL
);

INSERT INTO `Stations` VALUES
(123456, 'New Brunswick', 'New Jersey'),
(123457, 'Philadephia', 'Pennsylvania'),
(123458, 'New York City', 'New York');

-- Table: TrainSchedule
DROP TABLE IF EXISTS `TrainSchedule`;
CREATE TABLE TrainSchedule (
    ScheduleID INT PRIMARY KEY AUTO_INCREMENT,
    TrainID INT NOT NULL,
    TransitLineName VARCHAR(50) NOT NULL,
    Fare DECIMAL(10, 2) NOT NULL,
    Origin VARCHAR(50) NOT NULL,
    Destination VARCHAR(50) NOT NULL,
    Stops VARCHAR(255),
    DepartDate DATE NOT NULL,
    ArrivalDate DATE NOT NULL,
    FOREIGN KEY (TrainID) REFERENCES Train(TrainID)
);

INSERT INTO `TrainSchedule` (TrainID, TransitLineName, Fare, Origin, Destination, Stops, DepartDate, ArrivalDate) VALUES
(1234, 'Northeast Corridor', 50.0, 'Philadelphia', 'New York', 'New Brunswick', '2024-12-10', '2024-12-10'),
(1235, 'Northwest Corridor', 50.0, 'New York', 'Philadephia', 'New Brunswick', '2024-12-10', '2024-12-10');

-- Table: Passes
DROP TABLE IF EXISTS `Passes`;
CREATE TABLE Passes (
    StationID INT NOT NULL,
    ScheduleID INT NOT NULL,
    PRIMARY KEY (StationID, ScheduleID),
    FOREIGN KEY (StationID) REFERENCES Stations(StationID),
    FOREIGN KEY (ScheduleID) REFERENCES TrainSchedule(ScheduleID)
);

INSERT INTO `Passes` (StationID, ScheduleID) VALUES
(123456, 1234),
(123457, 1234),
(123458, 1234);

-- Table: Reserves
DROP TABLE IF EXISTS `Reserves`;
CREATE TABLE Reserves (
    Email VARCHAR(100) NOT NULL,
    ScheduleID INT NOT NULL,
    PassengerNumber INT NOT NULL,
    PRIMARY KEY (Email, ScheduleID),
    FOREIGN KEY (Email) REFERENCES Customer(Email),
    FOREIGN KEY (ScheduleID) REFERENCES TrainSchedule(ScheduleID)
);

INSERT INTO `Reserves` (Email, ScheduleID, PassengerNumber) VALUES
('EricZhou@gmail.com', 1, 1),
('JoshuaPae@gmail.com', 2, 2);

-- Table: Helps
DROP TABLE IF EXISTS `Helps`;
CREATE TABLE Helps (
    RepresentativeSSN VARCHAR(12) NOT NULL,
    CustomerEmail VARCHAR(100) NOT NULL,
    PRIMARY KEY (RepresentativeSSN, CustomerEmail),
    FOREIGN KEY (RepresentativeSSN) REFERENCES CustomerRepresentative(SSN),
    FOREIGN KEY (CustomerEmail) REFERENCES Customer(Email)
);

INSERT INTO `Helps` (RepresentativeSSN, CustomerEmail) VALUES
('111-111-1111', 'JustinGuo@gmail.com'),
('111-111-1111', 'ParagGupta@gmail.com');

-- Table: Manages
DROP TABLE IF EXISTS `Manages`;
CREATE TABLE Manages (
    ManagerSSN VARCHAR(12) NOT NULL,
    RepresentativeSSN VARCHAR(21) NOT NULL,
    PRIMARY KEY (ManagerSSN, RepresentativeSSN),
    FOREIGN KEY (ManagerSSN) REFERENCES Manager(SSN),
    FOREIGN KEY (RepresentativeSSN) REFERENCES CustomerRepresentative(SSN)
);

INSERT INTO `Manages` (ManagerSSN, RepresentativeSSN) VALUES
('222-222-2222', '111-111-1111');

SELECT * FROM Passes;
