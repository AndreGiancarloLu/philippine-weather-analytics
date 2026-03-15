WITH summary AS (
    SELECT
        province,
        region,
        AVG(temp_avg)            AS avg_daily_temp,
        AVG(rain_sum)            AS avg_daily_rain,
        AVG(rain_hours)          AS avg_daily_rain_hours,
        AVG(sunshine_duration)   AS avg_daily_sunshine_duration,
        AVG(humidity_max)        AS avg_daily_humidity_max,
        AVG(humidity_min)        AS avg_daily_humidity_min,
        AVG(wind_speed_max)      AS avg_daily_strongest_wind_speed
    FROM {{ ref('stg_raw_weather_data') }}
    GROUP BY province, region
)

SELECT * FROM summary