--Analysis on Dataset FROM 1896 till 2016 Olympic.
--------------------------------------------------

--Total count of events in Olympics 1896 VS Olympics 2016.
select year,count(distinct event) as total
from athlete_events as a
join athletes as b
on a.athlete_id=b.id
where year in (1896,2016)
group by year;

--Total no. of athletes (Overall) participated in Olympics 1896 VS Olympics 2016.
select year,count(distinct b.id) as total
from athlete_events as a
join athletes as b
on a.athlete_id=b.id
where year in (1896,2016)
group by year;

--Top 3 countries by Gold medal count till Olympic 2016.
select top 3 b.team,count(a.medal) as gold_medal
from athlete_events as a
join athletes as b
on a.athlete_id=b.id
where a.medal='Gold'
group by b.team
order by gold_medal desc;

--Which team has won the maximum gold medals in a particular year.
with cte as(
select b.athlete_id,b.year,a.team
from athlete_events as b
join athletes as a
on b.athlete_id=a.id
where b.medal='Gold'),
cte2 as(
select team,year,count(*) as total
from cte
group by team,year),
cte3 as(
select team,sum(total) as med
from cte2
group by team),
cte4 as(
select team from cte3
where med=(select max(med) from cte3))
select a.team,max(total) as gold_medal
from cte2 as a
join cte4 as b
on a.team=b.team
group by a.team;

--Athlete winning maximum Gold Medal each year. In case of tie names are comma seperated.
with cte as(
select name,year,count(*) as gold_medal
from athlete_events	 as a
join athletes as b
on a.athlete_id=b.id
where medal= 'Gold'
group by name,year),
cte2 as(
select year,max(gold_medal) as mx
from cte
group by year)
select a.year,a.gold_medal,STRING_AGG(name,', ') within group(order by name) as name
from cte as a
join cte2 as b
on a.year=b.year
and b.mx=a.gold_medal
group by a.year,a.gold_medal
order by gold_medal desc;

--Overall top 3 Gold medalist athlete and their country
select top 3 name,team as country,count(medal) as gold_medal
from athlete_events as a
join athletes as b
on a.athlete_id=b.id
where medal = 'Gold'
group by name,team
order by gold_medal desc;

--Total countries having Gold Medals less than Michael Phleps.
with cte as(
select name,team,count(medal) as cn
from athlete_events as a
join athletes as b
on a.athlete_id=b.id
where medal = 'Gold'
group by name,team),
cte2 as(
select max(cn) as mx from cte),
cte3 as(
select a.name,a.team,a.cn
from cte as a
join cte2 as b
on a.cn=b.mx),
cte4 as(
select team,count(medal) as count_
from athlete_events as a
join athletes as b
on a.athlete_id=b.id
where medal='Gold'
group by team)
select count(*) as total
from cte3 as a
join cte4 as b
on a.cn>b.count_;

--List of Countries having Gold Medals less than Michael Phleps.
with cte as(
select name,team,count(medal) as cn
from athlete_events as a
join athletes as b
on a.athlete_id=b.id
where medal = 'Gold'
group by name,team),
cte2 as(
select max(cn) as mx from cte),
cte3 as(
select a.name,a.team,a.cn
from cte as a
join cte2 as b
on a.cn=b.mx),
cte4 as(
select team,count(medal) as gold_medal
from athlete_events as a
join athletes as b
on a.athlete_id=b.id
where medal='Gold'
group by team)
select b.team,b.gold_medal
from cte3 as a
join cte4 as b
on a.cn>b.gold_medal
order by gold_medal desc;

--Athlete who won gold, silver and bronze medal in a single Olympics.
select a.name,b.year
from athletes as a
join athlete_events as b
on a.id=b.athlete_id
where medal in ('Gold','Silver','Bronze')
group by name,year
having count(distinct medal)=3
order by year desc;

--Athlete who won gold medal in Summer and Winter Olympics both.
select a.name
from athletes as a
join athlete_events as b
on a.id=b.athlete_id
and b.medal='Gold'
and b.season in ('Summer','Winter')
group by name
having count(distinct season)=2;

--Each Country the Year they won maximum Silver Medal.
with cte as(
select team,count(medal) as tm,year
from athletes as a
join athlete_events as b
on a.id=b.athlete_id
where medal='Silver'
group by team,year),
cte2 as(
select team,sum(tm) as silver_medal
from cte
group by team),
cte3 as(
select team,max(tm) as mx
from cte
group  by team),
cte4 as(
select a.team,a.year
from cte as a
join cte3 as b
on a.team=b.team
and a.tm=b.mx)
select a.team,a.silver_medal,b.year
from cte2 as a
join cte4 as b
on a.team=b.team
order by a.team;

--Analysis of INDIA in Olympics.
--------------------------------

--Total Years India participated in Olympics.
select team,count(distinct year) as count_
from athlete_events as a
join athletes as b
on a.athlete_id=b.id
where team='India'
group by team;

--How Many distinct events India participated in Olympics.
select count(distinct event) as count_
from athlete_events as a
join athletes as b
on a.athlete_id=b.id
where team='India';

--How India Team size (Athletes) changed over the years (1896 vs 2016).
select year,count(distinct id) as count_
from athlete_events as a
join athletes as b
on a.athlete_id=b.id
where year in (1896,2016) and team='India'
group by year;

--In which year India participated for first time.
select team,min(year) as year_
from athlete_events as a
join athletes as b
on a.athlete_id=b.id
where team='India'
group by team;

--In which year India had lowest Athlete participation.
with cte as(
select year,count(distinct id) as cn
from athlete_events as a
join athletes as b
on a.athlete_id=b.id
where team='India'
group by year),
cte2 as(
select min(cn) as mn from cte)
select a.year,b.mn
from cte as a
join cte2 as b
on a.cn=b.mn;

--In which year India had highest Athlete participation.
with cte as(
select year,count(distinct id) as cn
from athlete_events as a
join athletes as b
on a.athlete_id=b.id
where team='India'
group by year),
cte2 as(
select max(cn) as mn from cte)
select a.year,b.mn
from cte as a
join cte2 as b
on a.cn=b.mn;

--Event and year in which India has won its first gold medal,first silver medal and first bronze medal.
with cte as(
select a.team,b.medal,b.year,b.event
from athletes as a
join athlete_events as b
on a.id=b.athlete_id
where a.team='India'
and medal in ('Gold','Silver','Bronze')),
cte2 as( 
select team,medal,min(year) as mn
from cte
group by team,medal)
select a.event,a.year,a.medal
from cte as a
join cte2 as b
on a.team=b.team
and a.year=b.mn and a.medal=b.medal
group by a.medal,a.year,a.event;

--Count of events where India was 4th position.
with cte as(
select a.year,b.team,a.event,count(medal) as cn
from athlete_events as a
join athletes as b
on a.athlete_id=b.id
group by a.year,b.team,a.event),
cte2 as(
select *,dense_rank() over(partition by year,event order by cn desc) as rn from cte)
select count(*) as count_ from cte2
where rn=4 and team='India';

--List of events where India was 4th position.
with cte as(
select a.year,b.team,a.event,count(medal) as cn
from athlete_events as a
join athletes as b
on a.athlete_id=b.id
group by a.year,b.team,a.event),
cte2 as(
select *,dense_rank() over(partition by year,event order by cn desc) as rn from cte)
select year,team,event from cte2
where rn=4 and team='India';

--How many Winter Olympics year India has participated in.
select count(distinct year) as cn
from athlete_events as a
join athletes as b
on a.athlete_id=b.id
where season='Winter' and team='India';

--Name of events in Winter Olympics where India participated.
with cte as(
select *
from athlete_events as a
join athletes as b
on a.athlete_id=b.id
where season='Winter' and team='India')
select distinct event from cte;








