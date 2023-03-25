CREATE SCHEMA task_one;

-- Задание: необходимо найти 3-х самых молодых сотрудников в коллективе и выдать их имена,
-- предварительно отсортировав. Задачу требуется решить несколькими способами (чем больше, тем
-- лучше).

CREATE TABLE task_one.employees
(
    id   SERIAL primary key,
    name varchar(20),
    age  SMALLINT NOT NULL
);

INSERT INTO task_one.employees (name, age)
VALUES ('Вася', 23),
       ('Петя', 40),
       ('Маша', 19),
       ('Марина', 23),
       ('Сергей', 34),
       ('Владимир', 24),
       ('Антон', 39),
       ('Максим', 18);


-- Вариант 1
SELECT task_one.employees.name
FROM task_one.employees
ORDER BY task_one.employees.age, task_one.employees.name
LIMIT 3;

-- Вариант 2
SELECT name
FROM (SELECT task_one.employees.name, ROW_NUMBER() OVER (ORDER BY task_one.employees.age) AS row_number
      FROM task_one.employees
      ORDER BY task_one.employees.age, task_one.employees.name) subquery
WHERE subquery.row_number <= 3;

-- Варинт 3
SELECT name
FROM (SELECT task_one.employees.name, RANK() OVER (ORDER BY task_one.employees.age) AS row_number
      FROM task_one.employees
      ORDER BY task_one.employees.age, task_one.employees.name) subquery
WHERE subquery.row_number <= 3
LIMIT 3;

-- Варинт 4
SELECT task_one.employees.name
FROM task_one.employees
ORDER BY task_one.employees.age, task_one.employees.name
    FETCH FIRST 3 ROWS ONLY;

-- Вариант 5
WITH helpers AS
         (SELECT task_one.employees.name
          FROM task_one.employees
          ORDER BY task_one.employees.age, task_one.employees.name)
SELECT *
FROM helpers
LIMIT 3;