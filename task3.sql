CREATE SCHEMA task_three_four;

-- Необходимо сформировать таблицу следующего вида dict_item_prices.

CREATE TABLE task_three_four.item_prices
(
    item_id      NUMERIC(21, 0) NOT NULL,
    item_name    VARCHAR(150),
    item_price   NUMERIC(12, 2) NOT NULL,
    created_dttm TIMESTAMP WITHOUT TIME ZONE DEFAULT current_date
);

INSERT INTO task_three_four.item_prices (item_id, item_name, item_price, created_dttm)
VALUES (0, 'Духи', 100.00, '2022-02-24 00:00:00'),
       (0, 'Духи', 110.00, '2022-02-26 20:00:00'),
       (0, 'Духи', 120.00, '2022-02-27 00:00:00'),
       (1, 'Шампунь', 50.00, '2022-02-24 00:00:00'),
       (1, 'Шампунь', 55.00, '2022-02-25 00:00:00'),
       (1, 'Шампунь', 60.00, '2022-02-26 00:00:00'),
       (2, 'Приправа', 10.00, '2022-02-24 00:00:00'),
       (2, 'Приправа', 15.00, '2022-02-25 00:00:00'),
       (2, 'Приправа', 20.00, '2022-02-28 00:00:00'),
       (0, 'Духи', 120.00, '2022-03-1 00:00:00'),
       (1, 'Шампунь', 60.00, '2022-03-01 00:00:00');


CREATE TABLE task_three_four.dict_item_prices AS
SELECT task_three_four.item_prices.item_id,
       task_three_four.item_prices.item_name,
       task_three_four.item_prices.item_price,
       task_three_four.item_prices.created_dttm::date AS valid_from_dt,
       COALESCE(LEAD(task_three_four.item_prices.created_dttm)
                OVER (PARTITION BY task_three_four.item_prices.item_id ORDER BY task_three_four.item_prices.created_dttm) -
                INTERVAL '1' DAY,
                DATE '9999-12-31')::date              AS valid_to_dt
FROM task_three_four.item_prices;