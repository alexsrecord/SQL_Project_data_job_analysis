/*
I got interested in which companies wanted the most skills from their 
employees / most descriptive in their postings
*/

-- this finds gives the company and the number jobs they posted
WITH company_postings AS (
    SELECT 
        name,
        job_id
    FROM job_postings_fact
    INNER JOIN company_dim ON company_dim.company_id = job_postings_fact.company_id
),

-- this gives the job postings and number of skills listed
posting_skills AS (
    SELECT 
        job_postings_fact.job_id,
        count(*) AS skills
    FROM job_postings_fact
    LEFT JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
    GROUP BY job_postings_fact.job_id
)
-- this combines the two tables above and finds and lists the number
-- of jobs posted, total skills of those job and avg skills per posting
SELECT 
    name AS Company,
    count(*) AS jobs_posted,
    sum(skills) AS total_skills,
    round((sum(skills) / count(*)),2) AS Avg_skills_listed_per_job
from company_postings
INNER JOIN posting_skills on posting_skills.job_id= company_postings.job_id
GROUP BY name
ORDER BY Avg_skills_listed_per_job DESC
--LIMIT 10

/*
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
    count(*) AS total_jobs,
    sum(skills) AS total_skills,
    ROUND(sum(skills)/count(*),2) as avg_skill_per_job
FROM (
    select 
        job_id,
        count(*) as skills
    FROM skills_job_dim
    GROUP BY job_id
    ORDER by skills DESC) as job_skills

