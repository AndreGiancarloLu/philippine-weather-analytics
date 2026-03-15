WITH extreme_weather_summary AS (
    SELECT
        province,
        region,
        year,
        COUNTIF(wind_speed_max > 60)    AS extreme_wind_days,
        COUNTIF(wind_gusts_max > 100)   AS extreme_gust_days,
        COUNTIF(rain_sum > 50) AS extreme_rain_days,
        COUNTIF(temp_max > 35)          AS extreme_heat_days
    FROM {{ ref('stg_raw_weather_data') }}
    GROUP BY province, region, year
)

SELECT * FROM extreme_weather_summary