--1
create or replace function new_pool()
 returns table(ara int[]) as
$$
begin
 return query
 select array_append(s.ara, A.x) as ara
 from supersets s, A where A.x<>all(s.arr)
 except
 (select ara from supersets);
end;
$$ language plpgsql;


create or replace function Pool(value int[])
 returns void as
$$
begin
 drop table if exists supersets;
 create table supersets(ara int[]);

 insert into supersets values (value);

 while exists(select * from new_pool())
 loop
  insert into supersets select np.ara from new_pool() np;
end loop;
end;
$$ language plpgsql;


create or replace function superSetsOfSet(X int[])
 returns table(ara int[]) as 
$$
begin
 perform Pool(X);
 return query select distinct array_sort(s.ara) from supersets s;
end; 
$$ language plpgsql;


--2
--hw8.2.a
create or replace function connectedbyevenlengthpath()
returns table (source int,target int) as
$$
WITH RECURSIVE connected(source,target,distance) AS
(SELECT source, target, 1
FROM Graph
UNION all
SELECT connected.source, Graph.target,connected.distance+1 as distance FROM connected
INNER JOIN Graph ON (connected.target = Graph.source))
SELECT source, target
FROM connected
where ((connected.distance) % 2) = 0
union
select source, source as target
FROM graph
union
select target, target as target
FROM graph;
$$ language sql;
select * from connectedbyevenlengthpath();
--hw8.2.b
create or replace function connectedbyoddlengthpath()
returns table (source int,target int) as
$$
WITH RECURSIVE connected(source,target,distance) AS
(SELECT source, target, 1
FROM Graph
UNION all
SELECT connected.source, Graph.target,connected.distance+1 as distance FROM connected
INNER JOIN Graph ON (connected.target = Graph.source))
SELECT source, target
FROM connected
where ((connected.distance) % 2) = 1;
$$ language sql;
select * from connectedbyoddlengthpath();

--3
create or replace function n_node()
 returns table(node int) as
$$
begin
 delete from Graph G 
  where G.source in 
  (select T.node 
    from Topo_perfom T);
 return query
 select distinct g.source as node 
 from Graph g 
 where g.source not in 
 (select g2.target from graph g2);
end;
$$ language plpgsql;


create or replace function TP_main()
 returns void as
$$
declare
 i int; b int; t int;
 bs int[];
 ts int[];

begin
 drop table if exists Topo_perfom;
 create table Topo_perfom(ind int, node int);

 if exists(select * from Topo_perfom) then
  select into i MAX(tp.ind)+1 from Topo_perfom tp;
 else 
 i := 1;
 end if;

 ts := array(select distinct g.target as node 
  from Graph g 
  where g.target not in (select g2.source 
  from Graph g2));
 
 bs := array(select distinct g.source as node 
  from Graph g 
  where g.source not in 
  (select g2.target 
    from Graph g2));
 foreach b in array bs
 loop
  insert into Topo_perfom values(i, b);
  i := i+1;
 end loop;

 while exists(select node from n_node())
 loop
  bs := array(select * from n_node());
  foreach b in array bs
  loop
   if (b <> all(select node from Topo_perfom)) then
    insert into Topo_perfom values(i, b);
    i := i+1;
   end if;
  end loop;
 end loop;

 foreach t in array ts
 loop
  insert into Topo values(i, t);
  i := i+1;
 end loop;

end;
$$ language plpgsql;

create or replace function topologicalSort()
 returns table(ind int, node int) as
$$
begin
 perform TP_main();
 return query
  select * from Topo_perfom;
end;
$$ language plpgsql;

--4
--5
--6
select * from documents;
CREATE FUNCTION powerset(a anyarray) RETURNS SETOF anyarray AS $$
DECLARE
    retval  a%TYPE;
    alower  integer := array_lower(a, 1);
    aupper  integer := array_upper(a, 1);
    j       integer;
    k       integer;
BEGIN
    FOR i IN 0 .. (1 << (aupper - alower + 1)) - 1 LOOP
        retval := '{}';
        j := alower;
        k := i;
        WHILE k > 0 LOOP
            IF k & 1 = 1 THEN
                retval := array_append(retval, a[j]);
            END IF;
            j := j + 1;
            k := k >> 1;
        END LOOP;
        RETURN NEXT retval;
    END LOOP;
    RETURN;
END;
$$ LANGUAGE plpgsql IMMUTABLE STRICT; 


create or replace view docpower as
select d.doc,powerset(d.words) as words from documents d;
create or replace function frequentSets(t int)
returns table(words text[]) as
$$
select distinct dp.words
from docpower dp
where (select count(1)
    from docpower dp1
    where dp1.words=dp.words)>t
except
select ('{}');
$$ language sql;
select * from frequentSets(2);

--7
CREATE OR REPLACE FUNCTION Cluster_updation()
RETURNS VOID AS
$$
BEGIN
  TRUNCATE TABLE centroids;
  INSERT INTO centroids 
  SELECT uc.clusters, AVG(x) AS x, AVG(y) AS y 
  FROM dataSet ds INNER JOIN updatedCluster uc ON ds.p = uc.points 
  GROUP BY uc.clusters;
END;
$$ LANGUAGE PLPGSQL;


create or replace function kMeans(k integer)
 returns void as 
$$
DECLARE 
  distance float;
  c integer;
  track integer := 0;
  centroid RECORD;
  Dist RECORD;
  minimumdist RECORD;
  clustertrack RECORD;
BEGIN 
  DROP TABLE IF EXISTS centroids;
  DROP TABLE IF EXISTS distances;
  DROP TABLE IF EXISTS updatedCluster;
  DROP TABLE IF EXISTS prior_Cluster;
  CREATE TABLE centroids(points integer, x float, y float);
  CREATE TABLE distances(points integer, clusters float, distances float);
  CREATE TABLE updatedCluster(points integer, clusters float);
  CREATE TABLE previousClusters(points integer, clusters float);
  INSERT INTO previousClusters SELECT pid, NULL FROM dataSet;
  c := 1;
  FOR centroid IN SELECT pid, x, y FROM dataSet ORDER BY RANDOM() LIMIT k
  LOOP
    INSERT INTO centroids VALUES(c, centroid.x, centroid.y);
    c := c + 1;
  END LOOP;
  WHILE EXISTS(SELECT * FROM previousClusters except SELECT * FROM updatedCluster)
  LOOP
    track := track + 1;
    FOR Dist IN SELECT * FROM dataset
    LOOP
      FOR centroid IN SELECT points, x, y FROM centroids
      LOOP
        distance := sqrt(POWER(Dist.x - centroid.x,2) + power(Dist.y - centroid.y, 2));
        INSERT INTO distances VALUES(Dist.pid, centroid.points, distance);
      END LOOP;
    END LOOP;
    TRUNCATE TABLE updatedCluster;
    FOR minimumdist IN SELECT points FROM distances
    LOOP
      SELECT d.points, d.clusters INTO clustertrack 
      FROM distances d 
      WHERE d.points = minimumdist.points AND 
      d.distances = (SELECT MIN(d1.distances) FROM Distances d1 WHERE d1.points = d.points);
      IF NOT EXISTS(SELECT points, clusters 
        FROM updatedCluster 
        WHERE points = clustertrack.points AND clusters = clustertrack.clusters) THEN
        INSERT INTO updatedCluster VALUES(clustertrack.points, clustertrack.clusters);
      END IF;
    END LOOP;
    PERFORM Cluster_updation();
    TRUNCATE TABLE distances;
    TRUNCATE TABLE previousClusters;
    INSERT INTO previousClusters SELECT points, clusters FROM updatedCluster;
  END LOOP;
END;
$$ language plpgsql;


--hw8.8
create or replace function aggregatedWeight(p integer)
returns integer as
$$
begin
  IF exists (select pa.pid
    from parts pa
    where pa.pid=p) then
    return (select pa.weight
        from parts pa
         where pa.pid=p);
  else
    return
    
    (WITH RECURSIVE included_parts(pid, sid, quantity) AS (
      SELECT ps.pid, ps.sid, ps.quantity
    FROM partSubPart ps
      UNION ALL
      SELECT pr.pid, ps1.sid, pr.quantity*ps1.quantity
      FROM included_parts pr, partSubPart ps1
      WHERE ps.pid = pr.sid
      )
    
    SELECT sum(pr.quantity*pa.weight)
    FROM included_parts pr, parts pa
    where pr.sid in (select pa.pid from parts pa)
    GROUP BY pid);
  end if;
end;
$$ language plpgsql;

--hw8.9
CREATE TABLE graph
(
  source integer,
  target integer,
  weight integer
);
INSERT INTO graph VALUES 
(0, 1, 2), 
(1, 0, 2), 
(0, 4, 10), 
(4, 0, 10), 
(1, 3, 3), 
(3, 1, 3), 
(1, 4, 7), 
(4, 1, 7), 
(2, 3, 4), 
(3, 2, 4), 
(3, 4, 5), 
(4, 3, 5), 
(4, 2, 6),
(2, 4, 6);


drop table if exists node;
select source as node_number into node from graph g
union
select target as node_number from graph g;
select * from node;

CREATE OR REPLACE FUNCTION dijkstra_main(s int, t int)
  RETURNS int AS
$$
DECLARE
    tupnumber int;
    temp_place int;
    try_place int;
BEGIN
    drop table if exists tpo_node;
    --store the try node in a table
    CREATE TABLE tpo_node-
    (
        node_number int PRIMARY KEY,   
        tmp_path int NOT NULL,--tempo distance to the node
        last_node int,
        checker boolean NOT NULL --checker for if we finish this node
    );

    --populate the tempo table with initia
    INSERT INTO tpo_node (node_number, tmp_path, last_node, checker) SELECT node.node_number, 999999999, NULL, FALSE FROM node;
    
    --set tempo path dist to be 0
    UPDATE tpo_node SET tmp_path = 0 WHERE tpo_node.node_number = s;
    GET DIAGNOSTICS tupnumber = TUP_NUMBER;
    IF tupnumber <> 1 THEN DROP TABLE tpo_node; RETURN -1;
    END IF;

    LOOP
        temp_place := NULL;
        SELECT tpo_node.node_number, tmp_path INTO temp_place, try_place 
        FROM tpo_node WHERE checker = FALSE AND tmp_path < 999999999 ORDER BY tmp_path LIMIT 1;
        IF temp_place IS NULL OR temp_place = t THEN EXIT; 
        END IF;
        UPDATE tpo_node SET checker = TRUE WHERE tpo_node.node_number = temp_place;
          UPDATE tpo_node tn SET tmp_path = try_place + weight, last_node = temp_place FROM graph g
            WHERE g.source = temp_place AND tn.checker = FALSE AND tn.node_number = g.target  AND (try_place + g.weight) < tn.tmp_path;
    END LOOP;
      SELECT tmp_path INTO try_place 
      FROM tpo_node 
      WHERE node_number = t;
    RETURN try_place;
END;
$$
language plpgsql;
 
CREATE OR REPLACE FUNCTION Dijkstra(s int)
  RETURNS table(t int, Distances int) AS
$$
declare k integer; finaldist integer; 
  begin
      drop table if exists p;
    CREATE TABLE p(target int,distance int);
  for k in (select node_number from node)
  loop
    select * into finaldist from dijkstra_main(s, k);
      insert into p values(k, finaldist);
  end loop;
  return query
   select p.t, p.distance from p
    order by p.t;
  end;
$$
language plpgsql;
select * from Dijkstra(0);



--hw8.10
--a
--replicate the column A (a1,a1)
CREATE OR REPLACE FUNCTION mapper(A int, B int)
RETURNS TABLE (A1 int, A2 int) AS
$$
SELECT A as A1, A as A2;
$$ LANGUAGE SQL;
       
CREATE OR REPLACE FUNCTION reducer(A1 int, A2_array int[])
RETURNS TABLE(A1 int, A2 int) AS
$$
SELECT A1, p.A_prime
FROM unnest(select A2_array as A_prime) p;
$$ LANGUAGE SQL;

        
WITH
--mapper phase
map_output AS
(SELECT q.A1, q.A2
FROM R, LATERAL(SELECT p.A1, p.A2
FROM mapper(R.A,R.B) p) q),
--group phase
--get the int-array pairs a1-{a1,a1}
group_output AS
(SELECT p.A1, array_agg(p.A2) as A2_array
FROM map_output p
GROUP BY (p.A1),
--reducer phase
--project out (a1,a1)
reduce_output AS
(SELECT t.A, t.A_prime
FROM group_output r, LATERAL(SELECT s.A1 as A, s.A_prime
FROM reducer(r.A1, r.A2_array) s) t)
--output
SELECT A
FROM reduce_output;

--B
CREATE OR REPLACE FUNCTION mapper(A1 int, B1 int,A0 int, B0 int)
RETURNS TABLE (A int, B int,lable int) AS
$$
SELECT A1 as A, B1, 1 as lable--1 for r
union
SELECT A0 as A, B0, 0 as lable--o for s
;
$$ LANGUAGE SQL;
       
CREATE OR REPLACE FUNCTION reducer(A3 int,lable_array int[])
RETURNS TABLE(A int) AS
$$
begin
--project if it has 'R' and not has 'S'
  if exists(select lable_array
       where 0<@lable_array) 
 and not exists(select lable_array
       where 1<@lable_array) then
  select A3 as A;
  end if;
end;
$$ LANGUAGE SQL;


WITH
--mapper phase
map_output AS
(SELECT q.A, q.B,q.lable
FROM R,S, LATERAL(SELECT p.A, p.B,p.lable
FROM mapper(R.A,R.B,S.A,S.B) p) q),
--group phase

group_output AS
(SELECT p.A, array_agg(p.lable) as lable_array
FROM map_output p
GROUP BY (p.A),
--reducer phase

reduce_output AS
(SELECT t.A
FROM group_output r, LATERAL(SELECT s.A
FROM reducer(r.A, r.lable_array) s) t)
--output
SELECT A
FROM reduce_output;


--c
CREATE TYPE fooType AS(lable text,rest int);
--map
CREATE OR REPLACE FUNCTION mapper(A int,lable text,B int)
RETURNS TABLE(A int, value fooType) AS
$$
BEGIN
  RETURN QUERY
  SELECT A,(lable,B)::fooType as value;
END;
$$ LANGUAGE plpgsql;
--reduce
CREATE OR REPLACE FUNCTION reducer(A int,value_ft fooType[])
RETURNS TABLE(A int, B int, C int) AS
$$
BEGIN
  RETURN QUERY
   WITH 
    R AS (select rest from unnest(value_ft) where lable='R'),
    S AS (select rest from unnest(value_ft) where lable='S')
    select R.rest,k,S.rest FROM R CROSS JOIN S 
    WHERE EXISTS(SELECT * FROM R)
    AND EXISTS(SELECT * FROM S);
END;
$$ LANGUAGE plpgsql;

WITH
--mapper phase
map_output AS
(SELECT q.A, q.value
FROM R,LATERAL(SELECT p.A, p.value
FROM mapper(R.B,'R',R.A) p) q
union
SELECT q.A, q.value
FROM R,LATERAL(SELECT p.A, p.value
FROM mapper(S.B,'S',S.C) p) q),
--group phase

group_output AS
(SELECT p.A, array_agg(p.value) as value_ft
FROM map_output p
GROUP BY (p.A),
--reducer phase

reduce_output AS
(SELECT t.A,t.B,t.C
FROM group_output r, LATERAL(SELECT s.A
FROM reducer(r.A, r.value_ft) s) t)
--output
SELECT *
FROM reduce_output;




