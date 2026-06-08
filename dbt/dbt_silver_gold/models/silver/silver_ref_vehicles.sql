{{ config(materialized='table') }}

WITH base AS (
    SELECT DISTINCT
        LOWER([Groupe]) as groupe,
        COALESCE((conso_vitesse_mixte_Min + conso_vitesse_mixte_Max) * 1.0/2,0) as conso_essence_moyen_l_100km,
        COALESCE(([CO2_vitesse_mixte_Min] + [CO2_vitesse_mixte_Max]) * 1.0/2,0) as co2_moyen_g_km,
        LOWER([Energie]) as type_energie,
        LOWER([Modèle]) as modele,
        LOWER([Libellé_modèle]) as libelle_modele,
        LOWER([Type_de_boite]) as type_boite_vitesse,
        [Puissance_maximale] as puissance_max,
        LOWER([Carrosserie]) as carrosserie,
        LOWER([Gamme]) as gamme,
        LOWER([Description_Commerciale]) as description,
        LOWER([Marque]) as marque,
        [Poids_à_vide] as poids,
        [Prix_véhicule] as prix,
        [Puissance_nominale_électrique] as puissance_electrique,
        [Autonomie_elec_Max] as autonomie_elec_max_km,
        COALESCE(([Conso_elec_Max] + [Conso_elec_Min]) * 1.0/2,0) as conso_elec_moyen_kwh_100km
    FROM bronze_ref_vehicles
)
SELECT
    ROW_NUMBER() OVER (
        ORDER BY (SELECT NULL)
    ) AS id_vehicle,
    *
FROM base;