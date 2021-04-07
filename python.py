import urllib3
import boto3
import json
import urllib.parse
import os
import uuid

client = boto3.client('stepfunctions')


def lambda_handler(event, context):
    # INPUT -> { (unique)"TransactionID": "foo", "Type":"PURCHASE"}
    try:
        response = client.start_execution(

            stateMachineArn=os.environ['step'],
            name=str(uuid.uuid1()),
            input='{\"Comment\" : \"insert your json here\"}',
        )
        http = urllib3.PoolManager()

        uri = os.environ['uri']
        json_data = http.request('GET', uri).data
        print(json_data)
        result = json.loads(json_data)
        Transaction_ID = result['Transaction_ID']
        dynamodb = boto3.resource('dynamodb')
        table = dynamodb.Table('Transaction_Table')
        table.put_item(
            Item={
                'Transaction_ID': Transaction_ID,
            }
        )
    except Exception as e:
        print(e)
