-- необходимо сформировать таблицу customer_aggr

CREATE TABLE task_three_four.transaction_details
(
    transaction_id   BIGINT  NOT NULL,
    customer_id      BIGINT  NOT NULL,
    item_id          BIGINT  NOT NULL,
    item_number      INTEGER NOT NULL,
    transaction_dttm TIMESTAMP WITHOUT TIME ZONE DEFAULT current_date
);

INSERT INTO task_three_four.transaction_details (transaction_id, customer_id, item_id, item_number, transaction_dttm)
VALUES (1, 1, 0, 2, '2023-02-24 12:30:00'),
       (2, 1, 1, 1, '2023-02-25 10:00:00'),
       (3, 2, 1, 2, '2023-02-25 10:00:00'),
       (4, 2, 2, 3, '2023-02-28 16:20:00'),
       (5, 3, 2, 1, '2023-02-28 09:45:00'),
       (6, 3, 0, 2, '2023-02-26 11:30:00');


CREATE TABLE task_three_four.customer_aggr AS
SELECT DISTINCT task_three_four.transaction_details.customer_id,
                SUM(task_three_four.transaction_details.item_number * task_three_four.dict_item_prices.item_price)
                OVER (PARTITION BY task_three_four.transaction_details.customer_id) AS amount_spent_1m,
                FIRST_VALUE(task_three_four.dict_item_prices.item_name)
                OVER (PARTITION BY task_three_four.transaction_details.customer_id ORDER BY SUM(
                            task_three_four.transaction_details.item_number *
                            task_three_four.dict_item_prices.item_price) DESC)      AS top_item_1m
FROM task_three_four.transaction_details
         INNER JOIN task_three_four.dict_item_prices
                    ON task_three_four.transaction_details.item_id = task_three_four.dict_item_prices.item_id AND
                       task_three_four.transaction_details.transaction_dttm::date BETWEEN task_three_four.dict_item_prices.valid_from_dt::date
                           AND task_three_four.dict_item_prices.valid_to_dt::date
WHERE task_three_four.transaction_details.transaction_dttm::date >=
      DATE_TRUNC('month', current_date::date) - INTERVAL '1' MONTH
GROUP BY task_three_four.transaction_details.customer_id, task_three_four.dict_item_prices.item_name,
         task_three_four.transaction_details.item_number, task_three_four.dict_item_prices.item_price
HAVING SUM(task_three_four.transaction_details.item_number * task_three_four.dict_item_prices.item_price) > 0;
