from tools import get_api_vehicle, execute_sql_file, read_sql_to_df, connect_database, ingest_dataframe

#execute_sql_file("./database/drop_table.sql")

#df = get_api_vehicle()
#df.to_excel("ref_vehicles.xlsx", index=False)

#df = read_sql_to_df("SELECT * FROM ref_vehicles;")
#print(len(df))

#df = get_api_vehicle()
#for i in range(len(df)):
#    try:
#        df.iloc[[i]].to_sql(
#            name="ref_vehicles",
#            con=connect_database(),
#            schema="dbo",
#            if_exists="replace",
#            index=False
#        )
#        print(i)
#    except Exception as e:
#        print("LIGNE KO:", i)
#        print(e)
#        break