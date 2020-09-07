//=========================================================//
//                   Prototype skectch                     //
//=========================================================//

/*  Sensors:
 *    ICM-20648;
 *    MAX30205; 
*/

#include "BluetoothSerial.h"
#include <Wire.h>

// Check if Bluetooth configs are enabled
#if !defined(CONFIG_BT_ENABLED) || !defined(CONFIG_BLUEDROID_ENABLED)
#error Bluetooth is not enabled! Please run `make menuconfig` to and enable it
#endif

// ICM20648 registers
#define ICM20648_ADDRESS            0x68

#define ICM20648_ACCEL_XOUT_H       0x2D
#define ICM20648_ACCEL_XOUT_L       0x2E  
#define ICM20648_ACCEL_YOUT_H       0x2F   
#define ICM20648_ACCEL_YOUT_L       0x30  
#define ICM20648_ACCEL_ZOUT_H       0x31   
#define ICM20648_ACCEL_ZOUT_L       0x32  

#define ICM20648_PWR_MGMT_1         0x06
#define ACCEL_CONFIG                0x14  

#define ICM20648_WHO_AM_I           0x00

// TCA9558A register
#define TCAADDR                     0x70

// ESP32 I2C configurations
// Default:   SDA = 21    SCL = 22 
#define I2C_SDA                     21
#define I2C_SCL                     22

#define VECTOR_LENGTH 36

// Bluetooth Serial object
BluetoothSerial SerialBT;

// Handle received and sent messages
String message = "";
char incomingChar;
bool deviceConnected;

// ICM-20648 variables
uint8_t data_over_BT[VECTOR_LENGTH];      // Byte array to send over bluetooth


// Function to select the TCA9548 Switch channel
void TCA_select(uint8_t channel) {
  if(channel>7){
    Serial.println("Invalid channel. Exiting...");
    return;  
  }
  Wire.beginTransmission(TCAADDR);
  Wire.write(1 << channel);
  Wire.endTransmission();  
}


void setup() {
    Serial.begin(115200);
    //Wire.setClock(400000);  // I2C fast mode
    
    // Initialize the ICM20648 sensor
    // Channel 0
    Wire.begin(I2C_SDA, I2C_SCL);
    TCA_select(0);
    Wire.beginTransmission(ICM20648_ADDRESS);
    Wire.write(ICM20648_PWR_MGMT_1);           // Accessing Power Management register
    Wire.write(0x00);                          // Setting SLEEP register to 0 (Required)
    Wire.endTransmission();
            
    Wire.beginTransmission(ICM20648_ADDRESS);
    Wire.write(ACCEL_CONFIG);                  // Accessing Acceleration Configuration register
    Wire.write(0b00000110);                    // Set full scale range to +-16g (bit 1 and 2)
    Wire.endTransmission(true);                // true
    delay(20);

    // Channel 1
    Wire.begin(I2C_SDA, I2C_SCL);
    TCA_select(1);
    Wire.beginTransmission(ICM20648_ADDRESS);
    Wire.write(ICM20648_PWR_MGMT_1);           // Accessing Power Management register
    Wire.write(0x00);                          // Setting SLEEP register to 0 (Required)
    Wire.endTransmission();
            
    Wire.beginTransmission(ICM20648_ADDRESS);
    Wire.write(ACCEL_CONFIG);                  // Accessing Acceleration Configuration register
    Wire.write(0b00000110);                    // Set full scale range to +-16g (bit 1 and 2)
    Wire.endTransmission(true);                // true
    delay(20);
    
    // Channel 2
    Wire.begin(I2C_SDA, I2C_SCL);
    TCA_select(2);
    Wire.beginTransmission(ICM20648_ADDRESS);
    Wire.write(ICM20648_PWR_MGMT_1);           // Accessing Power Management register
    Wire.write(0x00);                          // Setting SLEEP register to 0 (Required)
    Wire.endTransmission();
            
    Wire.beginTransmission(ICM20648_ADDRESS);
    Wire.write(ACCEL_CONFIG);                  // Accessing Acceleration Configuration register
    Wire.write(0b00000110);                    // Set full scale range to +-16g (bit 1 and 2)
    Wire.endTransmission(true);                // true
    delay(20);
    
    // Channel 4
    Wire.begin(I2C_SDA, I2C_SCL);
    TCA_select(4);
    Wire.beginTransmission(ICM20648_ADDRESS);
    Wire.write(ICM20648_PWR_MGMT_1);           // Accessing Power Management register
    Wire.write(0x00);                          // Setting SLEEP register to 0 (Required)
    Wire.endTransmission();
            
    Wire.beginTransmission(ICM20648_ADDRESS);
    Wire.write(ACCEL_CONFIG);                  // Accessing Acceleration Configuration register
    Wire.write(0b00000110);                    // Set full scale range to +-16g (bit 1 and 2)
    Wire.endTransmission(true);                // true
    delay(20);
    
    // Channel 5
    Wire.begin(I2C_SDA, I2C_SCL);
    TCA_select(5);
    Wire.beginTransmission(ICM20648_ADDRESS);
    Wire.write(ICM20648_PWR_MGMT_1);           // Accessing Power Management register
    Wire.write(0x00);                          // Setting SLEEP register to 0 (Required)
    Wire.endTransmission();
            
    Wire.beginTransmission(ICM20648_ADDRESS);
    Wire.write(ACCEL_CONFIG);                  // Accessing Acceleration Configuration register
    Wire.write(0b00000110);                    // Set full scale range to +-16g (bit 1 and 2)
    Wire.endTransmission(true);                // true
    delay(20);
    
    // Channel 6
    Wire.begin(I2C_SDA, I2C_SCL);
    TCA_select(6);
    Wire.beginTransmission(ICM20648_ADDRESS);
    Wire.write(ICM20648_PWR_MGMT_1);           // Accessing Power Management register
    Wire.write(0x00);                          // Setting SLEEP register to 0 (Required)
    Wire.endTransmission();
            
    Wire.beginTransmission(ICM20648_ADDRESS);
    Wire.write(ACCEL_CONFIG);                  // Accessing Acceleration Configuration register
    Wire.write(0b00000110);                    // Set full scale range to +-16g (bit 1 and 2)
    Wire.endTransmission(true);                // true
    delay(20);
    
    SerialBT.begin("ESP32");
    
    if(!SerialBT.begin("ESP32"))
      Serial.println("An error occurred initializing Bluetooth");
    else
      Serial.println("Bluetooth initialized");
    
    Serial.println("Waiting for a connection...");
}

void loop() {
    if(deviceConnected){
      // Read ICM-20648 data
      // Channel 0
      Wire.begin(I2C_SDA, I2C_SCL);
      TCA_select(0);
      Wire.beginTransmission(ICM20648_ADDRESS);
      Wire.write(ICM20648_ACCEL_XOUT_H);
      Wire.endTransmission(false);             //false
      Wire.requestFrom(ICM20648_ADDRESS, 6, true);
      data_over_BT[0] = Wire.read();
      data_over_BT[1] = Wire.read();
      data_over_BT[2] = Wire.read();
      data_over_BT[3] = Wire.read();
      data_over_BT[4] = Wire.read();
      data_over_BT[5] = Wire.read();

      // Channel 1
      Wire.begin(I2C_SDA, I2C_SCL);
      TCA_select(1);
      Wire.beginTransmission(ICM20648_ADDRESS);
      Wire.write(ICM20648_ACCEL_XOUT_H);
      Wire.endTransmission(false);             //false
      Wire.requestFrom(ICM20648_ADDRESS, 6, true);
      data_over_BT[6] = Wire.read();
      data_over_BT[7] = Wire.read();
      data_over_BT[8] = Wire.read();
      data_over_BT[9] = Wire.read();
      data_over_BT[10] = Wire.read();
      data_over_BT[11] = Wire.read();
      
      // Channel 2
      Wire.begin(I2C_SDA, I2C_SCL);
      TCA_select(2);
      Wire.beginTransmission(ICM20648_ADDRESS);
      Wire.write(ICM20648_ACCEL_XOUT_H);
      Wire.endTransmission(false);             //false
      Wire.requestFrom(ICM20648_ADDRESS, 6, true);
      data_over_BT[12] = Wire.read();
      data_over_BT[13] = Wire.read();
      data_over_BT[14] = Wire.read();
      data_over_BT[15] = Wire.read();
      data_over_BT[16] = Wire.read();
      data_over_BT[17] = Wire.read();
            
      // Channel 4
      Wire.begin(I2C_SDA, I2C_SCL);
      TCA_select(4);
      Wire.beginTransmission(ICM20648_ADDRESS);
      Wire.write(ICM20648_ACCEL_XOUT_H);
      Wire.endTransmission(false);             //false
      Wire.requestFrom(ICM20648_ADDRESS, 6, true);
      data_over_BT[18] = Wire.read();
      data_over_BT[19] = Wire.read();
      data_over_BT[20] = Wire.read();
      data_over_BT[21] = Wire.read();
      data_over_BT[22] = Wire.read();
      data_over_BT[23] = Wire.read();
                  
      // Channel 5
      Wire.begin(I2C_SDA, I2C_SCL);
      TCA_select(5);
      Wire.beginTransmission(ICM20648_ADDRESS);
      Wire.write(ICM20648_ACCEL_XOUT_H);
      Wire.endTransmission(false);             //false
      Wire.requestFrom(ICM20648_ADDRESS, 6, true);
      data_over_BT[24] = Wire.read();
      data_over_BT[25] = Wire.read();
      data_over_BT[26] = Wire.read();
      data_over_BT[27] = Wire.read();
      data_over_BT[28] = Wire.read();
      data_over_BT[29] = Wire.read();
      
      delay(1);
/*                        
      // Channel 6
      Wire.begin(I2C_SDA, I2C_SCL);
      TCA_select(6);
      Wire.beginTransmission(ICM20648_ADDRESS);
      Wire.write(ICM20648_ACCEL_XOUT_H);
      Wire.endTransmission(false);             //false
      Wire.requestFrom(ICM20648_ADDRESS, 6, true);
      data_over_BT[30] = Wire.read();
      data_over_BT[31] = Wire.read();
      data_over_BT[32] = Wire.read();
      data_over_BT[33] = Wire.read();
      data_over_BT[34] = Wire.read();
      data_over_BT[35] = Wire.read();
*/
      // Send value
      SerialBT.write(data_over_BT,VECTOR_LENGTH);
      Serial.println("\n");
    }  

    // Read received messages (to open and close connection)
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
