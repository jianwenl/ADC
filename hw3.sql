create database jw_l;
\c jw_l;



--Q1）
create table A(
	x INTEGER
);

insert into A (x)values
	(1),
	(2),
	(3),
	(4),
	(5)
;

select a.x, sqrt(a.x) as square_root_x,power(a.x,2) as x_squared, power(2,a.x) as two_to_the_power_x, factorial(a.x) as x_factorial,log(a.x) as logarithm_x
from A a;


--Q2）

create table A(
	x INTEGER
);

create table B(
	x INTEGER
);

insert into A (x)values
	(1),
	(2),
	(3)
;

insert into B (x)values
	(1),
	(3),
	(4),
	(5)
;


select not exists(select a.x
			 from A a
			 except
			 select b.x
			 from B b) as empty_a_minus_b,
			 exists((select a.x
			 from A a
			 except
			 select b.x
			 from B b)
			 union
			 (select b.x
			 from B b
			 except
			 select a.x
			 from A a)) as not_empty_symmetric_difference,
			 not exists(select a.x
			 from A a
			 intersect
			 select b.x
			 from B b) as empty_a_intersection_b;

--Q3）

create table Pairs(
	x INTEGER,
	y INTEGER
);

insert into Pairs (x,y)values
	(1,1),
	(2,2),
	(3,4),
	(4,6),
	(5,9),
	(1,3),
	(5,2),
	(7,7)
;


select P1.x as x1,P1.y as y1,P2.x as x2,P2.y as y2
from pairs P1, pairs P2
where (P1.x<>P2.x and P1.y<>P2.y)
and P1.x+P1.y=P2.x+P2.y;

--Q4）
create table A(
	p boolean
);


create table B(
	Q boolean
);


create table C(
	R boolean
);

insert into A(P) values
	(TRUE),
	(FALSE),
	(NULL);
	
insert into B(Q) values
	(TRUE),
	(FALSE),
	(NULL);
	
insert into C(R) values
	(TRUE),
	(FALSE),
	(NULL);
	

select a.p,b.q, c.r, (not (
	not A.p 
	or
	B.q
	)
		or
		C.r
	   )

	from A,B,C;


--Q5)
--a)
--a1）
select EXISTS(SELECT  A.x
                  FROM    A
                  intersect
				  SELECT  B.x
                  FROM    B
				  ) as answer; 
--a2）
select EXISTS(SELECT  A.x
                  FROM    A
                  where A.x in
				  (SELECT  B.x
                  FROM    B)
				  ) as answer; 


--b)
--b1)
select not EXISTS(SELECT  A.x
                  FROM    A
                  except
				  SELECT  B.x
                  FROM    B
				  ) as answer; 
--b2)
select not EXISTS(SELECT  A.x
                  FROM    A
                  where A.x not in
				  (SELECT  B.x
                  FROM    B
				  )) as answer;



--c)
--c1）
select not EXISTS(SELECT  B.x
                  FROM    B
                  except
				  SELECT  A.x
                  FROM    A
				  ) as answer; 
--c2）
select not EXISTS(SELECT  B.x
                  FROM    B
                  where B.x not in
				  (SELECT  A.x
                  FROM    A
				   )
				  ) as answer;

--d)
--d1）
select EXISTS(SELECT  A.x
                  FROM    A
                  except
				  SELECT  B.x
                  FROM    B
				  )
union
select EXISTS(SELECT  B.x
                  FROM    B
                  except
				  SELECT  A.x
                  FROM    A
				  )
; 

--d2）
select EXISTS(SELECT  A.x
                  FROM    A
                  where A.x not in
				  (SELECT  B.x
                  FROM    B
				   )
				  )
				  or
				  EXISTS(SELECT  B.x
                  FROM    B
                  where B.x not in
				  (SELECT  A.x
                  FROM    A
				   )
				  )
				  as answer;

--e)
--e1）
with intersection as
(select A.x
from  A, B
where A.x=B.x)

select not exists ( 
select i1.x
from intersection i1, intersection i2, intersection i3
where i1.x<>i2.x and i2.x<>i3.x and i1.x<>i3.x
)
;
--e2）
select not exists ( 
select A1.x
from A A1,A A2,A A3, B B1,B B2,B B3
where A1.x<>A2.x and A2.x<>A3.x and A1.x<>A3.x
	and A1.x=B1.x and A2.x=B2.x and A3.x=B3.x
	and B1.x<>B2.x and B1.x<>B3.x and B3.x<>B2.x 
)
;


--f)
--f1）
select not EXISTS((SELECT  A.x
                  FROM    A
                  union
				  SELECT  B.x
                  FROM    B)
				  except
				  SELECT  C.x
                  FROM    C
				  ) as answer; 

--f2）
select not EXISTS(SELECT  A.x
                  FROM    A
                  where A.x NOT IN
				 
				  (SELECT  C.x
                  FROM    C)
				  )
OR
not EXISTS(SELECT  B.x
                  FROM    B
                  where B.x NOT IN
				 
				  (SELECT  C.x
                  FROM    C)
				  ) as answer; 

--g)
--g1）
with u as
((select A.x
from A
except
select B.x
from B)
union
(select B.x
from B
except
select C.x
from C) 
)
select exists (
select u.x
from u
) and not exists (
select u1.x
from u u1, u u2
	where u1.x<>u2.x
)
;
--g2）
select 
(
exists (
select A.x
from A
	where A.x not in(
	select B.x
	FROM B)
) or exists (select B.x
from B
	where B.x not in(
	select C.x
	FROM C)
) 
)
and
(
not exists (
select A1.x,A2.x
from A A1, A A2
	where A1.x<>A2.x AND A1.x NOT IN
	(SELECT B.x
	from B)
	and A2.x NOT IN
	(SELECT B.x
	from B)
)
)

and 
(
not
exists (
select B1.x,B2.x
from B B1, B B2
	where B1.x<>B2.x AND B1.x NOT IN
	(SELECT C.x
	from C)
	and B2.x NOT IN
	(SELECT C.x
	from C)
)
)
and
(
not
	 exists (
		 
select distinct A.x, B.x
from A,B,C
	where A.x NOT IN
	(SELECT B1.x
	from B B1)
	and B.x NOT IN
	(SELECT C1.x
	from C C1)
		and A.x<>B.x

)
	
	)

;



--Q6
--use count aggregate to solve Q5
--a)
select exists 
 (
	SELECT COUNT(1)
     FROM (SELECT  A.x
            FROM  A
           INTERSECT
           SELECT B.x
            FROM   B
             ) q)>=1
	;

--b)
select not exists 
 (
	SELECT COUNT(1)
     FROM (SELECT  A.x
            FROM  A
           except
           SELECT B.x
            FROM   B
             ) q)>=1
	;

--c)
select not exists 
 (
	SELECT COUNT(1)
     FROM (SELECT  B.x
            FROM  B
           except
           SELECT A.x
            FROM   A
             ) q)>=1
	;

--d)
select 
not EXISTS
	(select count(1)
	from 
	(
		(SELECT  A.x
           FROM  A
           except
			SELECT  B.x
            FROM    B)
		union
		(SELECT  B.x
           FROM  B
           except
			SELECT  A.x
            FROM    A)
				  ) q 
				 )
				 ≥1;

--e)
select 
not EXISTS
	(select count(1)
	from 
	(
		(SELECT  A.x
           FROM  A
           intersect
			SELECT  B.x
            FROM    B) q 
				 )
				 ≥2;

--f)
select 
not EXISTS
	(select count(1)
	from 
	
		(
			(SELECT  A.x
           FROM  A
           union
			SELECT  B.x
            FROM    B)
		except
		SELECT  C.x
            FROM    C) q 
				 )
				 ≥1;

--g)
select
(
		select count(1)
	from 
		( (SELECT  A.x
           FROM  A
           except
			SELECT  B.x
            FROM    B)
		union
			(SELECT  B.x
           FROM  B
           except
			SELECT  C.x
            FROM    C)) q
				 )
				 = 1
				 ;



--Q7)
create table W(
	A INTEGER,
	B VARCHAR(5)
);

insert into W (A,B)values
	(1,'John'),
	(2,'Ellen'),
	(3,'Ann'),
	(4,'Ann')

;


CREATE VIEW W_view AS
       SELECT W.A, W.B
       FROM   W;



SELECT distinct WV.A
FROM W_view WV, W
where (WV.A=W.A and WV.B<>W.B
and exists (
	SELECT WV.A
	FROM W_view WV, W
	where WV.A=W.A and WV.B<>W.B))
or not exists (
	SELECT WV.A
	FROM W_view WV, W
	where WV.A=W.A and WV.B<>W.B)
;


--Q8)
--a)
--a1)
CREATE FUNCTION booksBoughtbyStudent (studentid INTEGER,OUT BookNo int, OUT title VARCHAR(30),OUT price int)
    RETURNS SETOF RECORD
	AS
    $$
        SELECT BO.BookNo, BO.title, BO.price
		from Book BO, Student S, Buys BU
		where S.Sid=studentid and S.Sid=BU.Sid and BU.BookNo=BO.BookNo
		;
    $$ LANGUAGE SQL;

--a2)
SELECT distinct t.BookNo, t.title,t.price
FROM  booksBoughtbyStudent (1001) t;


SELECT distinct t.BookNo, t.title,t.price
FROM  booksBoughtbyStudent (1015) t;

--a3)
--a3A)
select S.Sid,S.Sname
from Student S
where 
(select count(1)
 from
(SELECT distinct t.BookNo
FROM  booksBoughtbyStudent (S.Sid) t
where t.price<50) q
)=1
;

--a3B)

select distinct S1.Sid,S2.Sid
from Student S1,Student S2
where not exists (select t1.BookNo
			from booksBoughtbyStudent (S1.Sid) t1
			where t1.BookNo not in 
			(select t2.BookNo
			from booksBoughtbyStudent (S2.Sid) t2))
		   and not exists
		   (select t2.BookNo
			from booksBoughtbyStudent (S2.Sid) t2
			where t2.BookNo not in 
			(select t1.BookNo
			from booksBoughtbyStudent (S1.Sid) t1))
and S1.Sid<>S2.Sid
;

--b)
--b1)
CREATE FUNCTION studentsWhoBoughtStudent (bn INTEGER,OUT sid int, OUT sname VARCHAR(15))
    RETURNS SETOF RECORD
	AS
    $$
        SELECT S.Sid, S.Sname
		from Book BO, Student S, Buys BU
		where S.Sid=BU.Sid and BU.BookNo=BO.BookNo and BO.BookNo=bn 
		;
    $$ LANGUAGE SQL;
--b2)
SELECT distinct t.sid, t.sname
FROM  studentsWhoBoughtStudent (2010) t;

--b3)
select distinct BU.BookNo
from Buys BU
where 
(
 select count(1)
 from 
 (select distinct TS.Sid
 from studentsWhoBoughtStudent(BU.BookNo) TS, Major M
where TS.Sid=M.Sid and M.Major='CS' and exists (select BS.BookNo
 from booksBoughtbyStudent (TS.Sid) BS
where BS.price>30)) p)>=2;

--c)
--c1)
select distinct S.Sid, M.Major
from Student S,Major M
where 
S.Sid=M.Sid
and
 (select count(1)
 from
(SELECT distinct t.BookNo
FROM  booksBoughtbyStudent (S.Sid) t
where t.price>30) q
)>=4;

 --c2)

select distinct S1.Sid,S2.Sid
from Student S1,Student S2, booksBoughtbyStudent (S1.Sid) t1, booksBoughtbyStudent (S2.Sid) t2

where (SELECT SUM(t1.price) as sumprice1
FROM  booksBoughtbyStudent (S1.Sid) t1) =
(SELECT SUM(t2.price) as sumprice2
FROM  booksBoughtbyStudent (S2.Sid) t2)
and S1.Sid<>S2.Sid
;

--c3)
select distinct S.Sid, S.Sname
from Student S
where 
(select sum(t1.price)
from booksBoughtbyStudent (S.Sid) t1
)
> (
	select avg(v.l)
	from (SELECT sum(q.t) as l
	from (select p.k, p.t
from (
	select S1.Sid as k,t2.price as t
from Student S1,Major M,booksBoughtbyStudent (S1.Sid) t2
where S1.Sid=M.Sid and M.Major='CS'
) p) q
	GROUP BY(q.k)) v	
)
;

--c4)
select t.bookno, t.title
from (
	select BO.BookNo,BO.title,BO.price,rank() OVER (ORDER BY price desc)
from Book BO
) t
where t.rank=3;

--c5)

select distinct BO.bookno, BO.title
from Book BO
where (select count(1)
from (
select t.sid
from studentsWhoBoughtStudent (BO.bookno) t
except

select M.Sid
from Major M
where M.Major='CS') q
			 
)=0;

--c6)
select distinct S.Sid, S.Sname
from Student S
where exists (select t.BookNo
			  from booksBoughtbyStudent (S.Sid) t
	 where t.BookNo in
(select distinct BU.BookNo
from Buys BU
where (
	select count(1)
from (select t.Sid
from studentsWhoBoughtStudent(BU.BookNo) t,Major M
where t.sid=M.Sid and M.Major='CS') q
)<2));

--c7)
select distinct S1.Sid, t.BookNo
from Student S1,booksBoughtbyStudent (S1.Sid) t
where t.price< all(
select AVG(t1.price)
from booksBoughtbyStudent (S1.Sid) t1
);

--c8)
select distinct S1.Sid, S2.Sid
from Student S1,Student S2, Major M1,Major M2, booksBoughtbyStudent (S1.Sid) t
where S1.Sid<>S2.Sid and M1.Sid=S1.Sid and M2.Sid=S2.Sid and M1.Major=M2.Major and 

(select count(1)
from (select t1.BookNo
from booksBoughtbyStudent (S1.Sid) t1
) p)
=
(select count(1)
from (select t2.BookNo
from booksBoughtbyStudent (S2.Sid) t2
) q)
;

--c9)
select distinct S1.Sid, S2.Sid, (select count(1) from (select t1.BookNo
from booksBoughtbyStudent (S1.Sid) t1
	  except
	  select t2.BookNo
from booksBoughtbyStudent (S2.Sid) t2
) p) as n
from Major M1,Major M2,Student S1,Student S2, booksBoughtbyStudent (S1.Sid) t1,booksBoughtbyStudent (S2.Sid) t2
where S1.Sid<>S2.Sid and S1.Sid=M1.SID AND S2.Sid=M2.SID and M1.Major=M2.Major
;

--c10)
select distinct BU.BookNo
from Buys BU
where 

(select count(1)
from (select TS.Sid
from studentsWhoBoughtStudent(BU.BookNo) TS, Major M
where TS.Sid=M.Sid and M.Major='CS') q)
=
(select count(1)
from (select M.Sid
from Major M
where M.Major='CS') p)-1
;


--Q9)
--data preparation
create table Student(
	Sid INT, 
	Sname text, 
	PRIMARY KEY (Sid)
);

create table Course(
	cno INT, 
	cname text, 
	total int,
	Max int,
	PRIMARY KEY (Cno)
);

create table Prerequisite(
	cno INT, 
	prereq int, 
	FOREIGN KEY (cno) REFERENCES course (cno),
	FOREIGN KEY (cno) REFERENCES course (cno)
);

create table HasTaken(
	Sid INT, 
	cno int, 
	FOREIGN KEY (sid) REFERENCES student (sid),
	FOREIGN KEY (cno) REFERENCES course (cno)
);

create table Enroll(
	Sid INT, 
	cno int, 
	FOREIGN KEY (sid) REFERENCES student (sid),
	FOREIGN KEY (cno) REFERENCES course (cno)
);

create table Waitlist(
	Sid INT, 
	cno int, 
	Position int, 
	FOREIGN KEY (sid) REFERENCES student (sid),
	FOREIGN KEY (cno) REFERENCES course (cno)
);




INSERT INTO Course(cno,cname,total,max)values(201,'Programming',0,3);
INSERT INTO Course(cno,cname,total,max)values(202,'Calculus',0,3);
INSERT INTO Course(cno,cname,total,max)values(203,'Probability',0,3);
INSERT INTO Course(cno,cname,total,max)values(204,'AI',0,2);
INSERT INTO Course(cno,cname,total,max)values(301,'DiscreteMathematics',0,2);
INSERT INTO Course(cno,cname,total,max)values(302,'OS',0,2);
INSERT INTO Course(cno,cname,total,max)values(303,'Databases',0,2);
INSERT INTO Course(cno,cname,total,max)values(401,'DataScience',0,2);
INSERT INTO Course(cno,cname,total,max)values(402,'Networks',0,2);
INSERT INTO Course(cno,cname,total,max)values(403,'Philosophy',0,2);


INSERT INTO Prerequisite(cno,prereq)values(301,201);
INSERT INTO Prerequisite(cno,prereq)values(301,202);
INSERT INTO Prerequisite(cno,prereq)values(302,201);
INSERT INTO Prerequisite(cno,prereq)values(302,202);
INSERT INTO Prerequisite(cno,prereq)values(302,203);
INSERT INTO Prerequisite(cno,prereq)values(401,301);
INSERT INTO Prerequisite(cno,prereq)values(401,204);
INSERT INTO Prerequisite(cno,prereq)values(402,302);

INSERT INTO Student(sid,sname)values(1,'Jean');
INSERT INTO Student(sid,sname)values(2,'Eric');
INSERT INTO Student(sid,sname)values(3,'Ahmed');
INSERT INTO Student(sid,sname)values(4,'Qin');
INSERT INTO Student(sid,sname)values(5,'Filip');
INSERT INTO Student(sid,sname)values(6,'Pam');
INSERT INTO Student(sid,sname)values(7,'Lisa');

INSERT INTO Hastaken(sid,cno)values(1,201);
INSERT INTO Hastaken(sid,cno)values(1,202);
INSERT INTO Hastaken(sid,cno)values(1,301);
INSERT INTO Hastaken(sid,cno)values(2,201);
INSERT INTO Hastaken(sid,cno)values(2,202);
INSERT INTO Hastaken(sid,cno)values(3,201);
INSERT INTO Hastaken(sid,cno)values(4,201);
INSERT INTO Hastaken(sid,cno)values(4,202);
INSERT INTO Hastaken(sid,cno)values(4,203);
INSERT INTO Hastaken(sid,cno)values(4,204);
INSERT INTO Hastaken(sid,cno)values(5,201);
INSERT INTO Hastaken(sid,cno)values(5,202);
INSERT INTO Hastaken(sid,cno)values(5,301);
INSERT INTO Hastaken(sid,cno)values(5,204);


--requirement1:the prerequisites requirement
CREATE OR REPLACE FUNCTION check_prerequisites_constraint()
    RETURNS TRIGGER
    LANGUAGE plpgsql
    AS $$
    BEGIN
    IF exists (
		select Prerequisite.prereq
			   from Prerequisite
			   where Prerequisite.prereq not IN (SELECT cno 
											  FROM hastaken 
											  where hastaken.sid=new.sid) 
				and Prerequisite.CNO=new.cno
	) THEN
        RAISE EXCEPTION 'not satisfy prerequisite';
    END IF;
    RETURN NEW;
    END;
    $$;
	
CREATE TRIGGER check_prerequisites_constraint
    BEFORE INSERT ON enroll
    FOR EACH ROW EXECUTE PROCEDURE check_prerequisites_constraint();

--INSERT INTO enroll(sid,cno)values(1,402);  ERROR:  not satisfy prerequisite 

--the increment of total enrollment
CREATE FUNCTION increment_the_enrollcourse_number()
    RETURNS TRIGGER
    AS $$
    BEGIN
    UPDATE course SET total = total + 1
	where course.CNO=NEW.cno;
    RETURN NEW;
    END;
    $$ LANGUAGE 'plpgsql';

CREATE TRIGGER increment_the_enrollcourse
    AFTER INSERT ON enroll
    FOR EACH ROW EXECUTE PROCEDURE increment_the_enrollcourse_number();

--INSERT INTO enroll(sid,cno)values(4,302);  total of 302 will become 1   

--constraint 2: the maximum constraint


CREATE OR REPLACE FUNCTION check_maximun_constraint()
    RETURNS TRIGGER
    AS $$
    BEGIN
		IF ( select exists (select course.total 
					   		  from course 
					   		 where course.total <= course.max and course.CNO=new.cno) ) THEN
	    	INSERT INTO Waitlist(Sid,cno,position) VALUES (NEW.sid, NEW.cno, count_the_waitlist (new.cno)); 
	    END IF;
	    RETURN NEW;
    END;
    $$ LANGUAGE 'plpgsql';


CREATE FUNCTION count_the_waitlist (corsno INT)
    RETURNS int AS
    $$
        select CAST (p.cont+1 AS int)
		from (select count(1) as cont
		from waitlist
		where waitlist.cno=corsno) p
    $$ LANGUAGE SQL;



CREATE TRIGGER check_maximun_no_constraint
    BEFORE INSERT ON enroll
    FOR EACH ROW EXECUTE PROCEDURE check_maximun_constraint();
--when the insertion to the enrollment exceed the maximun, it will show:ERROR:  exceed the maximun


--requirments3: drop course and the waitlist get enrolled
CREATE OR REPLACE FUNCTION drop_a_course()
RETURNS TRIGGER
    AS $$
    BEGIN
    	--when there are students on the waitlist
		IF exists (select waitlist.sid
				   from waitlist 
				   where waitlist.position>=1 and waitlist.CNO=old.cno)
		THEN
    	INSERT INTO enroll VALUES(sid_of_waitlist (old.cno), waitlist.cno);
		--no one on the waitlist
		elsif not exists (select waitlist.sid
				   from waitlist 
				   where waitlist.position>=1 and waitlist.CNO=old.cno)
		THEN
    	UPDATE course 
        SET total = total-1
		where course.cno=old.cno;
		END IF;
    END;
	$$ LANGUAGE 'plpgsql';


CREATE FUNCTION sid_of_waitlist (corsno INT)
    RETURNS int AS
    $$
        select sid
		from waitlist
		where waitlist.position=1 and waitlist.cno=corsno
    $$ LANGUAGE SQL;


CREATE TRIGGER drop_course
       AFTER DELETE ON enroll
	   FOR EACH ROW
       EXECUTE PROCEDURE drop_a_course();




--requirements 4:drop waitlist by himself and adjust on the waitlist
	   
CREATE OR REPLACE FUNCTION remove_from_waitlist_byhimself()
	RETURNS TRIGGER
    AS $$
    BEGIN
		IF ( select exists (select waitlist.position 
				   			  from waitlist 
				   			 where waitlist.position > old.position and course.CNO=old.cno)) THEN
    		UPDATE Waitlist SET position = position - 1 
    	where (waitlist.position > old.position and course.cno=old.cno);END IF;
		RETURN OLD;
    END;
	$$ LANGUAGE 'plpgsql';



CREATE TRIGGER selfremove_from_waitlist
       AFTER DELETE ON waitlist
	   FOR EACH ROW
       EXECUTE PROCEDURE remove_from_waitlist_byhimself();



\c postgres;

drop database jw_l;



