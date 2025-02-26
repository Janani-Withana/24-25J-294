#include <Arduino.h>
#if defined(ESP32)
#include <WiFi.h>
#elif defined(ESP8266)
#include <ESP8266WiFi.h>
#endif
#include <Firebase_ESP_Client.h>
 
// Provide the token generation process info.
#include "addons/TokenHelper.h"
// Provide the RTDB payload printing info and other helper functions.
#include "addons/RTDBHelper.h"
 
// Insert your network credentials
#define WIFI_SSID "POCO X3 NFC"
#define WIFI_PASSWORD "12345678"
 
// Insert Firebase project API Key
#define API_KEY "AIzaSyC_5uH3nBfFKt3EjgxIp49pryWVPwP38as"
 
// Insert RTDB URL
#define DATABASE_URL "https://nodemcu-592b5-default-rtdb.europe-west1.firebasedatabase.app"
 
// Define Firebase Data object
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;
 
unsigned long sendDataPrevMillis = 0;
unsigned long moistureSendPrevMillis = 0;
unsigned long sensor2SendPrevMillis = 0;
int intValue;
bool signupOK = false;
int previousValue = -1;
 
// GPIO pin definitions
#define LIGHT_CONTROL_PIN 2  // GPIO2 on ESP32
#define LIGHT_CONTROL_PIN1 4
#define CONTROL_PIN 5
#define AOUT_PIN1 35  // Analog pin for first moisture sensor
#define AOUT_PIN2 34  // Analog pin for second sensor
 
void setup() {
  Serial.begin(115200);
 
  // Initialize Wi-Fi
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();
 
  // Assign the API key (required)
  config.api_key = API_KEY;
 
  // Assign the RTDB URL (required)
  config.database_url = DATABASE_URL;
 
  // Sign up
  if (Firebase.signUp(&config, &auth, "", "")) {
    Serial.println("ok");
    signupOK = true;
  } else {
    Serial.printf("%s\n", config.signer.signupError.message.c_str());
  }
 
  // Assign the callback function for the long-running token generation task
  config.token_status_callback = tokenStatusCallback;  // see addons/TokenHelper.h
 
  // Begin Firebase
  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);
 
  // Initialize LIGHT_CONTROL_PIN as an output
  pinMode(LIGHT_CONTROL_PIN, OUTPUT);
  pinMode(LIGHT_CONTROL_PIN1, OUTPUT);
  pinMode(CONTROL_PIN, INPUT);
}
 
void loop() {
  // Update light control based on the database value
  if (Firebase.ready() && signupOK && (millis() - sendDataPrevMillis > 100 || sendDataPrevMillis == 0)) {
    sendDataPrevMillis = millis();
    if (Firebase.RTDB.getInt(&fbdo, "/Motor")) {
      if (fbdo.dataType() == "int") {
        intValue = fbdo.intData();
        Serial.println(intValue);
        delay(200);
        Firebase.RTDB.setInt(&fbdo, "/Motor", 0);
 
        // Control the LIGHT_CONTROL_PIN based on the retrieved value
        if (intValue == 1) {
          digitalWrite(LIGHT_CONTROL_PIN1, HIGH);  // Set GPIO2 HIGH
          Serial.println("GPIO4 HIGH (Motor On)");
        } else if (intValue == 0) {
          digitalWrite(LIGHT_CONTROL_PIN1, LOW);  // Set GPIO2 LOW
          Serial.println("GPIO4 LOW (Motor Off)");
        } else {
          Serial.println("Invalid value received.");
        }
      }
    } else {
      Serial.println(fbdo.errorReason());
    }
 
    // Get the integer value from RTDB
    if (Firebase.RTDB.getInt(&fbdo, "/light")) {
      if (fbdo.dataType() == "int") {
        intValue = fbdo.intData();
        Serial.println(intValue);
 
        // Control the LIGHT_CONTROL_PIN based on the retrieved value
        if (intValue == 1) {
          digitalWrite(LIGHT_CONTROL_PIN, HIGH);  // Set GPIO2 HIGH
          Serial.println("GPIO2 HIGH (Light On)");
        } else if (intValue == 0) {
          digitalWrite(LIGHT_CONTROL_PIN, LOW);  // Set GPIO2 LOW
          Serial.println("GPIO2 LOW (Light Off)");
        } else {
          Serial.println("Invalid value received.");
        }
      }
    } else {
      Serial.println(fbdo.errorReason());
    }
  }
 
  // Read the first sensor value
  int moistureValue1 = analogRead(AOUT_PIN1);
  Serial.print("Moisture sensor 1 value: ");
  Serial.println(moistureValue1);
 
  // Update the first sensor value in Firebase Realtime Database every 500ms
  if (Firebase.ready() && millis() - moistureSendPrevMillis > 500) {
    moistureSendPrevMillis = millis();
 
    if (Firebase.RTDB.setInt(&fbdo, "/moisture1", moistureValue1)) {
      Serial.println("Moisture sensor 1 value updated in Firebase.");
    } else {
      Serial.print("Error updating moisture sensor 1 value: ");
      Serial.println(fbdo.errorReason());
    }
  }
 
  // Read the second sensor value
  int moistureValue2 = analogRead(AOUT_PIN2);
  Serial.print("Moisture sensor 2 value: ");
  Serial.println(moistureValue2);
 
  // Update the second sensor value in Firebase Realtime Database every 500ms
  if (Firebase.ready() && millis() - sensor2SendPrevMillis > 500) {
    sensor2SendPrevMillis = millis();
 
    if (Firebase.RTDB.setInt(&fbdo, "/moisture2", moistureValue2)) {
      Serial.println("Moisture sensor 2 value updated in Firebase.");
    } else {
      Serial.print("Error updating moisture sensor 2 value: ");
      Serial.println(fbdo.errorReason());
    }
  }
 
   // Check the state of CONTROL_PIN (D5)
  int controlPinState = digitalRead(CONTROL_PIN);
 
  // If the signal is HIGH, update Motor value in Firebase to 0
  if (controlPinState == HIGH) {
    if (Firebase.RTDB.setInt(&fbdo, "/Motor", 0)) {
      Serial.println("Motor value updated to 0 in Firebase.");
    } else {
      Serial.print("Motor Runnig");
    }
  }
 
}