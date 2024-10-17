# api_call.py
import requests

import time
from settings import TOKEN_URL
from get_token import get_access_token

# Initialize global access token and expiration time variables
access_token, token_expiration_time = get_access_token()


def make_api_call(api_url):
    global access_token, token_expiration_time

    # Check if the access token is still valid
    if time.time() > token_expiration_time:
        access_token, token_expiration_time = get_access_token()

        # If token refresh fails, handle accordingly
        if access_token is None:
            print("Failed to refresh access token.")
            return

    headers = {
        "Authorization": f"Bearer {access_token}"
    }

    response = requests.get(api_url, headers=headers)

    # Check the response
    if response.status_code == 200:
        print("API Response:", response.json())
    else:
        print("API Request Failed:", response.status_code, response.text)

# Example Usage
if __name__ == "__main__":
    api_url = "https://api.pge.com/your_api_endpoint"  # Replace with actual API endpoint
    make_api_call(api_url)
