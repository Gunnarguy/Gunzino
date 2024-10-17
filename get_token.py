# get_token.py

import requests
import base64
import time
from settings import CLIENT_ID, CLIENT_SECRET, TOKEN_URL, YOUR_CERT_PATH, YOUR_KEY_PATH

def get_access_token():
    # Create the authorization header
    auth_str = f"{CLIENT_ID}:{CLIENT_SECRET}"
    b64_auth_str = base64.b64encode(auth_str.encode()).decode()

    headers = {
        "Authorization": f"Basic {b64_auth_str}",
        "Content-Type": "application/x-www-form-urlencoded"
    }

    data = {
        "grant_type": "client_credentials"
    }

    # Make the request to get the access token with client certificates
    response = requests.post(TOKEN_URL, headers=headers, data=data, cert=(YOUR_CERT_PATH, YOUR_KEY_PATH))

    # Check the response
    if response.status_code == 200:
        token_response = response.json()
        access_token = token_response["client_access_token"]
        expires_in = token_response["expires_in"]
        expiration_time = time.time() + expires_in
        
        return access_token, expiration_time
    else:
        print("Failed to get access token:", response.status_code)
        print("Response Text:", response.text)
        return None, None

if __name__ == "__main__":
    access_token, expiration_time = get_access_token()
    print(f"Access Token: {access_token}")
    print(f"Expires At: {expiration_time}")
