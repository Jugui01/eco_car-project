import yaml
import requests
import pandas as pd
from sqlalchemy import create_engine, text
import urllib
from pathlib import Path


def get_api_vehicle():
    # charger config
    with open("ingestion/config.yaml", "r") as f:
        config = yaml.safe_load(f)

    url = config["ademe"]["car_labelling_url"]
    size = config["ademe"]["page_size"]

    # requête API
    page = 1
    all_rows = []

    while True:
        r = requests.get(url, params={"page": page, "size": size})
        data = r.json()

        rows = data.get("results", [])
        if not rows:
            break

        all_rows.extend(rows)
        page += 1

    return(pd.DataFrame(all_rows))


def load_config_database(path="./database/config_database.yaml"):
    with open(path, "r") as f:
        return yaml.safe_load(f)
    
    
def connect_database():
    config = load_config_database()["db"]

    conn_str = (
        f"DRIVER={{{config['driver']}}};"
        f"SERVER={config['server']};"
        f"DATABASE={config['database']};"
        f"UID={config['username']};"
        f"PWD={config['password']};"
        "Encrypt=yes;"
        "TrustServerCertificate=no;"
        "Connection Timeout=30;"
    )

    params = urllib.parse.quote_plus(conn_str)

    engine = create_engine(
        f"mssql+pyodbc:///?odbc_connect={params}"
    )

    return engine


def execute_sql_file(sql_file_path):
    """
    Exécute un fichier SQL sur la base Azure SQL.
    
    Parameters
    ----------
    sql_file_path : str
        Chemin vers le fichier .sql
    """

    # lecture du fichier SQL
    sql_path = Path(sql_file_path)

    if not sql_path.exists():
        raise FileNotFoundError(f"Fichier SQL introuvable : {sql_file_path}")

    with open(sql_path, "r", encoding="utf-8") as f:
        sql_query = f.read()

    # connexion DB
    engine = connect_database()

    # exécution
    with engine.begin() as connection:
        connection.execute(text(sql_query))

    print(f"Script SQL exécuté : {sql_file_path}")
    
    
def ingest_dataframe(
    df,
    table_name,
    schema=None,
    if_exists="replace",
    chunksize=20
):

    engine = connect_database()

    with engine.begin() as connection:
        df.to_sql(
            name=table_name,
            con=connection,
            schema=schema,
            if_exists=if_exists,
            index=False,
            chunksize=chunksize
        )
        # rq : retrait de la méthode multi car provoque des erreurs de timeout sur Azure SQL (nb de paramètres = nb lignes x nb de colonnes, trop pour la base azure sql utilisée)

    print(f"{len(df)} lignes insérées dans {schema}.{table_name}")
    
    
def delete_table(table_name):
    """
    Vide une table Azure SQL si elle existe (DELETE uniquement).
    """

    engine = connect_database()
    full_table = f"[{table_name}]"

    with engine.begin() as conn:

        # vérifier existence de la table
        exists = conn.execute(text(f"""
            SELECT 1
            FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_NAME = '{table_name}'
        """)).fetchone()

        if not exists:
            print(f"Table {full_table} n'existe pas.")
            return

        # vider la table
        conn.execute(text(f"DELETE FROM {full_table}"))

    print(f"Table {full_table} vidée (DELETE).")


def read_sql_to_df(query, params=None):

    engine = connect_database()

    with engine.connect() as conn:
        df = pd.read_sql(
            sql=text(query),
            con=conn,
            params=params
        )

    return df
    
    
def bronze_ref_vehicles():
    df = get_api_vehicle()
    try:
        ingest_dataframe(df, "bronze_ref_vehicles", schema="dbo", if_exists="replace", chunksize=1000)
        print("Ingestion de ref_vehicles complète !")
    except Exception as e:
        print("Erreur :", e)
        raise SystemExit #stoppe le programme
    
    
    
    