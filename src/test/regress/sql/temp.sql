--
-- TEMP
-- Test temp relations and indexes
--

-- test temp table/index masking

CREATE TABLE temptest(col int);

CREATE INDEX i_temptest ON temptest(col);

CREATE TEMP TABLE temptest(col int);

CREATE INDEX i_temptest ON temptest(col);

DROP INDEX i_temptest;

DROP TABLE temptest;

DROP INDEX i_temptest;

DROP TABLE temptest;

-- test temp table selects

CREATE TABLE temptest(col int);

INSERT INTO temptest VALUES (1);

CREATE TEMP TABLE temptest(col int);

INSERT INTO temptest VALUES (2);

SELECT * FROM temptest;

DROP TABLE temptest;

SELECT * FROM temptest;

DROP TABLE temptest;

CREATE TEMP TABLE temptest(col int);

-- test temp table deletion

\c regression
SET autocommit TO 'on';

SELECT * FROM temptest;

-- Test manipulation of temp schema's placement in search path

create table public.whereami (f1 text);
insert into public.whereami values ('public');

create temp table whereami (f1 text);
insert into whereami values ('temp');

create function public.whoami() returns text
  as 'select ''public''::text' language sql;

create function pg_temp.whoami() returns text
  as 'select ''temp''::text' language sql;

-- default should have pg_temp implicitly first, but only for tables
select * from whereami;
select whoami();

-- can list temp first explicitly, but it still doesn't affect functions
set search_path = pg_temp, public;
select * from whereami;
select whoami();

-- or put it last for security
set search_path = public, pg_temp;
select * from whereami;
select whoami();

-- you can invoke a temp function explicitly, though
select pg_temp.whoami();

drop table public.whereami;
