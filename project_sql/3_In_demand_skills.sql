-- Here we are trying to find out what is the most listed skills for Data analyst job postings
-- which can be thought as the demand for these skills

SELECT 
    skills,
    COUNT(skills) as demand
FROM skills_job_dim
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
INNER JOIN job_postings_fact ON job_postings_fact.job_id = skills_job_dim.job_id
WHERE job_postings_fact.job_title LIKE '%Data Analyst%'
GROUP BY skills
ORDER BY demand DESC
LIMIT 10

/*
[
  {
    "skills": "sql",
    "demand": "84970"
  },
  {
    "skills": "excel",
    "demand": "57915"
  },
  {
    "skills": "python",
    "demand": "52124"
  },
  {
    "skills": "tableau",
    "demand": "44310"
  },
  {
    "skills": "power bi",
    "demand": "35187"
  },
  {
    "skills": "r",
    "demand": "27692"
  },
  {
    "skills": "sas",
    "demand": "24790"
  },
  {
    "skills": "powerpoint",
    "demand": "11520"
  },
  {
    "skills": "word",
    "demand": "11026"
  },
  {
    "skills": "sap",
    "demand": "8949"
  }
]
*/