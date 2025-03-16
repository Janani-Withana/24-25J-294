# gemini_api.py

import google.generativeai as genai

def configure_gemini(api_key: str):
    """
    Configure the Gemini (Google Generative AI) client.
    """
    genai.configure(api_key=api_key)
    # Initialize the Gemini 2.0 Flash model
    model = genai.GenerativeModel("gemini-2.0-flash")
    return model

def call_gemini_api(model, prompt: str) -> str:
    """
    Calls Gemini API to generate an answer based on the provided prompt.
    """
    try:
        response = model.generate_content(prompt)
        return response.text
    except Exception as e:
        return f"Error calling Gemini API: {e}"
