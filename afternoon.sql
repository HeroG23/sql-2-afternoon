--Part 1 Joins--

--PROBLEM 1--
SELECT *
FROM invoice i
JOIN invoice_line il ON il.invoice_id = i.invoice_id
WHERE il.unit_price > 0.99;

--PROBLEM 2--
SELECT i.invoice_date, c.first_name, c.last_name, i.total
FROM invoice i
JOIN customer c ON i.customer_id = c.customer_id;

--PROBLEM 3--
SELECT c.first_name, c.last_name, e.first_name, e.last_name
FROM customer c
JOIN employee e ON c.support_rep_id = e.employee_id;

--PROBLEM 4--
SELECT al.title, ar.name
FROM album al
JOIN artist ar ON al.artist_id = ar.artist_id;

--PROBLEM 5--
SELECT pt.track_id
FROM playlist_track pt
JOIN playlist p ON p.playlist_id = pt.playlist_id
WHERE p.name = 'Music';

--PROBLEM 6--
SELECT t.name
FROM track t
JOIN playlist_track pt ON pt.track_id = t.track_id
WHERE pt.playlist_id = 5;

--PROBLEM 7--
SELECT t.name, p.name
FROM track t
JOIN playlist_track pt ON t.track_id = pt.track_id
JOIN playlist p ON pt.playlist_id = p.playlist_id;

--PROBLEM 8--
SELECT t.name, a.title
FROM track t
JOIN album a ON t.album_id = a.album_id
JOIN genre g ON g.genre_id = t.genre_id
WHERE g.name = 'Alternative & Punk';

--Black Diamond--
SELECT p.name, g.name, al.title, ar.name
FROM artist ar
JOIN album al
ON al.artist_id = ar.artist_id
JOIN track t
ON al.album_id = t.album_id
JOIN genre g
ON t.genre_id = g.genre_id
JOIN playlist_track pt
ON pt.track_id = t.track_id
JOIN playlist p
ON p.playlist_id = pt.playlist_id;

--Part 2 Nested Queries--

--PROBLEM 1--
SELECT * FROM invoice
WHERE invoice_id in (
    SELECT invoice_id FROM invoice_line
    WHERE unit_price > 0.99
);

--PROBLEM 2--
SELECT * FROM playlist_track
WHERE playlist_id IN (
    SELECT playlist_id FROM playlist
    WHERE name = 'Music'
);

--PROBLEM 3--
SELECT name FROM track
WHERE track_id IN(
    SELECT track_id FROM playlist_track
    WHERE playlist_id = 5
);

--PROBLEM 4--
SELECT * FROM track
WHERE genre_id IN(
    SELECT genre_id FROM genre
    WHERE name = 'Comedy'
);

--PROBLEM 5--
SELECT * FROM track
WHERE album_id IN(
    SELECT album_id FROM album
    WHERE title = 'Fireball'
);

--PROBLEM 6--
SELECT * FROM track
WHERE album_id IN(
    SELECT album_id FROM album
    WHERE artist_id IN(
        SELECT artist_id FROM artist
        WHERE name = 'Queen'
    )
);

--Part 3 Updating Rows--

--PROBLEM 1--
UPDATE customer 
SET fax = null
WHERE fax IS NOT null;

--PROBLEM 2--
UPDATE customer 
SET company = 'Self'
WHERE company IS null;

--PROBLEM 3--
UPDATE customer
SET last_name = 'Thompson'
WHERE first_name = 'Julia' AND last_name = 'Barnett';

--PROBLEM 4--
UPDATE customer
SET support_rep_id = 4
WHERE email = 'luisrojas@yahoo.cl';

--PROBLEM 5--
UPDATE track
SET composer = 'The darkness around us'
WHERE genre_id = (
    SELECT genre_id FROM genre
    WHERE name = 'Metal'
) AND composer IS null;


--Part 4 Group By--

--PROBLEM 1--
SELECT COUNT(*), g.name
FROM track t
JOIN genre g ON t.genre_id = g.genre_id
GROUP BY g.name;

--PROBLEM 2--
SELECT COUNT(*), g.name
FROM track t
JOIN genre g ON g.genre_id = t.genre_id
WHERE g.name = 'Pop' OR g.name = 'Rock'
GROUP BY g.name;

--PROBLEM 3--
SELECT ar.name, COUNT(*)
FROM album al
JOIN artist ar ON ar.artist_id = al.artist_id
GROUP BY ar.name;

--Part 5 Use Distinct--

--PROBLEM 1--
SELECT DISTINCT composer
FROM track;

--PROBLEM 2--
SELECT DISTINCT billing_postal_code
FROM invoice;

--PROBLEM 3--
SELECT DISTINCT composer
FROM customer;

--Part 6 Delete Rows--

--TABLE--
CREATE TABLE practice_delete ( name TEXT, type TEXT, value INTEGER );
INSERT INTO practice_delete ( name, type, value ) 
VALUES ('delete', 'bronze', 50);
INSERT INTO practice_delete ( name, type, value ) 
VALUES ('delete', 'bronze', 50);
INSERT INTO practice_delete ( name, type, value ) 
VALUES ('delete', 'bronze', 50);
INSERT INTO practice_delete ( name, type, value ) 
VALUES ('delete', 'silver', 100);
INSERT INTO practice_delete ( name, type, value ) 
VALUES ('delete', 'silver', 100);
INSERT INTO practice_delete ( name, type, value ) 
VALUES ('delete', 'gold', 150);
INSERT INTO practice_delete ( name, type, value ) 
VALUES ('delete', 'gold', 150);
INSERT INTO practice_delete ( name, type, value ) 
VALUES ('delete', 'gold', 150);
INSERT INTO practice_delete ( name, type, value ) 
VALUES ('delete', 'gold', 150);

SELECT * FROM practice_delete;

--PROBLEM 1--
SELECT * FROM practice_delete;

DELETE FROM practice_delete
WHERE type = 'bronze';

--PROBLEM 2--
SELECT * FROM practice_delete;

DELETE FROM practice_delete
WHERE type = 'silver';

--PROBLEM 3--
SELECT * FROM practice_delete;

DELETE FROM practice_delete
WHERE value = 150;

--Part 7 eCommerce Simulation--

--TABLES
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    user_name VARCHAR(100),
    user_email VARCHAR(100)
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    product_price INTEGER
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    product_id INT REFERENCES products(product_id)
);

--users--
INSERT INTO users 
(user_name, user_email)
VALUES
('JOHN Wall', 'john_wall@gmail.com'),
('ALAN RICKMAN', 'alan_snape@outlook.com'),
('IDIOTA RAMIREZ', 'idiota_ramirez12324@yahoo.com');

--products--
INSERT INTO products
(product_name, product_price)
VALUES
('Tesla', 1235635),
('Range Rover', 56265656),
('Ford Fusion', 1);

--orders--
INSERT INTO orders
(user_id, product_id)
VALUES
(1,3),
(2,1),
(3,2);

--Get all products for the first order--
SELECT * FROM products
WHERE product_id = 1;

--All Orders--
SELECT * FROM orders

--Order Costs--
SELECT SUM(product_price)
FROM products p
JOIN orders o
ON o.product_id = p.product_id
WHERE o.order_id = 1;

--User Orders==
SELECT * 
FROM users u
JOIN orders o 
ON o.user_id = u.user_id
WHERE u.user_id = 1;

--Number of orders a user has--
SELECT COUNT(*), u.user_id
FROM orders o
JOIN users u
ON o.user_id = u.user_id
GROUP BY u.user_id;

--Black Diamond--

SELECT SUM(p.product_price), u.user_id
FROM products p
JOIN orders o
ON o.product_id = p.product_id
JOIN users u
ON u.user_id = o.user_id
GROUP BY u.user_id;