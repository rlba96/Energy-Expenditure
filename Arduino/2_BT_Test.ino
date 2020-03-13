#include "BluetoothSerial.h"
#include <Wire.h>

// Check if Bluetooth configs are enabled
#if !defined(CONFIG_BT_ENABLED) || !defined(CONFIG_BLUEDROID_ENABLED)
#error Bluetooth is not enabled! Please run `make menuconfig` to and enable it
#endif

#define MPU6050_ACCEL_XOUT_H       0x3B   // Register MSB AccX  
#define MPU6050_ACCEL_XOUT_L       0x3C   // Register LSB AccX 
#define MPU6050_ACCEL_YOUT_H       0x3D   // Register MSB AccY  
#define MPU6050_ACCEL_YOUT_L       0x3E   // Register LSB AccY 
#define MPU6050_ACCEL_ZOUT_H       0x3F   // Register MSB AccZ 
#define MPU6050_ACCEL_ZOUT_L       0x40   // Register LSB AccZ 

#define MPU9150_PWR_MGMT_1         0x6B   // R/W
#define ACCEL_CONFIG               0x1C   // Accelerometer configuration

#define I2C_SDA 33    // MPU-6050  amarelo
#define I2C_SCL 32    // MPU-6050  roxo

#define VECTOR_LENGTH 6


// Bluetooth Serial object
BluetoothSerial SerialBT;

// Handle received and sent messages
String message = "";
char incomingChar;
bool deviceConnected;

// MPU-6050 variables
const int MPU_I2C_ADRESS = 0x68;    // MPU-6050 and MPU-9250 addresses
uint8_t mpu6050[VECTOR_LENGTH];     // Byte array to send over bluetooth classic


void setup() {
    Serial.begin(115200);
    Wire.setClock(400000);  // I2C fast mode
    
    // MPU-6050 init
    Wire.begin(I2C_SDA, I2C_SCL);
    Wire.beginTransmission(MPU_I2C_ADRESS);
    Wire.write(MPU9150_PWR_MGMT_1);            // Accessing Power Management register
    Wire.write(0x00);                          // Setting SLEEP register to 0 (Required)
    Wire.endTransmission();

    Wire.beginTransmission(MPU_I2C_ADRESS);
    Wire.write(ACCEL_CONFIG);                  // Accessing Acceleration Configuration register
    Wire.write(0b00011000);                    // Set full scale range to +-16g
    Wire.endTransmission(true);
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
      //Wire.setClock(400000);  // I2C fast mode
      // === Read MPU-6050 data ===//
      unsigned long start = micros();
      Wire.begin(I2C_SDA, I2C_SCL);
      Wire.beginTransmission(MPU_I2C_ADRESS);
      Wire.write(MPU6050_ACCEL_XOUT_H);
      Wire.endTransmission(false);
      Wire.requestFrom(MPU_I2C_ADRESS, 6, true);
      for(int i=0; i<6; i++)
        mpu6050[i] = Wire.read();
      unsigned long finish = micros();
      Serial.println(finish-start);
/*
      // 2
      start = micros();
      Wire.beginTransmission(MPU_I2C_ADRESS);
      Wire.write(MPU6050_ACCEL_XOUT_H);
      Wire.endTransmission();
      Wire.requestFrom(MPU_I2C_ADRESS, 6, true);
      for(int i=6; i<12; i++)
        mpu6050[i] = Wire.read();
      finish = micros();
      Serial.println(finish-start);
*/
      // Send value
      start = micros();
      SerialBT.write(mpu6050,VECTOR_LENGTH);
      finish = micros();
      Serial.println(finish-start);
      Serial.println("\n");
    }  

    // Read received messages (to start and finish data acquisition)
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
