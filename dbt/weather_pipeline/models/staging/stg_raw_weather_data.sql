{{ config(
    materialized='table',
    partition_by={
        "field": "date",
        "data_type": "date",
        "granularity": "month"
    },
    cluster_by=["province"]
) }}

WITH raw_weather_data AS (
    SELECT
        -- identifiers --
        CAST(province AS STRING)                 AS province,
        CAST(latitude AS FLOAT64)                AS latitude,
        CAST(longitude AS FLOAT64)               AS longitude,
        CAST(date AS DATE)                       AS date,
        EXTRACT(YEAR FROM date)                  AS year,
        EXTRACT(MONTH FROM date)                 AS month,
        {{ get_region('province') }}             AS region,

        -- temperature --
        CAST(temperature_max AS FLOAT64)         AS temp_max,
        CAST(temperature_min AS FLOAT64)         AS temp_min,
        CAST(temperature_mean AS FLOAT64)        AS temp_avg,

        -- rain --
        CAST(rain_sum AS FLOAT64)                AS rain_sum,
        CAST(precipitation_hours AS FLOAT64)     AS rain_hours,

        -- wind --
        CAST(wind_speed_max AS FLOAT64)          AS wind_speed_max,
        CAST(wind_gusts_max AS FLOAT64)          AS wind_gusts_max,
        CAST(wind_direction_dominant AS FLOAT64) AS wind_direction,

        -- humidity --
        CAST(humidity_max AS FLOAT64)            AS humidity_max,
        CAST(humidity_min AS FLOAT64)            AS humidity_min,

        -- radiation --
        CAST(shortwave_radiation_sum AS FLOAT64) AS shortwave_radiation,
        CAST(sunshine_duration AS FLOAT64)       AS sunshine_duration,
        CAST(evapotranspiration AS FLOAT64)      AS evapotranspiration

    FROM {{ source('ph_weather', 'weather_daily') }}
),

with_season AS (
    SELECT
        *,
        -- season information --
        {{ get_season('month') }} AS season
    FROM raw_weather_data
)

SELECT * FROM with_season