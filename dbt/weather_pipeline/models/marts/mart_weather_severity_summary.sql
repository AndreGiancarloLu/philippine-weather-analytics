WITH table_with_heat_index AS (
    SELECT
        *,
        {{get_heat_index('temp_max', 'humidity_max')}} AS heat_index_max
    FROM
        {{ref('stg_raw_weather_data')}}
),

weather_severity_with_heat_index AS (
    SELECT
        province,
        region,
        year,
        COUNTIF(wind_speed_max >= 39 AND wind_speed_max < 62)    AS signal_1_wind_days,
        COUNTIF(wind_speed_max >= 62 AND wind_speed_max < 89)    AS signal_2_wind_days,
        COUNTIF(wind_speed_max >= 89 AND wind_speed_max < 118)   AS signal_3_wind_days,
        COUNTIF(wind_speed_max >= 118 AND wind_speed_max < 185)  AS signal_4_wind_days,
        COUNTIF(wind_speed_max >= 185)                           AS signal_5_wind_days,
        COUNTIF(rain_sum >= 50  AND rain_sum < 100)              AS moderate_to_heavy_rain_days,
        COUNTIF(rain_sum >= 100 AND rain_sum < 200)              AS heavy_to_intense_rain_days,
        COUNTIF(rain_sum >= 200)                                 AS intense_to_torrential_rain_days,
        COUNTIF(heat_index_max >= 27 AND heat_index_max < 33)    AS caution_heat_index_days,
        COUNTIF(heat_index_max >= 33 AND heat_index_max < 42)    AS extreme_caution_heat_index_days,
        COUNTIF(heat_index_max >= 42 AND heat_index_max < 52)    AS danger_heat_index_days,
        COUNTIF(heat_index_max >= 52)                            AS extreme_danger_heat_index_days
    FROM table_with_heat_index
    GROUP BY province, region, year
),
weather_severity_summary AS (
    SELECT
        *,
        -- total days per hazard type
        signal_1_wind_days + signal_2_wind_days + signal_3_wind_days 
            + signal_4_wind_days + signal_5_wind_days               AS total_wind_hazard_days,
        moderate_to_heavy_rain_days + heavy_to_intense_rain_days 
            + intense_to_torrential_rain_days                       AS total_rain_hazard_days,
        caution_heat_index_days + extreme_caution_heat_index_days 
            + danger_heat_index_days + extreme_danger_heat_index_days AS total_heat_hazard_days,

        -- significant hazard days only (Signal 3+ wind, heavy+ rain, extreme caution+ heat)
        signal_3_wind_days + signal_4_wind_days + signal_5_wind_days
            + heavy_to_intense_rain_days + intense_to_torrential_rain_days
            + extreme_caution_heat_index_days + danger_heat_index_days 
            + extreme_danger_heat_index_days                        AS significant_hazard_days,

        -- overall total across all hazard types
        signal_1_wind_days + signal_2_wind_days + signal_3_wind_days
            + signal_4_wind_days + signal_5_wind_days
            + moderate_to_heavy_rain_days + heavy_to_intense_rain_days
            + intense_to_torrential_rain_days
            + caution_heat_index_days + extreme_caution_heat_index_days
            + danger_heat_index_days + extreme_danger_heat_index_days AS total_hazard_days
    FROM weather_severity_with_heat_index
)

SELECT * FROM weather_severity_summary