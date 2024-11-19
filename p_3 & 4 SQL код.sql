/*
 3.  
Перейдіть до бази даних, з якою працювали у темі 3. Напишіть запит за допомогою операторів 
FROM та INNER JOIN, що об’єднує всі таблиці даних, які ми завантажили з файлів: order_details, 
orders, customers, products, categories, employees, shippers, suppliers. Для цього ви маєте знайти 
спільні ключі.*/

-- Використовуємо схему goit-rdb-hw-03
USE `goit-rdb-hw-03`; -- Вказуємо схему для роботи

-- Об'єднуємо всі таблиці за допомогою INNER JOIN
SELECT 
    od.id AS order_detail_id, -- ID деталізації замовлення
    od.order_id, -- ID замовлення
    od.product_id, -- ID продукту
    od.quantity, -- Кількість продукту
    o.date AS order_date, -- Дата замовлення
    c.name AS customer_name, -- Ім'я клієнта
    p.name AS product_name, -- Назва продукту
    cat.name AS category_name, -- Назва категорії
    s.name AS supplier_name, -- Ім'я постачальника
    e.first_name AS employee_first_name, -- Ім'я працівника
    e.last_name AS employee_last_name, -- Прізвище працівника
    sh.name AS shipper_name -- Назва перевізника
FROM 
    order_details od -- Початкова таблиця
INNER JOIN 
    orders o ON od.order_id = o.id -- Об'єднання з таблицею orders через order_id
INNER JOIN 
    customers c ON o.customer_id = c.id -- Об'єднання з таблицею customers через customer_id
INNER JOIN 
    products p ON od.product_id = p.id -- Об'єднання з таблицею products через product_id
INNER JOIN 
    categories cat ON p.category_id = cat.id -- Об'єднання з таблицею categories через category_id
INNER JOIN 
    suppliers s ON p.supplier_id = s.id -- Об'єднання з таблицею suppliers через supplier_id
INNER JOIN 
    employees e ON o.employee_id = e.employee_id -- Об'єднання з таблицею employees через employee_id
INNER JOIN 
    shippers sh ON o.shipper_id = sh.id; -- Об'єднання з таблицею shippers через shipper_id
    
/*4. 
Виконайте запити, перелічені нижче:*/

-- 4.1 Визначте, скільки рядків ви отримали (за допомогою оператора COUNT).

SELECT COUNT(*) AS row_count
FROM order_details od
INNER JOIN orders o ON od.order_id = o.id
INNER JOIN customers c ON o.customer_id = c.id
INNER JOIN products p ON od.product_id = p.id
INNER JOIN categories cat ON p.category_id = cat.id
INNER JOIN suppliers s ON p.supplier_id = s.id
INNER JOIN employees e ON o.employee_id = e.employee_id
INNER JOIN shippers sh ON o.shipper_id = sh.id;

-- 4.2 Змініть декілька операторів INNER на LEFT чи RIGHT. Визначте, що відбувається з кількістю рядків. Чому? Напишіть відповідь у текстовому файлі.

SELECT COUNT(*) AS row_count1
FROM order_details od
LEFT JOIN orders o ON od.order_id = o.id
LEFT JOIN customers c ON o.customer_id = c.id
LEFT JOIN products p ON od.product_id = p.id
LEFT JOIN categories cat ON p.category_id = cat.id
LEFT JOIN suppliers s ON p.supplier_id = s.id
LEFT JOIN employees e ON o.employee_id = e.employee_id
LEFT JOIN shippers sh ON o.shipper_id = sh.id;

/* Кількість рядків у запиті 4.1 та 4.2 співпадають так як у схемі всі ключі між таблицями співпадають, тобто кожен рядок у лівій таблиці має відповідний рядок у правій таблиці.*/

-- 4.3 Оберіть тільки ті рядки, де employee_id > 3 та ≤ 10.

SELECT *
FROM order_details od
INNER JOIN orders o ON od.order_id = o.id
INNER JOIN employees e ON o.employee_id = e.employee_id
WHERE e.employee_id > 3 AND e.employee_id <= 10;

-- 4.4 Згрупуйте за іменем категорії, порахуйте кількість рядків у групі, середню кількість товару (кількість товару знаходиться в order_details.quantity)
SELECT 
    cat.name AS category_name,
    COUNT(*) AS row_count,
    AVG(od.quantity) AS avg_quantity
FROM order_details od
INNER JOIN products p ON od.product_id = p.id
INNER JOIN categories cat ON p.category_id = cat.id
GROUP BY cat.name;

-- 4.5 Відфільтруйте рядки, де середня кількість товару більша за 21.

SELECT 
    cat.name AS category_name,
    COUNT(*) AS row_count,
    AVG(od.quantity) AS avg_quantity
FROM order_details od
INNER JOIN products p ON od.product_id = p.id
INNER JOIN categories cat ON p.category_id = cat.id
GROUP BY cat.name
HAVING AVG(od.quantity) > 21;

-- 4.6 Відсортуйте рядки за спаданням кількості рядків.

SELECT 
    cat.name AS category_name,
    COUNT(*) AS row_count,
    AVG(od.quantity) AS avg_quantity
FROM order_details od
INNER JOIN products p ON od.product_id = p.id
INNER JOIN categories cat ON p.category_id = cat.id
GROUP BY cat.name
HAVING AVG(od.quantity) > 21
ORDER BY row_count DESC;

-- 4.7 Виведіть на екран (оберіть) чотири рядки з пропущеним першим рядком.

SELECT 
    cat.name AS category_name,
    COUNT(*) AS row_count,
    AVG(od.quantity) AS avg_quantity
FROM order_details od
INNER JOIN products p ON od.product_id = p.id
INNER JOIN categories cat ON p.category_id = cat.id
GROUP BY cat.name
HAVING AVG(od.quantity) > 21
ORDER BY row_count DESC
LIMIT 4 OFFSET 1;
