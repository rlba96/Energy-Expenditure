#include "BluetoothSerial.h"
#include <Wire.h>

// Check if Bluetooth configs are enabled
#if !defined(CONFIG_BT_ENABLED) || !defined(CONFIG_BLUEDROID_ENABLED)
#error Bluetooth is not enabled! Please run `make menuconfig` to and enable it
#endif

#define MPU6050_ACCEL_XOUT_H       0x3B   // Register MSB Byte AccX  
#define MPU6050_ACCEL_XOUT_L       0x3C   // Register LSB Byte AccX 
#define MPU6050_ACCEL_YOUT_H       0x3D   // Register MSB Byte AccY  
#define MPU6050_ACCEL_YOUT_L       0x3E   // Register LSB Byte AccY 
#define MPU6050_ACCEL_ZOUT_H       0x3F   // Register MSB Byte AccZ 
#define MPU6050_ACCEL_ZOUT_L       0x40   // Register LSB Byte AccZ 

#define MPU9150_PWR_MGMT_1         0x6B   // R/W

#define I2C_SDA 33    // MPU-6050
#define I2C_SCL 32    // MPU-6050

#define VECTOR_LENGTH 6


// Bluetooth Serial object
BluetoothSerial SerialBT;


// Handle received and sent messages
String message = "";
char incomingChar;
bool deviceConnected;

// Timer: auxiliar variables
unsigned long previousMillis = 0;   // Stores last time value was published
const long interval = 200;            // interval at which to publish sensor readings

// MPU-6050 variables
const int MPU_I2C_ADRESS = 0x68;      // MPU-6050 and MPU-9250 addresses
uint8_t mpu6050[6];                  // Byte array to send over bluetooth classic
float mpu6050_print[3];               // To print the converted values
const int sensivity = 2048;           // MPU-6050 and MPU-9250 sensivity



void callback(esp_spp_cb_event_t event, esp_spp_cb_param_t *param){
    if(event == ESP_SPP_SRV_OPEN_EVT)
      Serial.println("Client connected");
   
    if(event == ESP_SPP_CLOSE_EVT )
      Serial.println("Client disconnected");
}



void setup() {
    Serial.begin(115200);
    
    // MPU-6050 init
    Wire.begin(I2C_SDA, I2C_SCL);
    Wire.beginTransmission(MPU_I2C_ADRESS);
    Wire.write(MPU9150_PWR_MGMT_1);
    Wire.write(0x00);
    Wire.endTransmission(true);
    delay(20);
    
    SerialBT.register_callback(callback);
    SerialBT.begin("ESP32");
    
    if(!SerialBT.begin("ESP32"))
      Serial.println("An error occurred initializing Bluetooth");
    else
      Serial.println("Bluetooth initialized");
    
    Serial.println("Waiting for a connection...");
}

void loop() {
    if(deviceConnected){
      unsigned long currentMillis = millis();

      // ============== Read MPU-6050 data ===============//
      mpu6050[0] = mpu6050_readSensor(MPU6050_ACCEL_XOUT_H,I2C_SDA,I2C_SCL);
      mpu6050[1] = mpu6050_readSensor(MPU6050_ACCEL_XOUT_L,I2C_SDA,I2C_SCL);
      mpu6050[2] = mpu6050_readSensor(MPU6050_ACCEL_YOUT_H,I2C_SDA,I2C_SCL);
      mpu6050[3] = mpu6050_readSensor(MPU6050_ACCEL_YOUT_L,I2C_SDA,I2C_SCL);
      mpu6050[4] = mpu6050_readSensor(MPU6050_ACCEL_ZOUT_H,I2C_SDA,I2C_SCL);
      mpu6050[5] = mpu6050_readSensor(MPU6050_ACCEL_ZOUT_L,I2C_SDA,I2C_SCL);


      // For a range of +-2g, 4g, 8g or 16g, we need to divide the raw
      // values by 16384, 8192, 4096 or 2048 according to the datasheet
      // MPU-6050
      mpu6050_print[0] = ((mpu6050[0]<<8)+mpu6050[1])/2048.0;
      mpu6050_print[1] = ((mpu6050[2]<<8)+mpu6050[3])/2048.0;
      mpu6050_print[2] = ((mpu6050[4]<<8)+mpu6050[5])/2048.0;
      
  
      if (currentMillis - previousMillis >= interval){
        previousMillis = currentMillis;
        SerialBT.write(mpu6050,VECTOR_LENGTH);

        /* Print out the values */
        Serial.println("Raw values sent over BT: ");
        Serial.print("MPU-6050: ");
        Serial.print(mpu6050[0]);
        Serial.print(" ");
        Serial.print(mpu6050[1]);
        Serial.print(",");
        Serial.print(mpu6050[2]);
        Serial.print(" ");
        Serial.print(mpu6050[3]);
        Serial.print(",");
        Serial.print(mpu6050[4]);
        Serial.print(" ");
        Serial.print(mpu6050[5]);  
        Serial.println("");
        
        Serial.println("Converted values: ");
        Serial.print("MPU-6050: ");
        Serial.print(mpu6050_print[0]);
        Serial.print(",");
        Serial.print(mpu6050_print[1]);
        Serial.print(",");
        Serial.print(mpu6050_print[2]);
        Serial.println("");
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

int mpu6050_readSensor(int addr, int SDA, int SCL){
    Wire.begin(SDA, SCL);
    Wire.beginTransmission(MPU_I2C_ADRESS);
    Wire.write(addr);
    Wire.endTransmission(false);
    Wire.requestFrom(MPU_I2C_ADRESS, 1, true);
    return Wire.read();
}
