-- This file includes some extra queries I ran that I was curious about

-- This finds the Data Analyst postings and the number of skills listed
-- together with the compensation, postings with no compensation listed were excluded 

SELECT 
    job_postings_fact.job_title,
    job_postings_fact.salary_year_avg,
    COUNT(*) as skill_count
FROM job_postings_fact
LEFT JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
WHERE
    job_postings_fact.salary_year_avg IS NOT NULL AND
    job_title LIKE '%Data Analyst%'
GROUP BY job_postings_fact.job_id
ORDER BY count(*) DESC
LIMIT 10


/*
Result set of the 10 most skills intensive Data Analyst roles and how much they pay
[
  {
    "job_title": "Senior - Data Analyst",
    "salary_year_avg": "160515.0",
    "skill_count": "21"
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
    "job_title": "Senior Data Analyst",
    "salary_year_avg": "140000.0",
    "skill_count": "17"
  },
  {
    "job_title": "Data Analyst - OpenData Europe",
    "salary_year_avg": "105000.0",
    "skill_count": "17"
  },
  {
    "job_title": "Senior Data Analyst",
    "salary_year_avg": "87027.5",
    "skill_count": "17"
  },
  {
    "job_title": "Senior Data Analyst",
    "salary_year_avg": "130000.0",
    "skill_count": "16"
  },
  {
    "job_title": "Lead Data Analyst",
    "salary_year_avg": "112500.0",
    "skill_count": "16"
  },
  {
    "job_title": "Data Analyst",
    "salary_year_avg": "100000.0",
    "skill_count": "16"
  },
  {
    "job_title": "Data Analyst/PH SME",
    "salary_year_avg": "75000.0",
    "skill_count": "16"
  }
]
*/




/*
I got interested in which companies wanted the most skills from their 
employees / most descriptive in their postings
*/

-- this finds every job posting in the data set together with the company which posted it
WITH company_postings AS (
    SELECT 
        name,
        job_id
    FROM job_postings_fact
    INNER JOIN company_dim ON company_dim.company_id = job_postings_fact.company_id
),

-- this gives each job postings and number of skills listed in them
posting_skills AS (
    SELECT 
        job_postings_fact.job_id,
        COUNT(*) AS skills
    FROM job_postings_fact
    LEFT JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
    GROUP BY job_postings_fact.job_id
)
-- this combines the two tables above and finds and lists the number
-- of jobs posted, total skills of those job and avg skills per posting
SELECT 
    name AS Company,
    COUNT(*) AS jobs_posted,
    SUM(skills) AS total_skills,
    ROUND(AVG(SKILLS),2)
from company_postings
INNER JOIN posting_skills on posting_skills.job_id= company_postings.job_id
GROUP BY name
ORDER BY AVG(SKILLS) DESC
--LIMIT 10

/*
Wow, one company is asking for an average of 44 skills for their employees 
[
  {
    "company": "Techversant Infotech Pvt Ltd",
    "jobs_posted": "15",
    "total_skills": "664",
    "avg_skills_listed_per_job": "44.27"
  },
  {
    "company": "Whatjobsa",
    "jobs_posted": "1",
    "total_skills": "42",
    "avg_skills_listed_per_job": "42.00"
  },
  {
    "company": "THE BOSTON CONSULTING GROUP",
    "jobs_posted": "2",
    "total_skills": "82",
    "avg_skills_listed_per_job": "41.00"
  },
  {
    "company": "PT Telkom Indonesia (Persero) Tbk",
    "jobs_posted": "1",
    "total_skills": "39",
    "avg_skills_listed_per_job": "39.00"
  },
  {
    "company": "Boston Consulting Group, Inc.",
    "jobs_posted": "1",
    "total_skills": "39",
    "avg_skills_listed_per_job": "39.00"
  },
  {
    "company": "Cardinal Delta",
    "jobs_posted": "2",
    "total_skills": "69",
    "avg_skills_listed_per_job": "34.50"
  },
  {
    "company": "Altar",
    "jobs_posted": "3",
    "total_skills": "96",
    "avg_skills_listed_per_job": "32.00"
  },
  {
    "company": "Altar.io",
    "jobs_posted": "16",
    "total_skills": "511",
    "avg_skills_listed_per_job": "31.94"
  },
  {
    "company": "Pladis Foods Limited",
    "jobs_posted": "3",
    "total_skills": "93",
    "avg_skills_listed_per_job": "31.00"
  },
  {
    "company": "Verypossible",
    "jobs_posted": "4",
    "total_skills": "122",
    "avg_skills_listed_per_job": "30.50"
  }
]
*/

-- I didnt believe the number of skills listed so I needed to double check
-- A quick check with just the skills_job_dim table
select 
    job_id,
    count(*) as skills
from skills_job_dim
GROUP BY job_id
ORDER by skills DESC
LIMIT 20

/*
Results: with the top job listing 53 skills it seems pausible

[
  {
    "job_id": 231519,
    "skills": "53"
  },
  {
    "job_id": 559452,
    "skills": "52"
  },
  {
    "job_id": 600918,
    "skills": "51"
  },
  {
    "job_id": 649332,
    "skills": "51"
  },
  {
    "job_id": 640511,
    "skills": "50"
  },
  {
    "job_id": 1426156,
    "skills": "49"
  },
  {
    "job_id": 505374,
    "skills": "48"
  },
  {
    "job_id": 1040625,
    "skills": "48"
  },
  {
    "job_id": 1716764,
    "skills": "45"
  },
  {
    "job_id": 518928,
    "skills": "44"
  },
  {
    "job_id": 1624880,
    "skills": "44"
  },
  {
    "job_id": 1415748,
    "skills": "43"
  },
  {
    "job_id": 1634821,
    "skills": "43"
  },
  {
    "job_id": 249587,
    "skills": "42"
  },
  {
    "job_id": 143368,
    "skills": "42"
  },
  {
    "job_id": 1104991,
    "skills": "42"
  },
  {
    "job_id": 579087,
    "skills": "42"
  },
  {
    "job_id": 378063,
    "skills": "42"
  },
  {
    "job_id": 403168,
    "skills": "42"
  },
  {
    "job_id": 552269,
    "skills": "42"
  }
]

*/


-- quick and dirty search of the total average skill per job
select 
    count(*) AS total_jobs_posted,
    sum(skills) AS total_skills_listed,
    ROUND(sum(skills)/count(*),2) as avg_skill_per_job
FROM (
    select 
        job_id,
        count(*) as skills
    FROM skills_job_dim
    GROUP BY job_id
    ORDER by skills DESC) as job_skills

/*
[
  {
    "total_jobs_posted": "670364",
    "total_skills_listed": "3669604",
    "avg_skill_per_job": "5.47"
  }
]
*/