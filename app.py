import base64
import requests
import xml.etree.ElementTree as ET
from flask import Flask, request

app = Flask(__name__)

client_id = '087ee2a1ce2143beb03714c5f3f09645'
client_secret = '926a8ffa938242ab8e2493524e6ae440'
bulk_id = '51834'

credentials = f"{client_id}:{client_secret}"
encoded_credentials = base64.b64encode(credentials.encode('utf-8')).decode('utf-8')

token_url = 'https://api.pge.com/datacustodian/test/oauth/v2/token'

def get_access_token():
    headers = {
        'Authorization': f'Basic {encoded_credentials}',
        'Content-Type': 'application/x-www-form-urlencoded'
    }
    data = {
        'grant_type': 'client_credentials'
    }
    response = requests.post(token_url, headers=headers, data=data)
    if response.status_code == 200:
        root = ET.fromstring(response.content)
        namespace = {'ns': 'https://api.pge.com/datacustodian/oauth/v2/token'}
        access_token = root.find('ns:client_access_token', namespace).text
        return access_token
    else:
        raise Exception(f"Failed to obtain access token. Status code: {response.status_code}")

@app.route('/notify', methods=['POST'])
def notify():
    notification_content = request.data
    print("Received Notification:")
    print(notification_content)
    try:
        access_token = get_access_token()
        fetch_customer_info(access_token)
        fetch_usage_data(access_token)
    except Exception as e:
        print(f"An error occurred: {e}")
    return '', 200

def fetch_customer_info(access_token):
    headers = {
        'Authorization': f'Bearer {access_token}',
        'Accept': 'application/atom+xml'
    }
    customer_info_url = f'https://api.pge.com/datacustodian/test/espi/1_1/resource/Batch/BulkRetailCustomerInfo/{bulk_id}'
    response = requests.get(
        customer_info_url,
        headers=headers,
        cert=('domain.cert.pem', 'private.key.pem')
    )
    if response.status_code == 200:
        print("Customer Information:")
        print(response.text)
        # Process the customer information here
    else:
        print(f"Failed to fetch customer info. Status code: {response.status_code}")
        print(response.text)

def fetch_usage_data(access_token):
    headers = {
        'Authorization': f'Bearer {access_token}',
        'Accept': 'application/atom+xml'
    }
    usage_data_url = f'https://api.pge.com/datacustodian/test/espi/1_1/resource/Batch/Bulk/{bulk_id}'
    response = requests.get(
        usage_data_url,
        headers=headers,
        cert=('domain.cert.pem', 'private.key.pem')
    )
    if response.status_code == 200:
        print("Usage Data:")
        print(response.text)
        # Process the usage data here
    else:
        print(f"Failed to fetch usage data. Status code: {response.status_code}")
        print(response.text)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=443, ssl_context=('domain.cert.pem', 'private.key.pem'))