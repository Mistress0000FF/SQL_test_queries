--Тестовое задание на позицию BI – аналитик
--Исп.: Ю.В. Сулковская

--Дана таблица agreements со следующими полями:
--• id_agreement – id договора;
--• date_open – дата открытия договора;
--• amount – задолженность по договору;
--• product_name – наименование продукта, может быть «авто» и «ипотека».

--1. Сумму задолженности по всем договорам:
SELECT
    SUM(amount) as total_amount
FROM agreements

--2. Количество договоров, открытых в сентябре 2010:
SELECT
    COUNT(id_agreement) as counts_of_agreements
FROM agreements
WHERE date_open >='2010-09-01' AND date_open <= '2010-09-30'

--3. Количество и сумма задолженности по всем договорам «авто»:
SELECT
    COUNT(id_agreement) as counts_of_agreements,
    SUM(amount) as total_ammount
FROM agreements 
WHERE product_name = 'авто'

--4. Доля по сумме/количеству продукта «ипотека» относительно общей суммы/количества договоров:
WITH (SELECT COUNT(id_agreement) FROM agreements WHERE product_name = 'ипотека') as mortgage_agreements,
    (SELECT SUM(amount) FROM agreements WHERE product_name = 'ипотека') as mortgage_ammount

SELECT
    (mortgage_agreements/COUNT(id_agreement))*100 as share_of_mortgage_agreements,
    (mortgage_ammount/SUM(amount))*100 as share_of_mortgage_ammount
FROM agreements

--5. Отобрать первые пять договоров в каждом месяце и упорядочить их по сумме задолженности:
SELECT
    item_id,
    date_trunc('month', update_date) as month,
    row_number() OVER w 
FROM items
WHERE month BETWEEN 1 AND 6
WINDOW w AS (PARTITION BY name ORDER BY update_date DESC)
ORDER BY price ASC