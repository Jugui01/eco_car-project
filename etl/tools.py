import yaml
import requests
import pandas as pd


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



df = get_api_vehicle()
print(df.head())