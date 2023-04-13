
--COVID 19 DATA EXPLORATION


-- Skills Used: Joins, CTE's, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types



select * from PortfolioProject..CovidVaccinations
where continent is not null 
order by 3,4

select * from PortfolioProject..CovidDeaths
where continent is not null 
order by 3,4






-- Select Data that we are going to be starting with

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Where continent is not null 
order by 1,2








-- TOTAL CASES vs TOTAL DEATHS
-- Shows likelihood of dying if you contract covid in your country


select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_by_Cases
from PortfolioProject..CovidDeaths 
where location like '%states%' and continent is not null
order by 1,2










-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

select location,date,population, total_cases, (total_cases/population)*100 as 'Percent Populaiton Infected'
from PortfolioProject..CovidDeaths 
where location like '%states%' and continent is not null
order by 1,2











--Countries with highest infection rate compared to population
select location,population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as 'Percent Population Infected'
from PortfolioProject..CovidDeaths 
--where location like '%states%'
where continent is not null
group by population,location
order by 'Percent Population Infected' desc









--How many people died from COVID per population

select location, Max(cast(total_deaths as int)) as TotalDeathCount 
from PortfolioProject..CovidDeaths 
--where location like '%states%'
where continent is not null
group by location
order by TotalDeathCount desc











-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population


select continent, Max(cast(total_deaths as int)) as TotalDeathCount 
from PortfolioProject..CovidDeaths 
--where location like '%states%'
where continent is not null
group by continent
order by TotalDeathCount desc








-- Global Numbers

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2









-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3








-- Using CTE to perform Calculation on Partition By in previous query


With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac








-- Creating view to store data for later visualizations


Create View PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
Sum(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population) * 100
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 --order by 2,3


