CREATE SCHEMA test_task;

-- Задание: необходимо найти 3-х самых молодых сотрудников в коллективе и выдать их имена,
-- предварительно отсортировав. Задачу требуется решить несколькими способами (чем больше, тем
-- лучше).

CREATE TABLE test_task.employees
(
    id   SERIAL primary key,
    name varchar(20),
    age  int
);

INSERT INTO test_task.employees (name, age)
VALUES ('Вася', 23),
       ('Петя', 40),
       ('Маша', 19),
       ('Марина', 23),
       ('Сергей', 34),
       ('Владимир', 24),
       ('Антон', 39),
       ('Максим', 18);


-- Вариант 1
SELECT test_task.employees.name
FROM test_task.employees
ORDER BY test_task.employees.age, test_task.employees.name
LIMIT 3;

-- Вариант 2
SELECT name
FROM (SELECT test_task.employees.name, ROW_NUMBER() OVER (ORDER BY test_task.employees.age) AS row_number
      FROM test_task.employees
      ORDER BY test_task.employees.age, test_task.employees.name) subquery
WHERE subquery.row_number <= 3;

-- Варинт 3
SELECT name
FROM (SELECT test_task.employees.name, RANK() OVER (ORDER BY test_task.employees.age) AS row_number
      FROM test_task.employees
      ORDER BY test_task.employees.age, test_task.employees.name) subquery
WHERE subquery.row_number <= 3
LIMIT 3;

-- Варинт 4
SELECT test_task.employees.name
FROM test_task.employees
ORDER BY test_task.employees.age, test_task.employees.name
    FETCH FIRST 3 ROWS ONLY;

-- Вариант 5
WITH helpers AS
         (SELECT test_task.employees.name
          FROM test_task.employees
          ORDER BY test_task.employees.age, test_task.employees.name)
SELECT *
FROM helpers
LIMIT 3;