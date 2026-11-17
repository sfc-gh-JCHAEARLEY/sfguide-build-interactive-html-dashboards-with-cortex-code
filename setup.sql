-- Build Interactive HTML Dashboards with Cortex Code: sample data
-- Creates HTML_REPORTS_QS.DEMO with five small synthetic tables used by every prompt in the guide.
-- Re-runnable: uses CREATE ... IF NOT EXISTS / CREATE OR REPLACE.

CREATE DATABASE IF NOT EXISTS HTML_REPORTS_QS;
CREATE SCHEMA IF NOT EXISTS HTML_REPORTS_QS.DEMO;
USE SCHEMA HTML_REPORTS_QS.DEMO;

-- 1. Orders for the revenue report and slide deck
CREATE OR REPLACE TABLE SALES AS
SELECT
  DATEADD(day, UNIFORM(0, 364, RANDOM()), '2026-01-01'::DATE)                     AS order_date,
  ARRAY_CONSTRUCT('North America', 'EMEA', 'APAC', 'LATAM')[UNIFORM(0, 3, RANDOM())]::STRING AS region,
  ARRAY_CONSTRUCT('Enterprise', 'Mid-market', 'SMB')[UNIFORM(0, 2, RANDOM())]::STRING       AS segment,
  ROUND(UNIFORM(500, 50000, RANDOM()) + UNIFORM(0, 99, RANDOM()) / 100, 2)        AS revenue_usd
FROM TABLE(GENERATOR(ROWCOUNT => 20000));

-- 2. Weekly active users for the Chart.js slider demo
CREATE OR REPLACE TABLE WEEKLY_ACTIVE_USERS AS
WITH w AS (
  SELECT ROW_NUMBER() OVER (ORDER BY SEQ4()) - 1 AS n
  FROM TABLE(GENERATOR(ROWCOUNT => 52))
)
SELECT
  DATEADD(week, n, '2025-11-03'::DATE)              AS week_start,
  1200 + n * 35 + UNIFORM(-120, 120, RANDOM())      AS active_users
FROM w;

-- 3. Query log for the Plotly and Vega-Lite demos
CREATE OR REPLACE TABLE QUERY_LOG AS
WITH q AS (
  SELECT
    ARRAY_CONSTRUCT('X-Small', 'Small', 'Medium', 'Large')[UNIFORM(0, 3, RANDOM())]::STRING      AS warehouse_size,
    ARRAY_CONSTRUCT('SELECT', 'INSERT', 'MERGE', 'CREATE TABLE AS')[UNIFORM(0, 3, RANDOM())]::STRING AS query_type,
    POW(10, UNIFORM(3, 8, RANDOM()) + UNIFORM(0, 99, RANDOM()) / 100)                          AS rows_scanned
  FROM TABLE(GENERATOR(ROWCOUNT => 2000))
)
SELECT
  warehouse_size,
  query_type,
  ROUND(rows_scanned) AS rows_scanned,
  GREATEST(1, ROUND(
    rows_scanned
    / DECODE(warehouse_size, 'X-Small', 200000, 'Small', 400000, 'Medium', 800000, 1600000)
    * 1000 * (0.5 + UNIFORM(0, 100, RANDOM()) / 100)
  )) AS duration_ms  -- at least 1 ms, so log-scale charts never see a zero
FROM q;

-- 4. Hourly warehouse credits for one week, for the 3D demo
CREATE OR REPLACE TABLE WAREHOUSE_CREDITS_HOURLY AS
WITH h AS (
  SELECT DATEADD(hour, ROW_NUMBER() OVER (ORDER BY SEQ4()) - 1, '2026-11-09 00:00:00'::TIMESTAMP_NTZ) AS hour_start
  FROM TABLE(GENERATOR(ROWCOUNT => 168))
)
SELECT
  hour_start,
  DAYNAME(hour_start) AS day_name,
  HOUR(hour_start)    AS hour_of_day,
  ROUND(
    IFF(HOUR(hour_start) BETWEEN 8 AND 18 AND DAYNAME(hour_start) NOT IN ('Sat', 'Sun'), 4, 0.8)
    + UNIFORM(0, 100, RANDOM()) / 50, 2
  ) AS credits
FROM h;

-- 5. Object dependencies for the D3 network demo
CREATE OR REPLACE TABLE OBJECT_DEPENDENCIES AS
SELECT
  column1::STRING AS source_name,
  column2::STRING AS source_type,
  column3::STRING AS target_name,
  column4::STRING AS target_type
FROM VALUES
  ('RAW.ORDERS',        'Source table', 'Q3 Revenue Report', 'Report'),
  ('RAW.CUSTOMERS',     'Source table', 'Q3 Revenue Report', 'Report'),
  ('RAW.PIPELINE',      'Source table', 'Pipeline Review',   'Report'),
  ('RAW.CUSTOMERS',     'Source table', 'Pipeline Review',   'Report'),
  ('Q3 Revenue Report', 'Report',       'SALES_LEADERSHIP',  'Role'),
  ('Q3 Revenue Report', 'Report',       'FINANCE_ANALYST',   'Role'),
  ('Pipeline Review',   'Report',       'SALES_LEADERSHIP',  'Role'),
  ('Pipeline Review',   'Report',       'Jordan Patel',      'User'),
  ('SALES_LEADERSHIP',  'Role',         'Avery Chen',        'User'),
  ('SALES_LEADERSHIP',  'Role',         'Sam Rivera',        'User'),
  ('FINANCE_ANALYST',   'Role',         'Priya Nair',        'User');
