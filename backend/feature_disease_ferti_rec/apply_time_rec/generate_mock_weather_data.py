import json
from datetime import datetime, timedelta, timezone
import random

# Function to generate mock weather data for a single location
def generate_weather_data(start_date, num_entries=24):
    weather_conditions = ["Clear", "Clouds", "Rain", "Snow", "Thunderstorm"]
    weather_icons = ["01d", "02d", "03d", "04d", "10d", "13d", "11d"]
    
    forecast_data = []

    # Generate weather data for the next num_entries hours
    for i in range(num_entries):
        timestamp = start_date + timedelta(hours=i)
        weather = random.choice(weather_conditions)
        icon = random.choice(weather_icons)
        
        # Simulate rain condition: 80% chance of no rain, 20% chance of rain
        rain_chance = 0 if random.random() > 0.2 else round(random.uniform(0.1, 5.0), 1)
        
        # Generate random weather parameters
        weather_data = {
            "dt": int(timestamp.timestamp()),
            "main": {
                "temp": round(random.uniform(290, 300), 2),
                "feels_like": round(random.uniform(290, 300), 2),
                "temp_min": round(random.uniform(290, 300), 2),
                "temp_max": round(random.uniform(290, 300), 2),
                "pressure": random.randint(1010, 1020),
                "humidity": random.randint(50, 80),
                "temp_kf": round(random.uniform(-2, 2), 1),
            },
            "weather": [
                {
                    "id": random.randint(200, 800),
                    "main": weather,
                    "description": weather.lower(),
                    "icon": icon
                }
            ],
            "clouds": {
                "all": random.randint(0, 100)
            },
            "wind": {
                "speed": round(random.uniform(1, 10), 2),
                "deg": random.randint(0, 360),
                "gust": round(random.uniform(0, 5), 2)
            },
            "visibility": 10000,
            "pop": round(random.uniform(0, 1), 2),
            "rain": {
                "1h": rain_chance
            },
            "sys": {
                "pod": "d" if i % 2 == 0 else "n"  # Daytime or nighttime
            },
            "dt_txt": timestamp.strftime("%Y-%m-%d %H:%M:%S")
        }
        
        forecast_data.append(weather_data)

    return forecast_data

# Function to generate mock weather data for multiple locations
def generate_mock_data_for_locations(locations, start_date, num_entries=24):
    mock_data = {"locations": []}

    for location in locations:
        print(f"Generating mock weather data for {location['city']['name']}...")
        forecast_data = generate_weather_data(start_date, num_entries)
        
        location_data = {
            "city": location['city'],
            "list": forecast_data
        }
        mock_data["locations"].append(location_data)
    
    return mock_data

# Example locations with mock city data
locations = [
    {"city": {"name": "Colombo", "coord": {"lat": 6.9271, "lon": 79.8612}, "country": "LK"}},
    {"city": {"name": "Kandy", "coord": {"lat": 7.2906, "lon": 80.6337}, "country": "LK"}},
    {"city": {"name": "Galle", "coord": {"lat": 6.0434, "lon": 80.2210}, "country": "LK"}},
    {"city": {"name": "Jaffna", "coord": {"lat": 9.6667, "lon": 80.0167}, "country": "LK"}}
]

# Generate mock weather data for future times only (next 24 hours from now)
current_time = datetime.now(timezone.utc)  # Get current UTC time (timezone-aware)
mock_weather_data = generate_mock_data_for_locations(locations, current_time, num_entries=24)

# Save mock data to a JSON file
with open("mock_weather_data.json", "w") as f:
    json.dump(mock_weather_data, f, indent=4)

print("Mock weather data generated and saved as mock_weather_data.json")
