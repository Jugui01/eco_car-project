import yaml
import requests
import pandas as pd
import pyodbc


def get_api_vehicle():
    # charger config
    with open("etl/config.yaml", "r") as f:
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

    return(pyodbc.connect(conn_str))

