

--1

--initial
select distinct s.sid,s.sname, b.bookno, b.title
from student s
cross join book b
inner join buys t on ((s.sname = 'Eric' or s.sname = 'Anna') and
s.sid = t.sid and
b.price > 20 and
t.bookno = b.bookno);


--pushing down selection
select distinct s.sid,s.sname, b.bookno, b.title
from (select s.sid,s.sname from student s where s.sname = 'Eric' or s.sname = 'Anna') s
cross join (select b.* from book b where b.price > 20) b
inner join buys t on (
s.sid = t.sid and
t.bookno = b.bookno);

--cascading rules
select distinct t.sid,s.sname, b.bookno, b.title
from  
	(select s3.sid,s3.sname
	 from
	(select s1.sid,s1.sname from student s1 where s1.sname = 'Eric'
	  union
	  select s2.sid,s2.sname from student s2 where s2.sname = 'Anna') s3) s
cross join 
(select b.bookno, b.title from book b where b.price > 20) b
inner join 
buys t on
(s.sid = t.sid and
t.bookno = b.bookno)
;
--Rewrite rule for joins and natural join
select distinct t.sid,s.sname, b.bookno, b.title
from  
	(select s3.sid,s3.sname
	 from
	(select s1.sid,s1.sname from student s1 where s1.sname = 'Eric'
	  union
	  select s2.sid,s2.sname from student s2 where s2.sname = 'Anna') s3) s
natural join buys t
natural join
(select b.bookno, b.title from book b where b.price > 20) b;

--2
--initial
select distinct s.sid
from student s
cross join book b
inner join buys t on ((s.sname = 'Eric' or s.sname = 'Anna') and
s.sid = t.sid and
b.price > 20 and
t.bookno = b.bookno);


--pushing down selection
select distinct s.sid
from (select s.sid from student s where s.sname = 'Eric' or s.sname = 'Anna') s
cross join book b
inner join buys t on (
s.sid = t.sid and
b.price > 20 and
t.bookno = b.bookno);

--pushing down selection
select distinct s.sid
from (select s.sid from student s where s.sname = 'Eric' or s.sname = 'Anna') s
cross join (select b.bookno from book b where b.price > 20) b
inner join buys t on (
s.sid = t.sid and
t.bookno = b.bookno
);

--Rewrite rule for joins and natural join
select distinct s.sid
from (select s.sid from student s where s.sname = 'Eric' or s.sname = 'Anna') s
natural join buys t
natural join (select b.bookno from book b where b.price > 20) b
;

--Regular Semi-joins rules
select distinct s.sid
from (select s.sid from student s where s.sname = 'Eric' 
	  union
	  select s.sid from student s where s.sname = 'Anna' 
	  or s.sname = 'Anna') s
		natural join 
		((select t.sid from buys t) t
		natural join (select b.bookno from book b where b.price > 20) b) k 
;

--3
--initial
select distinct s.sid, b1.price as b1_price, b2.price as b2_price
from (select s.sid from student s where s.sname <> 'Eric') s
cross join book b2
inner join book b1 on (b1.bookno <> b2.bookno and b1.price > 60 and b2.price >= 50)
inner join buys t1 on (t1.bookno = b1.bookno and t1.sid = s.sid)
inner join buys t2 on (t2.bookno = b2.bookno and t2.sid = s.sid);



--pushing down selection
select distinct s.sid, b1.price as b1_price, b2.price as b2_price
from (select s.sid from student s where s.sname <> 'Eric') s
cross join (select b2.bookno,b2.price from book b2 where b2.price>=50) b2
inner join (select b1.bookno,b1.price from book b1 where b1.price>=60) b1 on (b1.bookno <> b2.bookno)
inner join buys t1 on (t1.bookno = b1.bookno and t1.sid = s.sid)
inner join buys t2 on (t2.bookno = b2.bookno and t2.sid = s.sid)
;


--Rewrite rule for joins and natural join

select distinct t1.sid, b1.price as b1_price, b2.price as b2_price
from (select s.sid from student s where s.sname <> 'Eric') s
natural join buys t1-- on (t1.sid = s.sid)
natural join (select b1.bookno,b1.price from book b1 where b1.price>=60) b1-- on (t1.bookno = b1.bookno)
inner join (select b2.bookno,b2.price from book b2 where b2.price>=50) b2 on (b1.bookno <> b2.bookno)
inner join buys t2 on (t2.bookno = b2.bookno and t2.sid = t1.sid);


--Rewrite rules for projection and joins,we found out the 4 Join Relations 
--can be factored into ：student natural join a relation which can be further factored to two similiar relations
--By doing this, we do not need to select from a 4 join tables
select distinct s.sid, q.b1_price as b1_price, q.b2_price as b2_price
from (
	select s.sid from student s where s.sname <> 'Eric') s
	
	natural join 
	(select distinct bob1.sid,bob1.price as b1_price,bob2.price as b2_price
				from (select t1.sid,bb1.price,bb1.bookno
					from (select b1.bookno,b1.price from book b1 where b1.price>=60) bb1
					natural join buys t1
					 ) bob1
					inner join
					(select t2.sid,bb2.price,bb2.bookno
				from (select b2.bookno,b2.price from book b2 where b2.price>=50) bb2
				natural join buys t2 
					) bob2
				on bob1.sid=bob2.sid and bob1.bookno<>bob2.bookno) q;

--4

--initial
select q.sid
from (select s.sid, s.sname
from student s
except
select s.sid, s.sname
from student s
inner join buys t on (s.sid = t.sid)
inner join book b on (t.bookno = b.bookno and b.price > 50)) q;

--cancel the abundant variable
select q.sid
from (select s.sid--, s.sname
from student s
except
select s.sid--, s.sname
from student s
inner join buys t on (s.sid = t.sid)
inner join book b on (t.bookno = b.bookno and b.price > 50)) q;


--Elimination rules for projections，primary key constrain
--select q.sid
--from (
	select s.sid--, s.sname
from student s
except
select t.sid--, s.sname
from --student s
--inner join 
	  buys t 
	  --on (s.sid = t.sid)
inner join (select b.bookno from book b where b.price > 50) b on (t.bookno = b.bookno 
																  --and b.price > 50
																 )
--) q
;

--use semi join  rule
select s.sid
from student s
except
select t.sid
from buys t 
natural join (select b.bookno from book b where b.price > 50) b;

--5
--initial
select q.sid, q.sname
from (select s.sid, s.sname, 2007 as bookno
from student s
cross join book b
intersect
select s.sid, s.sname, b.bookno
from student s
cross join book b
inner join buys t on (s.sid = t.sid and t.bookno = b.bookno and b.price <25)) q;



--pushing down projection
select q.sid, q.sname
from (select s.sid, s.sname, 2007 as bookno
from student s
cross join (select b.bookno from book b) b
intersect
select t.sid, s.sname, b.bookno
from student s
cross join (select b.bookno from book b where b.price <25) b
inner join buys t on (s.sid = t.sid and 
					  t.bookno = b.bookno)
	 ) q;


--Rewrite rules for the selection operator (Distribution rules）
select q.sid, q.sname
from (select s.sid, s.sname, 2007-- as bookno
from student s
cross join (select b.bookno from book b) b
intersect
select t.sid, s.sname, b.bookno
from student s
cross join (select b.bookno from book b where b.price <25) b
inner join buys t on (s.sid = t.sid and 
					  t.bookno = b.bookno)
	 ) q;

--cancel the abundant join
select q.sid, q.sname
from (select s.sid, s.sname, 2007
from student s
intersect
select t.sid, s.sname, b.bookno
from student s
cross join (select b.bookno from book b where b.price <25) b
inner join buys t on (s.sid = t.sid
					  and 
					  t.bookno = b.bookno
					 )
	 ) q;

--Rewrite rule for joins and natural join
select q.sid, q.sname
from (select s.sid, s.sname, 2007
from student s
intersect
select t.sid, s.sname, b.bookno
from (select s.sid,s.sname from student s) s
natural join buys t
natural join (select b.bookno from book b where b.price <25) b
	 ) q;

--primary key constraint
select s.sid,s.sname 
from student s
natural join buys t
natural join (select b.bookno from book b where b.price<25 and b.bookno=2007) q


--6
--initial
select distinct q.bookno
from (select s.sid, s.sname, b.bookno, b.title
from student s
cross join book b
except
select s.sid, s.sname, b.bookno, b.title
from student s
cross join book b
inner join buys t on (s.sid = t.sid and t.bookno = b.bookno and b.price <20)) q;



--pushing down selection
select distinct q.bookno
from (select s.sid, s.sname, b.bookno, b.title
from student s
cross join book b
except
select s.sid, s.sname, b.bookno, b.title
from student s
cross join (select b.bookno,b.title from book b where b.price<20) b
inner join buys t on (s.sid = t.sid and t.bookno = b.bookno)) q;

--Rewrite rule for joins and natural join
select distinct q.bookno
from (
select s.sid, s.sname, b.bookno, b.title
from (select s.sid, s.sname from student s) s
cross join (select b.bookno,b.title from book b) b
except
select s.sid, s.sname, b.bookno, b.title
from student s
natural join buys t
natural join (select b.bookno,b.title from book b where b.price<20) b
) q;

--Rewrite rules for the selection operator selection (Distribution rules)
select distinct q.bookno
from (
select s.sid, s.sname, b.bookno, b.title
from (select s.sid, s.sname from student s) s
cross join (select b.bookno,b.title from book b) b
except
select t.sid, s.sname, b.bookno, b.title
from student s
natural join buys t
natural join (select b.bookno,b.title from book b where b.price<20) b
) q;

--Functional and primary key constraints
select distinct q.bookno
from (
select s.sid,b.bookno
from (select s.sid from student s) s
cross join (select b.bookno from book b) b
except
select t.sid,b.bookno
from student s
natural join buys t
natural join (select b.bookno from book b where b.price<20) b
) q;

--7
--initial
select s.sid
from student s
except
(select s1.sid
from student s1
inner join student s2 on (s1.sid <> s2.sid)
inner join buys t1 on (s1.sid = t1.sid)
union
select s1.sid
from student s1
inner join student s2 on (s1.sid <> s2.sid)
inner join buys t1 on (s1.sid = t1.sid)
inner join buys t2 on (t1.bookno = t2.bookno and t2.sid = s2.sid)
inner join book b on (t2.bookno = b.bookno and b.price = 80));


--Rewrite rules for the operations union（Relativized De Morgan）			  
(select s.sid
from student s
except
select t1.sid
from buys t1
inner join student s2 on (t1.sid <> s2.sid)
)
intersect
(select s.sid
from student s
except
select s1.sid
from student s1
inner join (select s2.sid from student s2) s2 on (s1.sid <> s2.sid)
inner join buys t1 on (s1.sid = t1.sid)
inner join buys t2 on (t1.bookno = t2.bookno and t2.sid = s2.sid)
inner join book b on (t2.bookno = b.bookno and b.price = 80));

--pushing down selection
(select s.sid
from student s
except
select t1.sid
from buys t1
inner join student s2 on (t1.sid <> s2.sid)
)
intersect
(select s.sid
from student s
except
select s1.sid
from student s1
inner join (select s2.sid from student s2) s2 on (s1.sid <> s2.sid)
inner join buys t1 on (s1.sid = t1.sid)
inner join buys t2 on (t1.bookno = t2.bookno and t2.sid = s2.sid)
inner join (select b.bookno from book b where b.price = 80) b on (t2.bookno = b.bookno)
);

--foreign key constriant
(select s.sid
from student s
except
select t1.sid
from buys t1
inner join student s2 on (t1.sid <> s2.sid)
)

						 intersect
(select s.sid
from student s
except
select t1.sid
from --student s1
buys t1
inner join (select s2.sid from student s2) s2 on (t1.sid <> s2.sid)
--inner join buys t1 on (s1.sid = t1.sid)
--inner join buys t2 on (t1.bookno = t2.bookno and t2.sid = s2.sid)
cross join (select b.bookno from book b where b.price = 80) b-- on (t2.bookno = b.bookno)
);

--observe that the latter part after intersect is a subset of the first part before intersect
select s.sid
from student s
except
select t1.sid
from --student s1
buys t1
inner join (select s2.sid from student s2) s2 on (t1.sid <> s2.sid)
cross join (select b.bookno from book b where b.price = 80) b;

--primary key constraint
select s.sid
from student s
except
select t1.sid
from buys t1
inner join (select s2.sid from student s2) s2 on (t1.sid <> s2.sid);


