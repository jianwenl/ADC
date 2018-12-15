create database jw_l;
\c jw_l;

--1

with vs as 
      (select distinct w.a
       from W w,W w1
       where w.A = w1.A and w.B <> w1.B)

select * from vs 
union  
select distinct q.a
from (
select w.a
from W w
except
select w.a
from W w, vs
) q;



--2
/*table*/
create table Student(
	Sid INTEGER, 
	Sname VARCHAR(15), 
	PRIMARY KEY (Sid)
);


create table Major(
	Sid INTEGER, 
	Major VARCHAR(15), 
	PRIMARY KEY (Sid,Major),
	FOREIGN KEY (Sid) REFERENCES Student (Sid)
);

create table Book(
	BookNo INTEGER, 
	Title VARCHAR(30), 
	Price INTEGER,
	PRIMARY KEY (BookNo)
);

create table Cites(
	BookNo INTEGER, 
	CitedBookNo INTEGER, 
	PRIMARY KEY (BookNo,CitedBookNo),
	FOREIGN KEY (BookNo) REFERENCES Book (BookNo),
	FOREIGN KEY (CitedBookNo) REFERENCES Book (BookNo)
);

create table Buys(
	Sid INTEGER, 
	BookNo INTEGER, 
	PRIMARY KEY (BookNo,Sid),
	FOREIGN KEY (Sid) REFERENCES Student (Sid),
	FOREIGN KEY (BookNo) REFERENCES Book (BookNo)
);


insert into Student (Sid,Sname)values
	(1001,'Jean'),
	(1002,'Maria'),
	(1003,'Anna'),
	(1004,'Chin'),
	(1005,'John'),
	(1006,'Ryan'),
	(1007,'Catherine'),
	(1008,'Emma'),
	(1009, 'Jan'), 
	(1010, 'Linda'),
	(1011, 'Nick'),
	(1012, 'Eric'), 
	(1013, 'Lisa'), 
	(1014, 'Filip'),
	(1015, 'Dirk'),
	(1016, 'Mary'),
	(1017, 'Ellen'), 
	(1020, 'Greg'),
	(1022, 'Qin'),
	(1023, 'Melanie'),
	(1040, 'Pam')
	;

insert into Major (Sid,Major)values
	(1001,'Math'),
	(1001,'Physics'),
	(1002,'CS'),
	(1002,'Math'),
	(1003,'Math'),
	(1004,'CS'),
	(1006,'CS'),
	(1007,'CS'),
	(1007,'Physics'),
	(1008,'Physics'),
	(1009,'Biology'),
	(1010,'Biology'),
	(1011,'CS'),
	(1011,'Math'),
	(1012,'CS'),
	(1013,'CS'),
	(1013,'Psychology'),
	(1014,'Theater'),
	(1017,'Anthropology'),
	(1022,'CS'),
	(1015,'Chemistry');
	
insert into Book (BookNo,Title,Price)values
	(2001,	'Databases',	40),
	(2002,	'OperatingSystems',	25),
	(2003,	'Networks',	20),
	(2004,	'AI',	45),
	(2005,	'DiscreteMathematics',	20),
	(2006,	'SQL',	25),
	(2007,	'ProgrammingLanguages',	15),
	(2008,	'DataScience',	50),
	(2009,	'Calculus',	10),
	(2010,	'Philosophy',	25),
	(2012,	'Geometry',	80),
	(2013,	'RealAnalysis',	35),
	(2011,	'Anthropology',	50),
	(2014,	'Topology',	70)
	;

insert into Cites (BookNo,CitedBookNo)values
	(2012,	2001),
	(2008,	2011),
	(2008,	2012),
	(2001,	2002),
	(2001,	2007),
	(2002,	2003),
	(2003,	2001),
	(2003,	2004),
	(2003,	2002),
	(2010,	2001),
	(2010,	2002),
	(2010,	2003),
	(2010,	2004),
	(2010,	2005),
	(2010,	2006),
	(2010,	2007),
	(2010,	2008),
	(2010,	2009),
	(2010,	2011),
	(2010,	2013),
	(2010,	2014)
	;

insert into Buys (Sid,BookNo)values
	(1023,	2012),
	(1023,	2014),
	(1040,	2002),
	(1001,	2002),
	(1001,	2007),
	(1001,	2009),
	(1001,	2011),
	(1001,	2013),
	(1002,	2001),
	(1002,	2002),
	(1002,	2007),
	(1002,	2011),
	(1002,	2012),
	(1002,	2013),
	(1003,	2002),
	(1003,	2007),
	(1003,	2011),
	(1003,	2012),
	(1003,	2013),
	(1004,	2006),
	(1004,	2007),
	(1004,	2008),
	(1004,	2011),
	(1004,	2012),
	(1004,	2013),
	(1005,	2007),
	(1005,	2011),
	(1005,	2012),
	(1005,	2013),
	(1006,	2006),
	(1006,	2007),
	(1006,	2008),
	(1006,	2011),
	(1006,	2012),
	(1006,	2013),
	(1007,	2001),
	(1007,	2002),
	(1007,	2003),
	(1007,	2007),
	(1007,	2008),
	(1007,	2009),
	(1007,	2010),
	(1007,	2011),
	(1007,	2012),
	(1007,	2013),
	(1008,	2007),
	(1008,	2011),
	(1008,	2012),
	(1008,	2013),
	(1009,	2001),
	(1009,	2002),
	(1009,	2011),
	(1009,	2012),
	(1009,	2013),
	(1010,	2001),
	(1010,	2002),
	(1010,	2003),
	(1010,	2011),
	(1010,	2012),
	(1010,	2013),
	(1011,	2002),
	(1011,	2011),
	(1011,	2012),
	(1012,	2011),
	(1012,	2012),
	(1013,	2001),
	(1013,	2011),
	(1013,	2012),
	(1014,	2008),
	(1014,	2011),
	(1014,	2012),
	(1017,	2001),
	(1017,	2002),
	(1017,	2003),
	(1017,	2008),
	(1017,	2012),
	(1020,	2001),
	(1020,	2012),
	(1022,	2014)
;
/*problem solve*/

--2.a
select distinct p.sid,p.sname
from 
(select s.sid as sid,s.sname as sname
from student s, buys BU,Cites C
where BU.bookno=C.bookno and s.sid=bu.sid) p;


--2.b
select distinct s.sid,s.sname
from student s, Major M1,Major M2
where s.sid=M1.sid and M1.Sid=M2.sid and M1.major<>M2.Major;

--2.c
select distinct bu.sid
from buys bu
except
select distinct bu1.sid
from buys bu1,buys bu2
where bu1.sid=bu2.sid and bu1.bookno<>bu2.bookno;

--2.d
with A as (
select b.bookno,b.title,b.price
from book b
except
select q.bookno,q.title,q.price
from (
select b.bookno,b.title,b.price
from book b
except
select b.bookno,b.title,b.price
from book b1,book b
where b1.price<b.price
) q
);

select A.bookno,A.title,A.price
from A
except
select A.bookno,A.title,A.price
from A A1, A
where A1.price<A.price;

--2e
select p.bookno,p.title
from 
(select b.bookno,b.title
from book b
except
select q.bookno,q.title
from
(select t.sid,b.bookno,b.title
from buys t,book b
	where t.bookno=b.bookno
except
select m.sid,b.bookno,b.title
from major m,book b
	where m.sid='1001'	
) q) p;

--2f
with
e
as
(select s.sid,s.sname,bu.bookno
from student s, buys bu,book bo
where bu.sid=s.sid and bu.bookno=bo.bookno and bo.price<50)
select distinct e1.sid,e1.sname
from e e1,e e2
where e1.bookno<>e2.bookno and e1.sid=e2.sid;

--2g
select distinct q.bookno
from
(
select m.sid,b.bookno
from major m,book b
where m.major='CS'
except
select t.sid,b.bookno
from buys t,book b
where t.bookno=b.bookno
) q;

--2h
select distinct b.bookno
from book b
except
select q.bookno
from (
select b.bookno
from book b, book b1, Cites c
where b.bookno=c.CitedBookNo and b1.BookNo=c.bookno and b1.Price>50
) q;

--2i
select distinct q.sid
from
(
select s.sid,b.bookno
from student s,buys t,book b
where s.sid=t.sid and t.bookno=b.bookno
except
select s.sid,b.bookno
from book b,student s
where b.price<30
) q
;

--2j
select distinct q.tsid as sid,q.bookno
	from(
		
		select distinct p.tsid,p.bookno
		from
		(
		select t.sid as tsid, t.BookNo as tbookno,b.BookNo,b.price,b.title
		from book b,buys t
		except
		
		select t.sid as tsid, t.BookNo as tbookno,b.BookNo,b.price,b.title
		from cites c,book b,buys t
		where c.citedbookno=b.bookno and t.bookno=c.bookno
			
	) p
	) q;

--2k
select distinct q.bookno1,q.bookno2
from (
select b1.bookno as bookno1,b1.title as title1, b1.price as price1,
	 b2.bookno as bookno2,b1.title as title2, b1.price as price2
from book b1,book b2
where b1.bookno<>b2.bookno

	intersect

	select distinct p2.bookno1,p2.title1, p2.price1,
	 p2.bookno2,p2.title2, p2.price2
	from
	(select b1.bookno as bookno1,b1.title as title1, b1.price as price1,
	 b2.bookno as bookno2,b1.title as title2, b1.price as price2
from book b1,book b2
except 
	(
	select p1.bookno1,p1.title1, p1.price1,
	 p1.bookno2,p1.title2, p1.price2
	from
(
	select t1.sid,b1.bookno as bookno1,b1.title as title1, b1.price as price1,
	 b2.bookno as bookno2,b1.title as title2, b1.price as price2
	from buys t1,Major m,book b1,book b2
	where m.major='CS' and m.sid=t1.sid and b1.bookno=t1.bookno
	except 
	select t2.sid,b1.bookno as bookno1,b1.title as title1, b1.price as price1,
	 b2.bookno as bookno2,b1.title as title2, b1.price as price2
	from buys t2,Major m,book b1,book b2
	where m.major='CS' and m.sid=t2.sid and b2.bookno=t2.bookno
) p1)
	) p2

	intersect

	select distinct p4.bookno1,p4.title1, p4.price1,
	 p4.bookno2,p4.title2, p4.price2
	from(
	select b1.bookno as bookno1,b1.title as title1, b1.price as price1,
	 b2.bookno as bookno2,b1.title as title2, b1.price as price2
from book b1,book b2
except

	(select p3.bookno1,p3.title1, p3.price1,
	 p3.bookno2,p3.title2, p3.price2
	from
	(
	select t2.sid,b1.bookno as bookno1,b1.title as title1, b1.price as price1,
	 b2.bookno as bookno2,b1.title as title2, b1.price as price2
	from buys t2,Major m,book b1,book b2
	where m.major='CS' and m.sid=t2.sid and b2.bookno=t2.bookno
	except 
	select t1.sid,b1.bookno as bookno1,b1.title as title1, b1.price as price1,
	 b2.bookno as bookno2,b1.title as title2, b1.price as price2
	from buys t1,Major m,book b1,book b2
	where m.major='CS' and m.sid=t1.sid and b1.bookno=t1.bookno
) p3)) p4
	) q;

--2l
select distinct q.s1sid,q.s2sid
from(

select distinct p.s1sid,p.s1sname,p.s2sid,p.s2sname
from(
select s1.sid as s1sid, s1.sname as s1sname, s2.sid as s2sid, s2.sname as s2sname
from student s1,student s2
except

select p1.s1sid,p1.s1sname,p1.s2sid,p1.s2sname
from(
(select t.bookno, s1.sid as s1sid, s1.sname as s1sname, s2.sid as s2sid, s2.sname as s2sname
from buys t,student s1,student s2
where t.sid=s1.sid
except
select t.bookno,s1.sid as s1sid, s1.sname as s1sname, s2.sid as s2sid, s2.sname as s2sname
from buys t,student s1,student s2
where t.sid=s2.sid)
	) p1
) p
intersect
select s1.sid as s1sid, s1.sname as s1sname, s2.sid as s2sid, s2.sname as s2sname
from student s1,student s2
where
s1.sid<>s2.sid
	) q;

--2m

with A as(

	select distinct C.Citedbookno
					from Book B,Cites C
					--where  not in 
	except		  
	select C.Citedbookno
			   from Cites C1,Book B,Cites C
			  where C1.Citedbookno=C.Citedbookno and B.BookNo=C1.bookno
			  
)
,
B as(
select distinct C.Citedbookno
FROM cites C
	except

	select q.Citedbookno
	from 
	(
		select p1.Citedbookno
		from
		(select distinct C.Citedbookno
					from Book B1,Book B2,Cites C
			except 
	 
			  select C.Citedbookno
			   from Cites C1,Book B1,Book B2,Cites C
			  where C1.Citedbookno=C.Citedbookno and B1.BookNo=C1.bookno
			  ) p1
		
	 intersect
	select p2.Citedbookno
		from
	(select distinct C.Citedbookno
					from Book B1,Book B2,Cites C
	except
			 select C.Citedbookno
			   from Cites C1,Book B1,Book B2,Cites C
			  where C1.Citedbookno=C.Citedbookno and B2.BookNo=C1.bookno
			  ) p2
		
	 intersect
		
	select distinct C.Citedbookno
					from Book B1,Book B2,Cites C
			where
	B1.BookNo<>B2.BookNo) q
			 
)
			  
			  select A.Citedbookno
			  FROM A
			  EXCEPT
			  select B.Citedbookno
			  FROM B

            


--3
--3a cancel "in" with 1 step
select distinct M.sid, M.Major
from Major M, Buys t, Book B
where B.price<20 and t.bookno=B.bookno and M.sid=t.sid;

--3b cancel "<= ALL" with 1 step

select q.sid,q.bookno
from
(
select t.sid,b.bookno
from buys t, Book b
where t.bookno=b.bookno
except

select distinct p.tsid,p.bookno
from
(select t.sid as tsid,t.bookno as tbookno,t1.sid as t1sid,t1.bookno as t1bookno,b.bookno,b.title,b.price,
 b1.bookno as bookno1,b1.title as title1,b1.price as price1
	from buys t, Book b, buys t1, Book b1
where t.bookno=b.bookno and t1.bookno=b1.bookno and t1.sid=t.sid
except
select t.sid as tsid,t.bookno as tbookno,t1.sid as t1sid,t1.bookno as t1bookno,b.bookno,b.title,b.price,
 b1.bookno as bookno1,b1.title as title1,b1.price as price1
from buys t, Book b, buys t1, Book b1
where (b.Price<=b1.price) 
) p

) q;

--3c cancel "in" with 1 step
select distinct q.bookno,q.title
from(
select b.bookno, b.title
from book b
where 20 <= b.price 
intersect
select b.bookno, b.title
from book b
where b.price <= 40 
intersect
select b.bookno, b.title
from book b,cites c
where b.bookno=c.citedbookno) q;

--3d cancel "in" and "exists" with one step
select distinct s.sid,s.sname
from Student s, Major m, buys t,Cites c, book b1, book b2
where s.sid=m.sid and m.major='CS' and s.sid=t.sid and t.bookno=c.CitedBookNo
and c.CitedBookNo=b1.bookno and c.bookno=b2.bookno and b1.price>b2.price;

--3e three steps
--step 1 for first order nest "exist"
select distinct b.bookno, b.title
from major m,book b
where m.major = 'CS' and
m.sid not in(select t.sid
from buys t
where t.bookno = b.bookno)
;

--step2 for second order nest "and"
select distinct q.bookno, q.title
from
( select b.bookno, b.title
from major m,book b
where m.major = 'CS' 
intersect
	select b.bookno, b.title
from major m,book b
where 			 
m.sid not in(select t.sid
from buys t
where t.bookno = b.bookno)
) q;

--step 3 for third order nest "not in"
select distinct q.bookno, q.title
from (

select p.bookno,p.title
from
(select b.bookno, b.title,b.price,m.*
from book b,major m
except
select b.bookno, b.title,b.price,m.*
from buys t,book b,major m
where t.bookno = b.bookno and m.sid=t.sid) p

intersect
select b.bookno, b.title
from book b,major m
where m.major = 'CS' ) q
;




--3f three steps

--step1 for first order nest “not exists”
select distinct q.bookno, q.title
from (
select b.bookno, b.title,b.price
from book b
except
	select b.bookno, b.title,b.price
from student s,book b
where s.sid in (select m.sid from major m
where m.major = 'CS') and
s.sid in (select m.sid from major m
where m.major = 'Math') and
s.sid not in (select t.sid
from buys t
where t.bookno = b.bookno)
			  ) q;

--step2 for second order nest "and "
select distinct q.bookno, q.title
from (
select b.bookno, b.title,b.price
from book b
except

	select q1.bookno, q1.title,q1.price
	from (
	select b.bookno, b.title,b.price,s.*
from student s,book b
where s.sid in (select m.sid from major m
where m.major = 'CS') 
	intersect
		select b.bookno, b.title,b.price,s.*
from student s,book b
where s.sid in (select m.sid from major m
where m.major = 'Math') 
	intersect
		select b.bookno, b.title,b.price,s.*
from student s,book b
where s.sid not in (select t.sid
from buys t
where t.bookno = b.bookno)
) q1




--step3 for third order each "in" or "not in"s
select distinct q.bookno, q.title
from
(
select b.bookno, b.title,b.price
from book b
except

select q1.bookno, q1.title,q1.price
from(

select distinct b.bookno, b.title,b.price,s.*
from student s, book b,major m
	where m.major = 'CS' and s.sid=m.sid
	
	intersect

	select distinct b.bookno, b.title,b.price,s.*
from student s, book b,major m
	where m.major = 'Math' and s.sid=m.sid
	
	intersect

	select q3.bookno, q3.title,q3.price,q3.sid,q3.sname
	from(
	select b.bookno, b.title,b.price,s.*
from student s, book b
except
		select b.bookno, b.title,b.price,s.*
		from buys t,student s, book b
		where t.bookno = b.bookno and s.sid=t.sid
		) q3

) q1
) q
	;

\c postgres;

drop database jw_l;









