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
    jpf.salary_year_avg IS NOT NULL AND
    --jpf.job_location LIKE 'Anywhere' AND
    job_country LIKE 'Australia'
ORDER BY salary_year_avg DESC
LIMIT 10    
