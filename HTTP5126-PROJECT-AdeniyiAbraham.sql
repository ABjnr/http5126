CREATE DATABASE gym_management;
USE gym_management;

-- CREATING THE MEMBERS TABLE
CREATE TABLE members (
    member_id INT AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone_number VARCHAR(15) NOT NULL,
    membership_type ENUM('Basic', 'Premium'),
    `status` ENUM('Active', 'Inactive'),
    join_date DATETIME NOT NULL,
    PRIMARY KEY (member_id)
);

-- CREATING THE TRAINERS TABLE
CREATE TABLE trainers (
    trainer_id INT AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(15) NOT NULL,
    specialization VARCHAR(75) NOT NULL,
    PRIMARY KEY (trainer_id)
);

-- CREATING THE CLASSES TABLE
CREATE TABLE classes (
    class_id INT AUTO_INCREMENT,
    `name` VARCHAR(100) NOT NULL,
    trainer_id INT,
    schedule_time DATETIME NOT NULL,
    max_capacity INT CHECK (max_capacity > 0 AND max_capacity <= 10),
    PRIMARY KEY (class_id),
    FOREIGN KEY (trainer_id) REFERENCES trainers(trainer_id)
);

-- CREATING THE CLASS REGISTRATIONS TABLE
CREATE TABLE class_registrations (
    class_registration_id INT AUTO_INCREMENT,
    member_id INT,
    class_id INT,
    `status` ENUM('Pending', 'Confirmed', 'Cancelled'),
    registration_date DATETIME NOT NULL,
    PRIMARY KEY (class_registration_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (class_id) REFERENCES classes(class_id)
);

-- CREATING THE PAYMENTS TABLE
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT,
    member_id INT,
    amount DECIMAL(10, 2) NOT NULL CHECK (amount > 0),
    `date` DATETIME NOT NULL,
    method VARCHAR(20) NOT NULL,
    PRIMARY KEY (payment_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);


-- CREATING A TRIGGER TO CHECK IF A CLASS IS AT MAX CAPACITY 
DELIMITER $$
CREATE TRIGGER trg_before_insert_class_registration
BEFORE INSERT ON class_registrations
FOR EACH ROW
BEGIN
    DECLARE total_registrations INT;
    DECLARE max_capacity INT;

    SELECT COUNT(*) INTO total_registrations
    FROM class_registrations
    WHERE class_id = NEW.class_id AND status = 'Confirmed';

    SELECT c.max_capacity INTO max_capacity
    FROM classes c
    WHERE c.class_id = NEW.class_id;

    IF NEW.status = 'Confirmed' AND total_registrations >= max_capacity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Class is full. Registration not allowed.';
    END IF;
END$$
DELIMITER ;



-- CREATING A VIEW TO CHECK ALL TRAINERS AND THEIR SCHEDULE
CREATE VIEW vw_trainer_schedule AS
SELECT 
    t.trainer_id,
    CONCAT(t.first_name, ' ', t.last_name) AS trainer_name,
    c.class_id,
    c.name AS class_name,
    c.schedule_time
FROM trainers t
JOIN classes c ON t.trainer_id = c.trainer_id
ORDER BY t.trainer_id, c.schedule_time;


-- CREATING A PROCEDURE TO CHECK IF A TRAINER IS AVAILABLE OR BOOKED
DELIMITER $$
CREATE PROCEDURE usp_check_trainer_availability (
    IN p_trainer_id INT,
    IN p_schedule_time DATETIME
)
BEGIN
    IF EXISTS (
        SELECT 1
        FROM classes
        WHERE trainer_id = p_trainer_id AND schedule_time = p_schedule_time
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Trainer is already booked at this time.';
    END IF;
END$$
DELIMITER ;

-- INSERTING DATA INTO THE MEMBERS TABLE
INSERT INTO members (first_name, last_name, email, phone_number, membership_type, `status`, join_date)
VALUES
('Liam', 'Johnson', 'liam.j@example.com', '6471234567', 'Premium', 'Active', '2024-01-15 10:00:00'),
('Emma', 'Williams', 'emma.w@example.com', '4162345678', 'Basic', 'Active', '2024-02-10 14:30:00'),
('Noah', 'Brown', 'noah.b@example.com', '9053456789', 'Premium', 'Inactive', '2024-03-05 08:45:00'),
('Olivia', 'Jones', 'olivia.j@example.com', '2894567890', 'Basic', 'Active', '2024-03-20 17:15:00'),
('Michael', 'Davis', 'michael.d@example.com', '6479876543', 'Premium', 'Active', '2024-01-20 11:30:00'),
('Sophia', 'Miller', 'sophia.m@example.com', '4168765432', 'Basic', 'Active', '2024-02-15 09:45:00'),
('William', 'Wilson', 'william.w@example.com', '9057654321', 'Premium', 'Active', '2024-02-28 14:15:00'),
('Isabella', 'Moore', 'isabella.m@example.com', '2896543210', 'Basic', 'Inactive', '2024-03-10 08:30:00'),
('James', 'Taylor', 'james.t@example.com', '6475432109', 'Premium', 'Active', '2024-03-15 16:00:00'),
('Charlotte', 'Anderson', 'charlotte.a@example.com', '4164321098', 'Basic', 'Active', '2024-03-25 10:45:00');

-- INSERTING DATA INTO THE TRAINERS TABLE
INSERT INTO trainers (first_name, last_name, email, phone_number, specialization)
VALUES
('Ava', 'Smith', 'ava.smith@trainer.com', '6471112233', 'Yoga'),
('Ethan', 'Clark', 'ethan.clark@trainer.com', '4162223344', 'Strength Training'),
('Sophia', 'Lee', 'sophia.lee@trainer.com', '9053334455', 'Cardio'),
('Benjamin', 'Wright', 'benjamin.w@trainer.com', '6474445566', 'Weight Loss'),
('Mia', 'Harris', 'mia.h@trainer.com', '4165556677', 'Pilates'),
('Lucas', 'Martin', 'lucas.m@trainer.com', '9056667788', 'CrossFit'),
('Amelia', 'Thompson', 'amelia.t@trainer.com', '2897778899', 'HIIT');

-- INSERTING DATA INTO THE CLASSES TABLE
INSERT INTO classes (`name`, trainer_id, schedule_time, max_capacity)
VALUES
('Morning Yoga', 1, '2024-04-14 08:00:00', 10),
('HIIT Workout', 2, '2024-04-14 10:00:00', 10),
('Evening Cardio', 3, '2024-04-14 18:00:00', 10),
('Pilates Fundamentals', 4, '2024-04-15 09:00:00', 10),
('CrossFit Challenge', 5, '2024-04-15 16:30:00', 10),
('Weight Loss Boot Camp', 3, '2024-04-16 07:00:00', 10),
('Evening Yoga Flow', 1, '2024-04-16 19:00:00', 10),
('Morning HIIT', 6, '2024-04-17 06:30:00', 10),
('Strength & Conditioning', 2, '2024-04-17 12:00:00', 10),
('Weekend Warriors', 5, '2024-04-18 10:00:00', 10);

-- INSERTING DATA INTO THE CLASS REGISTRATIONS TABLE
INSERT INTO class_registrations (member_id, class_id, `status`, registration_date)
VALUES
(2, 2, 'Pending', '2024-04-10 09:30:00'),
(3, 3, 'Confirmed', '2024-04-11 12:00:00'),
(5, 4, 'Confirmed', '2024-04-12 11:00:00'),
(6, 5, 'Confirmed', '2024-04-12 14:30:00'),
(7, 6, 'Pending', '2024-04-13 09:15:00'),
(8, 7, 'Confirmed', '2024-04-13 12:45:00'),
(9, 4, 'Confirmed', '2024-04-14 08:30:00'),
(10, 6, 'Cancelled', '2024-04-14 10:00:00'),
(1, 7, 'Confirmed', '2024-04-14 13:20:00'),
(3, 4, 'Pending', '2024-04-15 11:45:00'),
(4, 6, 'Confirmed', '2024-04-15 15:00:00'),
-- FILLING CLASS ONE TO MAX CAPACITY 
(2, 1, 'Confirmed', NOW()),
(3, 1, 'Confirmed', NOW()),
(5, 1, 'Confirmed', NOW()),
(6, 1, 'Confirmed', NOW()),
(7, 1, 'Confirmed', NOW()),
(8, 1, 'Confirmed', NOW()),
(9, 1, 'Confirmed', NOW()),
(10, 1, 'Confirmed', NOW());


-- INSERTING DATA INTO THE PAYMENT TABLE
INSERT INTO payments (member_id, amount, `date`, method)
VALUES
(1, 59.99, '2024-04-01 10:00:00', 'Credit Card'),
(2, 39.99, '2024-04-01 11:15:00', 'Debit'),
(3, 59.99, '2024-03-01 09:45:00', 'Cash'),
(4, 39.99, '2024-04-03 14:30:00', 'Credit Card'),
(5, 59.99, '2024-04-05 09:30:00', 'Credit Card'),
(6, 39.99, '2024-04-05 14:00:00', 'PayPal'),
(7, 59.99, '2024-04-06 10:15:00', 'Credit Card'),
(8, 39.99, '2024-04-07 16:30:00', 'Debit'),
(9, 59.99, '2024-04-08 11:45:00', 'Cash'),
(10, 39.99, '2024-04-09 13:00:00', 'Credit Card');



-- TO DISPLAY ALL THE DETAILS FROM THE VIEW
SELECT * FROM vw_trainer_schedule;

-- TO DISPLAY THE DETAILS OF A TRAINER WITH ID OF 2 
SELECT * FROM vw_trainer_schedule
WHERE trainer_id = 2;

-- RUNNING THE PROCEDURE TO CHECK IF A TRAINER IS AVAILABLE 
-- BEFORE ASSIGNING THEM TO ANOTHER CLASS 
CALL usp_check_trainer_availability(3, '2024-04-14 18:00:00');

-- RUNNING THE PROCEDURE FOR A TIME THE TRAINER ISN'T BOOKED
CALL usp_check_trainer_availability(3, '2024-04-20 10:00:00');

-- TRYING TO INSERT INTO THE CLASS REGISTRATIONS TABLE TO CHECK THE TRIGGER
-- THE LIMIT IS 10 FOR THE PURPOSE OF THIS PRESENTATION
-- This will FAIL due to your trigger
INSERT INTO class_registrations (member_id, class_id, status, registration_date)
VALUES (4, 2, 'Confirmed', NOW());


