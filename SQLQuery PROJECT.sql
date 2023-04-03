



--select * from PortfolioProject..CovidVaccinations
--order by 3,4

--This is to show how many people died per the cases
select location,date,total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_by_Cases
from PortfolioProject..CovidDeaths 
where location like '%states%' and continent is not null
order by 1,2


--This is to show how many people got cases compared to population
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




-- By Continent with highest death count
select continent, Max(cast(total_deaths as int)) as TotalDeathCount 
from PortfolioProject..CovidDeaths 
--where location like '%states%'
where continent is not null
group by continent
order by TotalDeathCount desc



-- Global Numbers

select sum(new_cases) as total_cases, sum (cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int)) / sum(new_cases)*100 as DeathPercentage --, total_deaths (total_deaths/total_cases)*100 as 'Percent Populaiton Infected'
from PortfolioProject..CovidDeaths 
--where location like '%states%' 
where continent is not null
--group by date
order by 1,2


-- Looking at total population vs vaccinations
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
-- agregate function
Sum(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
, (RollingPeopleVaccinated/population) * 100
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 order by 2,3


 -- USE CTE

 with PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
 as
 (
 select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
-- agregate function
Sum(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population) * 100
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
-- order by 2,3
 )

select * , (RollingPeopleVaccinated/Population) * 100
from PopvsVac




-- Creating view to store data for later visualizations


Create View PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
-- agregate function
Sum(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population) * 100
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 --order by 2,3


