INSERT INTO Train (TrainID, Color)
VALUES
(1, 'Red'),
(2, 'Blue'),
(3, 'Green'),
(4, 'Yellow');

INSERT INTO TrainSchedule (transitLineName, Train, Origin, Destination, departDate, arrivalDate, totalTravelTime, fare, stopCount)
VALUES
('Red Line', 1, 'Boston', 'New York', '2023-11-22 08:00:00', '2023-11-22 12:00:00', 240, 50.00, 3),
('Blue Line', 2, 'Chicago', 'Detroit', '2023-11-23 10:00:00', '2023-11-23 13:00:00', 180, 40.00, 2),
('Green Line', 3, 'Los Angeles', 'San Francisco', '2023-11-24 12:00:00', '2023-11-25 08:00:00', 480, 80.00, 5),
('Yellow Line', 4, 'Miami', 'Orlando', '2023-11-25 09:00:00', '2023-11-25 11:00:00', 120, 30.00, 1);

INSERT INTO TrainStation (stationID, name, cityName, state)
VALUES
(1, 'Boston South Station', 'Boston', 'MA'),
(2, 'New York Penn Station', 'New York', 'NY'),
(3, 'Chicago Union Station', 'Chicago', 'IL'),
(4, 'Detroit Central Station', 'Detroit', 'MI');

INSERT INTO TrainStops (transitLineName, Train, stationID, stopOrder, arrivalTime, departureTime)
VALUES
('Red Line', 1, 1, 1, '2023-11-22 08:00:00', '2023-11-22 08:30:00'),
('Red Line', 1, 2, 2, '2023-11-22 11:30:00', '2023-11-22 12:00:00'),
('Blue Line', 2, 3, 1, '2023-11-23 10:00:00', '2023-11-23 10:30:00'),
('Blue Line', 2, 4, 2, '2023-11-23 12:30:00', '2023-11-23 13:00:00');


INSERT INTO Customer (emailAddress, lastName, firstName, username, password)
VALUES
('john.doe@email.com', 'Doe', 'John', 'johndoe', 'password123'),
('jane.smith@email.com', 'Smith', 'Jane', 'janesmith', 'pass456'),
('michael.johnson@email.com', 'Johnson', 'Michael', 'mjohnson', 'pass789'),
('emily.davis@email.com', 'Davis', 'Emily', 'emdavis', 'pass012');

INSERT INTO Reservation (Number, emailAddress, transitLineName, Train, Origin, Destination, departDate, arrivalDate, fare, Passenger, totalFare)
VALUES
(1, 'john.doe@email.com', 'Red Line', 1, 'Boston', 'New York', '2023-11-22', '2023-11-22', 50.00, 'John Doe', 100.00),
(2, 'jane.smith@email.com', 'Blue Line', 2, 'Chicago', 'Detroit', '2023-11-23', '2023-11-23', 40.00, 'Jane Smith', 80.00),
(3, 'michael.johnson@email.com', 'Green Line', 3, 'Los Angeles', 'San Francisco', '2023-11-24', '2023-11-25', 80.00, 'Michael Johnson', 160.00),
(4, 'emily.davis@email.com', 'Yellow Line', 4, 'Miami', 'Orlando', '2023-11-25', '2023-11-25', 30.00, 'Emily Davis', 60.00);


INSERT INTO Employee (SSN, lastName, firstName, username, password, role)
VALUES
('123456789', 'Smith', 'Alice', 'alicesmith', 'emp123', 'Admin'),
('987654321', 'Brown', 'Bob', 'bobbrown', 'emp456', 'Employee'),
('456789123', 'Davis', 'David', 'davdavis', 'emp789', 'Admin'),
('789123456', 'Miller', 'Mike', 'mikemiller', 'emp012', 'Employee');


INSERT INTO CustomerIssues (emailAddress, issueDescription, response, salesRepSSN)
VALUES
('john.doe@email.com', 'Train was delayed', 'We apologize for the inconvenience', '123456789'),
('jane.smith@email.com', 'Seat was uncomfortable', 'We will investigate', '987654321'),
('michael.johnson@email.com', 'Baggage was lost', 'We will assist in locating your baggage', '456789123'),
('emily.davis@email.com', 'Ticket was not valid', 'Please contact customer service', '789123456');
