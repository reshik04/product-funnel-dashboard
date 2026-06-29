-- Module 4: Segmentation by Acquisition Channel
-- Slices funnel + retention by signup channel to find best/worst sources.
--
-- KEY FINDING: referral & email dominate at every stage.
--   Conversion:  referral 61.9% / email 61.7%  vs  social 19.0%  (~3.3x)
--   D30 retain:  referral 12.5%                 vs  social 2.0%   (~6.3x)
-- Yet referral+email are only ~26% of signups; organic+paid_search
-- (~54% of signups) convert and retain worst. Acquisition spend is
-- concentrated in the weakest channels.
-- RECOMMEND: shift budget toward referral & email; audit social spend.

-- Query 1: Conversion by channel
WITH user_channel AS (
  SELECT user_id, MIN(channel) AS channel
  FROM events WHERE event_name = 'signup' GROUP BY user_id
),
purchasers AS (
  SELECT DISTINCT user_id FROM events WHERE event_name = 'purchase'
)
SELECT
  uc.channel,
  COUNT(DISTINCT uc.user_id) AS signups,
  COUNT(DISTINCT p.user_id) AS purchasers,
  ROUND(100.0 * COUNT(DISTINCT p.user_id) / COUNT(DISTINCT uc.user_id), 1) AS conversion_pct
FROM user_channel uc
LEFT JOIN purchasers p ON uc.user_id = p.user_id
GROUP BY uc.channel
ORDER BY conversion_pct DESC;

-- Query 2: Retention by channel (D7 / D30)
WITH cohorts AS (
  SELECT user_id, MIN(event_date) AS cohort_date, MIN(channel) AS channel
  FROM events WHERE event_name = 'signup' GROUP BY user_id
),
activity AS (
  SELECT c.channel, e.user_id,
         DATE_DIFF('day', c.cohort_date, e.event_date) AS days_since_join
  FROM events e JOIN cohorts c ON e.user_id = c.user_id
)
SELECT
  channel,
  COUNT(DISTINCT user_id) AS users,
  ROUND(100.0 * COUNT(DISTINCT CASE WHEN days_since_join >= 7  THEN user_id END) / COUNT(DISTINCT user_id), 1) AS d7_pct,
  ROUND(100.0 * COUNT(DISTINCT CASE WHEN days_since_join >= 30 THEN user_id END) / COUNT(DISTINCT user_id), 1) AS d30_pct
FROM activity
GROUP BY channel
ORDER BY d30_pct DESC;