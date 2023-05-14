--Тестовое задание ДИ 12.04.2023
--Исп.: Ю.В. Сулковская

--1)	Задание Вывести id всех клиентов, которые посетили Банк №1 после посещения Банк №2.
--Формат ответа: уникальный набор id клиентов
SELECT DISTINCT(client_id) as uniq_client_id,
  prev_bank
FROM (SELECT client_id,
  bank_name,
  application_date,
  LAG(bank_name) OVER(PARTITION BY client_id ORDER BY application_date) AS 'prev_bank'
  FROM APPLICATIONS) as Temp
WHERE bank_name = 'Банк_№1' AND prev_bank = 'Банк_№2'

--2)	Задание: выбрать все типы товаров, проданные в декабре 2021 года.
--Формат ответа: уникальный набор id товаров
SELECT DISTINCT(product_id) as uniq_product_id
FROM sales
WHERE (sale_date >= '2021-12-01' AND sale_date < '2022-01-01')
