CREATE SCHEMA task_two;

-- Задание: нужно для каждого дня определить последнее местоположение абонента.

CREATE TABLE task_two.calls
(
    abonent   varchar(10),
    region_id varchar(5),
    dttm      timestamp WITHOUT TIME ZONE
);

INSERT INTO task_two.calls (abonent, region_id, dttm)
VALUES ('7072110988', '32722', '2021-08-18 13:15'),
       ('7072110988', '32722', '2021-08-18 14:00'),
       ('7072110988', '21534', '2021-08-18 14:15'),
       ('7072110988', '32722', '2021-08-19 09:00'),
       ('7071107101', '12533', '2021-08-19 09:15'),
       ('7071107101', '32722', '2021-08-19 09:27');

SELECT DISTINCT ON  (date_trunc('day', task_two.calls.dttm), task_two.calls.abonent) task_two.calls.abonent,
                                                                                      task_two.calls.region_id,
                                                                                      to_char(task_two.calls.dttm,'YYYY-MM-DD HH24:MI')
FROM task_two.calls
ORDER BY task_two.calls.abonent DESC, date_trunc('day', task_two.calls.dttm), task_two.calls.dttm DESC;