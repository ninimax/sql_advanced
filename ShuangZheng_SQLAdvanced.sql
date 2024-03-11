-- Create Tables
CREATE TABLE warehouses (
    warehouse_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    location VARCHAR(100) NOT NULL
);

CREATE TABLE carriers (
    carrier_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    contact_person VARCHAR(50),
    contact_number VARCHAR(15)
);

CREATE TABLE shipments (
    shipment_id SERIAL PRIMARY KEY,
    tracking_number VARCHAR(20) UNIQUE NOT NULL,
    weight DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20) DEFAULT 'Pending',
    warehouse_id INT REFERENCES warehouses(warehouse_id),
    carrier_id INT REFERENCES carriers(carrier_id)
);

-- Seed Data
INSERT INTO warehouses (name, location) VALUES
    ('Warehouse A', 'Location A'),
    ('Warehouse B', 'Location B');

INSERT INTO carriers (name, contact_person, contact_number) VALUES
    ('Carrier X', 'John Doe', '123-456-7890'),
    ('Carrier Y', 'Jane Smith', '987-654-3210');

INSERT INTO shipments (tracking_number, weight, warehouse_id, carrier_id) VALUES
    ('ABC123', 150.5, 1, 1),
    ('XYZ789', 200.0, 2, 2);
	
SELECT * FROM shipments

--TASK 1.1
CREATE VIEW warehouse_shipments AS
SELECT s.tracking_number, s.weight, s.status, w.name 
FROM shipments s
JOIN warehouses w ON s.warehouse_id = w.warehouse_id;
SELECT * FROM warehouse_shipments;

--TASK 1.2
CREATE VIEW carrier_shipments AS
SELECT s.tracking_number, s.weight, s.status, c.name 
FROM shipments s
JOIN carriers c ON s.carrier_id = c.carrier_id;
SELECT * FROM carrier_shipments;

--TASK 2.1
WITH pending_shipments AS (
	SELECT s.tracking_number, s.weight, w.location
	FROM shipments s
	JOIN warehouses w ON s.warehouse_id = w.warehouse_id
	WHERE s.status = 'Pending'
)
SELECT * FROM pending_shipments;

--TASK 2.2
WITH heavy_shipments AS (
	SELECT s.tracking_number, s.weight, c.name
	FROM shipments s
	JOIN carriers c ON s.carrier_id = c.carrier_id
	WHERE s.weight > 200
)
SELECT * FROM heavy_shipments;

--TASK 3.1
BEGIN;
UPDATE shipments
SET status = 'Shipped', weight = weight + 10
WHERE tracking_number = 'ABC123';
COMMIT;
SELECT * FROM shipments;
--TASK 3.2
BEGIN;
INSERT INTO shipments (tracking_number, weight, warehouse_id, carrier_id)
VALUES ('LMN456', 180.75, 2, 2);
COMMIT;
SELECT * FROM shipments;

--TASK 4.1
CREATE INDEX idx_tracking_number ON shipments (tracking_number);
