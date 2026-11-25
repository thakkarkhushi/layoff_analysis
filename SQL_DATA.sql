-- 1.cleaning data


-- Remove duplicates
CREATE TABLE `layoff_stagging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
  
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

delete 
from layoff_stagging2;

select * 
from layoff_stagging;

WITH duplicate_cte AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY company, location, industry, total_laid_off,
                         percentage_laid_off, `date`, stage, country,
                         funds_raised_millions
        ) AS row_num
    FROM layoff_stagging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

INSERT INTO layoff_stagging2
 SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY company, location, industry, total_laid_off,
                         percentrow_numage_laid_off, `date`, stage, country,
                         funds_raised_millions
        ) AS row_num
    FROM layoff_stagging;
    
select * 
from layoff_stagging2
WHERE row_num > 1;

DELETE 
from layoff_stagging2
WHERE row_num > 1;

select * 
from layoff_stagging2
WHERE row_num > 1;

select * 
from layoff_stagging2;

-- Standarzing Data

select (trim(company))
from layoff_stagging2;

update layoff_stagging2
set company=(trim(company));

select distinct(industry)
from layoff_stagging2 order by 1;

select * 
from layoff_stagging2 where industry like 'Crypto%';

update layoff_stagging2
set industry='Crypto'
where  industry like 'Crypto%';

select distinct(country)
from layoff_stagging2 order by 1;

update layoff_stagging2
set country='United states'
where country  like 'United states%';
-- populate D
select `date`,
str_to_date(`date`,'%m/%d/%Y')
from layoff_stagging2;

update layoff_stagging2
set `date`=str_to_date(`date`,'%m/%d/%Y');

alter TABLE layoff_stagging2
MODIFY COLUMN  `date` DATE;

SELECT  * from 
layoff_stagging2 where industry is null or industry='';

SELECT  * from 
layoff_stagging2 where company='Airbnb';

update layoff_stagging2
set industry=null
where industry='';
select *  from 
layoff_stagging2 t1 
join layoff_stagging2 t2
	on t1.company=t2.company
    AND t1.location=t2.location
WHERE (t1.industry is null)
and t2.industry is not null;

update layoff_stagging2 t1 
join layoff_stagging2 t2
	on t1.company=t2.company
set t1.industry=t2.industry
WHERE (t1.industry is null )
and t2.industry is not null;
-- Delete null rows
select *
from layoff_stagging2
where total_laid_off is null
and percentage_laid_off is null;

select * from
layoff_stagging2;
delete
from layoff_stagging2
where total_laid_off is null
and percentage_laid_off is null;

alter table layoff_stagging2
drop column row_num;

-- 2.exploratry Data Analysis

select * 
from layoff_stagging2;
-- total layoff by company wise
select company,sum(total_laid_off)
from layoff_stagging2
group by company
order by 2 desc;
-- total layoff by year wise
select year(`date`),sum(total_laid_off)
from layoff_stagging2
group by year(`date`)
order by 1 desc;
-- total layoff by stage wise
select stage,sum(total_laid_off)
from layoff_stagging2
group by stage 
order by 1 desc;
-- total layoff by month wise
select substr(`date`,1,7) as 'month' ,sum(total_laid_off)
from layoff_stagging2
where substr(`date`,1,7) IS NOT NULL
group by substr(`date`,1,7) 
order by 1;
-- rolling total
 with rolling_total as(
select substr(`date`,1,7) as `month` ,sum(total_laid_off) as total_off
from layoff_stagging2
where substr(`date`,1,7) IS NOT NULL
group by `month`
order by 1
 )
select `month`,total_off,sum(total_off) over (order by `month`) as rolling_total
from rolling_total;
-- company total laid-off by year wise
select company,year(`date`),sum(total_laid_off)
from layoff_stagging2
group by company,year(`date`)
order by 3 desc;
-- company total laid-off by year wise with top 5 ranks(rank is given based on highsht laid off by company)
with company_year(company,years,total_laid_off) as
(
	select company,year(`date`),sum(total_laid_off)
	from layoff_stagging2
	group by company,year(`date`)
),company_year_rank as 
(
select *,dense_rank() over (partition by years order by total_laid_off desc ) as ranking
from company_year
where years is not null
)
select * from company_year_rank
where ranking<=5;



