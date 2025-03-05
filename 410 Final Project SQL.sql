CREATE TABLE Restaurant 
(
    restaurant_id INT PRIMARY KEY, 
    restaurant_name VARCHAR(200), 
    restaurant_location VARCHAR(200),
    restaurant_phone VARCHAR(20),
    restaurant_website VARCHAR(200)
);

CREATE TABLE Menu
(
    menu_id INT,
    restaurant_id INT,
    num_of_items INT,
    menu_type VARCHAR(200), /*Can be value regular, seasonal, new years, etc.*/
    menu_version INT,
    FOREIGN KEY (restaurant_id) REFERENCES Restaurant(restaurant_id),
    PRIMARY KEY(menu_id, restaurant_id),
    UNIQUE (menu_id)
);

CREATE TABLE Menu_Item
(
    item_name VARCHAR(200),
    menu_id INT,
    item_description VARCHAR(200),
    item_ingredients VARCHAR(200),
    PRIMARY KEY(item_name, menu_id),
    FOREIGN KEY (menu_id) REFERENCES Menu(menu_id)
);

CREATE TABLE Orders
(
    order_id NUMBER PRIMARY KEY,
    restaurant_id NUMBER,
    order_date DATE,
    order_cost FLOAT,
    order_phone NUMBER(1) CHECK (order_phone IN (0, 1)),  -- Use 0 for FALSE, 1 for TRUE
    order_web NUMBER(1) CHECK (order_web IN (0, 1)),      -- Use 0 for FALSE, 1 for TRUE
    order_in_person NUMBER(1) CHECK (order_in_person IN (0, 1)), -- Use 0 for FALSE, 1 for TRUE
    FOREIGN KEY (restaurant_id) REFERENCES Restaurant (restaurant_id)
);


CREATE TABLE Current_Orders
(
    order_id INT PRIMARY KEY,
    order_status VARCHAR(200),
    order_special_request VARCHAR(200),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

CREATE TABLE Canceled_Orders
(
    order_id INT PRIMARY KEY,
    refund_status VARCHAR(200),
    cancel_reason VARCHAR(200),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

CREATE TABLE Past_Orders
(
    order_id INT PRIMARY KEY,
    completion_status VARCHAR(200),
    completion_date DATE
);

CREATE TABLE Archive_Orders
(
    archive_id INT PRIMARY KEY,
    order_id INT,
    FOREIGN KEY (order_id) REFERENCES Past_Orders(order_id) /*note this foreign key references another*/
);

CREATE TABLE Customer
(
    customer_id INT PRIMARY KEY,
    customer_first_name VARCHAR(200),
    customer_last_name VARCHAR(200),
    customer_phone VARCHAR(20),
    customer_email VARCHAR(200),
    customer_payment_method VARCHAR(200)
);

CREATE TABLE Ticket
(
    ticket_id INT PRIMARY KEY,
    customer_id INT,
    order_id INT,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- Insert Statements for Restaurant
INSERT INTO Restaurant (restaurant_id, restaurant_name, restaurant_location, restaurant_phone, restaurant_website) 
VALUES (1, 'The Gourmet Kitchen', '123 Culinary Ave', '123-456-7890', 'http://gourmetkitchen.com');

INSERT INTO Restaurant (restaurant_id, restaurant_name, restaurant_location, restaurant_phone, restaurant_website) 
VALUES (2, 'Pasta Palace', '456 Noodle St', '987-654-3210', 'http://pastapalace.com');

-- Insert Statements for Menu
INSERT INTO Menu (menu_id, restaurant_id, num_of_items, menu_type, menu_version) 
VALUES (1, 1, 10, 'Regular', 2023);

INSERT INTO Menu (menu_id, restaurant_id, num_of_items, menu_type, menu_version) 
VALUES (2, 1, 5, 'Seasonal', 2023);

INSERT INTO Menu (menu_id, restaurant_id, num_of_items, menu_type, menu_version) 
VALUES (3, 2, 8, 'Regular', 2023);

-- Insert Statements for Menu_Item
INSERT INTO Menu_Item (item_name, menu_id, item_description, item_ingredients) 
VALUES ('Truffle Pasta', 1, 'Pasta with truffle sauce', 'Pasta, truffle, cream, cheese');

INSERT INTO Menu_Item (item_name, menu_id, item_description, item_ingredients) 
VALUES ('Seasonal Salad', 2, 'Fresh greens with seasonal fruits', 'Lettuce, apple, nuts, dressing');

INSERT INTO Menu_Item (item_name, menu_id, item_description, item_ingredients) 
VALUES ('Spaghetti Bolognese', 3, 'Classic spaghetti with meat sauce', 'Spaghetti, ground beef, tomato sauce');

-- Insert Statements for Orders
INSERT INTO Orders (order_id, restaurant_id, order_date, order_cost, order_phone, order_web, order_in_person) 
VALUES (1, 1, TO_DATE('2024-12-01', 'YYYY-MM-DD'), 50.00, 1, 0, 0);

INSERT INTO Orders (order_id, restaurant_id, order_date, order_cost, order_phone, order_web, order_in_person) 
VALUES (2, 2, TO_DATE('2024-12-02', 'YYYY-MM-DD'), 30.00, 0, 1, 0);

INSERT INTO Orders (order_id, restaurant_id, order_date, order_cost, order_phone, order_web, order_in_person) 
VALUES (3, 1, TO_DATE('2024-12-03', 'YYYY-MM-DD'), 45.00, 0, 0, 1);

-- Insert Statements for Current_Orders
INSERT INTO Current_Orders (order_id, order_status, order_special_request) 
VALUES (1, 'Preparing', 'Extra cheese');

INSERT INTO Current_Orders (order_id, order_status, order_special_request) 
VALUES (2, 'Delivering', 'No nuts');

-- Insert Statements for Canceled_Orders
INSERT INTO Canceled_Orders (order_id, refund_status, cancel_reason) 
VALUES (3, 'Refunded', 'Customer canceled before preparation');

-- Insert Statements for Past_Orders
INSERT INTO Past_Orders (order_id, completion_status, completion_date) 
VALUES (1, 'Completed', TO_DATE('2024-12-01', 'YYYY-MM-DD'));

-- Insert Statements for Archive_Orders
INSERT INTO Archive_Orders (archive_id, order_id) 
VALUES (1, 1);

-- Insert Statements for Customer
INSERT INTO Customer (customer_id, customer_first_name, customer_last_name, customer_phone, customer_email, customer_payment_method) 
VALUES (1, 'John', 'Doe', '123-456-7890', 'john.doe@example.com', 'Credit Card');

INSERT INTO Customer (customer_id, customer_first_name, customer_last_name, customer_phone, customer_email, customer_payment_method) 
VALUES (2, 'Jane', 'Smith', '987-654-3210', 'jane.smith@example.com', 'PayPal');

-- Insert Statements for Ticket
INSERT INTO Ticket (ticket_id, customer_id, order_id) 
VALUES (1, 1, 1);

INSERT INTO Ticket (ticket_id, customer_id, order_id) 
VALUES (2, 2, 2);

-- 1. --
SELECT restaurant_name, restaurant_location, restaurant_phone, restaurant_website
FROM Restaurant;
-- Retrives customer-understandable information about all restaurants --

-- 2. --
SELECT Current_Orders.*,
  (SELECT COUNT(*)
    FROM Current_Orders
    WHERE order_status = 'Preparing')
FROM Current_Orders
WHERE order_status = 'Preparing';
-- Retrieves all current and ongoing orders and how many there are --

-- 3. --
SELECT order_id, restaurant_id, order_date, order_cost
FROM Orders
WHERE restaurant_id = 2
AND order_web = 1
AND order_date >= TO_DATE('2024-12-01', 'YYYY-MM-DD')
AND order_date <= TO_DATE('2024-12-31', 'YYYY-MM-DD');
-- Retrieves all web orders for a single restaurant in the month of December 2024 --

-- 4. --
SELECT order_id, refund_status, cancel_reason
FROM Canceled_Orders
WHERE order_id IN (
  SELECT order_id
  FROM Orders
  WHERE order_date > TO_DATE('2024-12-01', 'YYYY-MM-DD'));
-- Retrieves all cancelled orders after December 1st, 2024 --

-- 5. --
SELECT restaurant_id, AVG(order_cost)
FROM Orders
WHERE order_date > TO_DATE('2023-12-31', 'YYYY-MM-DD')
GROUP BY restaurant_id;
-- Retrieves the average cost of all orders placed after 2023 for each restaurant and groups them by restaurant --

-- 6. --
SELECT restaurant_id, COUNT(order_id)
FROM Orders
WHERE order_date >= TO_DATE('2024-01-01', 'YYYY-MM-DD')
AND order_date <= TO_DATE('2024-12-31', 'YYYY-MM-DD')
GROUP BY restaurant_id;
-- Retrieves the total number of orders for each restaurant for the year 2024 and groups them by restaurant --

-- 7. --
UPDATE Canceled_Orders
SET refund_status = 'Completed'
WHERE order_id = 1;
-- Updates the refund status of an order with an order_id of 1 to "Completed" --

-- 8. --
UPDATE Orders
SET order_cost = order_cost * 0.75
WHERE order_cost >= 50.00;
-- Applies a 25% off discount to orders whose total's are equal to or exceed $50.00 --

-- 9. --
SELECT Customer.customer_first_name, Customer.customer_last_name, Orders.order_cost, Orders.order_date
FROM Ticket
JOIN Customer on Ticket.customer_id = Customer.customer_id
JOIN Orders on Ticket.order_id = Orders.order_id
WHERE Ticket.ticket_id = 1; 
-- Retreives customer first name, last name, order cost, and order date from ticket 1 -- 

-- 10. --
SELECT ord.order_id, ord.order_cost, mi.item_name, mi.item_description
FROM Orders ord
JOIN Menu ON ord.restaurant_id = Menu.restaurant_id
JOIN Menu_item mi ON Menu.menu_id = mi.menu_id
WHERE ord.order_date = TO_DATE('2024-12-03', 'YYYY-MM-DD'); 
-- Retreives order ID, cost, item name, and description from all orders placed on a specific date -- 