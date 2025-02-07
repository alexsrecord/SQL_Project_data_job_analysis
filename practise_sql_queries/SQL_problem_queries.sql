
--find number of job postings per month
SELECT
    month,
    count(*)
FROM
    job_postings_fact AS JP,
LEFT JOIN (extract(month FROM job_posted_date) AS month)
WHERE
    JP.job_title like '%data%analyst%'
GROUP BY
    month


SELECT
    job_title_short,
    month,
    count(month)
FROM job_postings_fact,extract(month FROM job_posted_date) AS month
group by job_title_short,month
order by
    count(month) desc


SELECT
    job_title_short,
    month,
    count(month)
FROM job_postings_fact,extract(month FROM job_posted_date) AS month
WHERE job_title_short = 'Data Analyst'
group by job_title_short,month
order by
    count(month) desc


SELECT
    job_schedule_type,
    avg(salary_year_avg),
    avg(salary_hour_avg)
FROM job_postings_fact
WHERE job_posted_date >= '2023-06-02'
GROUP BY job_schedule_type

SELECT 
    extract(year FROM job_posted_date) AS year,
    count(*)
FROM job_postings_fact
group by year

SELECT
    extract(month FROM job_posted_date) AS month,
    count(job_id)
FROM job_postings_fact
WHERE extract(year FROM job_posted_date) = '2023'
group by month

SELECT
    company_dim.name
FROM job_postings_fact AS jpf
LEFT JOIN company_dim ON company_dim.company_id = jpf.company_id
WHERE extract(month FROM jpf.job_posted_date) in (4,5,6)
AND jpf.job_health_insurance IS TRUE
GROUP BY company_dim.name

Create table table_name AS Jan_2023_jobs

-- January 2023
CREATE TABLE Jan_jobs AS (
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(YEAR FROM job_posted_date) = 2023
    AND EXTRACT(MONTH FROM job_posted_date) = 1
);

-- February 2023
CREATE TABLE Feb_jobs AS (
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(YEAR FROM job_posted_date) = 2023
    AND EXTRACT(MONTH FROM job_posted_date) = 2
);

-- March 2023
CREATE TABLE Mar_jobs AS (
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(YEAR FROM job_posted_date) = 2023
    AND EXTRACT(MONTH FROM job_posted_date) = 3
);


--playing with date time manipulation
SELECT 
    job_posted_date,
    job_posted_date at time zone 'utc' at time zone 'aesst' AS aus_time,
    job_posted_date at time zone 'utc' at time zone 'aesst' - job_posted_date AS difference
FROM job_postings_fact
limit 10


--
SELECT
    LOCATION_CAT,
    COUNT(*)
FROM (
SELECT 
    job_title_short,
    CASE 
        WHEN job_location like '%Anywhere%' THEN 'Remote'
        WHEN job_location like 'New York, NY' THEN 'Local'
        ELSE 'ONSITE'
    END AS LOCATION_CAT
FROM job_postings_fact) 
GROUP BY LOCATION_CAT


--band data analyst salary to low, stadard and high using CASE
SELECT
    TEMP.salary_band,
    COUNT(TEMP.salary_band) AS TOTAL
FROM (
SELECT 
    salary_year_avg,
    CASE
        WHEN salary_year_avg < 60000 THEN 'low'
        WHEN salary_year_avg BETWEEN 60000 AND 110000 THEN 'standard'
        WHEN salary_year_avg > 110000 THEN 'high'
        ELSE 'not specified'
    END AS salary_band
FROM job_postings_fact
WHERE job_title_short like 'Data Analyst') AS TEMP
group by TEMP.salary_band
ORDER BY TOTAL


SELECT  
    company_dim.name,
    count(jpf.job_id)
FROM job_postings_fact AS jpf
LEFT JOIN company_dim ON company_dim.company_id = jpf.company_id
group by company_dim.name
order by count(jpf.job_id) desc


(SELECT 
    company_id,
    count(job_id)
FROM job_postings_fact
group by company_id)


SELECT 
    skills_dim.skills,
    skills_count.count
FROM
(SELECT 
    skill_id,
    count(skill_id) AS count
FROM skills_job_dim
group by skill_id) AS skills_count
right join skills_dim ON skills_dim.skill_id = skills_count.skill_id
order by skills_count.count desc
limit 5


SELECT 
    sizing.size,
    count(sizing.size)
FROM
(SELECT 
    job_count.name,
    CASE
        WHEN job_count.job_postings > 50 THEN 'Large' 
        WHEN job_count.job_postings BETWEEN 10 AND 50 THEN 'Medium'
        ELSE 'Small'
    END AS size
FROM 
(SELECT 
    company_dim.name AS name,
    count(job_postings_fact.job_id) AS job_postings
FROM job_postings_fact
LEFT JOIN company_dim ON company_dim.company_id = job_postings_fact.company_id
group by company_dim.company_id) AS job_count) AS sizing
GROUP BY sizing.size
ORDER by sizing.size


-- find the count of remote jobs per skill
--  display top 5 skills in demand for remote jobs 
--  include skills id, name, count of postings requiring the skill

-- number of remote jobs per skill, skills that no job reuqires is not included
With skills_count AS  (SELECT 
    skills_job_dim.skill_id,
    count(*)
FROM  skills_job_dim
LEFT JOIN job_postings_fact ON skills_job_dim.job_id = job_postings_fact.job_id
WHERE job_postings_fact.job_work_FROM_home IS TRUE
AND job_postings_fact.job_title_short ='Data Analyst'
group by skills_job_dim.skill_id
order by count(skills_job_dim.skill_id) desc
limit 5
)

SELECT 
    skills_count.skill_id,
    skills_dim.skills,
    skills_count.count
FROM skills_count 
LEFT JOIN skills_dim ON skills_dim.skill_id = skills_count.skill_id
order by skills_count.count desc


/*
Union example
get the corresponding skill and skill type foreach job position in q1
include those without any skills too
*/

--final results set list job_id and associated skills
SELECT
    job_skills.job_id,
    CASE 
        WHEN skills_dim.skills IS NULL then 'No skills listed'
        ELSE skills_dim.skills
    END AS Skill,
    CASE 
        WHEN skills_dim.type IS NULL then 'No skills listed'
        ELSE skills_dim.type
    END AS Skill_type  
FROM
(SELECT --result set of all job_ids with accompany skills
    q1_jobs.job_id,
    skill_id
FROM
(SELECT -- result set of all job_ids in q1
    job_id
    --salary_year_avg
FROM job_postings_fact
WHERE EXTRACT(month FROM job_posted_date) in (1,2,3)
--AND salary_year_avg > 700000
) AS q1_jobs
LEFT JOIN skills_job_dim ON skills_job_dim.job_id = q1_jobs.job_id)
as job_skills
LEFT JOIN skills_dim ON skills_dim.skill_id = job_skills.skill_id

SELECT 
    job_title_short,
    job_id
FROM Jan_jobs

union all

SELECT
    job_title_short,
    job_id
FROM Feb_jobs

union all

SELECT
    job_title_short,
    job_id
FROM Mar_jobs

/*
Find job posting from the firs tquarter that have a salary greater than 70k
-combine job posting tables from the first quarter of 2023
-get job postings with an average year salara 70k
*/


SELECT 
    job_title_short,
    salary_year_avg,
    job_posted_date
FROM Jan_jobs
WHERE salary_year_avg > 70000

Union all 

SELECT 
    job_title_short,
    salary_year_avg,
    job_posted_date
FROM Feb_jobs
WHERE salary_year_avg > 70000

Union all 

SELECT 
    job_title_short,
    salary_year_avg,
    job_posted_date
FROM Mar_jobs
WHERE salary_year_avg > 70000

