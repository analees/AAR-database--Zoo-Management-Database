
-- Query 1: Animals assigned to specific caretakers (JOIN query)
-- This query shows which animals are assigned to which caretakers,
-- including the animal name, species, and caretaker name
SELECT a.animal_id, a.name AS animal_name, a.species, e.name AS caretaker_name, e.role
FROM Animal a
JOIN Caretaker c ON a.animal_id = c.animal_id
JOIN Employee e ON c.employee_id = e.employee_id
ORDER BY e.name, a.species;

-- Query 2: Feeding times for each enclosure (JOIN and GROUP BY)
-- This query shows feeding times for animals grouped by their enclosures
SELECT
    ex.exhibit_id, ex.name AS exhibit_name, ex.location_in_zoo, 
    MIN(a.feeding_time) AS earliest_feeding_time, 
    MAX(a.feeding_time) AS latest_feeding_time,
    COUNT(a.animal_id) AS number_of_animals
FROM Exhibit ex
JOIN AnimalExhibit ae ON ex.exhibit_id = ae.exhibit_id
JOIN Animal a ON ae.animal_id = a.animal_id
GROUP BY ex.exhibit_id, ex.name, ex.location_in_zoo
ORDER BY ex.location_in_zoo;

-- Query 3: Number of tickets sold in a given time period (SUBQUERY)
-- This query counts how many tickets were sold for each exhibit during a specific date range
SELECT
    e.exhibit_id, e.name AS exhibit_name,
    (SELECT COUNT(*) FROM Ticket t WHERE t.exhibit_id = e.exhibit_id 
    AND t.date_of_purchase BETWEEN '2025-04-01 00:00:00' AND '2025-04-30 23:59:59') AS tickets_sold,
    (SELECT SUM(price) FROM Ticket t WHERE t.exhibit_id = e.exhibit_id 
    AND t.date_of_purchase BETWEEN '2025-04-01 00:00:00' AND '2025-04-30 23:59:59') AS total_revenue
FROM Exhibit e
ORDER BY tickets_sold DESC;

-- Query 4: Health status statistics with WINDOW FUNCTION
-- This query uses window functions to calculate the percentage of healthy animals by species
SELECT 
    species,
    COUNT(*) AS total_animals,
    SUM(CASE WHEN health_status = 'Healthy' THEN 1 ELSE 0 END) AS healthy_animals,
    ROUND(SUM(CASE WHEN health_status = 'Healthy' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS healthy_percentage,
    ROUND(SUM(CASE WHEN health_status = 'Healthy' THEN 1 ELSE 0 END) * 100.0 / 
        SUM(COUNT(*)) OVER (), 2) AS percent_of_total_healthy
FROM Animal
GROUP BY species
ORDER BY healthy_percentage DESC;

-- Query 5: Enclosures at or near capacity (HAVING clause with calculations)
-- This query gets the exhibits with 
SELECT
        e.exhibit_id, e.name AS exhibit_name, e.capacity, 
        COUNT(ae.animal_id) AS current_occupancy,
        ROUND((COUNT(ae.animal_id) * 100.0 / e.capacity), 1) AS occupancy_percentage
FROM Exhibit e
JOIN AnimalExhibit ae ON e.exhibit_id = ae.exhibit_id
GROUP BY e.exhibit_id, e.name, e.capacity
HAVING (COUNT(ae.animal_id) * 100.0 / e.capacity) >= 75
ORDER BY occupancy_percentage DESC;

-- Query 6: TRANSACTION for updating an animal's health status
-- This transaction updates an animal's health status
-- and also logs this change in a veterinary record
START TRANSACTION;

-- First, update the animal's health status
UPDATE Animal
SET health_status = 'Recovering'
WHERE animal_id = 8;

-- Then, update the existing veterinary record
UPDATE Veterinarian
SET health_checkup = NOW(),
    health_status = 'Recovering',
    medicine = 'Antibiotics'
WHERE employee_id = 2 AND animal_id = 8;

-- Commit the transaction if everything is successful
COMMIT;
