/*
Find out the total how many skills each job is asking for and the compensation
*/

SELECT 
    job_postings_fact.job_title,
    job_postings_fact.salary_year_avg,
    count(*) as skill_count
FROM job_postings_fact
LEFT JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
WHERE
    job_postings_fact.salary_year_avg IS NOT NULL AND
    job_title_short = 'Data Analyst'
GROUP BY job_postings_fact.job_id
ORDER BY count(*) DESC
LIMIT 20


/*

the top jobs that have listed the most skills
[
  {
    "job_title": "Senior - Data Analyst",
    "salary_year_avg": "160515.0",
    "skill_count": "21"
  },
  {
    "job_title": "Technical Data Architect - Healthcare",
    "salary_year_avg": "165000.0",
    "skill_count": "20"
  },
  {
    "job_title": "Data Analyst",
    "salary_year_avg": "67897.0",
    "skill_count": "20"
  },
  {
    "job_title": "Staff Data Analyst",
    "salary_year_avg": "180000.0",
    "skill_count": "18"
  },
  {
    "job_title": "Data Science Associate",
    "salary_year_avg": "72900.0",
    "skill_count": "18"
  },
  {
    "job_title": "Business Intelligence Engineer, Analytics",
    "salary_year_avg": "99150.0",
    "skill_count": "18"
  },
  {
    "job_title": "Data Analyst - OpenData Europe",
    "salary_year_avg": "105000.0",
    "skill_count": "17"
  },
  {
    "job_title": "Data Architect",
    "salary_year_avg": "163782.0",
    "skill_count": "16"
  },
  {
    "job_title": "Data Analytics- USDS",
    "salary_year_avg": "204584.5",
    "skill_count": "16"
  },
  {
    "job_title": "Data Analyst/PH SME",
    "salary_year_avg": "75000.0",
    "skill_count": "16"
  },
  {
    "job_title": "2023-2024 Information Technology – Information and Analytics Full Time",
    "salary_year_avg": "107000.0",
    "skill_count": "16"
  },
  {
    "job_title": "Lead Data Analyst",
    "salary_year_avg": "112500.0",
    "skill_count": "16"
  },
  {
    "job_title": "Data Architect",
    "salary_year_avg": "165000.0",
    "skill_count": "16"
  },
  {
    "job_title": "Data Analyst",
    "salary_year_avg": "100000.0",
    "skill_count": "16"
  },
  {
    "job_title": "Data Analyst",
    "salary_year_avg": "100000.0",
    "skill_count": "16"
  },
  {
    "job_title": "Data Analyst",
    "salary_year_avg": "100000.0",
    "skill_count": "16"
  },
  {
    "job_title": "Quality Data Analyst",
    "salary_year_avg": "118640.0",
    "skill_count": "15"
  },
  {
    "job_title": "Data Analyst II - BIS",
    "salary_year_avg": "115000.0",
    "skill_count": "15"
  },
  {
    "job_title": "Data Architect 2023",
    "salary_year_avg": "165000.0",
    "skill_count": "15"
  },
  {
    "job_title": "Data Analyst II - BIS",
    "salary_year_avg": "115000.0",
    "skill_count": "15"
  }
]
*/