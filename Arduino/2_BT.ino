/*********
  Rui Santos
  Complete project details at https://randomnerdtutorials.com
*********/

// Load libraries
#include "BluetoothSerial.h"

// Check if Bluetooth configs are enabled
#if !defined(CONFIG_BT_ENABLED) || !defined(CONFIG_BLUEDROID_ENABLED)
#error Bluetooth is not enabled! Please run `make menuconfig` to and enable it
#endif

// Bluetooth Serial object
BluetoothSerial SerialBT;

// Handle received and sent messages
String message = "";
char incomingChar;
String temperatureString = "";

// Timer: auxiliar variables
unsigned long previousMillis = 0;    // Stores last time temperature was published
const long interval = 5;         // interval at which to publish sensor readings

//value to send
uint32_t value = 0;

void setup() {
  Serial.begin(115200);
  SerialBT.begin("ESP32");
  Serial.println("Starting.");
}

void loop() {

  unsigned long currentMillis = millis();
  // Send temperature readings
  if (currentMillis - previousMillis >= interval){
    previousMillis = currentMillis;
    SerialBT.println(value); 
    Serial.println(value);
    value++;
  }
  
  
  // Read received messages (LED control command)
  if (SerialBT.available()){
    char incomingChar = SerialBT.read();
    if (incomingChar != '\n'){
      message += String(incomingChar);
    }
    else{
      message = "";
    }
    Serial.write(incomingChar);  
  }

}
