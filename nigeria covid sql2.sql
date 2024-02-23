use nigeria;
#percentage of people that died in each state in nigeria
select state, cumulative_death_cases, Cumulative_Confirmed_cases,(cumulative_death_cases/Cumulative_Confirmed_cases) *100 as percentage
 from covid_deaths;
 
 
 
select state,date, cumulative_death_cases, Cumulative_Confirmed_cases,(cumulative_death_cases/Cumulative_Confirmed_cases) *100 as percentage
 from covid_deaths
 where state like "%lagos%";
 #lagos withnessed her first case on 17/03/2020 and her first death on 3/4/2020 and the likelihood of dying from covid in lagos presently is a 0.75%.
 
 
#looking for states with the highest infection rate
select state, max(Cumulative_Confirmed_cases) as highestinfectionrate, max((cumulative_death_cases/Cumulative_Confirmed_cases)) *100 as percentage
from covid_deaths
group by state 
order by 1,2 ;


#states with the highest death count
select state, max(cumulative_death_cases) as totaldeaths
from covid_deaths
group by state
order by totaldeaths desc;


select da.date,da.state, da.Cumulative_Confirmed_cases, cr.Daily_Recovered_Case,
sum( cr.Daily_Recovered_Case) over (partition by da.state order by da.state,da.date) as rollingpeople
from covid_deaths as da
join cases_recover as cr
on da.date=cr.date
and da.state=cr.state
where da.state is not null
order by 2,3;

#temp table
drop table if exists people_vaccination;
create table people_vaccination 
 (state varchar (255),
cumulative_confirmed_cases varchar (255),
 daily_recovered_case numeric,
 rollingpeople numeric);
 insert into people_vaccination 
 select da.state, da.Cumulative_Confirmed_cases, cr.Daily_Recovered_Case,
sum( cr.Daily_Recovered_Case) over (partition by da.state order by da.state) as rollingpeople
from covid_deaths as da
join cases_recover as cr
on da.state=cr.state
where da.state is not null
order by 2,3;
select *, (cumulative_confirmed_cases/daily_recovered_case)*100
from people_vaccination;


#creating view for later visualization

drop table if exists people_vaccination;
create view people_vaccination as
  select da.state, da.Cumulative_Confirmed_cases, cr.Daily_Recovered_Case,
sum( cr.Daily_Recovered_Case) over (partition by da.state order by da.state) as rollingpeople
from covid_deaths as da
join cases_recover as cr
on da.state=cr.state
where da.state is not null
; 
select * from people_vaccination