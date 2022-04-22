create table acounts (
    id integer primary key NOT NULL,
    name varchar(40) NOT NULL,
    credit integer NOT NULL,
    сurrency char(5) NOT NULL
);

insert into accounts (id, name, credit, currency) values 
(1, "Artem Volkov", 1000, "RUB"),
(2, "Kotik Kotikov", 1000, "RUB"),
(3, "Ildar Shakirov", 1000, "RUB");

create table ledger (
    id serial,
    from_ integer NOT NULL,
    to_ integer NOT NULL,
    fee integer NOT NULL,
    amount integer NOT NULL,
    transaction_time timestamp NOT NULL
)

-- Transaction T1
begin;
savepoint T1;
update accounts set credit = credit - 500 where id = 1;
update accounts set credit = credit + 500 where id = 3;
-- inserting into transactions table
insert into ledger (from_, to_, fee, amount, transaction_time)
values (1, 3, 0, 500, current_date);
rollback to T1;
commit;
end;

-- Transaction 2
begin;
savepoint T2;
update accounts set credit = credit - 700 where id = 2;
update accounts set credit = credit + 700 where id = 1;
-- inserting into transactions table
insert into ledger (from_, to_, fee, amount, transaction_time)
values (2, 1, 0, 700, current_date);
rollback to T2;
commit;
end;

-- Transaction 3
begin;
savepoint T3;
update accounts set credit = credit - 100 where id = 2;
update accounts set credit = credit + 100 where id = 3;
-- inserting into transactions table
insert into ledger (from_, to_, fee, amount, transaction_time)
values (2, 3, 0, 100, current_date);
rollback to T3;
commit;
end;

-- Second part
alter table accounts add column BankName text;
update accounts set BankName = 'SberBank' where id = 1;
update accounts set BankName = 'Tinkoff' where id = 2;
update accounts set BankName = 'SberBank' where id = 3;

-- Transaction 1
begin;
savepoint T1;
update accounts set credit = credit - 500 where id = 1;
update accounts set credit = credit + 500 where id = 3;
-- inserting into transactions table
insert into ledger (from_, to_, fee, amount, transaction_time)
values (1, 3, 0, 500, current_date);
rollback to T1;
commit;

-- Transaction 2
begin;
savepoint T2;
update accounts set credit = credit - 730 where id = 2;
update accounts set credit = credit + 700 where id = 1;
-- inserting into transactions table
insert into ledger (from_, to_, fee, amount, transaction_time)
values (2, 1, 30, 700, current_date);
rollback to T2;
commit;

-- Transaction 3
begin;
savepoint T3;
update accounts set credit = credit - 130 where id = 2;
update accounts set credit = credit + 100 where id = 3;
-- inserting into transactions table
insert into ledger (from_, to_, fee, amount, transaction_time)
values (2, 3, 30, 100, current_date);
rollback to T3;
commit;
end;