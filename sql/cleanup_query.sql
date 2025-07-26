-- ============================
-- Campaign
-- ============================
CREATE OR REPLACE TABLE project_data.campaign_data_ready AS
SELECT
  Campaign_ID AS campaign_id,
  Company AS company,
  Campaign_Type AS campaign_type,
  Channel_Used AS channel_used,

  -- Ändrar år till 2024, behåller månad och dag
  DATE(2024, EXTRACT(MONTH FROM Date), EXTRACT(DAY FROM Date)) AS date,

  -- Rätt format för Looker Studio
  PARSE_DATE('%Y-%m', FORMAT_DATE('%Y-%m', DATE(2024, EXTRACT(MONTH FROM Date), EXTRACT(DAY FROM Date)))) AS year_month,

  Location AS city,
  Language AS language,
  Customer_Segment AS customer_segment,
  Conversion_Rate AS conversion_rate,
  Acquisition_Cost AS acquisition_cost,
  Clicks as clicks,
  Impressions AS impressions,
  ROI AS return_on_ad_spend,
  Engagement_Score AS engagement_score

FROM
  project_data.campaign_data_raw
WHERE
  Campaign_ID IS NOT NULL
  AND Date IS NOT NULL
  AND Impressions > 0
  AND EXTRACT(MONTH FROM Date) = 8

  -- Plockar ut ett företag
  AND Company = 'TechCorp'
  AND Language = 'English'

  -- Plockar ut tio kampanjer
LIMIT 10;

-- ============================
-- Ecommerce Cleanup
-- ============================
CREATE OR REPLACE TABLE project_data.ecommerce_data_ready AS
SELECT
  `Customer ID` AS customer_id,
  
  -- Skapar unikt user_id från 1 till antal kunder
  CONCAT('user_', CAST(ROW_NUMBER() OVER () AS STRING)) AS user_id,
  
  gender,
  age,
  city,
  `Membership Type` AS membership_type,
  ROUND(`Total Spend`, 2) AS total_spend,
  `Items Purchased` AS items_purchased,
  ROUND(`Average Rating`, 2) AS average_rating,
  `Discount Applied` AS discount_applied,
  `Days Since Last Purchase` AS days_since_last_purchase,
  `Satisfaction Level` AS satisfaction_level
FROM
  project_data.ecommerce_data_raw
WHERE
  `Customer ID` IS NOT NULL
  AND Gender IS NOT NULL
  AND Age IS NOT NULL
  AND `Total Spend` IS NOT NULL;

-- ============================
-- Sessions Cleanup
-- ============================
CREATE OR REPLACE TABLE project_data.sessions_data_ready AS
WITH base_sessions AS (
  SELECT
    *,
    ROW_NUMBER() OVER (ORDER BY RAND()) AS row_num
  FROM project_data.sessions_data_raw
  WHERE timestamp IS NOT NULL
    AND JSON_VALUE(parameters, '$.device_type') != 'bot'
),

final_sessions AS (
  SELECT
    -- Tilldela user_1 till user_350 till de första 350 sessions
    CASE 
      WHEN row_num <= 350 THEN CONCAT('user_', CAST(row_num AS STRING))
      ELSE CONCAT('user_', CAST(FLOOR(351 + RAND() * (4000 - 351)) AS STRING))
    END AS user_id,

    TIMESTAMP_MILLIS(CAST(timestamp AS INT64)) AS session_datetime,
    JSON_VALUE(parameters, '$.device_type') AS device_type,
    JSON_VALUE(parameters, '$.browser') AS browser,
    JSON_VALUE(parameters, '$.browser_version') AS browser_version,
    JSON_VALUE(parameters, '$.os') AS os,
    JSON_VALUE(parameters, '$.os_version') AS os_version,
    JSON_VALUE(parameters, '$.is_touch_capable') AS is_touch_capable,

    CASE
      WHEN RAND() < 0.14 THEN 'Google Ads'
      WHEN RAND() < 0.28 THEN 'Email'
      WHEN RAND() < 0.42 THEN 'YouTube'
      WHEN RAND() < 0.57 THEN 'Website'
      WHEN RAND() < 0.71 THEN 'Instagram'
      WHEN RAND() < 0.85 THEN 'Facebook'
      ELSE 'Direct'
    END AS utm_source
  FROM base_sessions
)

SELECT * FROM final_sessions;
