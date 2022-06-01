task1
--Корабли: Для каждого класса определите число кораблей этого класса, потопленных в сражениях. Вывести: класс и число потопленных кораблей.

select class, sum(case when result = 'sunk' then 1 else 0 end) as Sunks
from 
( 
select classes.class, name
from classes
left join ships
on classes.class = ships.class
union
select class, ship
from classes
join outcomes
on class = ship) as Sh
join outcomes
on Sh.name = outcomes.ship
group by class



--task2
--Корабли: Для каждого класса определите год, когда был спущен на воду первый корабль этого класса. Если год спуска на воду головного корабля неизвестен, определите минимальный год спуска на воду кораблей этого класса. Вывести: класс, год.

select classes.class, min(launched)
from ships
full join classes
on ships.class = classes.class
group by classes.class


--task3
--Корабли: Для классов, имеющих потери в виде потопленных кораблей и не менее 3 кораблей в базе данных, вывести имя класса и число потопленных кораблей.

SELECT C.class, count(result)
FROM classes c JOIN ships s ON
c.class = s.class left join outcomes o on
o.ship = s.name
WHERE result='sunk' 
and c.class IN (
SELECT DISTINCT c.class
FROM classes c JOIN ships s ON
c.class = s.class left join outcomes o on o.ship = s.name
GROUP BY c.class
HAVING count(name)>=3)
group by c.class
           
           
           --task4
--Корабли: Найдите названия кораблей, имеющих наибольшее число орудий среди всех кораблей такого же водоизмещения (учесть корабли из таблицы Outcomes).

SELECT name
FROM (SELECT O.ship AS name, numGuns, displacement
FROM Outcomes O  JOIN
Classes C ON O.ship = C.class AND
O.ship NOT IN (SELECT name
FROM Ships
)
UNION
SELECT S.name AS name, numGuns, displacement
FROM Ships S JOIN
Classes C ON S.class = C.class
) OS INNER JOIN
(SELECT MAX(numGuns) AS MaxNumGuns, displacement
FROM Outcomes O JOIN
Classes C ON O.ship = C.class AND
O.ship NOT IN (SELECT name
FROM Ships
)
GROUP BY displacement
UNION
SELECT MAX(numGuns) AS MaxNumGuns, displacement
FROM Ships S JOIN
Classes C ON S.class = C.class
GROUP BY displacement
) GD ON OS.numGuns = GD.MaxNumGuns AND
OS.displacement = GD.displacement



--task5
--Компьютерная фирма: Найдите производителей принтеров, которые производят ПК с наименьшим объемом RAM и с самым быстрым процессором среди всех ПК, имеющих наименьший объем RAM. Вывести: Maker

SELECT maker
FROM product
WHERE model IN (
SELECT model
FROM pc
WHERE ram = (
  SELECT MIN(ram)
  FROM pc
  )
AND speed = (
  SELECT MAX(speed)
  FROM pc
  WHERE ram = (
   SELECT MIN(ram)
   FROM pc
   )
  )
)
and maker IN
(SELECT maker
FROM product
WHERE type ='Printer')

