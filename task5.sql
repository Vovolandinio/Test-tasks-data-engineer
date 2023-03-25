CREATE SCHEMA task_five;

-- рассчитать количество публикаций в месяц с указанием первой даты месяца и долей
-- увеличения количества сообщений (публикаций) относительно предыдущего месяца.

CREATE TABLE task_five.posts
(
    id         SERIAL PRIMARY KEY NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE,
    title      TEXT
);

INSERT INTO task_five.posts (created_at, title)
VALUES
       ('2023-02-04 16:44:36', 'Hu Tao: The Newest 5-Star Pyro Character'),
       ('2023-03-10 14:57:32', 'Mastercard vs UnionPay'),
       ('2023-03-23 12:34:56', 'Xiao vs Eula: Who Is the Better Damage Dealer?'),
       ('2023-03-25 08:12:45', 'Hadoop or Greenplum: pros and cons'),
       ('2023-03-12 10:20:30', 'NFC: wireless paymen'),
       ('2023-04-17 15:45:22', 'Ayaka vs Yoimiya: Which New Character Is Worth Your Primogems?'),
       ('2023-05-17 15:45:22', 'Best SQL practices'),
       ('2023-06-17 15:45:22', 'what is written in the C programming language?'),
       ('2023-07-17 15:45:22', 'Top characters from genshin impact');


CREATE TABLE task_five.results AS
WITH monthly_posts AS
         (SELECT date_trunc('month', task_five.posts.created_at) AS month_start,
                 COUNT(*)                                        AS post_count
          FROM task_five.posts
          GROUP BY month_start),
     monthly_growth AS (SELECT monthly_posts.month_start,
                               monthly_posts.post_count,
                               LAG(monthly_posts.post_count) OVER (ORDER BY monthly_posts.month_start) AS prev_post_count,
                               (monthly_posts.post_count - LAG(monthly_posts.post_count) OVER (ORDER BY monthly_posts.month_start)) * 100.0 /
                               LAG(monthly_posts.post_count) OVER (ORDER BY monthly_posts.month_start) AS prcnt_growth
                        FROM monthly_posts)
SELECT to_char(month_start, 'YYYY-MM-DD') AS dt,
       post_count                         AS count,
       CASE
           WHEN monthly_growth.prev_post_count IS NULL THEN 'null'
           ELSE round(monthly_growth.prcnt_growth, 1) || '%'
           END                            AS prcnt_growth
FROM monthly_growth
ORDER BY month_start;