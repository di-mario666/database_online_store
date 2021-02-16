/* БД homespa сделала для интернет-магазина натуральной косметики.
Сайт - https://homesparu.ru
Это магазин моей знакомой, пока он только набирает обороты, надеюсь мои знания,полученные здесь помогут ей в работе магазина ив его развитии.

Задачи БД homespa : 
- Структурированное хранение информации о товарах,ценах,скидках,клиентах
- Возможность оперативного добавление информации
- Возможность делать выборку по необходимым параметрам/столбцам (какой клиент что чаще заказывает, какой товар больше/меньше продается и тп)
- Возможность делать групповые изменения в товарах (например: cкидки на товар дороже 500 р.)
- Отслеживание остаков на складе 
- Назначение скидки на группу товара */

-- СОЗДАНИЕ БД homespa:

DROP DATABASE IF EXISTS homespa; 
CREATE DATABASE homespa; 
USE homespa; 

-- СОЗДАНИЕ 10-ти таблиц БД и ручное заполнение данными:

DROP TABLE IF EXISTS site_structure; -- таблица структуры сайта 
CREATE TABLE site_structure ( 
    id SERIAL PRIMARY KEY,
    section_name VARCHAR(50) COMMENT 'Название разделов сайта' 
);    

INSERT INTO site_structure VALUES
(1,'info-reviews'),
(2,'catalog-price'),
(3,'contacts'),
(4,'basket');
    
    
DROP TABLE IF EXISTS users; 
CREATE TABLE users ( 
    id SERIAL PRIMARY KEY,
    firstname VARCHAR(50), 
    lastname VARCHAR(50),
    email VARCHAR(120) UNIQUE, 
    phone BIGINT,
    birthday DATE,
    KEY index_of_lastname_firstname(lastname,firstname)
);

INSERT INTO users VALUES
(1,'Sveta','Svetaokolova','Sveta@mail.ru',89295112236,'1974-05-30'),
(2,'Ivan','Zverev','123456@mail.ru',89255855836,'1987-02-21'),
(3,'Vika','Orlova','kiska@ya.ru',89145852236,'2000-10-01'),
(4,'Dima','Gerasimov','di-mario@mail.ru',89205159264,'2004-11-29'),
(5,NULL,'Kovalenko',NULL,89105857896,'1995-05-14');

DROP TABLE IF EXISTS categories; 
CREATE TABLE categories ( 
    id SERIAL PRIMARY KEY, 
    categories_name VARCHAR(50),
    
    INDEX categories_name_idx(categories_name)
); 

INSERT INTO categories VALUES
(1,'Craft soap'),
(2,'For hair'),
(3,'For the face'),
(4,'For the body'),
(5,'For the bath'),
(6,'Honey candles'),
(7,'Additional products');

DROP TABLE IF EXISTS product; 
CREATE TABLE product ( 
    id SERIAL PRIMARY KEY, 
    product_name VARCHAR(50), 
    description TEXT COMMENT 'Описание товара',
    categories_product BIGINT UNSIGNED NOT NULL,
    price INT UNSIGNED NOT NULL, 
    status_availability ENUM('YES','NO') NOT NULL DEFAULT 'YES' COMMENT 'статус товара по наличию',
    
    INDEX product_name_idx(product_name),
    FOREIGN KEY (categories_product) REFERENCES categories(id)
);

INSERT INTO product VALUES
(1, 'Soap with_clays', 'The benefits of clay have been known to mankind for hundreds of years.It deeply cleanses the pores' ,1, 290 ,'YES'),
(2, 'Soap-contains orange juice', 'This is just a magic soap-gommage Very small particles of the shell exfoliate the skin so delicately that it is especially felt after application! Composed of only vegetable oils: coconut, almond, Shea butter.' ,1, 350, 'NO'),
(3, 'Whipped soap with honey','Whipped soap is a unique variety that is made from air oils with the addition of fresh fragrant honey.Soap has the most gentle gentle foam. This is a real dessert for the skin.In the composition of Shea butter, coconut, almond, olive, honey',1 ,350 ,'YES'),
(4, 'Usma oil for eyebrows and lashes', 'Usma seed oil is highly concentrated, because it does not use any additives and, in particular, it is considered more effective.' ,2 ,450, 'YES'),
(5, 'Mens shampoo with bamboo charcoal', 'Natural shampoo with bamboo charcoal is made especially for men , it deeply cleanses the hair and at the same time takes care of the scalp, gives a healthy and well-groomed appearance.' ,2 ,450, 'NO'),
(6, 'Macerate for face massage', 'Lip care should be a must every day' ,3 ,450, 'YES'),
(7, 'Therapeutic lip balm', 'Lip care should be a must every day.' ,3 ,250, 'NO'),
(8, 'Air batter for the body', 'This is a treat for your skin. Whipped butter, similar to pastry cream.The composition is as natural as possible.Does not contain preservatives' ,4 ,550, 'YES'),
(9, 'Lifting a salt scrub with an extract of pepper', 'Orange macerate in coconut oil is a powerful tool in the fight against cellulite. It evens the skins relief, tightens , makes the silhouette slimmees' ,4 ,650, 'YES'),
(10, 'Praline for the bath', 'It is recommended to use such a bath at least once a week. And with dry skin, peeling, dehydration, conduct a two-week course of a bath with praline-1 every two days!' ,5 ,190, 'YES'),
(11, 'Moisturizing geysers for the "Heart" bath', 'Natural geysers for home Spa-this is a Relaxation and hydration of the skin' ,5 ,99, 'YES'),
(12, 'Set of honey candles', 'This helps eliminate dust, odors, and mold in the atmosphere, easing Allergy and asthma symptoms, and improving breathing.' ,6 ,650, 'YES'),
(13, 'Bast of jute', 'I have long wanted, what would I have appeared in a variety of natural sponges made of jute! And here they are-meet a new handmade product!' ,7 ,199, 'YES'),
(14, 'Aromatic sachet', 'This fragrant accessory can be put in a dresser drawer or hung in a closet, it will fill your underwear with an unobtrusive, but stable aroma of herbs and essential oils' ,7 ,199, 'YES'),
(15, 'Mens set', 'A set that will definitely surprise even the most sophisticated man.s' ,7 ,850, 'YES');

DROP TABLE IF EXISTS orders; -- Промежуточная таблица
CREATE TABLE orders ( 
    id SERIAL PRIMARY KEY, 
    user_id BIGINT UNSIGNED NOT NULL,
    data_order DATETIME COMMENT 'Дата заказа',
   
    FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO orders VALUES
(1,5,'2020-05-19 15:10:15'),
(2,3,'2019-08-29 21:08:23'),
(3,1,'2019-01-03 10:47:01'),
(4,2,'2020-02-01 07:15:00'),
(5,4,'2018-12-27 11:45:52'),
(6,2,'2020-01-22 19:25:05'),
(7,1,'2020-04-15 10:42:01');

DROP TABLE IF EXISTS orders_product ; -- Количество заказанных товаров по видам
CREATE TABLE orders_product ( 
  id SERIAL PRIMARY KEY, 
  order_id BIGINT UNSIGNED NOT NULL,
  product_id BIGINT UNSIGNED NOT NULL,
  total INT UNSIGNED DEFAULT 1, -- ОБщее кол-во
  
  KEY index_of_product_id_total(product_id,total),
  FOREIGN KEY (order_id) REFERENCES orders(id),
  FOREIGN KEY (product_id) REFERENCES product(id)
);  

INSERT INTO orders_product VALUES
(1,5,1,10),
(2,3,2,5),
(3,1,3,58),
(4,2,4,2),
(5,4,5,7),
(6,7,6,1),
(7,5,7,4);
    
DROP TABLE IF EXISTS discounts_product; -- Скидка по группам товаров
CREATE TABLE discounts_product (
  id SERIAL PRIMARY KEY,
  discounts_product_id BIGINT UNSIGNED NOT NULL,
  discount INT UNSIGNED, -- Значение скидки в процентах
  
  FOREIGN KEY (discounts_product_id) REFERENCES product(id)
);  

INSERT INTO discounts_product VALUES
(1,1,10),
(2,2,0),
(3,3,0),
(4,4,0),
(5,5,5),
(6,6,0),
(7,7,3);


DROP TABLE IF EXISTS discounts_user; -- Какой клиент получил какую скидку на какой товар
CREATE TABLE discounts_user (
  id SERIAL PRIMARY KEY,
  user_id BIGINT UNSIGNED NOT NULL,
  product_id BIGINT UNSIGNED NOT NULL,
  discount INT UNSIGNED, -- Значение скидки в процентах
  
  KEY index_of_product_id_discount(product_id,discount),
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (product_id) REFERENCES product(id)
);  

INSERT INTO discounts_user VALUES
(1,5,4,10),
(2,3,6,10),
(3,1,1,5),
(4,2,5,7),
(5,4,7,3),
(6,3,2,10),
(7,5,3,5),
(8,2,6,0),
(9,1,7,3),
(10,5,2,5),
(11,2,4,0);
    
DROP TABLE IF EXISTS storehouses; -- Промежуточная таблица
CREATE TABLE storehouses (
  id SERIAL PRIMARY KEY,
  name_storehouses VARCHAR(255)
); 

INSERT INTO storehouses VALUES
(1,'home'),
(2,'garage');
    
DROP TABLE IF EXISTS storehouses_products; -- Количество хранящегося товара по видам
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouse_id BIGINT UNSIGNED NOT NULL,
  product_id BIGINT UNSIGNED NOT NULL,
  quantity INT UNSIGNED,
  
  KEY index_of_product_id_quantity(product_id,quantity), 
  FOREIGN KEY (storehouse_id) REFERENCES storehouses(id),
  FOREIGN KEY (product_id) REFERENCES product(id)
);   

INSERT INTO storehouses_products VALUES
(1,1,1,10),
(2,1,2,5),
(3,1,3,4),
(4,1,4,7),
(5,1,5,3),
(6,1,6,10),
(7,1,7,5),
(8,2,1,0),
(9,2,2,11),
(10,2,3,40),
(11,2,4,22),
(12,2,5,1),
(13,2,6,0),
(14,2,7,14);



-- РЕЗЕРВНАЯ КОПИЯ БД
mysqldump --opt homespa > homespa.sql;  



--  ПРИМЕРЫ ВЫБОРОК 

-- Выборка клиентов у кого день рождения в этом месяце(чтобы можно было их поздравить и предложить скидку в честь др)
-- Если день рождения не в этом месяце, выводится название названия месяца в каком. 
SELECT firstname ,lastname,
  IF(
	MONTH (birthday) = 5,
	'in this month',
	(SELECT MONTHNAME(birthday)) 
  ) AS month_bd FROM users;

-- Вывести суммарное количество товарных позиций по складам
SELECT SUM(quantity) FROM storehouses_products;

-- Вывести суммарное количество товарa(product_id = 3), хранящихся в garage 
SELECT SUM(quantity) 
    FROM storehouses_products
    WHERE product_id = 3 AND storehouse_id = 2;
   
-- Вывести название самого дорогого и самого дешевого товаров
SELECT product_name, price 
   FROM product 
   WHERE price IN (SELECT MAX(price) FROM product)
   UNION
SELECT product_name, price 
   FROM product 
   WHERE price IN (SELECT MIN(price) FROM product);
  
-- Найти название товара и его цену, если помнишь пару слов из его описания
SELECT product_name, price 
   FROM product 
   WHERE description LIKE '%air oils with the addition%';  

-- Вывести(по убыванию) название товара с названием категории, к которой он пренадлежит с ценой выше 400 руб.  
SELECT product.product_name, product.price, categories.categories_name
   FROM product 
   JOIN categories 
   ON product.categories_product = categories.id
   WHERE price> 400
   ORDER BY price DESC;
  
 -- Вывести название товара и кол-во, хранящиеся на складе "home", начиная с наибольших запасов
SELECT product.product_name, storehouses_products.quantity
   FROM product
   JOIN storehouses_products
   ON product.categories_product = storehouses_products.product_id
   WHERE storehouse_id = 1
   ORDER BY quantity DESC;

  
-- ПРЕДСТАВЛЕНИЯ 

-- остатки товара,которые в наличии,хранящиеся на складе "garage",отсортированные по убыванию  
CREATE OR REPLACE VIEW product_balances
AS SELECT product_name, quantity
FROM product,storehouses_products
WHERE product.categories_product = storehouses_products.product_id
   AND storehouse_id = 2
   AND quantity > 0
   ORDER BY quantity DESC ;

SELECT * FROM product_balances;

-- Кол-во, проданного товара по группам товара, с сортировкой начиная с самого продаваемого
CREATE OR REPLACE VIEW total
AS SELECT categories_name,total
FROM categories,orders_product
WHERE categories.id = orders_product.product_id 
ORDER BY total DESC;

SELECT * FROM total;  

-- По-фамильно какой клиент какую категорию товара заказывает
CREATE OR REPLACE VIEW user_orders
AS SELECT lastname,product_id
FROM users,orders_product
WHERE users.id = orders_product.product_id;

SELECT * FROM user_orders; 



-- ХРАНИМАЯ ПРОЦЕДУРА
-- выводит ФИО пользователей у которых сегодня день рождения
DROP PROCEDURE IF EXISTS birthday; 
 
DELIMITER //

CREATE PROCEDURE birthday()
BEGIN
  SELECT firstname, lastname, birthday 
  FROM users
  WHERE MONTH(birthday) = MONTH (CAST(CURRENT_TIMESTAMP AS DATE)) AND DAYOFMONTH((birthday)) = DAY(CAST(CURRENT_TIMESTAMP AS DATE)); -- очень мудрено)) но я решил попробовать так)
END//

DELIMITER ;

CALL birthday();


-- ТРИГГЕР
-- количество записей в таблицу users
DROP PROCEDURE IF EXISTS users_count;

DELIMITER //

CREATE TRIGGER users_count AFTER INSERT ON users
FOR EACH ROW
BEGIN
  SELECT COUNT(*) INTO @total FROM users;
END//

INSERT INTO users VALUES
(6,'Goga','Archnyan','kiska@mail.ru',89201785641,'1986-01-12');

SELECT @total;

DELIMITER ;





    