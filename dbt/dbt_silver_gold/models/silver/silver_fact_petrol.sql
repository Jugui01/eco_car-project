{{ config(materialized='table') }}

WITH source AS (

    SELECT *
    FROM {{ source('bronze', 'bronze_fact_petrol') }}

),

final AS (

    SELECT
        s.[timestamp] as timestamp_ingestion,
        s.[id] as station_id,
        s.[latitude] as latitude,
        s.[longitude] as longitude,
        s.[cp] as code_postal,
        s.[pop] as routiere_autoroutiere,
        s.[adresse] as adresse,
        s.[ville] as ville,
        s.[horaires_automate_24_24] as automate_24_24,
        s.[code_departement] as code_departement,
        s.[code_region] as code_region,
        v.type_essence,
        v.maj_essence,
        v.prix,
        v.debut_rupture,
        v.type_rupture

    FROM source s

    CROSS APPLY (
        VALUES
            ('gazole', s.[gazole_maj], s.[gazole_prix], s.[gazole_rupture_debut], s.[gazole_rupture_type]),
            ('sp95',   s.[sp95_maj],   s.[sp95_prix],   s.[sp95_rupture_debut],   s.[sp95_rupture_type]),
            ('sp98',   s.[sp98_maj],   s.[sp98_prix],   s.[sp98_rupture_debut],   s.[sp98_rupture_type]),
            ('e10',    s.[e10_maj],    s.[e10_prix],    s.[e10_rupture_debut],    s.[e10_rupture_type]),
            ('e85',    s.[e85_maj],    s.[e85_prix],    s.[e85_rupture_debut],    s.[e85_rupture_type]),
            ('gplc',   s.[gplc_maj],   s.[gplc_prix],   s.[gplc_rupture_debut],   s.[gplc_rupture_type])
    ) v (
        type_essence,
        maj_essence,
        prix,
        debut_rupture,
        type_rupture
    )
    WHERE v.prix IS NOT NULL
)

SELECT *
FROM final