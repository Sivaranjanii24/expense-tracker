CREATE DATABASE expense_tracker;
USE expense_tracker;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL
);

CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL
);

INSERT INTO categories (category_name) VALUES
('Food'),
('Travel'),
('Shopping'),
('Bills'),
('Entertainment'),
('Health'),
('Others');

CREATE TABLE expenses (
    expense_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    category_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    expense_date DATE NOT NULL,
    description VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE TABLE budgets (
    budget_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    month_year VARCHAR(7) NOT NULL,  -- Format: YYYY-MM
    budget_amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

INSERT INTO users (name, email, password) VALUES
('Sivaranjani', 'siva@gmail.com', '12345');

INSERT INTO expenses (user_id, category_id, amount, expense_date, description)
VALUES
(1, 1, 250.00, '2025-10-01', 'Lunch'),
(1, 2, 1200.00, '2025-10-03', 'Bus ticket'),
(1, 3, 500.00, '2025-10-05', 'Clothes shopping'),
(1, 4, 700.00, '2025-10-07', 'Electricity bill'),
(1, 5, 300.00, '2025-10-09', 'Movie'),
(1, 1, 200.00, '2025-10-10', 'Snacks');

INSERT INTO budgets (user_id, month_year, budget_amount)
VALUES (1, '2025-10', 5000.00);

SELECT c.category_name, SUM(e.amount) AS total_spent
FROM expenses e
JOIN categories c ON e.category_id = c.category_id
WHERE e.user_id = 1
GROUP BY c.category_name
ORDER BY total_spent DESC;

#Total expenses per month
SELECT DATE_FORMAT(expense_date, '%Y-%m') AS month, SUM(amount) AS total
FROM expenses
WHERE user_id = 1
GROUP BY month;

#Remaining budject for the month
SELECT 
    b.month_year,
    b.budget_amount AS Budget,
    IFNULL(SUM(e.amount), 0) AS Spent,
    (b.budget_amount - IFNULL(SUM(e.amount), 0)) AS Remaining
FROM budgets b
LEFT JOIN expenses e 
    ON b.user_id = e.user_id 
   AND DATE_FORMAT(e.expense_date, '%Y-%m') = b.month_year
WHERE b.user_id = 1
GROUP BY b.month_year, b.budget_amount;

#Top 3 categories with highest expenses
SELECT c.category_name, SUM(e.amount) AS total_spent
FROM expenses e
JOIN categories c ON e.category_id = c.category_id
WHERE e.user_id = 1
GROUP BY c.category_name
ORDER BY total_spent DESC
LIMIT 3;

#Daily spending details
SELECT expense_date, SUM(amount) AS daily_total
FROM expenses
WHERE user_id = 1
GROUP BY expense_date
ORDER BY expense_date;



