--Тестовое задание на позицию Аналитика данных
--Исп.: Ю.В. Сулковская

--У нас есть 3 таблицы:
--a)	gambler_id | dep_time | dep_amount (таблица депозитов)
--b)	gambler_id | time | amount | transaction_type (таблица ставок и выигрышей, transaction_type: bet - ставка, win - выигрыш)
--c)	gambler_id | registration_time | status (таблица регистраций).

--1.	Найдите средний чек пользователей помесячно с начала 2022 года (средний чек - сумма депозитов / уник количество игроков):
SELECT
    date_trunc('month', dep_time) as month,
    SUM(dep_amount)/uniqExact(gambler_id) as avg_amount
FROM a
GROUP BY month
WHERE time > '2022.01.01'

--2.	Напишите запрос, который выдает сумму депозитов, сумму ставок и сумму выигрышей игроков, зарегистрировавшихся с начала 2022 года и имеющих статус не равный 'test_user':
SELECT uniqExact(a.gambler_id) as uniq_gambler_id,
    sum(a.amount) as all_amount
    a.transaction_type as transaction_type
FROM 
    (SELECT 
        gambler_id,
        dep_time as time,
        dep_amount as amount,
        transaction_type = 'dep') as a
INNER JOIN b ON a.gambler_id = b.gambler_id
INNER JOIN c ON a.gambler_id = c.gambler_id
WHERE time > '2022.01.01' AND status != 'test_user'

--3.	Возвращаемся к таблице депозитов (gambler_id | dep_time | dep_amount), она содержит все успешные депозиты пользователей в долларах. Напишите sql запрос, который будет выдавать для каждого игрока время депозита (минимальное), на котором была достигнута общая сумма депозитов в 10$.
Select gambler_id,
   MIN(dep_time) = min_dep_time,
   dep_amount,
   SUM(dep_amount) OVER w AS total_amount_on_date
FROM a
WINDOW w AS (PARTITION BY gambler_id
    ORDER BY dep_time ASCROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
WHERE total_amount_on_date < 10