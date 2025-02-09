/*
Finding out what are the most optimal skills to learn (high demand and high-paying)
*/

SELECT
    skills_dim.skills,
    COUNT(skills_job_dim.skill_id) AS num_jobs_listed,
    ROUND(AVG(salary_year_avg),2) AS average_skill_pay
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_dim.skill_id= skills_job_dim.skill_id
WHERE
    --job_country = 'Australia' AND
    job_title LIKE '%Data Analyst%' AND
    salary_year_avg IS NOT NULL
GROUP BY skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.skill_id) >= 524 --Skill listed to at least 10% of jobs
ORDER BY AVG(salary_year_avg) DESC

[
  {
    "skills": "python",
    "count": "1890",
    "avg": "103520.014329117063"
  },
  {
    "skills": "r",
    "count": "1124",
    "avg": "101116.189877112989"
  },
  {
    "skills": "tableau",
    "count": "1826",
    "avg": "100809.654880887185"
  },
  {
    "skills": "sql",
    "count": "3245",
    "avg": "99083.491811922188"
  },
  {
    "skills": "power bi",
    "count": "1084",
    "avg": "93875.585796961485"
  },
  {
    "skills": "excel",
    "count": "2089",
    "avg": "88941.306099284945"
  }
]


-- I wanted to find out how many jobs total there where so I could set a comfortable minimum job postings a skill needs
SELECT COUNT(*)
FROM job_postings_fact
WHERE
    --job_country = 'Australia' AND
    job_title LIKE '%Data Analyst%' AND
    salary_year_avg IS NOT NULL

[
  {
    "count": "5240"
  }
]