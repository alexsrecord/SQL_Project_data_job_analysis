-- Here we are trying to find out what is the most listed skills for Data analyst job postings
-- which can be thought as the demand for these skills

SELECT 
    skills,
    COUNT(skills_dim.skill_id) as demand
FROM skills_job_dim
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
INNER JOIN job_postings_fact ON job_postings_fact.job_id = skills_job_dim.job_id
WHERE job_postings_fact.job_title LIKE '%Data Analyst%'
GROUP BY skills_dim.skill_id
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

SELECT
    skills_dim.skills,
    COUNT(skills_dim.skills)
FROM skills_job_dim
INNER JOIN job_postings_fact ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_postings_fact.job_country = 'Australia' AND
    job_postings_fact.job_title_short = 'Data Analyst'
GROUP BY skills_dim.skills
ORDER BY count(skills_dim.skills) DESC
LIMIT 10


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