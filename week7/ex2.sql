select f.film_id, f.title
from film f 
left join inventory i on i.film_id = f.film_id
left join rental r on i.inventory_id = r.inventory_id
inner join film_category fc on f.film_id = fc.film_id
inner join category ctg on fc.category_id = ctg.category_id
where r.rental_id is NULL
and (ctg.name = 'Horror' or ctg.name = 'Sci-fi')
and (f.rating = 'R' or f.rating = 'PG-13');
--result: 171 - Commandments Express
--        909 - Treasure Command

--explain:
-- Nested Loop Left Join  (cost=88.14..296.71 rows=1 width=19)
-- Filter: (r.rental_id IS NULL)
--  ->  Hash Right Join  (cost=87.86..177.99 rows=215 width=23)
--        Hash Cond: (i.film_id = f.film_id)
--        ->  Seq Scan on inventory i  (cost=0.00..70.81 rows=4581 width=6)
--        ->  Hash  (cost=87.27..87.27 rows=47 width=19)
--              ->  Nested Loop  (cost=1.54..87.27 rows=47 width=19)
--                    ->  Hash Join  (cost=1.26..20.58 rows=125 width=2)
--                          Hash Cond: (fc.category_id = ctg.category_id)
--                           ->  Seq Scan on film_category fc  (cost=0.00..16.00 rows=1000 width=4)
--                          ->  Hash  (cost=1.24..1.24 rows=2 width=4)
--                                ->  Seq Scan on category ctg  (cost=0.00..1.24 rows=2 width=4)
--                                      Filter: (((name)::text = 'Horror'::text) OR ((name)::text = 'Sci-fi'::text))
--                    ->  Index Scan using film_pkey on film f  (cost=0.28..0.53 rows=1 width=19)
--                          Index Cond: (film_id = fc.film_id)
--                          Filter: ((rating = 'R'::mpaa_rating) OR (rating = 'PG-13'::mpaa_rating))
--  ->  Index Scan using idx_fk_inventory_id on rental r  (cost=0.29..0.51 rows=4 width=8)
--        Index Cond: (inventory_id = i.inventory_id)

--So, the most expensive steps are nested loop left join and hash right join. A probable solution is making a query without
-- joining all the tables (which would make it more complicated, but efficient)

select str.store_id as store_id, c.city as city, sum(p.amount) 
from store str
	join address ad on ad.address_id = str.address_id
	join city c on ad.city_id = c.city_id
join staff stf on stf.store_id = str.store_id
join payment as p on p.staff_id = stf.staff_id
where date('2007.05.14') - 30 < p.payment_date and p.payment_date < date('2007.05.14')
group by (str.store_id, c.city);
-- result: 2 - Woodridge - 7148.37
--         1 - Lethbridge - 6936.63

--explain: 
--HashAggregate  (cost=416.59..431.57 rows=1198 width=45)
--  Group Key: str.store_id, c.city
--  ->  Hash Join  (cost=19.17..391.71 rows=3317 width=19)
--        Hash Cond: (p.staff_id = stf.staff_id)
--        ->  Seq Scan on payment p  (cost=0.00..326.94 rows=3317 width=8)
--               Filter: (('2007-04-14'::date < payment_date) AND (payment_date < '2007-05-14'::date))
--        ->  Hash  (cost=19.14..19.14 rows=2 width=17)
--              ->  Nested Loop  (cost=18.67..19.14 rows=2 width=17)
--                    ->  Merge Join  (cost=18.40..18.44 rows=2 width=10)
--                          Merge Cond: (str.store_id = stf.store_id)
--                          ->  Sort  (cost=17.37..17.37 rows=2 width=6)
--                                Sort Key: str.store_id
--                                ->  Hash Join  (cost=1.04..17.36 rows=2 width=6)
--                                      Hash Cond: (ad.address_id = str.address_id)
--                                      ->  Seq Scan on address ad  (cost=0.00..14.03 rows=603 width=6)
--                                      ->  Hash  (cost=1.02..1.02 rows=2 width=6)
--                                            ->  Seq Scan on store str  (cost=0.00..1.02 rows=2 width=6)
--                          ->  Sort  (cost=1.03..1.03 rows=2 width=6)
--                                Sort Key: stf.store_id
--                                ->  Seq Scan on staff stf  (cost=0.00..1.02 rows=2 width=6)
--                    ->  Index Scan using city_pkey on city c  (cost=0.28..0.35 rows=1 width=13)

-- The most expensive operations are HashAggregate and Hash Join. Once again, making query without joining all tables
-- can improve it's efficiency