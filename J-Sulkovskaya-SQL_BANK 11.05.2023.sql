--Тестовой задание на позицию Аналитик SQL
--Исп.: Ю.В. Сулковская

--Имеются таблицы:		
--test_clients (Название таблицы)		Описание:
--client_ID	        |varchar(255) NOT NULL	|ID клиента
--filial	        |varchar(40) NOT NULL	|Филиал
--dog_id	        |varchar(255) NOT NULL	|ID договора
--debt	            |NUMBER(22,2)		    |Сумма к выплате
		
--test_pays (Название таблицы)		Описание:
--client_ID	  |varchar(255) NOT NULL  |ID клиента
--employee_ID |varchar(255) NOT NULL  |ФИО сотрудника
--sum_pay	  |NUMBER(22,2)	          |Сумма оплаты
--date_pay	  |CHAR mm/dd/yyyy	      |Дата оплаты
		
--test_staff (Название таблицы)		Описание:
--employee_ID	    |varchar(255) NOT NULL |ФИО сотрудника
--chief_ID	        |varchar(255) NOT NULL |ID руководителя
--employee_salary	|NUMBER(22,2)	       |Зарплата сотрудника

--1  Вывести количество филиалов, где имеется более 10 клиентов с 2мя кредитами:
SELECT
	COUNT(DISTINCT filial) as count_of_filials
FROM
	(SELECT
		filial,
		COUNT(DISTINCT client_ID) as count_of_clients,
		COUNT(dog_id) as count_of_dogs
	FROM test_clients
	WHERE count_of_dogs = 2 AND count_of_clients > 10
	GROUP BY filial)

--2 Вывести количество и сумму платежей за 1 квартал 2020 года по филиалу "Moscow":
SELECT  test_clients.filial as filial,
	test_clients.COUNT(client_ID) as total_count,
	test_pays.SUM(sum_pay) as total_pay
FROM test_clients
JOIN test_pays ON test_clients.client_ID = test_pays.client_ID
WHERE date_pay >= '01.01.2020'
	AND date_pay < '01.04.2020'
	AND filial = 'Moscow'
GROUP BY filial

--3 Вывести сумму платежей по сотруднику "Jone Smith", а сумму платежей по остальным сотрудникам записать  в группу "Остальные"
--без использования UNION (UNION ALL) и без подзапросов:
WITH (SELECT SUM(sum_pay) FROM test_pays WHERE employee_ID != 'Jone Smith') as others_pay

SELECT
	SUM(sum_pay) as Jone_Smith_total_pay,
	others_pay
FROM test_pays
WHERE employee_ID = 'Jone Smith'

--4. Вывести информацию по руководителю "Martin  Lee":
--а) кол-во сотрудников, находящихся в подчинении и их сумме зарплат;
--б) количество договоров и сумму обязательств по договору (сумма к выплате), находящихся в работе у сотрудников;

--A):
SELECT
	COUNT(employee_ID) as total_employees
	SUM(employee_salaryas) as total_salarys
FROM test_staff
WHERE chief_ID = 'Martin  Lee'

--Б):
SELECT
	test_pays.employee_ID
	test_clients.COUNT(dog_id) as count_of_dogs,
	test_clients.SUM(debt) as total_debt
FROM test_pays
JOIN test_clients ON test_pays.client_ID = test_clients.client_ID
JOIN test_staff ON test_pays.employee_ID = test_staff.employee_ID
WHERE chief_ID = 'Martin  Lee'