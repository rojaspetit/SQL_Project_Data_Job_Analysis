/*
Question: What are the top skills based on salary?
    - Look at the average salary ssociated with each skill for Data Analyst position
    - Focuses on roles with specified salaries, regardless of location

Objective: Reveal how different skills impact salary levels for Data Analysts, 
helping identify the most financially rewarding skills to acquire or develop.
*/

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

/*
Average salary alone can be misleading, as skills appearing in only a few job postings 
may rank highly due to small sample sizes. Salary should therefore be considered alongside 
skill demand and frequency to identify more reliable market trends.

[
  {
    "skills": "pyspark",
    "avg_salary": "208172"
  },
  {
    "skills": "bitbucket",
    "avg_salary": "189155"
  },
  {
    "skills": "watson",
    "avg_salary": "160515"
  },
  {
    "skills": "couchbase",
    "avg_salary": "160515"
  },
  {
    "skills": "datarobot",
    "avg_salary": "155486"
  },
  {
    "skills": "gitlab",
    "avg_salary": "154500"
  },
  {
    "skills": "jupyter",
    "avg_salary": "152777"
  },
  {
    "skills": "pandas",
    "avg_salary": "146554"
  },
  {
    "skills": "golang",
    "avg_salary": "145000"
  },
  {
    "skills": "elasticsearch",
    "avg_salary": "145000"
  },
  {
    "skills": "databricks",
    "avg_salary": "141907"
  },
  {
    "skills": "linux",
    "avg_salary": "136508"
  },
  {
    "skills": "numpy",
    "avg_salary": "136119"
  },
  {
    "skills": "kubernetes",
    "avg_salary": "132500"
  },
  {
    "skills": "scala",
    "avg_salary": "131359"
  },
  {
    "skills": "atlassian",
    "avg_salary": "131162"
  },
  {
    "skills": "twilio",
    "avg_salary": "127000"
  },
  {
    "skills": "airflow",
    "avg_salary": "126103"
  },
  {
    "skills": "jenkins",
    "avg_salary": "125436"
  },
  {
    "skills": "notion",
    "avg_salary": "125000"
  },
  {
    "skills": "postgresql",
    "avg_salary": "123879"
  },
  {
    "skills": "swift",
    "avg_salary": "123500"
  },
  {
    "skills": "gcp",
    "avg_salary": "122500"
  },
  {
    "skills": "microstrategy",
    "avg_salary": "121619"
  },
  {
    "skills": "crystal",
    "avg_salary": "120100"
  }
]
*/