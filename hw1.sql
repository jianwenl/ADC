
create database <JW_L>;
\c <JW_L>;


/*problem 1*/
create table hw1_sailor(
	Sid INTEGER, 
	Sname VARCHAR(20), 
	Rating INTEGER, 
	Age INTEGER,
	PRIMARY KEY (Sid)
);


create table hw1_boat(
	Bid INTEGER, 
	Bname VARCHAR(15), 
	Color VARCHAR(15),
	PRIMARY KEY (Bid)
);

create table hw1_reserves(
	Sid INTEGER, 
	Bid INTEGER, 
	Day VARCHAR(20),
	FOREIGN KEY (Sid) REFERENCES hw1_sailor(Sid),
	FOREIGN KEY (Bid) REFERENCES hw1_boat(Bid)
);


insert into hw1_boat (Bid,Bname,Color)values
	(101,'Interlake','blue'),
	(102,'Sunset','red'),
	(103,'Clipper','green'),
	(104,'Marine','red');

insert into hw1_sailor (Sid,Sname,Rating,Age)values
	(22,'Dustin',7,45),
	(29,'Brutus',1,33),
	(31,'Lubber',8,55),
	(32,'Andy',8,25),
	(58,'Rusty',10,35),
	(64,'Horatio',9,35),
	(71,'Zorba',10,16),
	(74,'Horatio',9,35),
	(85,'Art',3,25),
	(95,'Bob',3,63);
	
insert into hw1_reserves (Sid,Bid,Day)values
	(22,101,'Monday'),
	(22,102,'Tuesday'),
	(22,103,'Wednesday'),
	(31,102,'Thusrday'),
	(31,103,'Friday'),
	(31,104,'Saturday'),
	(64,101,'Sunday'),
	(64,102,'Monday'),
	(74,102,'Saturday');


/*problem 2*/

/*add into primary key*/
Insert into hw1_sailor (Sid,Sname,Rating,Age) 
values (22,'Allen',2,56);
/*ERROR:  insert or update on table "hw1_sailor" violates primary key constraint*/

/*add into foreign key*/
Insert into hw1_reserves (Sid,Bid,Day) 
values (80,104,'Sunday');
/*ERROR:  insert or update on table "hw1_reserves" violates foreign key constraint */


/*alter table drop foreign key*/
ALTER TABLE hw1_reserves 
DROP CONSTRAINT Sid;

/*alter table drop primary key*/
ALTER TABLE hw1_sailor
DROP CONSTRAINT Sid;

/*insert when no primary key*/
Insert into hw1_reserves (Sid,Bid,Day) 
values (80,'Allen',2,56);

/*no primary key violation*/

/*delete the inserted tuple*/

Delete from hw1_reserves
where Sid=80;

/*alter table add back primary key*/
alter TABLE hw1_sailor
ADD PRIMARY KEY Sid;

/*alter table add back foreign key*/
alter TABLE hw1_reserves
ADD FOREIGN KEY Sid;




/*problem 3*/

/*3.a*/
select S.Rating
from hw1_sailor S;

/*3.b*/

select B.Bid, B.color
from hw1_boat B;

/*3.c*/
select S.Sname
from hw1_sailor S
where S.Age>=15 and S.Age<=30;

/*3.d*/
select B.Bname
from hw1_boat B,hw1_reserves R
where B.Bid=R.Bid and (R.Day='Saturday'or R.Day='Sunday'); 

/*3.e*/
select distinct S1.Sname
from hw1_sailor S1,hw1_boat B1,hw1_reserves R1
where S1.Sid = R1.Sid and B1.Color ='red' and B1.Bid=R1.Bid
intersect
select distinct S2.Sname
from hw1_sailor S2,hw1_boat B2,hw1_reserves R2
where S2.Sid = R2.Sid and B2.Color ='green'and B2.Bid=R2.Bid;

/*3.f */
select distinct s.sname
from
(
select distinct S1.sid, s1.sname
from hw1_sailor S1,hw1_boat B1,hw1_reserves R1
where S1.Sid = R1.Sid and R1.Bid=B1.Bid and B1.Color='red'

EXCEPT

select distinct S2.sid, s2.sname
from hw1_sailor S2,hw1_boat B2,hw1_reserves R2
where S2.Sid = R2.Sid And R2.Bid=B2.Bid and (B2.Color='green'
	 or B2.Color='blue' )
) s;


/*3.g*/
select distinct S.Sname
from hw1_sailor S,hw1_boat B,hw1_reserves R1,hw1_reserves R2
where S.Sid = R1.Sid and R1.Sid=R2.Sid and R1.Bid <> R2.Bid;

/*3.h*/
select S.Sid
from hw1_sailor S,hw1_reserves R
where S.Sid <> R.Sid
EXCEPT
select S1.Sid
from hw1_sailor S1,hw1_sailor S2,hw1_reserves R
where S1.Sid = R.Sid and S1.Sid = S2.Sid;

/*3.i*/
select S1.Sid,S2.Sid
from hw1_sailor S1,hw1_sailor S2,hw1_reserves R
where S1.Sid <> S2.Sid and S1.Sid = R.Sid and R.Day='Saturday';

/*3.j */
select B.Bid
from hw1_sailor S,hw1_boat B,hw1_reserves R1,hw1_reserves R2
where B.Bid = R1.Bid
EXCEPT
select B.Bid
from hw1_sailor S,hw1_boat B,hw1_reserves R1,hw1_reserves R2
where R1.Sid <> R2.Sid and R1.Bid = R2.Bid and B.Bid = R1.Bid;



\c postgres;

drop database <JW_L>;








