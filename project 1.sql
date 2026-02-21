use project;
-- Reataurants Table
create table restaurants(
restaurant_id int primary key,
name varchar(100),
city varchar(100),
state varchar(100),
country varchar(50),
zip_code varchar(50),
latitude decimal(10,5),
longitude decimal(10,5),
alcohol_service varchar(100),
smoking_Allowed varchar(30),
price varchar(20),
franchise varchar(5),
seating_type varchar(50),
parking varchar(30)
);
select * from restaurants;

-- Reataurantd_cusine Table
create table restaurant_cuisine(
restaurant_id int,
cuisine varchar(100),
foreign key (restaurant_id) references restaurants(restaurant_id)
);

-- Consumers Table
create table  consumers (
consumer_id varchar(20) primary key,
city varchar(50),
state varchar(100),
country varchar(100),
latitude DECIMAL(10,6),
longitude DECIMAL(10,6),
smoker VARCHAR(20),
drink_level VARCHAR(50),
transportation_method VARCHAR(50),
marital_status VARCHAR(50),
children VARCHAR(50),
age DECIMAL(10,4),
occupation VARCHAR(100),
budget VARCHAR(20)
);
select * from consumers;

-- Consumers_Preferences Table 
create table consumer_preferences(
consumer_id varchar(100),
preferred_cuisine varchar(100),
foreign key (consumer_id) references consumers(consumer_id) 
);
select*from consumer_preferences;

--  Ratings Table
create table ratings(
consumer_id varchar(100),
restaurant_id int,
overall_rating int,
food_rating int,
serice_rating int,
foreign key (consumer_id) references consumers(consumer_id),
foreign key(restaurant_id) references restaurants(restaurant_id)
);

-- where cluse questions
select*from restaurant_cuisine;
select*from consumer_preferences;
select * from consumers;
select*from ratings;
select*from restaurants;

-- 1)List all details of consumers who live in the city of 'Cuernavaca'.
select *
from consumers 
where city="cuernavaca";
-- insights:- it shows all the profine of all the consumers located in cuernavaca

-- 2)Find the Consumer_ID, Age, and Occupation of all consumers who are 'Students' AND are 'Smokers'.
select 
consumer_id,
age,
occupation,
smoker 
from consumers 
where smoker="yes" and occupation ="student";
-- insights:- shows all the students who are smokers

-- 3)List the Name, City, Alcohol_Service, and Price of all restaurants that serve 'Wine & Beer' and have a 'Medium' price level. 
select 
name,
city,
alcohol_service,
price 
from restaurants 
where alcohol_service="wine & beer" and price="medium";
-- insights:- this will highlights the mid-range restaurants which provide alchol

-- 4)Find names and cities of restaurants that are part of a 'Franchise'.
select 
name,
city 
from restaurants 
where franchise="yes";
-- insights:- shows all the large chain or franchise restuart in every cities

-- 5) Show the Consumer_ID, Restaurant_ID, and Overall_Rating for all ratings where the Overall_Rating was 'Highly Satisfactory'.
select 
consumer_id,
restaurant_id,
overall_rating 
from ratings 
where overall_rating=2;
-- insights:- Helps identify consumers who consistently give high ratings and restaurants that provide superior service

-- join questions
-- 6) List names and cities of restaurants that received an Overall_Rating of 2 from at least one consumer.
select 
name,
city,
overall_rating 
from restaurants r 
join ratings ra
on r.restaurant_id=ra.restaurant_id 
where overall_rating=2;
-- insights:- this will shows all the restaurants which have high consumer feedback

-- 7) Find Consumer_ID and Age of consumers who rated restaurants located in 'San Luis Potosi'.
select 
c.consumer_id,
c.age,
re.city 
from consumers c 
join ratings r 
on c.consumer_id=r.consumer_id 
join restaurants re 
on r.restaurant_id=re.restaurant_id
where re.city="San Luis Potosi"; 
-- insights:- shows which age group are going restaurants in san luis potosi

-- 8)List names of restaurants serving 'Mexican' cuisine that were rated by consumer 'U1001'.
select 
name
from restaurants re 
join restaurant_cuisine rc 
on re.restaurant_id=rc.restaurant_id 
join ratings r 
on re.restaurant_id=r.restaurant_id
where rc.cuisine ='mexican' and r.consumer_id='u1001';
-- insights:- shows which mexican restaurant is preffered by a consumer

-- 9)Find all details of consumers who prefer 'American' cuisine AND have a 'Medium' budget.
select * 
from  consumers 
where consumer_id in 
(select 
consumer_id 
from consumer_preferences 
where preferred_cuisine='american' 
and budget='medium'
);
-- insights:- shows the american cuisine restaurant for medium budget

-- 10)List restaurants (Name, City) with Food_Rating lower than the average Food_Rating across all restaurants
select 
re.name,
re.city 
from restaurants re 
join ratings r 
on re.restaurant_id=r.restaurant_id 
where r.food_rating <
(select 
avg(food_rating) 
from ratings);
-- insights:- shows all the restaurant which have low ratings

-- 11) Find consumers (Consumer_ID, Age, Occupation) who rated at least one restaurant but NOT any restaurant serving 'Italian' cuisine.
select 
distinct c.consumer_id, 
c.age, 
c.occupation
from consumers c
join ratings r 
on c.consumer_id = r.consumer_id
where c.consumer_id not in (
select r2.consumer_id 
from ratings r2
join restaurant_cuisine rc
on r2.restaurant_id = rc.restaurant_id
where rc.cuisine = 'Italian'
);
-- insights:- shows consumers who rate exicively and avoid italian cusine

-- 12)List restaurant names that received ratings from consumers older than 30
select 
re.name as restaurant_name 
from restaurants re 
join ratings r 
on re.restaurant_id=r.restaurant_id 
join consumers c 
on c.consumer_id=r.consumer_id 
where age>30;
-- insights:-shows the restaurant which are popular in older people

-- 13)Find Consumer_ID and Occupation of consumers whose preferred cuisine is 'Mexican' and who rated any restaurant with an Overall_Rating of 0
select 
c.consumer_id,
c.occupation 
from consumers c 
join consumer_preferences co 
on c.consumer_id=co.consumer_id 
join ratings r 
on c.consumer_id=r.consumer_id 
where preferred_cuisine="mexican" and overall_rating=0 ; 
-- insights:- shows consumers with 0 ratings means dissatisfied consumer with most popular cuisine.

-- 14)List names and cities of restaurants serving 'Pizzeria' cuisine that are located in a city where at least one 'Student' lives. 
select 
r.name,
r.city 
from restaurants r 
join restaurant_cuisine re 
on r.restaurant_id=re.restaurant_id 
where re.cuisine='pizzeria' and r.city in 
(select 
city 
from consumers 
where occupation="student");
-- insights:-Shows whether pizza restaurants are available in student-dense cities (the demanded occupation for piza)

-- 15)Find consumers (Consumer_ID, Age) who are 'Social Drinkers' and have rated a restaurant that has 'No' parking.
select 
distinct c.consumer_id, 
c.age
from consumers c
join ratings r 
on c.consumer_id = r.consumer_id
join restaurants re
on r.restaurant_id = re.restaurant_id
where c.drink_level = 'Social Drinker' and re.parking = 'public';
-- insights:- shows all the social drinkers where public parking allowed this shows the people perfer parking 

-- WHERE Clause and Order of Execution
-- 16)List Consumer_IDs and count of restaurants they rated, only for 'Students' who rated more than 2 restaurants.
select 
c.consumer_id,
count(r.restaurant_id) 
from consumers c 
join ratings r 
on c.consumer_id=r.consumer_id 
where c.occupation='student'
group by consumer_id
having count(r.restaurant_id)>2;
-- insights:- Identifies highly active student reviewers helps to attact students

-- 17)Calculate Engagement_Score = Age/10 (integer). Show for consumers whose score = 2 and use 'Public' transport.
select 
consumer_id,
age,
floor(age/10) as engagement_score
from consumers
where floor(age/10)=2 and transportation_method='public';
-- insights:- shows young people who relay on public transport

-- 18)For restaurants in 'Cuernavaca', show Name, City, and Average Overall_Rating where rating > 1.0.
select 
r.name,
r.city,
avg(ra.overall_rating) as avg_rating 
from restaurants r 
join ratings ra 
on r.restaurant_id=ra.restaurant_id 
where city='cuernavaca'
group by r.restaurant_id,
r.name,
r.city
having avg(ra.overall_rating)>1.0; 
-- insights:- shows the top performing restaurant in cuernavaca

-- 19)List Consumer_ID, Age, and Restaurant_Name for 'Employed' consumers who gave a Food_Rating of 0 to restaurants in 'Ciudad Victoria
select c.consumer_id,
age,
r.name 
from restaurants r 
join ratings re 
on r.restaurant_id=re.restaurant_id 
join consumers c 
on re.consumer_id=c.consumer_id 
where c.occupation='Employed' and re.food_rating=0 and r.city='ciudad victoria';
-- insights:- shows the consumers whose ratings are low for employed people

-- 20)Find Married consumers whose Food_Rating = Service_Rating for ratings with Overall Rating = 2.
select * 
from consumers c 
join ratings r 
on c.consumer_id=r.consumer_id 
where food_rating=serice_rating and overall_rating=2 and marital_status="married"; 
-- insights:- shows where married cuples felt food quality and servie are good

-- 21) List consumers from San Luis Potosi & the Mexican restaurants they rated with Overall_Rating = 2.
with spl_consumers as (
select consumer_id,
age 
from consumers 
where city='san luis potosi')
select 
c.consumer_id,
c.age,
r.name 
from spl_consumers c
join ratings re 
on c.consumer_id=re.consumer_id 
join restaurants r 
on re.restaurant_id=r.restaurant_id
join restaurant_cuisine ra 
on r.restaurant_id=ra.restaurant_id
where ra.cuisine='mexican' and re.overall_rating=2;
-- insights:- it shows the mexican restaurants in san luis potosi with good ratings 

-- 22)For each occupation, find average age of consumers who have rated at least one restaurant. 
select 
c.occupation,
avg(c.age) as avg_age 
from  consumers c 
join (select distinct consumer_id from ratings) as rating_table
on c.consumer_id=rating_table.consumer_id 
group by c.occupation;
-- insights:- shows which occupation groups are highly active in restaurant platforms

-- 23) Which cuisines have the highest number of restaurants? 
SELECT 
    cuisine,
    COUNT(restaurant_id) AS restaurant_count
FROM restaurant_cuisine014
GROUP BY cuisine
ORDER BY restaurant_count DESC;
-- 24) Find which restaurant is having  the high ratings.
select
r.restaurant_id,
ra.name,
sum(r.overall_rating) as HighRatings
from ratings r
join restaurants ra 
on r.restaurant_id=ra.restaurant_id
group by ra.name,r.restaurant_id
order by HighRatings desc;
