{% macro get_heat_index(temp_max_c, humidity_max) %}

(CASE
    -- use simple formula if average of simple HI and T is below 80F
    WHEN (
        0.5 * (
            ({{ temp_max_c }} * 9.0/5 + 32)
            + 61.0
            + (({{ temp_max_c }} * 9.0/5 + 32 - 68.0) * 1.2)
            + ({{ humidity_max }} * 0.094)
        ) + ({{ temp_max_c }} * 9.0/5 + 32)
    ) / 2 < 80
    THEN (
        (0.5 * (
            ({{ temp_max_c }} * 9.0/5 + 32)
            + 61.0
            + (({{ temp_max_c }} * 9.0/5 + 32 - 68.0) * 1.2)
            + ({{ humidity_max }} * 0.094)
        )) - 32
    ) * 5.0/9

    -- RH < 13% and T between 80-112F: subtract adjustment
    WHEN {{ humidity_max }} < 13
        AND ({{ temp_max_c }} * 9.0/5 + 32) BETWEEN 80 AND 112
    THEN (
        (
            -42.379
            + 2.04901523 * ({{ temp_max_c }} * 9.0/5 + 32)
            + 10.14333127 * {{ humidity_max }}
            - 0.22475541 * ({{ temp_max_c }} * 9.0/5 + 32) * {{ humidity_max }}
            - 0.00683783 * POWER({{ temp_max_c }} * 9.0/5 + 32, 2)
            - 0.05481717 * POWER({{ humidity_max }}, 2)
            + 0.00122874 * POWER({{ temp_max_c }} * 9.0/5 + 32, 2) * {{ humidity_max }}
            + 0.00085282 * ({{ temp_max_c }} * 9.0/5 + 32) * POWER({{ humidity_max }}, 2)
            - 0.00000199 * POWER({{ temp_max_c }} * 9.0/5 + 32, 2) * POWER({{ humidity_max }}, 2)
        )
        - ((13 - {{ humidity_max }}) / 4.0)
            * SQRT((17 - ABS({{ temp_max_c }} * 9.0/5 + 32 - 95.0)) / 17.0)
        - 32
    ) * 5.0/9

    -- RH > 85% and T between 80-87F: add adjustment
    WHEN {{ humidity_max }} > 85
        AND ({{ temp_max_c }} * 9.0/5 + 32) BETWEEN 80 AND 87
    THEN (
        (
            -42.379
            + 2.04901523 * ({{ temp_max_c }} * 9.0/5 + 32)
            + 10.14333127 * {{ humidity_max }}
            - 0.22475541 * ({{ temp_max_c }} * 9.0/5 + 32) * {{ humidity_max }}
            - 0.00683783 * POWER({{ temp_max_c }} * 9.0/5 + 32, 2)
            - 0.05481717 * POWER({{ humidity_max }}, 2)
            + 0.00122874 * POWER({{ temp_max_c }} * 9.0/5 + 32, 2) * {{ humidity_max }}
            + 0.00085282 * ({{ temp_max_c }} * 9.0/5 + 32) * POWER({{ humidity_max }}, 2)
            - 0.00000199 * POWER({{ temp_max_c }} * 9.0/5 + 32, 2) * POWER({{ humidity_max }}, 2)
        )
        + (({{ humidity_max }} - 85) / 10.0) * ((87 - ({{ temp_max_c }} * 9.0/5 + 32)) / 5.0)
        - 32
    ) * 5.0/9

    -- standard Rothfusz equation
    ELSE (
        -42.379
        + 2.04901523 * ({{ temp_max_c }} * 9.0/5 + 32)
        + 10.14333127 * {{ humidity_max }}
        - 0.22475541 * ({{ temp_max_c }} * 9.0/5 + 32) * {{ humidity_max }}
        - 0.00683783 * POWER({{ temp_max_c }} * 9.0/5 + 32, 2)
        - 0.05481717 * POWER({{ humidity_max }}, 2)
        + 0.00122874 * POWER({{ temp_max_c }} * 9.0/5 + 32, 2) * {{ humidity_max }}
        + 0.00085282 * ({{ temp_max_c }} * 9.0/5 + 32) * POWER({{ humidity_max }}, 2)
        - 0.00000199 * POWER({{ temp_max_c }} * 9.0/5 + 32, 2) * POWER({{ humidity_max }}, 2)
        - 32
    ) * 5.0/9
END)

{% endmacro %}