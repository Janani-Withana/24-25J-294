int stepPin = 4;
int directionPin = 5;
 
void setup() {
  Serial.begin(9600);
  pinMode(3, INPUT);
  pinMode(2, INPUT);    // Arduino pin D2 as input
  pinMode(12, OUTPUT);  
  pinMode(stepPin, OUTPUT);
  pinMode(directionPin, OUTPUT);
}
 
void loop() {
  int mainSignal = digitalRead(3);
  if (mainSignal == HIGH ||  mainSignal == LOW ) {
    Serial.println("Motor On");
    int signal = digitalRead(2);  // Read signal from ESP32
    if (signal == HIGH) {
     
      Serial.println("Gate Going Up");
      digitalWrite(directionPin, HIGH);
      for (int stepCount = 1; stepCount <= 10000; stepCount++) {
        digitalWrite(stepPin, HIGH);
        delayMicroseconds(1000);
        digitalWrite(stepPin, LOW);
        delayMicroseconds(1000);
      }
      Serial.println("Motor Went UP Completed");
    } else {
      Serial.println("Gate Going Down");
      digitalWrite(directionPin, LOW);
      for (int stepCount = 1; stepCount <= 10000; stepCount++) {
        digitalWrite(stepPin, HIGH);
        delayMicroseconds(1000);
        digitalWrite(stepPin, LOW);
        delayMicroseconds(1000);
      }
      Serial.println("Motor Went DOWN Completed");
    }
  } else {
    Serial.println("Motor Off");
    delay(500);
  }
}