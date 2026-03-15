WITH agg_months AS(
    SELECT
        province, 
        region,
        year, 
        month,
        AVG(temp_avg) AS avg_monthly_temp,
        SUM(rain_sum) AS total_monthly_rain,
        SUM(rain_hours) AS total_monthly_rain_hours,
        MAX(wind_speed_max) AS max_monthly_wind_speed,
        MAX(wind_gusts_max) AS max_monthly_wind_gust,
        AVG(humidity_max) AS avg_monthly_max_humidity,
        AVG(humidity_min) AS avg_monthly_min_humidity,
        SUM(shortwave_radiation) AS total_monthly_shortwave_radiation,
        SUM(sunshine_duration) AS total_monthly_sunshine_duration,
        SUM(evapotranspiration) AS total_monthly_evapotranspiration
    FROM
        {{ref('stg_raw_weather_data')}}
    GROUP BY
        province, region, year, month
)

SELECT * FROM agg_months