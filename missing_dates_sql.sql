WITH
  /* builds recursively the dates between the chosen date and the current date */
  /* NOTE: EDIT THE REQUIRED DATES */
  RECURSIVE dates AS (
  SELECT
    1 AS n,
    DATE '2023-01-01' AS day
  UNION ALL
  SELECT
    n + 1,
    DATE_ADD(day, INTERVAL 1 DAY)
  FROM
    dates
  WHERE
    n <= DATE_DIFF(CURRENT_DATE(),'2023-01-01', DAY) ),
  
  /* executes the building of date_ column */
  build_dates_rec AS (
  SELECT
    day AS date_
  FROM
    dates ),

  /* table that we want to look for missing dates */
  /* NOTE: CHANGE THE DATE COLUMN NAME AND THE TABLE NAME ACCORDING TO YOUR NEEDS */
  table_to_check AS (
  SELECT
    existing_date,
    COUNT(*) OVER (PARTITION BY existing_date) AS num_occurences
  FROM (
    SELECT
      DISTINCT(CAST(COLUMN NAME AS DATE)) AS existing_date,
    FROM
      `TABLE NAME`
    WHERE
      CAST(COLUMN NAME AS DATE) >= '2023-01-01') )

SELECT
  date_,
  CASE WHEN num_occurences > 0 THEN 0 ELSE 1 END AS is_missing,
FROM
  build_dates_rec
LEFT JOIN
  table_to_check
ON
  build_dates_rec.date_ = existing_date
ORDER BY
  date_
