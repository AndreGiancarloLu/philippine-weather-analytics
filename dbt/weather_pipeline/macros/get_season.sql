{% macro get_season(month) -%}
CASE
    WHEN
    -- Wet season from June to November --
        month IN (6, 7, 8, 9, 10, 11)
        THEN 'Wet'
    ELSE
        'Dry'
END
{%- endmacro %}