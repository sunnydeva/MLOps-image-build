from google.cloud import storage
import pandas as pd
from config.config import GCS_BUCKET_NAME, CSV_PATH



def load_data():

    try:
        client = storage.Client()
        bucket_name = GCS_BUCKET_NAME
        file_path = CSV_PATH
        bucket = client.bucket(bucket_name)
        blob = bucket.blob(file_path)
        data = pd.read_csv(blob.open("rb"))
        return data
    except Exception as e:
        print(f"An error occurred while loading the data: {e}")
        return None
    