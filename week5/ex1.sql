--Find the names of suppliers who supply some red part.
select sname from Suppliers where sid in (
 select distinct  sid 
 from PartsCatalog 
 where pid in (
 	select pid from Parts 
 	where color = 'Red'
 )
);

--Find the sids of suppliers who supply some red or green part.
select distinct sid 
from PartsCatalog 
where pid in (
 select pid from Parts 
 where color = 'Red' or color = 'Green'
);

--Find the sids of suppliers who supply some red part or are at 221 Packer Street.
select sid from Suppliers where sid in (
	select distinct sid 
	from PartsCatalog 
	where pid in (
	 select pid from Parts 
	 where color = 'Red'
	)
)
or address = '221 Packer Street';
 
 --Find the sids of suppliers who supply every red or green part.
 select sid 
 from PartsCatalog 
 where pid in (
 	select pid from Parts 
 	where color = 'Red' or color = 'Green'
 )
 group by sid
 having count(*) = (
	select count(*) from Parts 
 	where color = 'Red' or color = 'Green'
 );

--Find the sids of suppliers who supply every red part or supply every green part.
select distinct C.sid
from 
PartsCatalog C join Parts P on C.pid = P.pid
where 
P.color = 'Green' or P.color = 'Red'
group by (C.sid, P.color) 
having count(C.pid) = (
	select count(*) from Parts where color = P.color
);

--•ind pairs of sids such that the supplier with the first sid charges more for some part than the supplier with the second sid.
select C1.sid, C2.sid
from PartsCatalog C1, PartsCatalog C2
where C1.pid = C2.pid and  C1.sid != C2.sid and C1.cost > C2.cost;

--Find the pids of parts supplied by at least two different suppliers.
select distinct pid 
from PartsCatalog 
group by pid
having count(pid) > 1;
 
 --Find the average cost of the red parts and green parts for each of the suppliers
select C.sid, P.color, avg(C.cost)
from 
PartsCatalog C join Parts P on C.pid = P.pid
where 
P.color = 'Green' or P.color = 'Red'
group by (C.sid, P.color);

--Find the sids of suppliers whose most expensive part costs $50 or more
select sid
from PartsCatalog
group by sid having MAX(cost) >= 50