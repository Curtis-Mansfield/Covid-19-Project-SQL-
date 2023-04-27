
-- Looking at Total Cases vs Total Deaths 
use PortfolioProject;

-- GLOBAL NUMBERS


--  1.- This query looks at the dearth percentage of each country
SELECT 
  location, 
  SUM(cast (new_deaths as int)) as total_deaths, 
  SUM(new_cases) as total_cases, 
  SUM(cast(new_deaths as int))/ SUM(new_cases) as DeathPercentage 
FROM 
  CovidDeaths 
where 
  location not in ('World', 'Europe', 'North America', 'European Union', 'South America') 
GROUP BY 
  location 
order by 
  DeathPercentage DESC;


--   2.- This returns a count of total deaths, and groups it by country. Adding a where clause helps by removing the continents in the location column. 
SELECT 
  location, 
  SUM(cast(new_deaths as INT)) as TotalDeathCount 
FROM 
  CovidDeaths 
where 
  location not in ( 'World', 'Europe', 'North America', 'European Union', 'South America', 'Asia') 
Group BY 
  location 
order by 
  TotalDeathCount DESC;
-- The results of this query show that even though Mexico had the highest death rate, the USA has the highest number of deaths by a country. 


-- This next query looks at the total death count by conitinent instead of country
-- Grouping by Continent instead of location
SELECT continent, 
        MAX(cast(total_deaths as INT)) as TotalDeathCount
FROM 
  CovidDeaths 
WHERE 
  continent is not null 
Group BY 
  continent 
order by 
  TotalDeathCount DESC;


--  3.- Looking at countries iwth highest infection rate compared to population
SELECT 
  location, 
  population, 
  MAX(total_cases) as total_infected, 
  MAX((total_cases / population))* 100 as PercentInfected 
FROM 
  CovidDeaths 
WHERE 
  location not in ( 'World', 'Europe', 'North America', 'European Union', 'South America', 'Asia') 
Group BY 
  population, 
  location 
order by 
  PercentInfected DESC;

-- The results show that several countries have a 10% or higher percent infected rate. 
-- However the USA has about a 10% rate but has 32 million total infected, no other country with that high of a rate has nearly as many deaths. 



--  4.- Shows the countries with highest infection rate grouping it by date.
SELECT 
  location, 
  population, 
  date, 
  MAX(total_cases) as HighestInfectionCount, 
  MAX((total_cases / population))* 100 as PercentInfected 
FROM 
  CovidDeaths 
Group BY 
  population, 
  location, 
  date 
order by 
  PercentInfected DESC;


-- This query shows the highest infection rate for the US for a period of time. 
SELECT 
  location, 
  date, 
  total_cases, 
  total_deaths, 
  (total_deaths / total_cases)* 100 as DeathPercentage 
FROM 
  CovidDeaths 
WHERE 
  location = 'United States' 
order by 
  location, 
  date;

-- The results of this query show NULL values for the first several rows, that is because there were no deaths reported until 2020-02-29. 







