
-- ============================
-- campaign_dashboard_view
-- ============================

CREATE OR REPLACE VIEW project_data.campaign_dashboard_view AS
SELECT
  c.campaign_id,
  c.company,
  c.campaign_type,
  c.channel_used AS channel,
  c.date,
  c.year_month,
  c.city AS city,
  c.language,
  c.customer_segment,
  c.conversion_rate,
  c.acquisition_cost,
  c.return_on_ad_spend,
  c.clicks,
  c.impressions,
  c.engagement_score
FROM project_data.campaign_data_ready c;



-- ============================
-- sales_dashboard_view
-- ============================

CREATE OR REPLACE VIEW project_data.sales_dashboard_view AS

-- Skapar en temporär tabell med EN session per användare (senaste)
WITH one_session_per_user AS (
  SELECT
    user_id,
    session_datetime,
    utm_source,
    device_type,
    browser,
    os,
    ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY session_datetime DESC) AS row_num
  FROM project_data.sessions_data_ready
)

SELECT
  e.customer_id,
  e.user_id,

  -- Översätter kön till svenska
  CASE
    WHEN e.gender = 'Male' THEN 'Man'
    WHEN e.gender = 'Female' THEN 'Kvinna'
    ELSE e.gender
  END AS gender,

  e.age,
  e.city,

  -- Översätter medlemstyp till svenska
  CASE
    WHEN e.membership_type = 'Gold' THEN 'Guld'
    WHEN e.membership_type = 'Silver' THEN 'Silver'
    WHEN e.membership_type = 'Bronze' THEN 'Brons'
    ELSE e.membership_type
  END AS membership_type,

  e.total_spend,
  e.items_purchased,
  e.average_rating,
  e.discount_applied,
  e.days_since_last_purchase,

  -- Översätter nöjdhetsnivå till svenska
  CASE
    WHEN e.satisfaction_level = 'Satisfied' THEN 'Nöjd'
    WHEN e.satisfaction_level = 'Unsatisfied' THEN 'Missnöjd'
    WHEN e.satisfaction_level = 'Neutral' THEN 'Neutral'
    ELSE e.satisfaction_level
  END AS satisfaction_level,

  -- Fält från endast en session per användare
  s.session_datetime,
  DATE(s.session_datetime) AS date,
  FORMAT_DATE('%Y-%m', DATE(s.session_datetime)) AS year_month,
  s.utm_source,
  s.device_type,
  s.browser,
  s.os

FROM project_data.ecommerce_data_ready e
LEFT JOIN one_session_per_user s
  ON e.user_id = s.user_id AND s.row_num = 1
WHERE s.session_datetime IS NOT NULL;



-- ============================
-- session_dashboard_view
-- ============================

CREATE OR REPLACE VIEW project_data.session_dashboard_view AS
SELECT 
  s.user_id,
  s.session_datetime,
  DATE(s.session_datetime) AS date,
  FORMAT_DATE('%Y-%m', DATE(s.session_datetime)) AS year_month,

  -- Översätter utm_source-värde "Direct" till svenska
  CASE
    WHEN s.utm_source = 'Direct' THEN 'Direkt'
    ELSE s.utm_source
  END AS utm_source,

  s.device_type,
  s.browser,
  s.browser_version,
  s.os,
  s.os_version,
  s.is_touch_capable

FROM project_data.sessions_data_ready s
WHERE s.session_datetime IS NOT NULL;
