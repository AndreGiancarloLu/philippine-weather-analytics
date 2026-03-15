WITH monthly_patterns AS (
    SELECT
        province,
        region,
        month,
        AVG(avg_monthly_temp)             AS avg_temp,
        AVG(total_monthly_rain)           AS avg_rain,
        AVG(avg_monthly_max_humidity)     AS avg_humidity_max,
        AVG(avg_monthly_min_humidity)     AS avg_humidity_min,
        AVG(max_monthly_wind_speed)       AS avg_wind_speed
    FROM {{ ref('int_monthly') }}
GROUP BY province, region, month
)

SELECT * FROM monthly_patterns