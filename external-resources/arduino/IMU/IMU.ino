#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_BNO055.h>
#include <SoftwareSerial.h>
#include <utility/imumaths.h>

/*
   Connections
   ===========
   Connect SCL to analog 5
   Connect SDA to analog 4
   Connect VDD to 3.3-5V DC
   Connect GROUND to common ground

      Board layout:
      +----------+
      |         *| RST   PITCH  ROLL  HEADING
  ADR |*        *| SCL
  INT |*        *| SDA     ^            /->
  PS1 |*        *| GND     |            |
  PS0 |*        *| 3VO     Y    Z-->    \-X
      |         *| VIN
      +----------+
*/

/* Set the delay between fresh samples */
// 1000ms / 10ms = 100 (Samples per second)
#define BNO055_SAMPLERATE_DELAY_MS (10)

// Check I2C device address and correct line below (by default address is 0x29 or 0x28)
//                                   id, address
Adafruit_BNO055 bno = Adafruit_BNO055(55, 0x28);

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
  Serial.println("Orientation Sensor Test"); Serial.println("");

  /* Initialise the sensor */
  if (!bno.begin()) {
    Serial.print("No BNO055 detected");
    while (1);
  }

  delay(1000);

  /* Use external crystal for better accuracy */
  bno.setExtCrystalUse(true);

  // pinMode(RS422_TX_PIN, OUTPUT);
  // RS422_BUS.begin(9600);
}

void loop(void) {
  /* Get a new sensor event */
  sensors_event_t event;
  bno.getEvent(&event);

  // Human readable sensor testing code
  // DO NOT UNCOMMENT DURING OPERATION
  // Serial.print(F("Orientation: "));
  // Serial.print((float)event.orientation.y);
  // Serial.print(F(" "));
  // Serial.print((float)event.orientation.z);
  // Serial.println(F(""));

  uint16_t pitch = (int)(event.orientation.y*16);
  uint16_t roll = (int)(event.orientation.z*16);;

  uint8_t data[5];
  // Start bytes
  // Multiple ensure system stability
  data[0] = 0xAB;
  data[1] = 0xCD;
  data[2] = 0xEF;
  // Data
  data[3] = (uint8_t)(pitch >> 8); // Orientation Y (high byte)
  data[4] = (uint8_t)(pitch); // Orientation Y (low byte)
  data[5] = (uint8_t)(roll >> 8); // Orientation Z (high byte)
  data[6] = (uint8_t)(roll); // Orientation Z (low byte)


  // Send the packed data over the RS422 interface
  for (int i = 0; i < 5; i++) {
    Serial.write(data[i]);
  }

  delay(BNO055_SAMPLERATE_DELAY_MS);
}
