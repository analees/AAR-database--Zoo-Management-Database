

DROP DATABASE IF EXISTS aar_zoo;
CREATE DATABASE aar_zoo;
USE aar_zoo;

-- entities

CREATE TABLE Animal (
    animal_id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(256) NOT NULL,
    date_of_birth DATETIME NOT NULL,
    species VARCHAR(256) NOT NULL, 
    date_of_arrival DATETIME NOT NULL,
    gender VARCHAR(256) NOT NULL,
    funding_source VARCHAR(256) NOT NULL,
    food_type VARCHAR(256) NOT NULL,
    place_of_origin VARCHAR(256) NOT NULL,
    feeding_time TIME,
    health_status VARCHAR(256) NOT NULL,
    -- constraint
    CONSTRAINT chk_date_of_birth CHECK (date_of_birth <= SYSDATE()),
    CONSTRAINT chk_date_of_arrival CHECK (date_of_arrival <= SYSDATE()),
    PRIMARY KEY (animal_id)
);

CREATE TABLE Employee (
    employee_id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(256) NOT NULL,
    role VARCHAR(256) NOT NULL,
    age INT NOT NULL,
    salary DECIMAL(10,2) NOT NULL,
    -- constraint
    CONSTRAINT chk_age CHECK (age >= 16),
    PRIMARY KEY (employee_id)  
);

CREATE TABLE Exhibit (
    exhibit_id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(256) NOT NULL,
    location_in_zoo VARCHAR(256) NOT NULL,
    capacity INT NOT NULL,
    temperature VARCHAR(256) NOT NULL,
    PRIMARY KEY (exhibit_id),
    FOREIGN KEY (exhibit_id) REFERENCES Animal(animal_id)
);

CREATE TABLE Visitor (
    visitor_id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(256) NOT NULL,
    age INT NOT NULL,
    PRIMARY KEY (visitor_id)
);

CREATE TABLE Ticket (
    ticket_id INT NOT NULL AUTO_INCREMENT,
    visitor_id INT NOT NULL,
    exhibit_id INT NOT NULL,
    date_of_purchase DATETIME NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (ticket_id),
    FOREIGN KEY (visitor_id) REFERENCES Visitor(visitor_id),
    FOREIGN KEY (exhibit_id) REFERENCES Exhibit(exhibit_id)
);

CREATE TABLE Former_Employee (
    employee_id int NOT NULL,
    name VARCHAR(256) NOT NULL,
    date_of_departure DATETIME NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
);

CREATE TABLE Caretaker(
    employee_id INT NOT NULL,
    animal_id INT NOT NULL,
    PRIMARY KEY (employee_id, animal_id),
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id),
    FOREIGN KEY (animal_id) REFERENCES Animal(animal_id)
);

CREATE TABLE Veterinarian(
    employee_id INT NOT NULL,
    animal_id INT NOT NULL,
    PRIMARY KEY (employee_id, animal_id),
    health_checkup DATETIME NOT NULL,
    health_status VARCHAR(256) NOT NULL,
    medicine VARCHAR(256) NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id),
    FOREIGN KEY (animal_id) REFERENCES Animal(animal_id)
);

CREATE TABLE Feeding(
    employee_id INT NOT NULL,
    animal_id INT NOT NULL,
    PRIMARY KEY (employee_id, animal_id),
    feeding_schedule DATETIME NOT NULL,
    food VARCHAR(256) NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id),
    FOREIGN KEY (animal_id) REFERENCES Animal(animal_id)
);

CREATE TABLE AnimalExhibit(
    animal_id INT NOT NULL,
    exhibit_id INT NOT NULL,
    FOREIGN KEY (animal_id) REFERENCES Animal(animal_id),
    FOREIGN KEY (exhibit_id) REFERENCES Exhibit(exhibit_id)
);

-- triggers 
DELIMITER $$

    -- old employee moves from employee to former_employee
    CREATE TRIGGER move_to_former_employee
    BEFORE DELETE ON Employee
    FOR EACH ROW

    BEGIN
    INSERT INTO Employee(employee_id, name,date_of_departure)
    VALUES(OLD.employee_id, OLD.name, NOW());
    END $$

    -- update feeding time
    CREATE TRIGGER update_feeding_time
    AFTER INSERT ON Feeding
    FOR EACH ROW

    BEGIN 
    UPDATE Animal
    SET feeding_time = NEW.feeding_schedule
    WHERE animal_id = NEW.animal_id;
    END $$

    -- update health records
    CREATE TRIGGER update_health_records
    AFTER INSERT ON Veterinarian
    FOR EACH ROW 

    BEGIN 
    UPDATE Animal 
    SET health_status = NEW.health_status
    WHERE animal_id = NEW.animal_id;
    END $$
DELIMITER $$

-- *** Sample Data ***

INSERT INTO Animal (name, date_of_birth, species, date_of_arrival, gender, funding_source, food_type, place_of_origin, feeding_time, health_status)
VALUES 
('Leo', '2015-06-15', 'Lion', '2018-03-10', 'Male', 'Sponsorship', 'Meat', 'Safari Park', '08:00:00', 'Healthy'),
('Simba', '2017-08-22', 'Lion', '2019-05-15', 'Male', 'Zoo Fund', 'Meat', 'Zoo', '10:00:00', 'Healthy'),
('Nala', '2016-04-10', 'Lion', '2018-07-20', 'Female', 'Donation', 'Meat', 'Zoo', '12:00:00', 'Healthy'),
('Tigress', '2014-11-05', 'Tiger', '2017-02-25', 'Male', 'Government Grant', 'Meat', 'Wildlife Sanctuary', '14:00:00', 'Healthy'),
('Po', '2019-01-28', 'Panda', '2021-09-01', 'Female', 'Private Donor', 'Plant', 'China', '16:00:00', 'Healthy'),
('Boog', '2015-06-15', 'Bear', '2018-03-10', 'Male', 'Sponsorship', 'Meat', 'Safari Park', '08:00:00', 'Healthy'),
('Vincent', '2017-08-22', 'Bear', '2019-05-15', 'Male', 'Zoo Fund', 'Meat', 'Zoo', '10:00:00', 'Healthy'),
('Rhinox', '2016-04-10', 'Rhino', '2018-07-20', 'Female', 'Donation', 'Meat', 'Zoo', '12:00:00', 'Healthy'),
('Marty', '2014-11-05', 'Zebra', '2017-02-25', 'Male', 'Government Grant', 'Meat', 'Wildlife Sanctuary', '14:00:00', 'Healthy'),
('Melman', '2019-01-28', 'Giraffe', '2021-09-01', 'Female', 'Private Donor', 'Plant', 'China', '16:00:00', 'Healthy');

INSERT INTO Employee (name, role, age, salary)
VALUES 
('John Doe', 'Caretaker', 28, 45000.00),
('Jane Smith', 'Veterinarian', 35, 60000.00),
('Mike Johnson', 'Caretaker', 22, 35000.00),
('Emily Davis', 'Caretaker', 29, 40000.00),
('Chris Lee', 'Caretaker', 40, 30000.00);

INSERT INTO Exhibit (name, location_in_zoo, capacity, temperature)
VALUES 
('Lion Habitat', 'East Wing', 4, 'Warm'),
('Tiger Habitat', 'East Wing', 20, 'Warm'),
('Panda Habitat', 'North Wing', 10, 'Cool'),
('Forest Habitat', 'West Wing', 2, 'Cool'),
('Safari Habitat', 'South Wing', 20, 'Warm');

INSERT INTO AnimalExhibit (animal_id, exhibit_id)
VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 2),
(5, 3),
(6, 4),
(7, 4),
(8, 5),
(9, 5),
(10, 5);

INSERT INTO Visitor (name, age)
VALUES 
('Alice Brown', 34),
('Bob White', 28),
('Charlie Green', 45),
('Diana Black', 22),
('Eve Yellow', 50),
('Jason Mamoa', 40),
('Jack Black', 50),
('Emma Myers', 22),
('Danielle Brooks', 30),
('Sebastian Hansen', 12);

INSERT INTO Ticket (visitor_id, exhibit_id, date_of_purchase, price)
VALUES 
(1, 1, '2025-04-01 10:30:00', 15.00),
(2, 2, '2025-04-01 11:00:00', 15.00),
(3, 3, '2025-04-01 12:00:00', 15.00),
(4, 4, '2025-04-01 13:00:00', 15.00),
(5, 1, '2025-04-01 14:00:00', 15.00),
(6, 1, '2025-04-01 10:30:00', 15.00),
(7, 1, '2025-04-01 11:00:00', 15.00),
(8, 4, '2025-04-01 12:00:00', 15.00),
(9, 4, '2025-04-01 13:00:00', 15.00),
(10, 5, '2025-04-01 14:00:00', 15.00);

INSERT INTO Former_Employee (employee_id, name, date_of_departure)
VALUES 
(1, 'John Doe', '2024-09-30'),
(2, 'Jane Smith', '2024-09-30'),
(3, 'Mike Johnson', '2024-09-30');

INSERT INTO Caretaker (employee_id, animal_id)
VALUES 
(4, 1),
(4, 2),
(1, 3),
(3, 4),
(5, 5);

INSERT INTO Veterinarian (employee_id, animal_id, health_checkup, health_status, medicine)
VALUES 
(2, 1, '2025-03-24 09:00:00', 'Sick', 'None'),
(2, 2, '2025-03-24 10:00:00', 'Sick', 'None'),
(2, 3, '2025-03-24 11:00:00', 'Healthy', 'None'),
(2, 4, '2025-03-24 12:00:00', 'Healthy', 'None'),
(2, 5, '2025-03-24 13:00:00', 'Healthy', 'None'),
(2, 6, '2025-03-25 09:00:00', 'Healthy', 'None'),
(2, 7, '2025-03-25 10:00:00', 'Healthy', 'None'),
(2, 8, '2025-03-25 11:00:00', 'Sick', 'ibuprofen'),
(2, 9, '2025-03-25 12:00:00', 'Healthy', 'None'),
(2, 10, '2025-03-25 13:00:00', 'Healthy', 'None');

INSERT INTO Feeding (employee_id, animal_id, feeding_schedule, food)
VALUES 
(1, 1, '2024-10-01 08:00:00', 'Cow Meat'),
(3, 2, '2024-10-01 10:00:00', 'Cow Meat'),
(4, 3, '2024-10-01 12:00:00', 'Cow Meat'),
(5, 4, '2024-10-01 14:00:00', 'Cow Meat'),
(1, 5, '2024-10-01 16:00:00', 'Bamboo'),
(3, 6, '2024-10-01 08:00:00', 'Salmon'),
(4, 7, '2024-10-01 10:00:00', 'Salmon'),
(5, 8, '2024-10-01 12:00:00', 'Grass'),
(1, 9, '2024-10-01 14:00:00', 'Grass'),
(3, 10, '2024-10-01 16:00:00', 'Leaves');
