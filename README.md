# Data Jobs Analysis

## Introduction

This project explores the Data Analyst job market using job posting data from 2023. The goal is to identify the highest-paying Data Analyst roles, the most in-demand skills, and where salary and skill demand overlap.

As I continue building my career in Data Analytics, I wanted to better understand which skills are most valuable in the job market and where developing them could create the most opportunities.

If you want to explore the SQL queries behind this analysis, [check them out here](/project_sql/).

## Background

My goal is to understandwhich skills are most in demand, which are associated with higher salaries, and where these two areas overlap.

The data comes from a SQL course and contains information on job titles, salaries, locations, and required skills across Data Analyst job postings from 2023.

### The questions I wanted to answer through my SQL queries were:

1. What are the top-paying Data Analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for Data Analysts?
4. Which skills are associated with higher salaries?
5. **What are the most optimal skills to learn?**

## Tools I Used 

![SQL](https://img.shields.io/badge/SQL-4479A1?style=flat&logo=sql&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=flat&logo=postgresql&logoColor=white)
![Visual Studio Code](https://img.shields.io/badge/Visual%20Studio%20Code-007ACC?style=flat&logo=visualstudiocode&logoColor=white)
![GitHub](https://img.shields.io/badge/GitHub-181717?style=flat&logo=github&logoColor=white)

- **SQL:** Used to query the database and uncover insights from the job posting data.
- **PostgreSQL:** Used to create and manage the database containing the job posting data.
- **Visual Studio Code:** Used as my main environment for writing and running SQL queries.
- **GitHub:** Used for version control and to share the SQL queries and findings from the analysis.

## The Analysis

### 1. Top Paying Data Analyst Jobs
To identify the highest-paying Data Analyst roles, I filtered job postings by salary and location, focusing on remote positions and jobs available in Mexico. This query highlights the top-paying opportunities in the field.

```SQL
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim
    ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    (job_location LIKE '%Mexico' OR job_work_from_home = TRUE) AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10
;
```

**Key Findings:**
- The highest-paying role in the dataset is a Data Analyst position at Mantys, with an annual salary of $650,000.
- All 10 positions are listed as full-time roles.
- Although the query included positions in Mexico, none of the top 10 results are based in Mexico; all are listed as remote.

### 2. Skills for Top Paying Jobs

To identify the skills required for the highest-paying Data Analyst roles, I combined the top-paying jobs with their associated skills. This query shows which skills are most common among these high-paying positions.

```SQL
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN
        company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        (job_location LIKE '%Mexico' OR job_work_from_home = TRUE) AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT
    top_paying_jobs.*,
    skills
FROM
    top_paying_jobs
INNER JOIN
    skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC
;
```

**Key Findings:**
- **SQL** appears in 8 of the 8 top-paying jobs that list skills, making it the most consistent skill in this group.
- **Python** appears in 7 of these jobs, while **Tableau** appears in 6, showing strong demand for both programming and data visualization skills.
- Other skills such as **R, Snowflake, Pandas, and Excel** also appear across several of the highest-paying roles, although less consistently.

### 3. In-Demand Skills for Data Analysts

To identify the most in-demand skills for Data Analysts, I counted how often each skill appeared across job postings. This query highlights the skills most frequently requested by employers.

```SQL
SELECT
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM
    job_postings_fact
INNER JOIN
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    (job_location LIKE '%Mexico' OR job_work_from_home = TRUE)
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 10
;
```

**Key Findings:**
- **SQL** is the most in-demand skill, appearing in 8,472 job postings, well ahead of the other skills.
- **Excel, Python, and Tableau** follow as the next most requested skills, with 5,729, 5,098, and 4,353 postings respectively.
- The results show a strong combination of **data querying, analysis, and visualization skills**, with SQL, Excel, Python, Tableau, and Power BI making up the top five.


| Rank | Skill | Demand Count |
|---:|---|---:|
| 1 | SQL | 8,472 |
| 2 | Excel | 5,729 |
| 3 | Python | 5,098 |
| 4 | Tableau | 4,353 |
| 5 | Power BI | 3,203 |

### 4. Top Paying Skills

To identify the skills associated with higher salaries, I calculated the average annual salary for Data Analyst roles requiring each skill. This query highlights which skills are associated with the highest average salaries in the dataset.

```SQL
SELECT
    skills,
    ROUND(AVG(salary_year_avg),0) AS avg_salary 
FROM
    job_postings_fact
INNER JOIN
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND (job_location LIKE '%Mexico' OR job_work_from_home = TRUE)
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25
;
```

**Key Findings:**
- **PySpark** ranks first, with an average salary of **$208,172**, followed by **Bitbucket** at **$189,155**.
- Several of the highest-paying skills are related to **big data, cloud platforms, and technical infrastructure**, such as PySpark, Databricks, Kubernetes, and GCP.
- Some skills appear in fewer job postings, so their high average salaries should be interpreted with caution.

### 5. Most Optimal Skills to Learn

To identify the most optimal skills to learn, I combined skill demand with average salary. I filtered out skills with fewer than 50 job postings to focus on skills with a meaningful level of demand.

```SQL
SELECT
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary

FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id

WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND (job_location LIKE '%Mexico' OR job_work_from_home = TRUE)
GROUP BY
    skills_dim.skills
HAVING
    COUNT(skills_job_dim.job_id) > 50
ORDER BY
    avg_salary DESC,
    demand_count DESC
;
```

**Key Findings:**
- **Python, Tableau, and SQL** stand out as strong combinations of high demand and competitive average salaries.
- **Python** appears in 244 job postings with an average salary of **$101,436**, while **SQL** appears in 408 postings with an average salary of **$97,456**.
- **Looker** has the highest average salary in this group at **$102,998**, although it appears in only 54 job postings.


| Rank | Skill | Demand Count | Average Salary |
|---:|---|---:|---:|
| 1 | Looker | 54 | $102,998 |
| 2 | Python | 244 | $101,436 |
| 3 | R | 152 | $100,580 |
| 4 | SAS | 126 | $98,902 |
| 5 | Tableau | 243 | $98,064 |
| 6 | SQL | 408 | $97,456 |
| 7 | Power BI | 122 | $95,808 |
| 8 | PowerPoint | 58 | $88,701 |
| 9 | Excel | 273 | $86,924 |

## What I learned

As I begin my journey into Data Analytics, this project helped me gain hands-on experience with SQL, one of the essential tools used in the Data field.

- **🧩 CTEs:** Gained practical experience using Common Table Expressions to organize queries and break complex analysis into clearer steps.
- **📊 Data Aggregation:** Improved my ability to use functions such as `COUNT()` and `AVG()` with `GROUP BY` to answer specific analytical questions.
- **💡 Structured Thinking:** Strengthened my ability to break down complex questions into smaller steps and translate them into focused SQL queries.

## Conclusions

### Key Insights

1. **SQL stands out as a core skill:** It was the most in-demand skill in the dataset and also appeared consistently among the highest-paying roles.
2. **Python and visualization skills are highly relevant:** Python, Tableau, and Power BI combine strong demand with competitive average salaries.
3. **Demand matters when evaluating salary:** Some specialized skills showed very high average salaries, but with much lower demand. This makes the combination of salary and demand more useful when identifying skills with broader market value.

### Closing Thoughts

This project represents one of my first steps into Data Analytics and gave me the opportunity to work with SQL while exploring a question that is directly relevant to my own career development.

As I learn how data can be used to make better decisions, I wanted to apply that same mindset to my own development: rather than choosing which skills to learn based only on assumptions or baises, I used job market data to understand where demand and salary intersect.

This is only an initial step, but it gives me a more informed direction for continuing to develop the skills needed to enter a competitive Data Analytics job market.

## 👤 Author

**Edgar Rojas**

*Data Analytics Portfolio Project*