IF NOT EXISTS(
    SELECT 1
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_NAME = 'bronze_ref_vehicles'
)
BEGIN
    CREATE TABLE bronze_ref_vehicles(
        [Masse_OM_Max] INT,
        [Conso_vitesse_mixte_Max] FLOAT,
        [Essai_CO2_type_1] FLOAT,
        [Groupe] VARCHAR(50),
        [CO2_vitesse_mixte_Min] FLOAT,
        [Cylindrée] INT,
        [Conso_basse_vitesse_Max] FLOAT,
        [Bonus-Malus] VARCHAR(50),
        [Puissance_fiscale] INT,
        [Energie] VARCHAR(50),
        [CO2_basse_vitesse_Min] FLOAT,
        [Modèle] VARCHAR(50),
        [Libellé_modèle] VARCHAR(50),
        [Essai_HC] FLOAT,
        [Conso_vitesse_mixte_Min] FLOAT,
        [Type_de_boite] VARCHAR(50),
        [CO2_vitesse_mixte_Max] FLOAT,
        [Puissance_maximale] INT,
        [CO2_moyenne_vitesse_Min] FLOAT,
        [Carrosserie] VARCHAR(50),
        [CO2_basse_vitesse_Max] FLOAT,
        [Gamme] VARCHAR(50),
        [CO2_T-haute_vitesse_Min] FLOAT,
        [Nombre_rapports] INT,
        [Barème_Bonus-Malus] INT,
        [Essai_particules] FLOAT,
        [Conso_haute_vitesse_Max] FLOAT,
        [_i] INT PRIMARY KEY,
        [Description_Commerciale] VARCHAR(200),
        [Conso_T-haute_vitesse_Max] FLOAT,
        [CO2_haute_vitesse_Max] FLOAT,
        [CO2_T-haute_vitesse_Max] FLOAT,
        [CO2_moyenne_vitesse_Max] FLOAT,
        [Masse_OM_Min] INT,
        [Conso_moyenne_vitesse_Max] FLOAT,
        [Conso_basse_vitesse_Min] FLOAT,
        [Marque] VARCHAR(50),
        [Rapport_poids-puissance] FLOAT,
        [_rand] INT,
        [Poids_à_vide] INT,
        [Conso_moyenne_vitesse_Min] FLOAT,
        [Conso_haute_vitesse_Min] FLOAT,
        [Essai_Nox] FLOAT,
        [Conso_T-haute_vitesse_Min] FLOAT,
        [CO2_haute_vitesse_Min] FLOAT,
        [Prix_véhicule] INT,
        [_score] INT,
        [_id] VARCHAR(100),
        [Puissance_nominale_électrique] FLOAT,
        [Autonomie_elec_Max] FLOAT,
        [Autonomie_elec_urbain_Max] FLOAT,
        [Conso_elec_Max] FLOAT,
        [Essai_HCNox] FLOAT,
        [Conso_elec_Min] FLOAT,
        [Autonomie_elec_urbain_Min] FLOAT,
        [Autonomie_elec_Min] FLOAT
    )
END
;

IF NOT EXISTS (
    SELECT 1
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_NAME = 'bronze_fact_petrol'
)
BEGIN
    CREATE TABLE bronze_fact_petrol (
        [timestamp] DATETIME2 DEFAULT SYSDATETIME(),
        [id] INT,
        [latitude] FLOAT,
        [longitude] FLOAT,
        [cp] INT,
        [pop] VARCHAR(1),
        [adresse] VARCHAR(100),
        [ville] VARCHAR(100),

        [gazole_maj] DATETIMEOFFSET,
        [gazole_prix] FLOAT,
        [sp95_maj] DATETIMEOFFSET,
        [sp95_prix] FLOAT,
        [e85_maj] DATETIMEOFFSET,
        [e85_prix] FLOAT,
        [gplc_maj] DATETIMEOFFSET,
        [gplc_prix] FLOAT,
        [e10_maj] DATETIMEOFFSET,
        [e10_prix] FLOAT,

        [sp98_maj] DATETIMEOFFSET,
        [sp98_prix] FLOAT,

        [e10_rupture_debut] DATETIMEOFFSET,
        [e10_rupture_type] VARCHAR(50),
        [sp98_rupture_debut] DATETIMEOFFSET,
        [sp98_rupture_type] VARCHAR(50),
        [sp95_rupture_debut] DATETIMEOFFSET,
        [sp95_rupture_type] VARCHAR(50),
        [e85_rupture_debut] DATETIMEOFFSET,
        [e85_rupture_type] VARCHAR(50),
        [gplc_rupture_debut] DATETIMEOFFSET,
        [gplc_rupture_type] VARCHAR(50),
        [gazole_rupture_debut] DATETIMEOFFSET,
        [gazole_rupture_type] VARCHAR(50),

        [carburants_disponibles] VARCHAR(100),
        [carburants_indisponibles] VARCHAR(100),
        [carburants_rupture_temporaire] VARCHAR(100),
        [carburants_rupture_definitive] VARCHAR(100),

        [horaires_automate_24_24] VARCHAR(3),
        [services_service] VARCHAR(500),
        [departement] VARCHAR(100),
        [code_departement] VARCHAR(2),
        [region] VARCHAR(100),
        [code_region] VARCHAR(2),
        [horaires_jour] VARCHAR(500)
    );
END
ELSE
BEGIN
    DELETE FROM bronze_fact_petrol
    WHERE [timestamp] < DATEADD(DAY, -15, SYSDATETIME());
END;


