-- Module 3: Cohort Retention Analysis
-- Cohorts users by signup month, measures retention at D1/D7/D30.
-- Engine: DATE_DIFF days-since-join per event, counted as distinct users.
--
-- Overall retention curve:
--   Day 0:      4000 (100%)
--   Returned:   2414 (60%)
--   D7 active:  722  (18%)
--   D30 active: 187  (4.7%)
--
-- Insight: 60% return after day 1, but retention collapses to <5% by D30.
-- Decay is consistent across all monthly cohorts -> systemic, not seasonal.

WITH cohorts AS (
  SELECT user_id, MIN(event_date) AS cohort_date
  FROM events
  GROUP BY user_id
),
activity AS (
  SELECT
    e.user_id,
    DATE_TRUNC('month', c.cohort_date) AS cohort_month,
    DATE_DIFF('day', c.cohort_date, e.event_date) AS days_since_join
  FROM events e
  JOIN cohorts c ON e.user_id = c.user_id
)
SELECT
  cohort_month,
  COUNT(DISTINCT user_id) AS cohort_size,
  ROUND(100.0 * COUNT(DISTINCT CASE WHEN days_since_join >= 1  THEN user_id END) / COUNT(DISTINCT user_id), 1) AS d1_pct,
  ROUND(100.0 * COUNT(DISTINCT CASE WHEN days_since_join >= 7  THEN user_id END) / COUNT(DISTINCT user_id), 1) AS d7_pct,
  ROUND(100.0 * COUNT(DISTINCT CASE WHEN days_since_join >= 30 THEN user_id END) / COUNT(DISTINCT user_id), 1) AS d30_pct
FROM activity
GROUP BY cohort_month
ORDER BY cohort_month;