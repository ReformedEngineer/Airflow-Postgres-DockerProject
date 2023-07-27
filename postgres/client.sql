
/*
This SQL script performs the following operations:

1. Creates a new database named 'client'.
2. Connects to the 'client' database.
3. Creates several tables including 'Customers', 'Emails', 'ContactNumbers', 'Stores', 'Orders', 'delivery_cost', 'returned', and 'Coupons'.
4. Copies data from CSV files into these tables.
5. Inserts specific data into 'delivery_cost' and 'returned' tables.
6. Creates a view 'new_customers_per_month' that shows the number of new customers each month.
*/

-- # Creating a new database named 'client'.
CREATE DATABASE client;

-- # Connecting to the 'client' database.
\c client

-- # Creating a table 'Customers' with columns 'unique_customer_id' and 'first_order'.
CREATE TABLE IF NOT EXISTS Customers (
    unique_customer_id INT PRIMARY KEY NOT NULL,
    first_order TIMESTAMP
);

-- # Copying data from a CSV file into the 'Customers' table.
COPY Customers FROM '/processed_data/Customers.csv' DELIMITER ',' CSV HEADER;

-- # Creating a table 'Emails' with 'email_id', 'email', and 'unique_customer_id' columns. 'unique_customer_id' is a foreign key referencing 'Customers' table.
CREATE TABLE IF NOT EXISTS Emails (
    email_id INT PRIMARY KEY NOT NULL,
    email TEXT NOT NULL,
    unique_customer_id INT NOT NULL,
    FOREIGN KEY (unique_customer_id) REFERENCES Customers(unique_customer_id)
);
-- # Copying data from a CSV file into the 'Emails' table.
COPY Emails FROM '/processed_data/Emails.csv' DELIMITER ',' CSV HEADER;

-- # Creating a table 'ContactNumbers' with 'contact_id', 'contact_no', and 'unique_customer_id' columns. 'unique_customer_id' is a foreign key referencing 'Customers' table.
CREATE TABLE IF NOT EXISTS ContactNumbers (
    contact_id INT PRIMARY KEY NOT NULL,
    contact_no TEXT NOT NULL,
    unique_customer_id INT NOT NULL,
    FOREIGN KEY (unique_customer_id) REFERENCES Customers(unique_customer_id)
);

-- # Copying data from a CSV file into the 'ContactNumbers' table.
COPY ContactNumbers FROM '/processed_data/ContactNumbers.csv' DELIMITER ',' CSV HEADER;

-- # Creating a table 'Stores' with 'id', 'name', 'business_id', 'latitude', and 'longitude' columns.
CREATE TABLE IF NOT EXISTS Stores (
    id INT PRIMARY KEY NOT NULL,
    name TEXT NOT NULL,
    business_id INT,
    latitude FLOAT,
    longitude FLOAT
);

-- # Copying data from a CSV file into the 'Stores' table.
COPY Stores FROM '/processed_data/Stores.csv' DELIMITER ',' CSV HEADER;

-- # Creating a table 'Orders' with various columns. 'store_id' is a foreign key referencing 'Stores' table and 'unique_customer_id' is a foreign key referencing 'Customers' table.
CREATE TABLE IF NOT EXISTS Orders (
    id INT PRIMARY KEY NOT NULL,
    date TIMESTAMP,
    store_id INT NOT NULL,
    unique_customer_id INT NOT NULL,
    cost_total DECIMAL(10, 2),
    delivery_cost DECIMAL(10, 2),
    refund_total DECIMAL(10, 2),
    delivery_refund_total DECIMAL(10, 2),
    FOREIGN KEY (store_id) REFERENCES Stores(id),
    FOREIGN KEY (unique_customer_id) REFERENCES Customers(unique_customer_id)
);

-- # Copying data from a CSV file into the 'Orders' table.
COPY Orders FROM '/processed_data/Orders.csv' DELIMITER ',' CSV HEADER;


-- # Creating a table 'delivery_cost' with 'deliverycost_id' and 'deliverycost' columns.
CREATE TABLE IF NOT EXISTS delivery_cost (
    deliverycost_id INT PRIMARY KEY,
    deliverycost TEXT NOT NULL
);


-- # Inserting data into the 'delivery_cost' table.
INSERT INTO delivery_cost (deliverycost_id, deliverycost) VALUES 
(1, 'FREE'),
(0, 'NOT FREE');

-- # Creating a table 'returned' with 'return_id' and 'is_returned' columns.
CREATE TABLE IF NOT EXISTS returned (
    return_id INT PRIMARY KEY,
    is_returned TEXT NOT NULL
);


-- # Inserting data into the 'returned' table.
INSERT INTO returned (return_id, is_returned) VALUES 
(1, 'Yes'),
(0, 'NO');


-- # Creating a table 'Coupons' with various columns. 'order_id' is a foreign key referencing 'Orders' table, 'freedelivery' is a foreign key referencing 'delivery_cost' table, and 'returned' is a foreign key referencing 'returned' table.
CREATE TABLE IF NOT EXISTS Coupons (
    coupon_id INT PRIMARY KEY NOT NULL,
    order_id INT,
    code TEXT,
    name TEXT,
    freedelivery INT,
    amountoff FLOAT,
    percentoff FLOAT,
    deduct FLOAT,
    returned INT,
    timestamp TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES Orders(id),
    FOREIGN KEY (freedelivery) REFERENCES delivery_cost(deliverycost_id),
    FOREIGN KEY (returned) REFERENCES returned(return_id)
);

-- # Copying data from a CSV file into the 'Coupons' table.
COPY Coupons FROM '/processed_data/Coupons.csv' DELIMITER ',' CSV HEADER;


-- # Creating a view 'new_customers_per_month' that shows the number of new customers each month.
CREATE VIEW new_customers_per_month AS 
SELECT 
    DATE_TRUNC('month', first_order) AS month, 
    COUNT(DISTINCT unique_customer_id) AS new_customers 
FROM 
    Customers 
GROUP BY 
    month;
