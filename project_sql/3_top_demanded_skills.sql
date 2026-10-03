/*
Question: What are the most in-demand skills for data analysts?
    - Join job postings to inner join table, similar to query 2
    - Identify the top 10 in-demand skills for a data analyst

Objective: to retrieve the top 10 skills with the highest demand in the job market in 2023,
providing insights into the most valuable skills for job seekers
*/

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

/*
[
  {
    "skills": "sql",
    "demand_count": "8472"
  },
  {
    "skills": "excel",
    "demand_count": "5729"
  },
  {
    "skills": "python",
    "demand_count": "5098"
  },
  {
    "skills": "tableau",
    "demand_count": "4353"
  },
  {
    "skills": "power bi",
    "demand_count": "3203"
  },
  {
    "skills": "r",
    "demand_count": "2510"
  },
  {
    "skills": "sas",
    "demand_count": "2152"
  },
  {
    "skills": "azure",
    "demand_count": "982"
  },
  {
    "skills": "powerpoint",
    "demand_count": "975"
  },
  {
    "skills": "looker",
    "demand_count": "967"
  }
]
*/