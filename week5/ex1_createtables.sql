create table if not exists Suppliers (
	sid int primary key,
	sname text not null,
	address text not null
);

create table if not exists Parts (
	pid int primary key,
	pname text not null,
	color text not null
);

create table if not exists PartsCatalog (
	sid int not null,
	pid int not null,
	cost real not null,
	primary key (sid, pid)
);


insert into Parts (pid, pname, color)
values 
(1, 'Red1', 'Red'),
(2, 'Red2', 'Red'),
(3, 'Green1', 'Green'),
(4, 'Blue1', 'Blue'),
(5, 'Red3', 'Red');

insert into PartsCatalog (pid, sid, cost) 
values 
(1, 1, 10.00),
(1, 2, 20.00),
(1, 3, 30),
(1, 4, 40),
(1, 5, 50),
(2, 1, 9),
(2, 3, 34),
(2, 5, 48);

insert into Suppliers (sid, sname, address)
values 
(1, 'Yosemite Sham', 'Devil’s canyon, AZ'),
(2, 'Wiley E. Coyote', 'RR Asylum, NV'),
(3, 'Elmer Fudd', 'Carrot Patch, MN');



select * from Parts;

