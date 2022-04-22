### PART 2, READ COMMITED LEVEL ##

### terminal 1 
postgres=# BEGIN;
BEGIN
postgres=*# select * from account where group_id = 2;
 username |   fullname   | balance | group_id
----------+--------------+---------+----------
 mike     | Michael Dole |      73 |        2
(1 row)

postgres=*# select * from account where group_id = 2;
 username |   fullname   | balance | group_id
----------+--------------+---------+----------
 mike     | Michael Dole |      73 |        2
(1 row)

postgres=*# update account set balance = balance + 15 where group_id = 2;
UPDATE 1
postgres=*# commit;
COMMIT
postgres=# select * from account;
 username |     fullname     | balance | group_id
----------+------------------+---------+----------
 bitdiddl | Ben Bitdiddle    |      65 |        1
 alyssa   | Alyssa P. Hacker |      79 |        3
 jones    | Alice Jones      |      92 |        1
 bbrown   | Bob Brown        |     100 |        2
 mike     | Michael Dole     |      88 |        2
(5 rows)

### terminal 2
postgres=# BEGIN;
BEGIN
postgres=*# update account set group_id = 2 where fullname = 'Bob Brown';
UPDATE 1
postgres=*# commit;
COMMIT

# Explanation: the fact of moving bob to the second group in T2 was not applied in T1 since T2 was not commited. Therefore, only one member of group 2 before T1 was started
# (Michael Dole) got his balance updated.

### PART 2, REPEATABLE READ LEVEL ##

### terminal 1

postgres=# BEGIN transaction ISOLATION LEVEL REPEATABLE READ;
BEGIN
postgres=*# select * from account where group_id = 2;
 username |   fullname   | balance | group_id
----------+--------------+---------+----------
 mike     | Michael Dole |      88 |        2
(1 row)

postgres=*# update account set group_id = 3 where fullname = 'Bob Brown';
UPDATE 1
postgres=*# end;
COMMIT
postgres=# BEGIN transaction ISOLATION LEVEL REPEATABLE READ;
BEGIN
postgres=*# select * from account where group_id = 2;
 username |   fullname   | balance | group_id
----------+--------------+---------+----------
 mike     | Michael Dole |      88 |        2
(1 row)

postgres=*# update account set balance = balance + 15 where group_id = 2;
UPDATE 1
postgres=*# commit;
COMMIT
postgres=# select * from account;
 username |     fullname     | balance | group_id
----------+------------------+---------+----------
 bitdiddl | Ben Bitdiddle    |      65 |        1
 alyssa   | Alyssa P. Hacker |      79 |        3
 jones    | Alice Jones      |      92 |        1
 bbrown   | Bob Brown        |     100 |        2
 mike     | Michael Dole     |     103 |        2
(5 rows)


### terminal 2

postgres=# BEGIN transaction ISOLATION LEVEL REPEATABLE READ;
BEGIN
postgres=*# update account set group_id = 2 where fullname = 'Bob Brown';
UPDATE 1
postgres=*# commit;
COMMIT

# Explanation: similarly, the fact of moving bob to the second group in T2 was not applied in T1. Therefore, only one member of group 2 before T1 was started
# (Michael Dole) got his balance updated.