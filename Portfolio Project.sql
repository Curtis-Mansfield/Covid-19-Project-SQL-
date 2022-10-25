--Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you get covid in your country. 

SELECT location, 
        date, 
        total_cases,  
        total_deaths,
        (total_deaths/total_cases)*100 as DeathPercentage
FROM `portfolio-project-366016.Covid_Project.covid_deaths`
WHERE location = 'United States'
order by 1,2; 



-- Looking at Total Cases vs Population
-- Shows the Percentage od population that got covid in USA

SELECT location, 
        date, 
        total_cases,  
        population,
        (total_cases/population)*100 as CasePercentage
FROM `portfolio-project-366016.Covid_Project.covid_deaths`
WHERE location = 'United States'
order by 1,2;

-- Looking at countries iwth highest infection rate compared to population

SELECT location, 
        population, 
        MAX(total_cases) as HighestInfectionCount,  
        MAX((total_cases/population))*100 as PercentInfected
FROM `portfolio-project-366016.Covid_Project.covid_deaths`

WHERE location = 'United States'
Group BY population, location
order by PercentInfected DESC;

--Shows the countries with highest deathh count per population
-- This was returning data where it was grouping by continents, so addind a where clause that searches for when continent is not null will benefit us. 

SELECT location, 
        MAX(cast(total_deaths as INT)) as TotalDeathCount
FROM `portfolio-project-366016.Covid_Project.covid_deaths`
WHERE continent is not null
Group BY location
order by TotalDeathCount DESC;

-- Grouping by Continent instead of location

SELECT continent, 
        MAX(cast(total_deaths as INT)) as TotalDeathCount
FROM `portfolio-project-366016.Covid_Project.covid_deaths`

WHERE continent is not null

Group BY continent
order by TotalDeathCount DESC;


--GLOBAL NUMBERS
-- Looking at the global death percentage by dates

SELECT 
        date, 
        SUM(new_cases) as total_cases,  
        SUM(cast (new_deaths as int)) as total_deaths,
        SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM `portfolio-project-366016.Covid_Project.covid_deaths`
WHERE continent is not null
GROUP BY date
order by 1,2 ;

--Joining the vaccination and death tables
-- looking at total poulation vs vaccinations

SELECT dea.continent, 
        dea.location,
        dea.date, 
        dea.population, 
        vac.new_vaccinations, 
        SUM(vac.new_vaccinations) OVER (Partition by dea.location order by dea.location, dea.date) as VaccineRollingCount, 
        
FROM `portfolio-project-366016.Covid_Project.covid_vacc` dea
JOIN `portfolio-project-366016.Covid_Project.covid_deaths` vac
  ON dea.location = vac.location
  and dea.date = vac.date
where dea.continent is not null
order by 1,2,3;


--Creating Temp Table

/*CREATE TABLE #PercentPopulationVaccinated
(
  Continent nvarchar(255), 
  Location nvarchar(255),
  date datetime, 
  Population numeric, 
  New_vaccinations numeric, 
  RollingPeopleVaccinated numeric

)

 
 INSERT INTO #PercentPopulationVaccinated
 SELECT dea.continent, 
        dea.location,
        dea.date, 
        dea.population, 
        vac.new_vaccinations, 
        SUM(vac.new_vaccinations) OVER (Partition by dea.location order by dea.location, dea.date) as VaccineRollingCount, 
        
FROM `portfolio-project-366016.Covid_Project.covid_vacc` dea
JOIN `portfolio-project-366016.Covid_Project.covid_deaths` vac
  ON dea.location = vac.location
  and dea.date = vac.date
where dea.continent is not null
order by 1,2,3;

*/


