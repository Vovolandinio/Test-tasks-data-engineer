-- Задание: нужно для каждого дня определить последнее местоположение абонента.

CREATE TABLE test_task.calls
(
    abonent   varchar(10),
    region_id varchar(5),
    dttm      timestamp
);

INSERT INTO test_task.calls (abonent, region_id, dttm)
VALUES ('7072110988', '32722', '2021-08-18 13:15'),
       ('7072110988', '32722', '2021-08-18 14:00'),
       ('7072110988', '21534', '2021-08-18 14:15'),
       ('7072110988', '32722', '2021-08-19 09:00'),
       ('7071107101', '12533', '2021-08-19 09:15'),
       ('7071107101', '32722', '2021-08-19 09:27');

SELECT DISTINCT ON (date_trunc('day', test_task.calls.dttm), test_task.calls.abonent) test_task.calls.abonent,
                                                                                      test_task.calls.region_id,
                                                                                      test_task.calls.dttm
FROM test_task.calls
ORDER BY test_task.calls.abonent DESC, date_trunc('day', test_task.calls.dttm), test_task.calls.dttm DESC;