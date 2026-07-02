from google import genai
import os

# Replace with your actual Gemini API key for testing
api_key = "mock_key_replace_me"
client = genai.Client(api_key=api_key)

response = client.models.generate_content(
    model="gemini-2.5-flash",
    contents="Say hello"
)

print(response.text)