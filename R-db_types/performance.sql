SELECT e.firstname, month(o.OrderDate) as Month, avg(quantity)
from `order details` as od, orders as o,employees as e
where od.orderid = o.orderid AND
o.employeeid = e.employeeid
group by e.firstname,Month
order by e.firstname,Month

SELECT e.firstname, month(o.OrderDate) as Month, avg(unitprice)
from `order details` as od, orders as o,employees as e
where od.orderid = o.orderid AND
o.employeeid = e.employeeid
group by e.firstname,Month
order by e.firstname,Month

SELECT e.firstname, month(o.OrderDate) as Month, avg(freight)
from `order details` as od, orders as o,employees as e
where od.orderid = o.orderid AND
o.employeeid = e.employeeid
group by e.firstname,Month
order by e.firstname,Month