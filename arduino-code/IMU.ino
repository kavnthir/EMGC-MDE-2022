#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_BNO055.h>

// Create an instance of the Adafruit_BNO055 class
Adafruit_BNO055 bno = Adafruit_BNO055();

// Pinout for the RS422 interface
const int RS422_TX_PIN = 10;
const int RS422_RX_PIN = 11;

void setup()
{
  // Initialize the BNO055 sensor
  bno.begin();

  // Initialize the RS422 interface
  Serial.begin(9600, SERIAL_8N1, RS422_RX_PIN, RS422_TX_PIN);
}

void loop()
{
  // Read the accelerometer data
  sensors_event_t event;
  bno.getEvent(&event);
  
  // Pack the accelerometer data into a UART format
  uint8_t data[7];
  data[0] = 0xAA; // Start byte
  data[1] = 0x01; // Data type (accelerometer)
  data[2] = (uint8_t)(event.acceleration.x >> 8); // Accelerometer X (high byte)
  data[3] = (uint8_t)(event.acceleration.x); // Accelerometer X (low byte)
  data[4] = (uint8_t)(event.acceleration.y >> 8); // Accelerometer Y (high byte)
  data[5] = (uint8_t)(event.acceleration.y); // Accelerometer Y (low byte)
  data[6] = (uint8_t)(event.acceleration.z >> 8); // Accelerometer Z (high byte)
  data[7] = (uint8_t)(event.acceleration.z); // Accelerometer Z (low byte)
  
  // Send the packed data over the RS422 interface
  for (int i = 0; i < 7; i++) {
    Serial.write(data[i]);
  }
  
  // Delay before sending the next set of data
  delay(250);
}
