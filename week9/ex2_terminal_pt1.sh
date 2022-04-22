### PART 1, READ COMMITED LEVEL ##

### terminal 1 

postgres=# begin;
BEGIN
postgres=*# select * from account;
 username |     fullname     | balance | group_id
----------+------------------+---------+----------
 jones    | Alice Jones      |      82 |        1
 bitdiddl | Ben Bitdiddle    |      65 |        1
 mike     | Michael Dole     |      73 |        2
 alyssa   | Alyssa P. Hacker |      79 |        3
 bbrown   | Bob Brown        |     100 |        3
(5 rows)

postgres=*# select * from account;
 username |     fullname     | balance | group_id
----------+------------------+---------+----------
 jones    | Alice Jones      |      82 |        1
 bitdiddl | Ben Bitdiddle    |      65 |        1
 mike     | Michael Dole     |      73 |        2
 alyssa   | Alyssa P. Hacker |      79 |        3
 bbrown   | Bob Brown        |     100 |        3
(5 rows)

postgres=*# select * from account;
 username |     fullname     | balance | group_id
----------+------------------+---------+----------
 bitdiddl | Ben Bitdiddle    |      65 |        1
 mike     | Michael Dole     |      73 |        2
 alyssa   | Alyssa P. Hacker |      79 |        3
 bbrown   | Bob Brown        |     100 |        3
 ajones   | Alice Jones      |      82 |        1
(5 rows)

postgres=*# update account set balance = balance + 10 where fullname = 'Alice Jones';
UPDATE 1
postgres=*# commit;
COMMIT


### terminal 2
postgres=# begin;
BEGIN
postgres=*# update account  set username = 'ajones' where fullname = 'Alice Jones'
;
UPDATE 1
postgres=*# select * from account;
 username |     fullname     | balance | group_id
----------+------------------+---------+----------
 bitdiddl | Ben Bitdiddle    |      65 |        1
 mike     | Michael Dole     |      73 |        2
 alyssa   | Alyssa P. Hacker |      79 |        3
 bbrown   | Bob Brown        |     100 |        3
 ajones   | Alice Jones      |      82 |        1
(5 rows)

postgres=*# commit;
COMMIT
postgres=# select * from account;
 username |     fullname     | balance | group_id
----------+------------------+---------+----------
 bitdiddl | Ben Bitdiddle    |      65 |        1
 mike     | Michael Dole     |      73 |        2
 alyssa   | Alyssa P. Hacker |      79 |        3
 bbrown   | Bob Brown        |     100 |        3
 ajones   | Alice Jones      |      82 |        1
(5 rows)
postgres=# begin;
BEGIN
postgres=*# update account set balance = balance + 30 where fullname = 'Alice Jones';
UPDATE 1
postgres=*# rollback;
ROLLBACK
postgres=#

#Outout explanation: after uodating Alice's username in the second terminal in transaction, the changes were displayed only in the second terminal, the first's table
#remained the same. Only after the changes were commited, they were displayed at the first terminal as well. As for update transactions at the same time, the second did not execute unless 
#the first update was commited, therefore concurrent updates in transaction are applied sequentially and both cannot be executed at the same moment.

### PART 1, REPEATABLE READ LEVEL ##

### terminal 1 
postgres=# BEGIN transaction ISOLATION LEVEL REPEATABLE READ;
BEGIN
postgres=*# select * from account;
 username |     fullname     | balance | group_id
----------+------------------+---------+----------
 bitdiddl | Ben Bitdiddle    |      65 |        1
 mike     | Michael Dole     |      73 |        2
 alyssa   | Alyssa P. Hacker |      79 |        3
 bbrown   | Bob Brown        |     100 |        3
 ajones   | Alice Jones      |      92 |        1
(5 rows)

postgres=*# select * from account;
 username |     fullname     | balance | group_id
----------+------------------+---------+----------
 bitdiddl | Ben Bitdiddle    |      65 |        1
 mike     | Michael Dole     |      73 |        2
 alyssa   | Alyssa P. Hacker |      79 |        3
 bbrown   | Bob Brown        |     100 |        3
 ajones   | Alice Jones      |      92 |        1
(5 rows)

postgres=*# select * from account;
 username |     fullname     | balance | group_id
----------+------------------+---------+----------
 bitdiddl | Ben Bitdiddle    |      65 |        1
 mike     | Michael Dole     |      73 |        2
 alyssa   | Alyssa P. Hacker |      79 |        3
 bbrown   | Bob Brown        |     100 |        3
 ajones   | Alice Jones      |      92 |        1
(5 rows)

postgres=*# update account set balance = balance + 10 where fullname = 'Alice Jones';
ERROR:  could not serialize access due to concurrent update
postgres=!# commit;
ROLLBACK

### terminal 2
postgres=# BEGIN transaction ISOLATION LEVEL REPEATABLE READ;
BEGIN
postgres=*# select * from account;
 username |     fullname     | balance | group_id
----------+------------------+---------+----------
 bitdiddl | Ben Bitdiddle    |      65 |        1
 mike     | Michael Dole     |      73 |        2
 alyssa   | Alyssa P. Hacker |      79 |        3
 bbrown   | Bob Brown        |     100 |        3
 ajones   | Alice Jones      |      92 |        1
(5 rows)

postgres=*# update account set username = 'jones' where fullname = 'Alice Jones';
UPDATE 1
postgres=*# select * from account;
 username |     fullname     | balance | group_id
----------+------------------+---------+----------
 bitdiddl | Ben Bitdiddle    |      65 |        1
 mike     | Michael Dole     |      73 |        2
 alyssa   | Alyssa P. Hacker |      79 |        3
 bbrown   | Bob Brown        |     100 |        3
 jones    | Alice Jones      |      92 |        1
(5 rows)

postgres=*# commit
postgres-*# ;
COMMIT
postgres=# select * from account;
 username |     fullname     | balance | group_id
----------+------------------+---------+----------
 bitdiddl | Ben Bitdiddle    |      65 |        1
 mike     | Michael Dole     |      73 |        2
 alyssa   | Alyssa P. Hacker |      79 |        3
 bbrown   | Bob Brown        |     100 |        3
 jones    | Alice Jones      |      92 |        1
(5 rows)

postgres=# BEGIN transaction ISOLATION LEVEL REPEATABLE READ;
BEGIN
postgres=*# update account set balance = balance + 30 where fullname = 'Alice Jones';
UPDATE 1
postgres=*# rollback;
ROLLBACK

# Explanation: unlike the READ COMMITED isolation level, the changes of the username at the second terminal were not diplayed in the first even after being commited.
# As for concurrent update, erminal 2 updates table because it has latest version of table,  while terminal 1 gets  serialization errorwhen it tries to update
# the table because it works with old version of it.


