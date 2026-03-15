WITH agg_years AS (
    SELECT
        province,
        region,
        year,
        AVG(avg_monthly_temp)                    AS avg_yearly_temp,
        SUM(total_monthly_rain)                  AS total_yearly_rain,
        SUM(total_monthly_rain_hours)            AS total_yearly_rain_hours,
        MAX(max_monthly_wind_speed)              AS max_yearly_wind_speed,
        AVG(avg_monthly_max_humidity)            AS avg_yearly_max_humidity,
        AVG(avg_monthly_min_humidity)            AS avg_yearly_min_humidity,
        SUM(total_monthly_shortwave_radiation)   AS total_yearly_shortwave_radiation,
        SUM(total_monthly_sunshine_duration)     AS total_yearly_sunshine_duration,
        SUM(total_monthly_evapotranspiration)    AS total_yearly_evapotranspiration
    FROM 
        {{ ref('int_monthly') }}
    GROUP BY 
        province, region, year
)

SELECT * FROM agg_years