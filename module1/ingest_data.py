import pandas as pd
from sqlalchemy import create_engine
from time import time
import argparse
import os

def main(params):
    user=params.user
    password=params.password
    host = params.host
    port = params.port
    db = params.db
    table_name= params.table_name
    url= params.url
    csv_name='output.csv'
    
    
    #download the csv
    os.system(f"wget {url} -O {csv_name}.gz")
    os.system(f"gzip -d -c {csv_name}.gz > {csv_name}")

    
    
    engine = create_engine(f'postgresql://{user}:{password}@{host}:{port}/{db}')


    df_iter= pd.read_csv(csv_name,iterator=True,chunksize=100_000)

    df=next(df_iter)
    df.tpep_pickup_datetime	= pd.to_datetime(df.tpep_pickup_datetime)
    df.tpep_dropoff_datetime	= pd.to_datetime(df.tpep_dropoff_datetime)
    df.head(n=0).to_sql(con=engine,name=table_name,if_exists='replace')

    df.to_sql(con=engine,name=table_name,if_exists='append')

    while True:
        start_t=time()
        df=next(df_iter)
        df.tpep_pickup_datetime	= pd.to_datetime(df.tpep_pickup_datetime)
        df.tpep_dropoff_datetime	= pd.to_datetime(df.tpep_dropoff_datetime)
        df.to_sql(con=engine,name=table_name,if_exists='append')
        end_t=time()
        print(f"inserted chunks, chunk size {len(df)}, time taken {end_t - start_t}")

if __name__=="__main__":
    parser = argparse.ArgumentParser(description="Ingest CSV To Postgres")

    parser.add_argument('--user', help="user for postgres")
    parser.add_argument('--password', help="password for postgres")
    parser.add_argument('--host', help="host for postgres")
    parser.add_argument('--port', help="port for postgres")
    parser.add_argument('--db', help="database name for postgres")
    parser.add_argument('--table_name', help="name of the table we will write the resutls to")
    parser.add_argument('--url', help="url for the cssv file")
    
    args=parser.parse_args()
    
    main(args)
    
     









