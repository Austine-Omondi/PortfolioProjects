
-- COVID-19 DATA EXPLORATION

--Skills used: Joins, CTE's, Creating Views, Converting Data Types, Temp Tables, Windows Functions, Aggregate Functions

SELECT *
FROM PortfolioProject..CovidDeaths
ORDER BY 3,4

--SELECT *
--FROM PortfolioProject..CovidVaccinations
--WHERE total_vaccinations is NOT NULL

--SELECT location, date, new_cases, total_deaths, population
--FROM PortfolioProject..CovidDeaths
--ORDER BY 1,2

-- Confirm data types we are working with

SELECT 
  COLUMN_NAME, 
  DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'CovidDeaths' 
  AND COLUMN_NAME IN ('total_cases', 'total_deaths');

-- Global Overview - TOTAL CASES VS TOTAL DEATHS
-- Shows the percentage of population infected with Covid

WITH CountryLatestTotals AS (
  SELECT location,
    MAX(total_cases) AS latest_total_cases,
    MAX(TRY_CAST(total_deaths AS FLOAT)) AS latest_total_deaths
  FROM PortfolioProject..CovidDeaths
  WHERE continent IS NOT NULL
  GROUP BY location
)
SELECT 
  SUM(latest_total_cases) AS global_cases,
  SUM(latest_total_deaths) AS global_deaths,
  (SUM(latest_total_deaths) / SUM(latest_total_cases)) * 100 AS global_death_rate
FROM CountryLatestTotals;

---- option 2 to compare
--SELECT 
--  SUM(new_cases) AS global_cases,
--  SUM(TRY_CAST(new_deaths AS FLOAT)) AS global_deaths,
--  (SUM(TRY_CAST(new_deaths AS FLOAT)) / SUM(new_cases)) * 100 AS global_death_rate
--FROM PortfolioProject..CovidDeaths
--WHERE continent IS NOT NULL;


--TOTAL CASES VS TOTAL DEATHS in individual countries such as United States, Kenya etc.

SELECT  Location, date, total_cases, total_deaths, (total_deaths/ total_cases)*100 as death_percentage
FROM PortfolioProject..CovidDeaths
ORDER BY location, date

SELECT  Location, date, total_cases, total_deaths, (total_deaths/ total_cases)*100 as death_percentage
FROM PortfolioProject..CovidDeaths
WHERE Location like '%kenya%'
ORDER BY location, date

SELECT  Location, date, total_cases, total_deaths, (total_deaths/ total_cases)*100 as death_percentage
FROM PortfolioProject..CovidDeaths
WHERE Location like '%states%'
ORDER BY 1, 2

-- TOTAL CASES VS POPULATION
-- Shows the percentage of population infected with Covid

SELECT  Location, date, total_cases, Population, (total_cases / Population) *100 as percentage_of_population_infected
FROM PortfolioProject..CovidDeaths
WHERE Location like '%states%'
ORDER BY 1, 2


--Daily New Cases/Deaths Worldwide

SELECT 
  date,
  SUM(new_cases) AS daily_new_cases,
  SUM(TRY_CAST(new_deaths AS FLOAT)) AS daily_new_deaths
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY date;

--	COUNTRIES WITH HIGHEST INFECTION RATES COMPARED TO POPULATION

Select location, population, MAX(total_cases) as Highest_Infection_Count,
MAX((total_cases/population)) *100 as percentage_of_population_infected
FROM PortfolioProject..CovidDeaths
WHERE continent is NOT NULL
GROUP BY location, population
ORDER BY percentage_of_population_infected DESC

-- Infection and Death Rates (Top 10)
-- Shows ten countries with the highest infection and death rates

WITH CountryLatest AS (
  SELECT location, population,
    MAX(total_cases) AS total_cases,
    MAX(TRY_CAST(total_deaths AS FLOAT)) AS total_deaths
  FROM PortfolioProject..CovidDeaths
  WHERE continent IS NOT NULL
  GROUP BY location, population
 
)
SELECT TOP 10 location,
  (total_cases / population) * 100 AS infection_rate,
  (total_deaths / total_cases) * 100 AS death_rate
FROM CountryLatest
ORDER BY infection_rate DESC;

-- Aged Population vs. Death Rates

WITH CountryStats AS (
  SELECT location, population,
    MAX(ROUND(aged_65_older, 0)) AS aged_65_older,
    MAX(ROUND(aged_70_older, 0)) AS aged_70_older,
    MAX(total_cases) AS total_cases,
    MAX(TRY_CAST(total_deaths AS FLOAT)) AS total_deaths
  FROM PortfolioProject..CovidDeaths
  WHERE continent IS NOT NULL
  GROUP BY location, population
)
SELECT
  location,
  aged_65_older,
  aged_70_older,
  (total_deaths / total_cases) * 100 AS death_rate
FROM CountryStats
ORDER BY aged_65_older DESC;




-- COUNTRIES WITH HIGHEST DEATH COUNT PER POPULATION

Select TOP 10 location, population,
MAX(TRY_CAST(total_deaths AS bigint)) as death_count
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY death_count DESC


-- BREAKING THINGS DOWN BY CONTINENT


-- CONTINENTS WITH HIGHEST DEATH COUNT

Select continent,
MAX(TRY_CAST(total_deaths AS bigint)) as Total_death_count
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL 
GROUP BY continent
ORDER BY Total_death_count DESC

-- TOTAL POPULATION VS VACCINATIONS

-- Shows the Percentage of Population that has recieved at least one Covid Vaccine

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(TRY_CAST(vac.new_vaccinations AS bigint)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as rolling_total_of_people_vaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
   ON dea.location = vac.location
   and dea.date =  vac.date
WHERE dea.continent IS NOT NULL AND vac.new_vaccinations IS NOT NULL
ORDER BY 2, 3

-- -- Using CTEs to perform Calculation on Partition By in previous query

WITH PopvsVac (continent, location, date, population, new_vaccinations, rolling_total_of_people_vaccinated ) As
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(TRY_CAST(vac.new_vaccinations AS bigint)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as rolling_total_of_people_vaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
   ON dea.location = vac.location
   and dea.date =  vac.date
WHERE dea.continent IS NOT NULL AND vac.new_vaccinations IS NOT NULL
)
SELECT *, (rolling_total_of_people_vaccinated/population)*100
FROM PopvsVac
ORDER BY location


-- TEMP TABLE
-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table IF exists #PercentageOfpeopleVaccinated
Create Table #PercentageOfpeopleVaccinated(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
rolling_total_of_people_vaccinated numeric
)

Insert into #PercentageOfpeopleVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(TRY_CAST(vac.new_vaccinations AS bigint)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as rolling_total_of_people_vaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
   ON dea.location = vac.location
   and dea.date =  vac.date
WHERE dea.continent IS NOT NULL AND vac.new_vaccinations IS NOT NULL


SELECT *, (rolling_total_of_people_vaccinated/population)*100
FROM #PercentageOfpeopleVaccinated
ORDER BY location

-- Pre-Existing Health Conditions(CardioVascular issues and diabetes prevalence)

WITH CountryHealth AS (
  SELECT location,
    MAX(cardiovasc_death_rate) AS cardiovascular_death_rate,
    MAX(diabetes_prevalence) AS diabetes_prevalence,
    MAX(total_deaths) AS total_deaths,
    MAX(total_cases) AS total_cases
  FROM PortfolioProject..CovidDeaths
  WHERE continent IS NOT NULL
  GROUP BY location
)
SELECT 
  location,
  cardiovascular_death_rate,
  diabetes_prevalence,
  (total_deaths / total_cases) * 100 AS death_rate
FROM CountryHealth;


-- CREATING VIEWS TO STORE DATA FOR VISUALIZATION IN TABLEAU
 -- 1 --
CREATE VIEW PercentageOfpeopleVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(TRY_CAST(vac.new_vaccinations AS bigint)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as rolling_total_of_people_vaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
   ON dea.location = vac.location
   and dea.date =  vac.date
WHERE dea.continent IS NOT NULL AND vac.new_vaccinations IS NOT NULL

-- 2 --
CREATE VIEW CONTINENTS_WITH_HIGHEST_DEATH_COUNT AS
Select continent,
MAX(TRY_CAST(total_deaths AS bigint)) as Total_death_count
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL 
GROUP BY continent
--ORDER BY Total_death_count DESC

-- 3 --
CREATE VIEW COUNTRIES_WITH_HIGHEST_DEATH_COUNT_PER_POPULATION AS
Select TOP 10 location, population,
MAX(TRY_CAST(total_deaths AS bigint)) as death_count
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
--ORDER BY death_count DESC

-- 4 --
CREATE VIEW COUNTRIES_WITH_HIGHEST_INFECTION_RATES_COMPARED_TO_POPULATION AS
Select location, population, MAX(total_cases) as Highest_Infection_Count,
MAX((total_cases/population)) *100 as percentage_of_population_infected
FROM PortfolioProject..CovidDeaths
WHERE continent is NOT NULL
GROUP BY location, population
--ORDER BY percentage_of_population_infected DESC

-- 5-- 

CREATE VIEW Global_Overview AS
WITH CountryLatestTotals AS (
  SELECT location,
    MAX(total_cases) AS latest_total_cases,
    MAX(TRY_CAST(total_deaths AS FLOAT)) AS latest_total_deaths
  FROM PortfolioProject..CovidDeaths
  WHERE continent IS NOT NULL
  GROUP BY location
)
SELECT 
  SUM(latest_total_cases) AS global_cases,
  SUM(latest_total_deaths) AS global_deaths,
  (SUM(latest_total_deaths) / SUM(latest_total_cases)) * 100 AS global_death_rate
FROM CountryLatestTotals;
