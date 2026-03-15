{% macro get_region(province) -%}
CASE
    WHEN 
        province IN
        ("Abra", "Albay", "Apayao", "Aurora", "Bataan", "Batanes", "Batangas", "Benguet", "Bulacan",
         "Cagayan", "Camarines Norte", "Camarines Sur", "Catanduanes", "Cavite", "Ifugao", "Isabela",
         "Ilocos Norte", "Ilocos Sur", "Kalinga", "Laguna", "La Union", "Marinduque", "Masbate", "Metro Manila (NCR)", "Mountain Province",
         "Nueva Ecija", "Nueva Vizcaya", "Occidental Mindoro", "Oriental Mindoro", "Palawan", "Pampanga",
         "Pangasinan", "Quezon", "Quirino", "Rizal", "Romblon", "Sorsogon", "Tarlac", "Zambales")
        THEN 'Luzon'
    WHEN
        province IN
        ("Aklan", "Antique", "Biliran", "Bohol", "Capiz", "Cebu", "Eastern Samar", "Guimaras", "Iloilo", 
         "Leyte", "Negros Occidental", "Negros Oriental", "Northern Samar", "Samar", "Siquijor", "Southern Leyte")
        THEN 'Visayas'
    WHEN
        province IN
        ("Agusan del Norte", "Agusan del Sur", "Basilan", "Bukidnon", "Camiguin", "Davao de Oro",
         "Davao del Norte", "Davao del Sur", "Davao Occidental", "Davao Oriental", "Dinagat Islands", "Lanao del Norte",
         "Lanao del Sur", "Maguindanao del Norte", "Maguindanao del Sur", "Misamis Occidental", "Misamis Oriental", "Cotabato", "Sarangani", "South Cotabato",
         "Sultan Kudarat", "Sulu", "Surigao del Norte", "Surigao del Sur", "Tawi-Tawi", "Zamboanga del Norte",
         "Zamboanga del Sur", "Zamboanga Sibugay")
        THEN 'Mindanao'
    ELSE
        'Unknown'
END
{%- endmacro %}