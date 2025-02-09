/*
Finding out which skills pay the most on average for a data Analyst
*/

SELECT 
  skills,
  --SUM(salary_year_avg),
  COUNT(skills) AS job_postings,
  ROUND(AVG(salary_year_avg),2) AS skill_avg_pay
FROM skills_job_dim
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
INNER JOIN job_postings_fact ON job_postings_fact.job_id = skills_job_dim.job_id
WHERE 
    salary_year_avg IS NOT NULL AND
    job_title like '%Data Analyst%'
GROUP BY skills_dim.skills
ORDER BY AVG(salary_year_avg) DESC
LIMIT 10

/*
[
  {
    "skills": "yarn",
    "sum": "340000.0",
    "count": "1",
    "skill_avg_pay": "340000.00"
  },
  {
    "skills": "dplyr",
    "sum": "392500.0",
    "count": "2",
    "skill_avg_pay": "196250.00"
  },
  {
    "skills": "fastapi",
    "sum": "185000.0",
    "count": "1",
    "skill_avg_pay": "185000.00"
  },
  {
    "skills": "golang",
    "sum": "323500.0",
    "count": "2",
    "skill_avg_pay": "161750.00"
  },
  {
    "skills": "couchbase",
    "sum": "160515.0",
    "count": "1",
    "skill_avg_pay": "160515.00"
  },
  {
    "skills": "vmware",
    "sum": "147500.0",
    "count": "1",
    "skill_avg_pay": "147500.00"
  },
  {
    "skills": "perl",
    "sum": "2980345.5",
    "count": "21",
    "skill_avg_pay": "141921.21"
  },
  {
    "skills": "dynamodb",
    "sum": "280000.0",
    "count": "2",
    "skill_avg_pay": "140000.00"
  },
  {
    "skills": "twilio",
    "sum": "277000.0",
    "count": "2",
    "skill_avg_pay": "138500.00"
  },
  {
    "skills": "datarobot",
    "sum": "257985.5",
    "count": "2",
    "skill_avg_pay": "128992.75"
  }
]
*/