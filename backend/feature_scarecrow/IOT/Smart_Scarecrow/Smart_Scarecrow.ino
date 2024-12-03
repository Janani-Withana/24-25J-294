int ledPin = 13;
int sensorPin = 8;
int sensorPin1 = 9; // Pin for the second sensor
int sensorState = LOW; // Tracks the motion state
int sensorValue = 0; // Stores the state of sensor 1
int sensorValue1 = 0; // Stores the state of sensor 2
int stepPin = 3;
int directionPin = 2;

#define relay_pin 4
#define relay_pin1 5

void setup() {
  pinMode(ledPin, OUTPUT); // LED output
  pinMode(sensorPin, INPUT); // Sensor 1 input
  pinMode(sensorPin1, INPUT); // Sensor 2 input
  pinMode(relay_pin, OUTPUT); // Relay 1 output
  pinMode(relay_pin1, OUTPUT); // Relay 2 output
  pinMode(stepPin, OUTPUT); // Stepper motor step pin
  pinMode(directionPin, OUTPUT); // Stepper motor direction pin

  // Initialize serial communication
  Serial.begin(9600);
  Serial.println("System initialized.");
}

void activateRelay(int relayPin, const char* relayName) {
  digitalWrite(relayPin, LOW);
  Serial.print(relayName);
  Serial.println(" Activated.");
  delay(1000);

  digitalWrite(relayPin, HIGH);
  Serial.print(relayName);
  Serial.println(" Deactivated.");
}

void loop() {
  // Read sensor values
  sensorValue = digitalRead(sensorPin);
  sensorValue1 = digitalRead(sensorPin1);

  // Debugging: Print sensor states
  Serial.print("Sensor 1 Value: ");
  Serial.print(sensorValue);
  Serial.print(" | Sensor 2 Value: ");
  Serial.println(sensorValue1);

  if (sensorValue == HIGH || sensorValue1 == HIGH) {
    digitalWrite(ledPin, LOW); // Turn on LED
    Serial.println("LED ON - Motion detected.");
    delay(100);

    if (sensorState == LOW) {
      Serial.println("Motion detected!");

      // Activate both relays sequentially
      activateRelay(relay_pin, "Relay 1");
      activateRelay(relay_pin1, "Relay 2");

      // Move stepper motor upwards
      Serial.println("Gate Going Up...");
      digitalWrite(directionPin, HIGH); // Set direction to UP
      for (int stepCount = 1; stepCount <= 10000; stepCount++) {
        digitalWrite(stepPin, HIGH);
        delayMicroseconds(1000);
        digitalWrite(stepPin, LOW);
        delayMicroseconds(1000);

        // Debugging: Print step count every 1000 steps
        if (stepCount % 1000 == 0) {
          Serial.print("Stepper progress: ");
          Serial.println(stepCount);
          digitalWrite(4, LOW);
          // digitalWrite(4, HIGH);
        }
      }

      sensorState = HIGH; // Update motion state
      digitalWrite(4, HIGH);
    }
  } else {
    digitalWrite(ledPin, HIGH); // Turn off LED
    Serial.println("LED OFF - No motion detected.");
    delay(200);

    if (sensorState == HIGH) {
      Serial.println("Motion stopped!");
      sensorState = LOW; // Reset motion state
    }
  }

  // Add a small delay to prevent flooding the serial monitor
  delay(100);
}
