SELECT * FROM users;
-- List of Databases
SELECT datname FROM pg_database;
SELECT datname
FROM pg_database
WHERE datistemplate = false;
SELECT * from prac;
create database ABC;
use 'abc';
SELECT datname FROM pg_database;
SELECT prac;
create table if not exists users (user_id identity primary key not null, name varchar not null);
SELECT table_name FROM information_schema.tables WHERE table_schema='public';
SELECT current_user;
drop table users;
create table if not exists users (user_id identity primary key not null, name varchar not null);
create table if not exists users (user_id uuid primary key not null, name varchar not null, age integer, verified boolean not null);
SELECT name from users;
insert into users values ('acde070d-8c4c-4f0d-9d8a-162843c10333', 'ND', 20, true);
insert into users values ('acde070d-8c4c-4f0d-9d8a-162843c10334', 'HD', 33, false);
insert into users values ('acde070d-8c4c-4f0d-9d8a-162843c10335', 'HHD', 40, true);
insert into users values ('acde070d-8c4c-4f0d-9d8a-162843c10336', 'AMD', 80, false);
insert into users values ('acde070d-8c4c-4f0d-9d8a-162843c10337', 'IDD', 54, true);
insert into users values ('acde070d-8c4c-4f0d-9d8a-162843c10338', 'D', 67, true);
insert into users(user_id, name, verified) values ('acde070d-8c4c-4f0d-9d8a-162843c10339', 'D', true);
SELECT * FROM users WHERE verified=true;
SELECT * FROM users WHERE age>18;
SELECT * FROM users order by age desc;
SELECT 1, 2;
-- AS: To rename the column or property name
SELECT name, age, age+10 AS addition_value FROM users;
-- To filter out the similar result or get the unique results
SELECT distinct verified from users;
-- Exercise
SELECT name, age, age*1.1 AS "New Age" FROM users;
-- and & not operator
SELECT * from users where not (age>20 and age<58 and verified=true);
-- in
SELECT * from users WHERE age not in (18, 19, 20);
-- between
SELECT * FROM users WHERE age between 20 and 40;
-- like
SELECT * FROM users WHERE name like 'N_';
SELECT * FROM users WHERE name like '%D'
-- Exercise
SELECT * FROM users WHERE name like '%trail%' or name like '%avenue%'
SELECT * FROM users WHERE age like '%9';
-- regexp
SELECT * FROM users WHERE name ~ '^ND$';
SELECT * FROM users WHERE name ~ '\w*D$';
SELECT * FROM users WHERE name !~ '\w+D$';
-- Exercise
SELECT * FROM users WHERE name ~ 'elka|ambur'
SELECT * FROM users WHERE name ~ 'ey$|on$'
SELECT * FROM users WHERE name ~ '^my|se'
SELECT * FROM users WHERE name ~ 'b[ru]'
-- null
SELECT * FROM users WHERE age=null;
SELECT * FROM users WHERE age is not null;
-- Order by
SELECT * FROM users Order by age;
SELECT * FROM users Order by age desc;
-- 3rd column
SELECT * FROM users Order by 3;
-- Exercise
SELECT * FROM users WHERE verified=true Order by age*10;
-- limit
SELECT * FROM users limit 3;
-- for pagination with 2 offset having 3 limit
SELECT * FROM users limit 3 offset 2;