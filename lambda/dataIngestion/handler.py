import json
import boto3
import requests
from datetime import datetime

s3 = boto3.client('s3')
bucket_name = 'your-weather-raw-data-bucket'

def lambda_handler(event, context):
    response = requests.get("https://api.weatherapi.com/v1/forecast.json", params={
        "key": "d2ab6fdba2f14df9bd5214239251006",
        "q": "Edinburgh",
        "days": 7,
    },verify = False)
    
    data = response.json()
    timestamp = datetime.utcnow().strftime('%Y-%m-%dT%H-%M-%SZ')
    filename = f"weather_data_{timestamp}.json"

    s3.put_object(
        Bucket=bucket_name,
        Key=filename,
        Body=json.dumps(data)
    )

    return {
        'statusCode': 200,
        'body': json.dumps('Weather data saved to S3!')
    }