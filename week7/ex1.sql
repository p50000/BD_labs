select * from customer;

explain select * from customer;
-- Seq Scan on customer  
-- (cost=0.00..4033.00 rows=100000 width=211)

explain select name 
from customer 
where name like 'Ja%';
-- Seq Scan on customer  
-- (cost=0.00..4283.00 rows=4148 width=211)

-- Filter: (name ~~ 'Ja%'::text)

explain select * 
from customer 
where address = '5156 Mary Spur';
-- Seq Scan on customer  
-- (cost=0.00..4283.00 rows=1 width=211)
-- Filter: (address = '5156 Mary Spur'::text)

explain select * 
from customer 
where id in (5353, 1, 22, 99903, 15000);
-- Index Scan using customer_pkey on customer  
-- (cost=0.29..25.56 rows=5 width=211)

--   Index Cond: (id = ANY ('{5353,1,22,99903,15000}'::integer[]))

-- creating indexes
create index address_id
on customer
using hash(address);

create index name_id
on customer
using btree(name);

-- repeating queries

explain select name
from customer 
where name like 'Ja%';
-- Index Only Scan using name_id on customer  
-- (cost=0.42..115.47 rows=4148 width=14)
-- Index Cond: ((name >= 'Ja'::text) AND (name < 'Jb'::text))
-- Filter: (name ~~ 'Ja%'::text)

-- So, the query is implemented differently and is ~10 times faster 
-- thanks to btree on name

explain select * 
from customer 
where address = '5156 Mary Spur';
-- Index Scan using address_id on customer  
-- (cost=0.00..8.02 rows=1 width=211)
-- Index Cond: (address = '5156 Mary Spur'::text)

-- So, the query is ~1000 times faster 
-- thanks to hash on address


explain select * 
from customer 
where id in (5353, 1, 22, 99903, 15000);
-- Index Scan using customer_pkey on customer  
-- (cost=0.29..25.56 rows=5 width=211)
-- Index Cond: (id = ANY ('{5353,1,22,99903,15000}'::integer[]))
-- nothing changed since id is the primary key and no index on it was created