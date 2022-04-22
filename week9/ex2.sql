create table account (
    username varchar(40) NOT NULL,
    fullname varchar(40) NOT NULL,
    balance integer NOT NULL,
    group_id integer NOT NULL
);

insert into account(username, fullname, balance, group_id)
values
('jones', 'Alice Jones', 82, 1),
('bitdiddl', 'Ben Bitdiddle', 65, 1),
('mike', 'Michael Dole', 73, 2),
('alyssa', 'Alyssa P. Hacker', 79, 3),
('bbrown', 'Bob Brown', 100, 3);