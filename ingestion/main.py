from tools import execute_sql_file, bronze_ref_vehicles

def main():
    print("🚀 Démarrage du pipeline ETL")

    # 1. Initialisation base
    print("Initialisation de la base de données...")
    execute_sql_file("./database/initialize.sql")

    # 2. Ingestion bronze
    print("Ingestion couche bronze...")
    bronze_ref_vehicles()

    print("Pipeline terminé avec succès")
    
    
if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print("Erreur dans le pipeline ETL :", e)
    