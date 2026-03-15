WITH season_summary AS (
    SELECT
        province,
        region,
        season,
        AVG(temp_avg)            AS avg_temp,
        AVG(rain_sum)            AS avg_rain,
        AVG(wind_speed_max)      AS avg_wind_speed,
        AVG(humidity_max)        AS avg_humidity
    FROM 
        {{ ref('stg_raw_weather_data') }}
    GROUP BY 
        province, region, season
)

SELECT * FROM season_summary