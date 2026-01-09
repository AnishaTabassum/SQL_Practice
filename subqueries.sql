
/* =========================================================
   SQL SUBQUERIES PRACTICE FILE
   Covers: Scalar, Row, Table & Correlated Subqueries
   ========================================================= */


/* ---------------------------------------------------------
   INDEPENDENT SUBQUERY → SCALAR SUBQUERY
   (returns a single value)
   --------------------------------------------------------- */

-- find the movies with highest profit
select * from movies
where (gross-budget) = (select max(gross-budget) from movies);

-- alternative approach
select * from movies
order by (gross-budget) desc limit 1;


-- find how many movie has rating greater than the average rating of all movies
select * from movies
where score>(select avg(score) from movies);


-- find the highest rated movie
select * from movies
where score=(select max(score) from movies);


-- find the highest rated movie among all the movies
-- where number of votes are greater than the average vote
select * from movies 
where score=(select max(score) from movies 
			where score>(select avg(score) from movies));



/* ---------------------------------------------------------
   INDEPENDENT SUBQUERY → ROW SUBQUERY
   (one column, multiple rows)
   --------------------------------------------------------- */

-- find all the users who never order
select user_id from zomato.users_food 
where user_id not in (
    select distinct(user_id) from zomato.orders_food
);


-- find all the movies made by top 3 directors
-- (in terms of total gross income)
with top_directors as (
    select director from movies 
	group by director 
	order by sum(gross) desc limit 3
)
select * from movies 
where director in (select * from top_directors);


-- find all movies of all those actors
-- whose filmography's average rating is greater than 8.5
-- (take 25000 votes as cutoff)
select * from movies 
where star in (
    select star from movies 
    where votes >25000
	group by star
	having avg(score)>8.5
);



/* ---------------------------------------------------------
   INDEPENDENT SUBQUERY → TABLE SUBQUERY
   (multiple columns, multiple rows)
   --------------------------------------------------------- */

-- find the highest rated movies of each genre
-- votes cutoff 25000
select * from movies_data 
where (genre,score) in (
    select genre,max(score) from movies_data
	where votes>25000
	group by genre
);


-- find the most profitable movies of each year
select * from movies_data
where (year,gross-budget) in (
    select year,max(gross-budget) from movies_data 
	group by year
);


-- find the highest grossing movies of top 5
-- actor and director combo in terms of total gross income
with actor_director_combo as (
    select star,director,max(gross) from movies_data
	group by star,director
	order by max(gross) desc limit 5
)
select * from movies_data 
where (star,director,gross) in (
    select * from actor_director_combo
);



/* ---------------------------------------------------------
   CORRELATED SUBQUERY
   --------------------------------------------------------- */

-- find all the movies that have a rating higher
-- than the average rating of movies in the same genre
select * from movies_data m1
where score>(
    select avg(score) from movies_data m2 
	where m2.genre=m1.genre
);


-- find the favorite food of each customer
use zomato;

with fav_food as (
    select t2.user_id,
           t1.name,
           t3.f_id,
           t4.f_name,
           count(*) as 'frequency'
    from users_food t1
    join orders_food t2 on t1.user_id=t2.user_id
    join order_details_food t3 on t2.order_id=t3.order_id
    join food t4 on t3.f_id=t4.f_id
    group by t2.user_id,t1.name,t3.f_id,t4.f_name
)
select * from fav_food f1
where frequency =(
    select max(frequency) from fav_food f2
	where f2.user_id=f1.user_id
);



/* ---------------------------------------------------------
   SUBQUERY USAGE WITH SELECT
   --------------------------------------------------------- */

-- get the percentage of votes for each movie
-- compared to the total number of votes
select name,
(votes/(select sum(votes) from movies_data))*100 
as 'percentage_votes'
from movies_data;


-- display movie name, genre, score
-- and average score of its genre
select name,genre,score,
(select avg(score) from movies_data m2 
 where m2.genre=m1.genre) as 'genre_avg'
from movies_data m1;



/* ---------------------------------------------------------
   SUBQUERY USAGE WITH FROM
   --------------------------------------------------------- */

-- display the rating of all the restaurants
use zomato;

select r_name,avg_rating 
from (
    select r_id,
           avg(restaurant_rating) as 'avg_rating'
	from orders_food 
	group by r_id
) t1
join restaurants t2 
on t1.r_id=t2.r_id;



/* ---------------------------------------------------------
   SUBQUERY USAGE WITH HAVING
   --------------------------------------------------------- */

-- find genres having average score greater
-- than the average score of all movies
select genre,avg(score) 
from movies_data
group by genre
having avg(score)>(
    select avg(score) from movies_data
);



/* ---------------------------------------------------------
   SUBQUERY USAGE WITH INSERT
   --------------------------------------------------------- */

-- populate loyal_users table
-- (customers who ordered more than 3 times)
insert into loyal_users(user_id,name)
select t1.user_id,name 
from orders_food t1
join users_food t2 on t1.user_id=t2.user_id
group by user_id,name
having count(*)>3;



/* ---------------------------------------------------------
   SUBQUERY USAGE WITH DELETE
   --------------------------------------------------------- */

-- delete all customers who never ordered
delete from users_food
where user_id in (
    select uid from (
        select user_id as uid
        from users_food
        where user_id not in (
            select distinct user_id from orders_food
        )
    ) as temp
);
