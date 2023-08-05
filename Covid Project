select *
from CovidDeaths

select Location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%kingdom%'
order by 1,2

select Location, date, total_cases, (total_cases/population)*100 PercentPopulationinfected
From PortfolioProject..CovidDeaths
Where location like '%kingdom%'
order by 1,2

select Location, population, max(total_cases), max((total_cases/population))*100 PercentPopulationinfected
From PortfolioProject..CovidDeaths
--Where location like '%kingdom%'
group by location, population
order by PercentPopulationinfected desc

select location, max(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths 
where continent is null
Group by location
order by TotalDeathCount desc

select date, total_cases, total_deaths, (total_deaths/total_cases)*100 DeathPercentage
from CovidDeaths
where continent is not null
group by date
order by 1,2

select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, sum(cast
	(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
group by date
order by 1,2

With PopvsVac (Continent, Location, Date, Population, new_vaccinations, PeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location Order by dea.location,
dea.date) PeopleVaccinated
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
)

select *, (PeopleVaccinated/Population)*100 percenty
from PopvsVac

drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
PeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location Order by dea.location,
dea.date) PeopleVaccinated
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location Order by dea.location,
dea.date) PeopleVaccinated
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

create view UnitedKingdom as
select Location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%kingdom%'


create view PercentPopulationInfected as
select Location, population, max(total_cases) MaxCases, max((total_cases/population))*100 as PercentPopulationinfected
From CovidDeaths
group by location, population

j
