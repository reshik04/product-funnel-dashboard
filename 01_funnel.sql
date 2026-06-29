-- Module 2: Conversion Funnel
-- Counts distinct users reaching each step: signup -> activation -> purchase
-- Result: 4000 signup -> 2911 activation -> 1410 purchase
-- Biggest leak: activation -> purchase (52% of activated users never buy)

WITH signups AS (
  SELECT COUNT(DISTINCT user_id) AS users FROM events WHERE event_name='signup'
),
activated AS (
  SELECT COUNT(DISTINCT user_id) AS users FROM events WHERE event_name='activation'
),
purchased AS (
  SELECT COUNT(DISTINCT user_id) AS users FROM events WHERE event_name='purchase'
)
SELECT
  (SELECT users FROM signups)   AS signup,
  (SELECT users FROM activated) AS activation,
  (SELECT users FROM purchased) AS purchase;