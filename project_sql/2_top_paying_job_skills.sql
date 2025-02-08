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
    jpf.salary_year_avg IS NOT NULL
ORDER BY jpf.salary_year_avg DESC
LIMIT 50
)

SELECT 
    skills_dim.skills,
    Count(skills_dim.skills),
    ROUND((count(skills_dim.skills)::NUMERIC * 100 / (SELECT count(*) FROM jobs)::NUMERIC),2) AS Percent_of_total_jobs
FROM (
SELECT *
FROM jobs
INNER JOIN skills_job_dim ON jobs.job_id = skills_job_dim.job_id) AS job_skills
LEFT JOIN skills_dim ON skills_dim.skill_id = job_skills.skill_id
GROUP BY skills_dim.skills
ORDER BY count(skills_dim.skills) DESC
LIMIT 15
/*
Results of above Query on data set
[
  {
    "skills": "python",
    "count": "29",
    "percent_of_total_jobs": "58.00"
  },
  {
    "skills": "sql",
    "count": "28",
    "percent_of_total_jobs": "56.00"
  },
  {
    "skills": "tableau",
    "count": "19",
    "percent_of_total_jobs": "38.00"
  },
  {
    "skills": "r",
    "count": "18",
    "percent_of_total_jobs": "36.00"
  },
  {
    "skills": "excel",
    "count": "8",
    "percent_of_total_jobs": "16.00"
  },
  {
    "skills": "sas",
    "count": "8",
    "percent_of_total_jobs": "16.00"
  },
  {
    "skills": "power bi",
    "count": "7",
    "percent_of_total_jobs": "14.00"
  },
  {
    "skills": "snowflake",
    "count": "5",
    "percent_of_total_jobs": "10.00"
  },
  {
    "skills": "spark",
    "count": "5",
    "percent_of_total_jobs": "10.00"
  },
  {
    "skills": "aws",
    "count": "5",
    "percent_of_total_jobs": "10.00"
  },
  {
    "skills": "pandas",
    "count": "5",
    "percent_of_total_jobs": "10.00"
  },
  {
    "skills": "express",
    "count": "4",
    "percent_of_total_jobs": "8.00"
  },
  {
    "skills": "git",
    "count": "4",
    "percent_of_total_jobs": "8.00"
  },
  {
    "skills": "oracle",
    "count": "4",
    "percent_of_total_jobs": "8.00"
  },
  {
    "skills": "go",
    "count": "4",
    "percent_of_total_jobs": "8.00"
  }
]
*/

/*
Optimising query and also filtering according to my interests 
*/

SELECT
    skills_dim.skills,
    count(skills_dim.skills)
FROM skills_job_dim
INNER JOIN job_postings_fact ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_postings_fact.job_country = 'Australia' AND
    job_postings_fact.job_title_short = 'Data Analyst'
GROUP BY skills_dim.skills
ORDER BY count(skills_dim.skills) DESC
LIMIT 20


/*
Here are the results in json format:

skill = skills listed
count = how many of the filtered jobs listed the skill

[
  {
    "skills": "sql",
    "count": "772"
  },
  {
    "skills": "python",
    "count": "437"
  },
  {
    "skills": "power bi",
    "count": "398"
  },
  {
    "skills": "excel",
    "count": "390"
  },
  {
    "skills": "tableau",
    "count": "329"
  },
  {
    "skills": "r",
    "count": "269"
  },
  {
    "skills": "sas",
    "count": "196"
  },
  {
    "skills": "azure",
    "count": "144"
  },
  {
    "skills": "aws",
    "count": "117"
  },
  {
    "skills": "go",
    "count": "111"
  },
  {
    "skills": "sql server",
    "count": "100"
  },
  {
    "skills": "snowflake",
    "count": "82"
  },
  {
    "skills": "word",
    "count": "76"
  },
  {
    "skills": "oracle",
    "count": "69"
  },
  {
    "skills": "sap",
    "count": "63"
  },
  {
    "skills": "jira",
    "count": "56"
  },
  {
    "skills": "flow",
    "count": "54"
  },
  {
    "skills": "alteryx",
    "count": "54"
  },
  {
    "skills": "databricks",
    "count": "47"
  },
  {
    "skills": "dax",
    "count": "47"
  }
]

*/