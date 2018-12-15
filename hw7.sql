--1a
create or replace function setintersection(A anyarray, B anyarray)
returns anyarray as
$$ select ARRAY(select unnest(A)
intersect
select unnest(B));
$$ language sql;
--1b
create or replace function setdifference(A anyarray, B anyarray)
returns anyarray as
$$ select ARRAY(select unnest(A)
except
select unnest(B));
$$ language sql;

create or replace function memberof(x anyelement, A anyarray)
returns boolean as
$$
select x = SOME(A);
$$ language sql;

--2
create or replace view student_books as
select s.sid as sid, array(select t.bookno
from buys t
where t.sid = s.sid
order by bookno) as books
from student s
order by sid;
select *
from student_books;
--2a
create or replace view book_students as
select b.bookno as bookno,setunion(array(select t.sid
from buys t
where t.bookno = b.bookno
order by bookno),ARRAY[]::int[]) as students
from book b
order by bookno;
select *
from book_students;
--2b
create or replace view book_citedbooks as
select b.bookno,setunion(array(select c.citedbookno
from cites c
where c.bookno = b.bookno
order by bookno),ARRAY[]::int[]) as citedbooks
from book b
order by bookno;
select *
from book_citedbooks;
--2c
create or replace view book_citingbooks as
select b.bookno,setunion(array(select c.bookno
from cites c
where c.citedbookno = b.bookno
order by bookno),ARRAY[]::int[]) as citingbooks
from book b
order by bookno;
select *
from book_citingbooks;
--2d
create or replace view major_students as
select distinct m.major,array(select m1.sid
from major m1
where m1.major = m.major
order by sid) as students
from major m
order by major;
select *
from major_students;
--2e
create or replace view student_majors as
select s.sid,setunion(array(select m.major
from major m
where m.sid = s.sid
order by sid),ARRAY[]::VARCHAR[]) as majors
from student s
order by sid;
select *
from student_majors;
--3a
select sb.sid
from student_books sb
where cardinality(sb.books)=2;

--3b
select sb.sid
from student_books sb
where cardinality(setdifference((select sb.books
				 					from student_books sb
				 where sb.sid=1001), sb.books))=0;	

--3c
create or replace view book_less_than_30 as
select ARRAY(select b.bookno
from book b
where b.price<=30) as bookno;								 
select bc.bookno
from book_citedbooks bc,book_less_than_30
where cardinality(setdifference(bc.citedbooks,book_less_than_30.bookno))<2;
--3d
create or replace view t1(bookno,sid) as
SELECT bs.bookno,bs.students as sid
FROM book_students bs;

create or replace view t2(sid) as
select setintersection((select ms.students
from major_students ms
where ms.major='CS'),
(select ms.students
from major_students ms
where ms.major='Math')) as sid;

select distinct t1.bookno,b.title
from t1,t2,book b
 where cardinality(setdifference(t1.sid,t2.sid))>0 and b.bookno=t1.bookno;
--3e
create or replace view e1 as
select array(
select b.bookno
from book b
where b.price<50) as bookno;
create or replace view e2 as
select array(
select bcting.bookno
from book_citingbooks bcting,e1
where cardinality(setintersection(bcting.citingbooks,e1.bookno))>=2) as bookno;
select sb.sid,unnest(setintersection(sb.books,e2.bookno))
from student_books sb,e2
where cardinality(setintersection(sb.books,e2.bookno))>=1;
--3f
select array(
select s.sid
from student s
where memberof(s.sid, (select setintersection((select ms.students
from major_students ms
where ms.major='CS'),
(select ms.students
from major_students ms
where ms.major='Math')) as sid))
 ) as students;

--3g
create or replace view g1(books) as
select sb.books
from student_books sb
where sb.sid=1001;
select sm.sid,sm.majors
from student_majors sm,student_books sb,g1
where sm.sid=sb.sid and cardinality(setintersection(sb.books,g1.books))=0;

--3h
select array( 
select distinct p.*
from(
select unnest (sb.books)
from student_books sb,major_students ms
where sb.sid=some(ms.students) and ms.major='CS') p) as books;

--3i
select array(
select distinct p.*
from	(select unnest (bs.students)
from book_students bs,book_citedbooks bc
where bs.bookno=bc.bookno and cardinality(bc.citedbooks)>=2) p
	);

--3j
create or replace view j1 as
select ms.students
from major_students ms
where ms.major='CS';
select bs.bookno as b,setintersection(bs.students,j1.students)
from book_students bs,j1;

--3k
create or replace view k1 as
select array(
select unnest(sb.books) as bookno
from major_students ms,student_books sb
where ms.major='Math' and sb.sid=some(ms.students)) as bookno;

create or replace view k2 as
select array(
select unnest (bs.students)
from k1,book_students bs
where memberof(bs.bookno,k1.bookno)) as students;

select setdifference(ms.students,k2.students)
from major_students ms,k2
where ms.major='CS';

--3l
select bs1.bookno,bs2.bookno
from book_students bs1,book_students bs2
where bs1.bookno<>bs2.bookno 
and cardinality(setdifference(bs1.students,bs2.students))=0
and cardinality(setdifference(bs2.students,bs1.students))=0;

--3m
create or replace view m1 as
select ms.students
from major_students ms
where ms.major='Math';
create or replace view m2 as
select ms.students
from major_students ms
where ms.major='CS';
									  
select bs1.bookno,bs2.bookno
from book_students bs1,book_students bs2,m1,m2
where cardinality(setintersection(bs1.students,m1.students))<cardinality(setintersection(bs2.students,m2.students))
and bs1.bookno<>bs2.bookno;

--3n
create or replace view n1 as
select array(
select b.bookno
from book b where b.price>50) as bookno;
select sb.sid							 
from student_books sb,n1																					 
where cardinality(setdifference(n1.bookno,sb.books))=1;	











