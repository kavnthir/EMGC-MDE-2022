#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_BNO055.h>
#include <SoftwareSerial.h>
#include <utility/imumaths.h>

// Pinout for the RS422 interface
// Reconfigured with jumpers as detailed on i/o shield documentation
// Link below details default hardware UART serial outputs for boards for jumper config
// https://www.arduino.cc/reference/en/language/functions/communication/serial/

// If SoftwareSerial library were to be used instead of onboard serializer, the below pin defines are to be modified and used.
// SoftwareSerial libraries is signficantly slower than hardware serializers.
// const int RS422_TX_PIN = 2; 
// const int RS422_RX_PIN = 3; 
// SoftwareSerial RS422_BUS = SoftwareSerial (RS422_RX_PIN, RS422_TX_PIN);

void setup(void) {
  Serial.begin(9600); // Baud rate is overkill, 60 baud min for system operation @ 100Hz

  // pinMode(RS422_TX_PIN, OUTPUT);
  // RS422_BUS.begin(9600);
}

void loop(void) {

  // convert analog to similar data range of BNO055 data output from speedgoat

  // Human readable sensor testing code
  // DO NOT UNCOMMENT DURING OPERATION
  // Serial.print(F("Orientation: "));
  // Serial.print((float)orientation.y);
  // Serial.print(F(" "));
  // Serial.print((float)orientation.z);
  // Serial.println(F(""));

  uint8_t data[5];
  // Start bytes
  // Multiple ensure system stability
  data[0] = 0xAB; 
  data[1] = 0xCD; 
  data[2] = 0xEF; 
  // Data
  data[3] = (uint8_t)(event.orientation.y >> 8); // Orientation Y (high byte)
  data[4] = (uint8_t)(event.orientation.y); // Orientation Y (low byte)
  data[5] = (uint8_t)(event.orientation.z >> 8); // Orientation Z (high byte)
  data[6] = (uint8_t)(event.orientation.z); // Orientation Z (low byte)
  
  // Send the packed data over the RS422 interface
  for (int i = 0; i < 5; i++) {
    Serial.write(data[i]);
  }

  delay(10);
}
