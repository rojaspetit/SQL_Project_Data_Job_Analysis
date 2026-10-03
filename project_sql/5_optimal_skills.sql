/*
Question: What are the most optimal skills to learn? Considering it's in high-demand and a high-paying skill.
    - Identify skills in high demand with high average salaries for Data Analyst roles
    - Concentrate on remote positions or positions in Mexico

Objective: Target skills that offer job security (high-demand) and financial benefits (high salaries),
offering strategic insights for career development in data analysis
*/

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

/*
[
  {
    "skills": "looker",
    "demand_count": "54",
    "avg_salary": "102998"
  },
  {
    "skills": "python",
    "demand_count": "244",
    "avg_salary": "101436"
  },
  {
    "skills": "r",
    "demand_count": "152",
    "avg_salary": "100580"
  },
  {
    "skills": "sas",
    "demand_count": "126",
    "avg_salary": "98902"
  },
  {
    "skills": "tableau",
    "demand_count": "243",
    "avg_salary": "98064"
  },
  {
    "skills": "sql",
    "demand_count": "408",
    "avg_salary": "97456"
  },
  {
    "skills": "power bi",
    "demand_count": "122",
    "avg_salary": "95808"
  },
  {
    "skills": "powerpoint",
    "demand_count": "58",
    "avg_salary": "88701"
  },
  {
    "skills": "excel",
    "demand_count": "273",
    "avg_salary": "86924"
  }
]
*/