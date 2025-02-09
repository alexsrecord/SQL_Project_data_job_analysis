# SQL Data Analysis Project

## Introduction

This repository contains SQL queries and analyses conducted as part of my learning journey through Luke B's SQL course. The goal of this project was to apply SQL concepts to real-world datasets, extract meaningful insights, and refine my querying skills.

🔗 Check out the SQL Queries:  [project_sql folder](/project_sql/)

## Background

This project is based on a dataset provided in Luke B's course, which was scraped from various job postings. The objective was to analyze job market trends, particularly for data-related roles, and answer key questions such as:

- What are the highest-paying jobs?
- Which skills are most in demand for Data Analysts?

While the dataset covers global job postings, it primarily focuses on the U.S. job market and contains data from 2023, making it slightly outdated for current trends in Australia.

📘 Luke Barousse's Course: [Course Link](https://www.lukebarousse.com/sql)

## Tools Used

- **SQL**: Core technology used for querying and data analysis
- **PostgreSQL**: Chosen database management system
- **Visual Studio Code**: Preferred text editor for writing SQL queries
- **Git & GitHub**: Version control and project sharing

## Analysis
The project explores various aspects of job market data, including:

1. Top-paying jobs – Identifying roles with the highest salaries
2. Skills required for top-paying jobs – Understanding the key qualifications for high-income roles
3. Most in-demand skills – Determining the most frequently mentioned skills in job postings
4. Top-paying skills – Identifying which skills offer the best compensation
5. Optimal skills to learn – Finding the intersection of high demand and high salary skills

### 1. Top-paying jobs
This query pulls key information and filters on 'Data Analyst roles that I'm more interested in. I joined the job_postings_fact table with another company_dim to include the company names.

```sql
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

ORDER BY salary_year_avg DESC
LIMIT 10    
```
#### Results:
| **Company**                   | **Job Title**                                        | **Listed Salary** | **Country**      | **Employment** |
|-------------------------------|------------------------------------------------------|-------------------|------------------|----------------|
| Mantys                        | Data Analyst                                        | 650,000.0         | India            | Full-time      |
| ЛАНИТ                          | Data base administrator                             | 400,000.0         | Belarus          | Full-time      |
| Torc Robotics                 | Director of Safety Data Analysis                    | 375,000.0         | United States    | Full-time      |
| Illuminate Mission Solutions   | HC Data Analyst, Senior                             | 375,000.0         | United States    | Full-time      |
| Citigroup, Inc                | Head of Infrastructure Management & Data Analytics  | 375,000.0         | United States    | Full-time      |
| Illuminate Mission Solutions   | Sr Data Analyst                                     | 375,000.0         | United States    | Full-time      |
| Care.com                       | Head of Data Analytics                              | 350,000.0         | United States    | Full-time      |
| Anthropic                     | Data Analyst                                        | 350,000.0         | United States    | Full-time      |
| Meta                          | Director of Analytics                               | 336,500.0         | United States    | Full-time      |
| OpenAI                        | Research Scientist                                  | 285,000.0         | United States    | Full-time      |

### 2. Skills required for top-paying jobs
This extends the previous query as a CTE (Common Table Expression) and expands the results to include the top 50 jobs. Additionally, it includes the percentage of job postings that list each skill.

```sql
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

```
#### Results

| **Skills**   | **Count** | **Percent of Total Jobs** |
|--------------|-----------|---------------------------|
| Python       | 28        | 56.00%                    |
| SQL          | 27        | 54.00%                    |
| R            | 19        | 38.00%                    |
| Tableau      | 18        | 36.00%                    |
| Excel        | 9         | 18.00%                    |
| Power BI     | 7         | 14.00%                    |
| SAS          | 6         | 12.00%                    |
| Spark        | 6         | 12.00%                    |
| Pandas       | 5         | 10.00%                    |
| AWS          | 4         | 8.00%                     |


### 3. Most In-Demand Skills

This query identifies the most frequently listed skills in job postings. It is filtered to focus on the Australian market. I used an INNER JOIN here to ensure complete records.

```sql
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
```
#### Results:
| **Skills**   | **Count** |
|--------------|-----------|
| SQL          | 772       |
| Python       | 437       |
| Power BI     | 398       |
| Excel        | 390       |
| Tableau      | 329       |
| R            | 269       |
| SAS          | 196       |
| Azure        | 144       |
| AWS          | 117       |
| Go           | 111       |


### 4. top paying skills
This query identifies which skill pays the best for roles associated with a Data Analyst position. I have also included the number of job postings for each skill to provide insight into how popular or in-demand the skill is.


```sql
SELECT 
  skills,
  SUM(salary_year_avg),
  COUNT(skills),
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
```

#### Results:
| **Skills**   | **Job Postings** | **Skill Avg Pay** |
|--------------|------------------|-------------------|
| Yarn         | 1                | 340,000.00        |
| Dplyr        | 2                | 196,250.00        |
| FastAPI      | 1                | 185,000.00        |
| Golang       | 2                | 161,750.00        |
| Couchbase    | 1                | 160,515.00        |
| VMware       | 1                | 147,500.00        |
| Perl         | 21               | 141,921.21        |
| DynamoDB     | 2                | 140,000.00        |
| Twilio       | 2                | 138,500.00        |
| DataRobot    | 2                | 128,992.75        |


### 5. Optimal skills to learn
This query combines the previous two results to determine which skills are both in high demand and offer high pay. To focus on skills that are not niche, I have set a threshold that the skills must appear in at least 10% of job postings.

```sql
SELECT
    skills_dim.skills,
    COUNT(skills_job_dim.skill_id),
    AVG(salary_year_avg)
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

```

Results:
| **Skills**   | **Num Jobs Listed** | **Average Skill Pay** |
|--------------|---------------------|-----------------------|
| Python       | 1890                | 103,520.01            |
| R            | 1124                | 101,116.19            |
| Tableau      | 1826                | 100,809.65            |
| SQL          | 3245                | 99,083.49             |
| Power BI     | 1084                | 93,875.59             |
| Excel        | 2089                | 88,941.31             |


## What I learned
I cannot vouch for the accuracy of the dataset as it was provided to me, however based on the data set I have listed some insights below:

#### Analysis Insights

- Top-paying jobs: The highest-paying Data Analyst roles are with companies like Mantys (India), offering salaries as high as $650,000.
- Skills required for top-paying jobs: Key skills for high-paying Data Analyst roles include Python, SQL, and R, with Python being the most mentioned in job postings (56%).
- Most in-demand skills: The most frequently listed skills in Data Analyst job postings in Australia include SQL, Python, and Power BI.
- Top-paying skills: Some of the highest-paying skills for Data Analyst roles include Yarn, Dplyr, and FastAPI, with Yarn offering an average pay of $340,000.
- Optimal skills to learn: Skills that are both in high demand and offer high pay include Python, R, and Tableau, with Python leading in both job listings and average pay ($103,520).

### Closing Thoughts

In this course, I gained hands-on experience with SQL and database management. Here are some key takeaways:

- Learned to write complex SQL queries to analyze and extract insights from datasets.
- Gained practical experience in identifying trends and patterns in data.
- Enhanced my ability to work with large datasets and spot outliers.
- This project improved both my SQL proficiency and my ability to derive actionable insights efficiently.

One interesting outlier I found was that while most companies list less than 10 skills per posting, some companies list an average of 30-40 skills!




