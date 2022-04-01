--1st expression
select * 
from Author A join Book B 
on A.author_id = B.editor;

--2nd expression
select distinct first_name, last_name
from (select *
      from Author A join (
      	select author_id
        from Author except (
        	select editor from Book
        ) 
      ) D
      on A.author_id = D.author.id
     );

--3rd expression   
select author_id
from author except (
	select editor from book
);