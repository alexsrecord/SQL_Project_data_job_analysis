/* Question : what are the top-paying data analyst job?
- identify the top 10 highest paying data analyst roles
- focus on job posting with specified salaries (dont include nulls)
- include what company has posted the job
*/

SELECT 
    company_dim.name AS Company,
    jpf.job_title AS Job_title,
    jpf.salary_year_avg AS Listed_Salary,
    jpf.job_country AS Country,
    jpf.job_schedule_type AS Employment
FROM job_postings_fact AS jpf
LEFT JOIN company_dim ON company_dim.company_id = jpf.company_id
WHERE 
    jpf.job_title_short LIKE 'Data Analyst' AND
    jpf.salary_year_avg IS NOT NULL 
    --jpf.job_location LIKE 'Anywhere' AND
    --job_country LIKE 'Australia'
ORDER BY salary_year_avg DESC
LIMIT 10    


/*
[
  {
    "company": "Mantys",
    "job_title": "Data Analyst",
    "listed_salary": "650000.0",
    "country": "India",
    "employment": "Full-time"
  },
  {
    "company": "ЛАНИТ",
    "job_title": "Data base administrator",
    "listed_salary": "400000.0",
    "country": "Belarus",
    "employment": "Full-time"
  },
  {
    "company": "Torc Robotics",
    "job_title": "Director of Safety Data Analysis",
    "listed_salary": "375000.0",
    "country": "United States",
    "employment": "Full-time"
  },
  {
    "company": "Illuminate Mission Solutions",
    "job_title": "HC Data Analyst , Senior",
    "listed_salary": "375000.0",
    "country": "United States",
    "employment": "Full-time"
  },
  {
    "company": "Citigroup, Inc",
    "job_title": "Head of Infrastructure Management & Data Analytics - Financial...",
    "listed_salary": "375000.0",
    "country": "United States",
    "employment": "Full-time"
  },
  {
    "company": "Illuminate Mission Solutions",
    "job_title": "Sr Data Analyst",
    "listed_salary": "375000.0",
    "country": "United States",
    "employment": "Full-time"
  },
  {
    "company": "Care.com",
    "job_title": "Head of Data Analytics",
    "listed_salary": "350000.0",
    "country": "United States",
    "employment": "Full-time"
  },
  {
    "company": "Anthropic",
    "job_title": "Data Analyst",
    "listed_salary": "350000.0",
    "country": "United States",
    "employment": "Full-time"
  },
  {
    "company": "Meta",
    "job_title": "Director of Analytics",
    "listed_salary": "336500.0",
    "country": "United States",
    "employment": "Full-time"
  },
  {
    "company": "OpenAI",
    "job_title": "Research Scientist",
    "listed_salary": "285000.0",
    "country": "United States",
    "employment": "Full-time"
  }
]
*/