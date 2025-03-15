import json
from datetime import datetime, timedelta, timezone
import requests  # To make API requests
import random

# Function to load the mock weather data from the file
def load_mock_weather_data(file_path='mock_weather_data.json'):
    with open(file_path, 'r') as f:
        data = json.load(f)
    return data

# Real API call for fetching weather data (commented out)
# def load_real_weather_data(api_key, location):
#     url = f"http://api.openweathermap.org/data/2.5/forecast?q={location}&appid={api_key}&units=metric"
#     response = requests.get(url)
#     if response.status_code == 200:
#         data = response.json()
#         return data
#     else:
#         print(f"Error fetching data: {response.status_code}")
#         return None


# IST is UTC +5:30
IST = timezone(timedelta(hours=5, minutes=30))

# Function to find non-rainy time slots within a given range
def find_non_rainy_time_slots(weather_data, start_time, end_time):
    available_times = []
    
    for entry in weather_data:
        timestamp = entry["dt"]
        
        # Convert the timestamp to IST (Indian Standard Time)
        weather_time = datetime.fromtimestamp(timestamp, IST)  # Now this will be in IST
        
        # Debugging output to check time
        # print(f"Checking time: {weather_time} with weather condition: {entry['weather'][0]['main']}")
        
        if start_time <= weather_time <= end_time:
            if entry["weather"][0]["main"] != "Rain" and entry["rain"]["1h"] == 0:
                available_times.append(weather_time)
    
    return available_times

# Function to recommend the best time based on non-rainy slots within the next 2 days
def recommend_fertilizer_time(location, weather_data, current_time):
    # Define the forecast window (next 2 days from current time)
    two_days_later = current_time + timedelta(days=2)
    
    # Check for available non-rainy times between 8 AM - 12 PM and 3 PM - 6 PM
    morning_start = current_time.replace(hour=8, minute=0, second=0, microsecond=0)
    morning_end = current_time.replace(hour=12, minute=0, second=0, microsecond=0)
    evening_start = current_time.replace(hour=15, minute=0, second=0, microsecond=0)
    evening_end = current_time.replace(hour=18, minute=0, second=0, microsecond=0)
    
    print(f"Looking for available non-rainy times between {morning_start} and {morning_end} or between {evening_start} and {evening_end}.")
    
    # Search for non-rainy time slots in the forecast (within 2 days)
    available_times = find_non_rainy_time_slots(weather_data, morning_start, evening_end)

    # Filter out times before the current time (we want only future times)
    future_times = [time for time in available_times if time > current_time]
    
    if future_times:
        print("Available non-rainy time slots:")
        for time in future_times:
            print(f"- {time}")
        return future_times
    else:
        print("No available non-rainy times in the next 2 days.")
        return None

# Main function to simulate fertilizer recommendation for a given location
def main():
    # Get the location input (for now hardcoded for testing)
    location_name = input("Enter the location (e.g., Colombo, Kandy): ")

    # Replace the following line with the API call when ready (uncomment the line below)
    # api_key = "your_api_key_here"
    # mock_weather_data = load_real_weather_data(api_key, location_name)
    
    # Load mock data (this could be the API call later)
    mock_weather_data = load_mock_weather_data()
    
    # Find the location in the mock data
    location_data = next((loc for loc in mock_weather_data['locations'] if loc['city']['name'].lower() == location_name.lower()), None)
    
    if not location_data:
        print(f"Location '{location_name}' not found in mock data.")
        return
    
    weather_data = location_data['list']  # Get the weather forecast for the location
    current_time = datetime.now(timezone.utc)  # Get the current UTC time (timezone-aware)

    # Debugging: Print current time
    print(f"Current UTC time: {current_time}")
    
    # Call recommendation function
    available_times = recommend_fertilizer_time(location_name, weather_data, current_time)
    
    if available_times:
        print(f"Available times for fertilizer application: {available_times}")
    else:
        print("No suitable time found within the next 2 days.")

if __name__ == "__main__":
    main()
