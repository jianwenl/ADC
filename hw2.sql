
create database <Jw_l>;
\c <jw_l>;


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



/*1*/
select distinct BU.Sid, M.Major
from Buys BU, Major M, Book BO
where BU.Sid=M.Sid And BO.BookNo=BU.BookNo and BO.Price< 20;

/*2*/

select BO.BookNo, BO.Title
from Book BO
where BO.Price>=20 and BO.Price<=40 
and BO.BookNo=some
( 
select C.CitedBookNo
from Cites C
where C.BookNo<>C.CitedBookNo
)
;

/*3*/
select S.Sid, S.Sname
from Student S,Major M
where S.Sid=M.Sid and M.Major='CS'
INTERSECT
select S.Sid, S.Sname
from Student S,Buys BU, Book BO1, Book BO2, Cites C
where S.Sid=BU.Sid and BU.BookNo=BO1.BookNo AND BO1.BookNo=C.CitedBookNo and BO2.BookNo=C.BookNo and BO1.Price>BO2.Price

;

/*4*/
select distinct BO.BookNo, BO.Title
from Book BO, Cites C
where BO.BookNo=C.CitedBookNo and C.BookNo<>C.CitedBookNo and EXISTS (select C1.BookNo
																	 from Cites C1
																	 where C1.CitedBookNo=C.BookNo); 

/*5*/
select distinct BO.BookNo
from Book BO
where BO.Price <= ALL(select B1.Price from Book B1);


/*6*/
select distinct BO0.BookNo, BO0.Title
from Book BO0
where NOT EXISTS (
select BO1.BookNo
from Book BO1
where BO1.Price > BO0.Price);

/*7*/
select S1.BookNo,S1.Title
from
(
select distinct BO2.BookNo,BO2.Title,BO2.Price
from Book BO2
EXCEPT
select distinct BO0.BookNo,BO0.Title,BO0.Price
from Book BO0
where NOT EXISTS (
select BO1.BookNo
from Book BO1
where BO1.Price > BO0.Price)
) S1
where NOT EXISTS (
select S2.BookNo
from
	(
select distinct BO2.BookNo,BO2.Title,BO2.Price
from Book BO2
EXCEPT
select distinct BO0.BookNo,BO0.Title,BO0.Price
from Book BO0
where NOT EXISTS (
select BO1.BookNo
from Book BO1
where BO1.Price > BO0.Price)
) S2
where S2.Price > S1.Price)
;



/*8*/
select distinct BO.BookNo, BO.Price
from Book BO, Book BO1, Cites C
where BO.BookNo=C.BookNo AND C.CitedBookNo=BO1.BookNo AND BO1.Price>20

/*9*/
select distinct BO.BookNo, BO.Title
from Book BO, Buys BU, Major M
where BO.BookNo = BU.BookNo and M.Sid = BU.Sid and (M.Major='Biology'or M.Major='Psychology');

/*10*/
select distinct BO.BookNo, BO.Title
from Book BO, Buys BU, Major M
where EXISTS (select M.Sid 
			  from Major M
			where M.Major='CS' and M.Sid NOT IN (SELECT BU1.Sid
												from Buys BU1
												where BU1.BookNo=BU.BookNo) );

/*11*/
select BO.BookNo
from Book BO
except
select BO.BookNo
from Book BO,Buys BU,Major M
where BU.Sid=M.Sid and M.Major<>'Biology' and BU.BookNo=BO.BookNO; 
/*the book that is not bought by also satisfy the condition here*/

/*12*/
select distinct BO.BookNo, BO.Title
from Book BO, Buys BU
where BO.BookNo = BU.BookNo
and not exists (
	select S.Sid
	from 
(--student who take both cs and math
SELECT M1.Sid AS Sid
FROM    Major M1
WHERE M1.Major='CS' 
INTERSECT
SELECT M2.Sid AS Sid
FROM    Major M2
WHERE M2.Major='Math'
) S
where S.Sid not in (
select BU1.Sid
	from Buys BU1
	where BU1.BookNo=BU.BookNo
)
)
;

/*13*/
select distinct S.Sid, S.Sname
from Student S, Buys BU
where S.Sid=BU.Sid AND EXISTS (
(SELECT distinct BU1.BookNo
FROM Buys BU1
where BU.Sid=BU1.Sid
except
 --bought by at least two
select distinct BU2.BookNo
 from Buys BU2
 where EXISTS (
 select BU3.Sid,BU4.Sid
	 from Major M2,Major M3,Buys BU3,Buys BU4
	 where BU3.BookNo=BU2.BookNO AND BU4.BookNo=BU2.BookNO AND
	 M2.Sid=BU3.Sid and M3.Sid=BU4.Sid
	 and M2.Sid<>M3.Sid and
	 M2.Major='CS'AND
	 M3.Major='CS'
 )

)

);

/*14*/
select distinct S1.Sid
from Student S1
EXCEPT
select distinct BU2.Sid
	from Student S1, Buys BU2,Buys BU1,Book BO1,Book BO2
	where S1.Sid=BU1.Sid AND S1.Sid=BU2.Sid AND BU1.BookNo<>BU2.BookNo 
 and BO2.Price>20 and BO1.Price>20 
 and BO1.BookNo=BU1.BookNO and BO2.BookNo=BU2.BookNO and BO1.BookNo<>BO2.BookNo
;

/*15*/
select BU.Sid, BU.BookNo
FROM Buys BU, Book BO
WHERE BO.BookNO=BU.BookNO and NOT EXISTS (
SELECT BU1.BookNo
FROM Buys BU1, Book BO1
where BU1.Sid=BU.Sid and BO1.BookNo=BU1.BookNO and BO.Price>BO1.Price
);

/*16*/

SELECT COUNT(1) FROM (

select distinct M1.Sid, M2.Sid
FROM Major M1, Major M2
where M1.Sid<>M2.Sid AND M1.Major=M2.Major and
(exists (
select BU1.Sid
	from Buys BU1
	where BU1.Sid=M1.Sid and BU1.BookNO not in(
	select BU2.BookNo
		from Buys BU2
		where BU2.Sid=M2.Sid
	))
	or
	exists (
select BU2.Sid
	from Buys BU2
	where BU2.Sid=M2.Sid and BU2.BookNO not in(
	select BU1.BookNo
		from Buys BU1
		where BU1.Sid=M1.Sid
	)
)
)
) x;



/*17*/
SELECT COUNT(1) FROM (

select distinct S1.Sid, S2.Sid, BO.BookNo
from Student S1,Student S2, Buys BU, Book BO
where S1.Sid=BU.Sid and BU.BookNo=BO.BookNo 
and S2.Sid not in (
select BU2.Sid
	from Buys BU2
	where BU2.BookNo=BU.BookNo
)
) x;

/*18*/
SELECT COUNT(1) FROM (
select distinct BU1.Sid, BU2.Sid
from Buys BU1,Buys BU2
where BU1.Sid<>BU2.Sid and BU1.BookNo=BU2.BookNO

except
select distinct BU1.Sid, BU3.Sid
from Buys BU1,Buys BU2,Buys BU3,Buys BU4
where BU1.Sid<>BU3.Sid and BU2.Sid<>BU4.Sid and BU2.Sid<>BU3.Sid and BU1.Sid<>BU4.Sid 
and BU1.Sid=BU2.Sid 
and BU3.Sid=BU4.Sid 
and BU1.BookNo<>BU2.BookNo and BU3.BookNo<>BU4.BookNo 
and ((BU1.BookNo=BU3.BookNo and BU2.BookNo=BU4.BookNo) or 
(BU1.BookNo=BU4.BookNo and BU2.BookNo=BU3.BookNo))
) x;


/*19*/
select BU.BookNo
FROM Buys BU
WHERE exists (select M.Sid
					from Major M
					where M.Major='CS' and M.Sid <>BU.Sid)

EXCEPT
select BU1.BookNo
FROM Buys BU1
WHERE exists (select M1.Sid,M2.Sid
			  from Major M1,Major M2
			  where M1.Sid<>M2.Sid and M1.Major='CS' and M2.Major='CS'
			  and M1.Sid NOT IN (select BU2.Sid
							 from Buys BU2
							 where BU2.BookNo=BU1.BookNo)
			   and M2.Sid NOT IN (select BU3.Sid
							 from Buys BU3
							 where BU3.BookNo=BU1.BookNo)
			 )
			 ;







\c postgres;

drop database <jw_l>;


