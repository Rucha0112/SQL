                                                 -- -- -- -- -- EVENT MANAGEMENT SYSTEM PROJECT -- -- -- -- -- 
create database projectevent ;
use projectevent ;
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100),
    email VARCHAR(100),
    password VARCHAR(100),
    phone_number VARCHAR(15),
    role ENUM('client', 'manager') DEFAULT 'client',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
select * from users ;
INSERT INTO Users (full_name, email, password, phone_number, role)
VALUES ('John Doe', 'john.doe@example.com', 'password123', '1234567890', 'client'),
       ('joseph mar' , 'joseph.mar@gmail.com', 'password124', '789123456' , 'client') ,
       ('Alice Smith', 'alice.smith@example.com', 'password456', '9876543210', 'manager') ;

CREATE TABLE Events (
    event_id INT PRIMARY KEY AUTO_INCREMENT,
    event_name VARCHAR(100),
    event_date DATE,
    location VARCHAR(100),
    client_id INT,
    manager_id INT,
    budget DECIMAL(10,2),
    status ENUM('scheduled', 'completed', 'canceled') DEFAULT 'scheduled',
    FOREIGN KEY (client_id) REFERENCES Users(user_id),
    FOREIGN KEY (manager_id) REFERENCES Users(user_id)
);
select * from events ;
INSERT INTO Events (event_name, event_date, location, client_id, manager_id, budget)
VALUES ('Corporate Meeting', '2024-10-15', 'City Hall', 1, 2, 5000.00),
       ('Wedding', '2024-11-20', 'Grand Plaza', 1, 2, 15000.00),
       ('Birthday Party' , '2024-12-01' , 'Diamond Hall' , 1, 2, 16000) ;

CREATE TABLE Services (
    service_id INT PRIMARY KEY AUTO_INCREMENT,
    service_name VARCHAR(100),
    cost DECIMAL(10,2)
);
select * from services ;
INSERT INTO Services (service_name, cost)
VALUES ('Catering', 3000.00),
       ('Sound System', 1000.00),
       ('colddrink' , 5000) ;
	
CREATE TABLE Event_Services (
    event_id INT,
    service_id INT,
    quantity INT,
    PRIMARY KEY (event_id, service_id),
    FOREIGN KEY (event_id) REFERENCES Events(event_id),
    FOREIGN KEY (service_id) REFERENCES Services(service_id)
);
select * from event_services ;
INSERT INTO Event_Services (event_id, service_id, quantity)
VALUES (1, 1, 1),   -- 1 sound system for Event 2
	   (2, 2, 100), -- 100 plates of catering for Event 1
       (3, 3, 10);  -- 10 botles of coldrinks for Event 3 
       
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    event_id INT,
    payment_amount DECIMAL(10,2),
    payment_date DATE,
    payment_method ENUM('credit_card', 'paypal', 'bank_transfer'),
    status ENUM('pending', 'completed', 'failed') DEFAULT 'pending',
    FOREIGN KEY (event_id) REFERENCES Events(event_id)
);
select * from payments ;
INSERT INTO Payments (event_id, payment_amount, payment_date)
VALUES (1, 2500.00, '2024-09-20'),
       (2, 7500.00, '2024-09-21'),
       (3, 5000.00, '2024-01-24') ;

CREATE TABLE Feedback (
    feedback_id INT PRIMARY KEY AUTO_INCREMENT,
    event_id INT,
    client_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comments TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (event_id) REFERENCES Events(event_id),
    FOREIGN KEY (client_id) REFERENCES Users(user_id)
);
select * from feedback ;
INSERT INTO Feedback (event_id, client_id, rating, comments)
VALUES (1, 1, 5, 'Amazing event! Everything was perfect.'),
       (2, 1, 4, 'Great event but the sound system was a bit loud.'),
       (3, 1, 3, 'everything is good but colddrink taste was not good.') ;
       
                                          -- -- -- -- --  QUESTIONS -- -- -- -- --
 -- 1.)  Write a query to retrieve all events managed by the manager with manager_id = 2. --
 SELECT event_name, event_date, location, budget 
FROM Events 
WHERE manager_id = 2;

-- 2.) Write a query to list all services provided for the event with event_id = 1. --
SELECT s.service_name, es.quantity
FROM Event_Services es
JOIN Services s ON es.service_id = s.service_id
WHERE es.event_id = 1;

-- 3.) Write a query to calculate the total budget for all events managed by the manager with manager_id = 2. --
SELECT SUM(budget) AS total_budget
FROM Events
WHERE manager_id = 2 ;

-- 4.) Write a query to find all clients who have organized more than one event.--
SELECT u.full_name, COUNT(e.event_id) AS event_count
FROM Users u
JOIN Events e ON u.user_id = e.client_id
WHERE u.role = 'client'
GROUP BY u.full_name
HAVING COUNT(e.event_id) > 1;

-- 5.) Write a query to list all events that have received a feedback rating of 5.--
SELECT e.event_name, f.rating, f.comments
FROM Events e
JOIN Feedback f ON e.event_id = f.event_id
WHERE f.rating = 5;

-- 6.) Write a query to retrieve all events that took place at the Grand Plaza.-- 
SELECT event_name, event_date, budget
FROM Events
WHERE location = 'Grand Plaza';

-- 7.) Write a query to calculate the total revenue from all completed payments.--
SELECT SUM(payment_amount) AS total_revenue
FROM Payments
WHERE status = 'completed';

-- 8.) Write a query to find all clients who haven’t organized any events.--
SELECT full_name
FROM Users u
LEFT JOIN Events e ON u.user_id = e.client_id
WHERE u.role = 'client' AND e.event_id IS NULL;

-- 9.) Write a query to find the event with the highest budget and the name of the client who organized it.--
SELECT e.event_name, e.budget, u.full_name
FROM Events e
JOIN Users u ON e.client_id = u.user_id
ORDER BY e.budget DESC
LIMIT 1;

-- 10.) Write a query to list all feedback provided for the event with event_id = 2.--
SELECT f.rating, f.comments, u.full_name
FROM Feedback f
JOIN Users u ON f.client_id = u.user_id
WHERE f.event_id = 2;

-- 11.) Write a query to count how many events are in each status.--
SELECT status, COUNT(event_id) AS event_count
FROM Events
GROUP BY status;

-- 12.) Write a query to find events where the total cost of services exceeds the event's budget.-- 
SELECT e.event_name, e.budget, SUM(s.cost * es.quantity) AS total_service_cost
FROM Events e
JOIN Event_Services es ON e.event_id = es.event_id
JOIN Services s ON es.service_id = s.service_id
GROUP BY e.event_id
HAVING SUM(s.cost * es.quantity) > e.budget;

-- 13.) Write a query to retrieve all events and the total amount of payments made for each event.-- 
SELECT e.event_name, SUM(p.payment_amount) AS total_payments
FROM Events e
JOIN Payments p ON e.event_id = p.event_id
GROUP BY e.event_name;

-- 14.) Write a query to find all events that have no services assigned.--
SELECT event_name
FROM Events e
LEFT JOIN Event_Services es ON e.event_id = es.event_id
WHERE es.event_id IS NULL;

                                               -- -- -- -- -- Overview -- -- -- -- --
-- Users: Manages clients and managers.
-- Events: Holds event details.
-- Services: Lists services like catering and sound systems.
-- Event_Services: Links events and services.
-- Payments: Tracks payments for events.
-- Feedback: Stores client feedback.















       
       








