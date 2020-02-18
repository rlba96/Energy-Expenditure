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

#define VECTOR_LENGTH 10

// Bluetooth Serial object
BluetoothSerial SerialBT;

// Handle received and sent messages
String message = "";
char incomingChar;
bool deviceConnected;

// Timer: auxiliar variables
unsigned long previousMillis = 0;     // Stores last time value was published
const long interval = 1;            // interval at which to publish sensor readings

//value to send
//uint32_t value = 0;
uint8_t value[VECTOR_LENGTH];
//uint32_t value[VECTOR_LENGTH];


void callback(esp_spp_cb_event_t event, esp_spp_cb_param_t *param){
    if(event == ESP_SPP_SRV_OPEN_EVT){
      Serial.println("Client connected");
    }
   
    if(event == ESP_SPP_CLOSE_EVT ){
      Serial.println("Client disconnected");
    }
}

void setup() {
    Serial.begin(115200);
    SerialBT.register_callback(callback);
    SerialBT.begin("ESP32");
    
    if(!SerialBT.begin("ESP32")){
      Serial.println("An error occurred initializing Bluetooth");
    }else{
      Serial.println("Bluetooth initialized");
    }

    for(int i=0; i<VECTOR_LENGTH; i++){
      value[i] = 0;
    }
    
    Serial.println("Waiting for a connection...");
}

void loop() {

    if(deviceConnected){
      unsigned long currentMillis = millis();
  
      if (currentMillis - previousMillis >= interval){
        previousMillis = currentMillis;
        for(int i=0; i<VECTOR_LENGTH; i++){
          Serial.print(value[i]);
          value[i]++;
          if(i == VECTOR_LENGTH-1){
            Serial.println("");
          }
          else{
            Serial.print(",");
          }
        } 
        SerialBT.write(value,VECTOR_LENGTH);
      }
    }

    // Read received messages (to start and finish data delivery)
    if (SerialBT.available()){
      char incomingChar = SerialBT.read();
      if (incomingChar != '\n'){
        message += String(incomingChar);
      }
      else{
        message = "";
      }
      
      if (message == "s"){
        deviceConnected = true;
        message = "";
      }
      else if (message == "x"){
        deviceConnected = false;
        message = "";
      }  
    } 
}
