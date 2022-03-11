select *
from [covid-data-Deaths]

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum (convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date)
as rollingpeoplevaccinated
from [Portfolio Project]..[covid-data-Deaths] as dea
join [Portfolio Project]..[covid-vaccination-data (1)] as vac
on dea.location= vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

--with cte

with popvsva (continent, location, date, population,new_vaccinations, rollingpeoplevaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum (convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date)
as rollingpeoplevaccinated
from [Portfolio Project]..[covid-data-Deaths] as dea
join [Portfolio Project]..[covid-vaccination-data (1)] as vac
on dea.location= vac.location
and dea.date = vac.date
where dea.continent is not null

)
select *
from popvsva

--TEMP TABLE
drop table if exists #percentpopulattionvaccinated
create table #percentpopulattionvaccinated
(
continetnt nvarchar (255),
location nvarchar (255),
date datetime,
population numeric ,
New_vaccination numeric,
rollingpeoplevaccinated numeric
)
insert into #percentpopulattionvaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum (convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date)
as rollingpeoplevaccinated
from [Portfolio Project]..[covid-data-Deaths] as dea
join [Portfolio Project]..[covid-vaccination-data (1)] as vac
on dea.location= vac.location
and dea.date = vac.date
--where dea.continent is not null

select *, (rollingpeoplevaccinated/population)*100
from #percentpopulattionvaccinated


create view percentpopulattionvaccinated as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum (convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date)
as rollingpeoplevaccinated
from [Portfolio Project]..[covid-data-Deaths] as dea
join [Portfolio Project]..[covid-vaccination-data (1)] as vac
on dea.location= vac.location
and dea.date = vac.date
--where dea.continent is not null
--order by 2,3


select *
from percentpopulattionvaccinated