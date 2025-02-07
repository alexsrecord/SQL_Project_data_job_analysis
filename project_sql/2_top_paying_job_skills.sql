/*
Find out what the skills of the top paying Data Analyst jobs are
This builds on the first query. 
Result set of below finds what the skills listed are for the jobs filtered within the CTE
Current CTE filters on data analyst jobs in australia
*/

WITH jobs AS (
SELECT 
    jpf.job_id, -- added to relate to skills table
    company_dim.name AS Company,
    jpf.job_title AS Job_title,
    jpf.salary_year_avg AS Listed_Salary,
    jpf.job_country AS Country,
    jpf.job_schedule_type AS Employment
FROM job_postings_fact AS jpf
LEFT JOIN company_dim ON company_dim.company_id = jpf.company_id
WHERE 
    jpf.job_title_short = 'Data Analyst' AND
    --jpf.salary_year_avg IS NOT NULL AND
    --jpf.job_location LIKE 'Anywhere' AND
    job_country = 'Australia'
ORDER BY salary_year_avg DESC
--LIMIT 10
)

SELECT 
    skills_dim.skills,
    Count(skills_dim.skills),
    count(skills_dim.skills)::FLOAT*100 / (SELECT count(*) FROM jobs)::FLOAT AS PERCENT
FROM (
SELECT *
FROM jobs
INNER JOIN skills_job_dim ON jobs.job_id = skills_job_dim.job_id) AS job_skills
LEFT JOIN skills_dim ON skills_dim.skill_id = job_skills.skill_id
GROUP BY skills_dim.skills
ORDER BY count(skills_dim.skills) DESC