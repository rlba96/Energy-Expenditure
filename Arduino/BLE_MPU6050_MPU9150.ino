#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>
#include <Wire.h>
#include <iostream>
#include <string>

// Register names according to the datasheet
#define MPU9150_ACCEL_XOUT_H       0x3B   // R  
#define MPU9150_ACCEL_XOUT_L       0x3C   // R  
#define MPU9150_ACCEL_YOUT_H       0x3D   // R  
#define MPU9150_ACCEL_YOUT_L       0x3E   // R  
#define MPU9150_ACCEL_ZOUT_H       0x3F   // R  
#define MPU9150_ACCEL_ZOUT_L       0x40   // R  

#define MPU9150_PWR_MGMT_1         0x6B   // R/W

//MPU9150 Compass
#define MPU9150_CMPS_XOUT_L        0x4A   // R
#define MPU9150_CMPS_XOUT_H        0x4B   // R
#define MPU9150_CMPS_YOUT_L        0x4C   // R
#define MPU9150_CMPS_YOUT_H        0x4D   // R
#define MPU9150_CMPS_ZOUT_L        0x4E   // R
#define MPU9150_CMPS_ZOUT_H        0x4F   // R

// BLE uuids
#define SERVICE_UUID           "6E400001-B5A3-F393-E0A9-E50E24DCCA9E" // UART service UUID
#define CHARACTERISTIC_UUID_RX "6E400002-B5A3-F393-E0A9-E50E24DCCA9E"
#define DHTDATA_CHAR_UUID "6E400003-B5A3-F393-E0A9-E50E24DCCA9E" 

int MPU9150_I2C_ADDRESS = 0x69;   // MPU-9150 I2C address
const int MPU = 0x68; // MPU-6050 I2C address

// Store acc data
int mpu9150_accX;
int mpu9150_accY;
int mpu9150_accZ;

float mpu6050_accX;
float mpu6050_accY;
float mpu6050_accZ;

int c = 0;

bool deviceConnected = false;

char mpuDataString[30];     // String to send over BLE

BLECharacteristic *pCharacteristic;

class MyServerCallbacks: public BLEServerCallbacks {
    void onConnect(BLEServer* pServer) {
      deviceConnected = true;
    };
 
    void onDisconnect(BLEServer* pServer) {
      deviceConnected = false;
    }
};

class MyCallbacks: public BLECharacteristicCallbacks {
    void onWrite(BLECharacteristic *pCharacteristic) {
      std::string rxValue = pCharacteristic->getValue();
      Serial.println(rxValue[0]);
 
      if (rxValue.length() > 0) {
        Serial.println("*********");
        Serial.print("Received Value: ");
 
        for (int i = 0; i < rxValue.length(); i++) {
          Serial.print(rxValue[i]);
        }
        Serial.println();
        Serial.println("*********");
      }
    }
};

void setup()
{      
  // Initialize the Serial Bus for printing data.
  Serial.begin(115200);

  // Initialize the 'Wire' class for the I2C-bus.
  Wire.begin();

  Wire.beginTransmission(MPU);       // Start communication with MPU6050 // MPU=0x68
  Wire.write(0x6B);                  // Talk to the register 6B
  Wire.write(0x00);                  // Make reset - place a 0 into the 6B register
  Wire.endTransmission(true);        //end the transmission
  delay(20);

  // Clear the 'sleep' bit to start the sensor.
  MPU9150_writeSensor(MPU9150_PWR_MGMT_1, 0);
  //MPU9150_writeSensor_2(MPU9150_PWR_MGMT_1, 0);

  MPU9150_setupCompass();
  //MPU9150_setupCompass_2();

  // Create the BLE Device
  BLEDevice::init("ESP32 Acc"); // Give it a name
 
  // Configura o dispositivo como Servidor BLE
  BLEServer *pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());
 
  // Cria o servico UART
  BLEService *pService = pServer->createService(SERVICE_UUID);
 
  // Cria uma Característica BLE para envio dos dados
  pCharacteristic = pService->createCharacteristic(
                      DHTDATA_CHAR_UUID,
                      BLECharacteristic::PROPERTY_NOTIFY
                    );
                       
  pCharacteristic->addDescriptor(new BLE2902());
 
  // cria uma característica BLE para recebimento dos dados
  BLECharacteristic *pCharacteristic = pService->createCharacteristic(
                                         CHARACTERISTIC_UUID_RX,
                                         BLECharacteristic::PROPERTY_WRITE
                                       );
 
  pCharacteristic->setCallbacks(new MyCallbacks());
 
  // Inicia o serviço
  pService->start();
 
  // Inicia a descoberta do ESP32
  pServer->getAdvertising()->start();
  Serial.println("Esperando um cliente se conectar...");
}

void loop()
{
  if (deviceConnected) {
    
    // Store values
    mpu9150_accX = MPU9150_readSensor(MPU9150_ACCEL_XOUT_L,MPU9150_ACCEL_XOUT_H);
    mpu9150_accY = MPU9150_readSensor(MPU9150_ACCEL_YOUT_L,MPU9150_ACCEL_YOUT_H);
    mpu9150_accZ = MPU9150_readSensor(MPU9150_ACCEL_ZOUT_L,MPU9150_ACCEL_ZOUT_H);
  
    // === Read accelerometer data === //
    Wire.beginTransmission(MPU);
    Wire.write(0x3B); // Start with register 0x3B (ACCEL_XOUT_H)
    Wire.endTransmission(false);
    Wire.requestFrom(MPU, 6, true); // Read 6 registers total, each axis value is stored in 2 registers
    
    //For a range of +-2g, we need to divide the raw values by 16384, according to the datasheet
    mpu6050_accX = (Wire.read() << 8 | Wire.read()) / 16384.0; // X-axis value
    mpu6050_accY = (Wire.read() << 8 | Wire.read()) / 16384.0; // Y-axis value
    mpu6050_accZ = (Wire.read() << 8 | Wire.read()) / 16384.0; // Z-axis value
    
    // Print MPU-9150 values
    Serial.print(mpu9150_accX);
    Serial.print("  ");
    Serial.print(mpu9150_accY);
    Serial.print("  ");
    Serial.print(mpu9150_accZ);
    Serial.println();
  
    // Print MPU-6050 values
    Serial.print(mpu6050_accX);
    Serial.print(",");
    Serial.print(mpu6050_accY);
    Serial.print(",");
    Serial.println(mpu6050_accZ);
    Serial.println();
  
    sprintf(mpuDataString,"%d,%d,%d,%f,%f,%f",mpu9150_accX,mpu9150_accY,mpu9150_accZ,mpu6050_accX,mpu6050_accY,mpu6050_accZ);
  
    pCharacteristic->setValue(mpuDataString);
       
    pCharacteristic->notify(); // Envia o valor para o aplicativo!
    Serial.print("*** Dado enviado: ");
    Serial.print(mpuDataString);
    Serial.println(" ***");
  }
  delay(1000);
}

void MPU9150_setupCompass(){
  MPU9150_I2C_ADDRESS = 0x0C;      //change Address to Compass

  MPU9150_writeSensor(0x0A, 0x00); //PowerDownMode
  MPU9150_writeSensor(0x0A, 0x0F); //SelfTest
  MPU9150_writeSensor(0x0A, 0x00); //PowerDownMode

  MPU9150_I2C_ADDRESS = 0x69;      //change Address to MPU

  MPU9150_writeSensor(0x24, 0x40); //Wait for Data at Slave0
  MPU9150_writeSensor(0x25, 0x8C); //Set i2c address at slave0 at 0x0C
  MPU9150_writeSensor(0x26, 0x02); //Set where reading at slave 0 starts
  MPU9150_writeSensor(0x27, 0x88); //set offset at start reading and enable
  MPU9150_writeSensor(0x28, 0x0C); //set i2c address at slv1 at 0x0C
  MPU9150_writeSensor(0x29, 0x0A); //Set where reading at slave 1 starts
  MPU9150_writeSensor(0x2A, 0x81); //Enable at set length to 1
  MPU9150_writeSensor(0x64, 0x01); //overvride register
  MPU9150_writeSensor(0x67, 0x03); //set delay rate
  MPU9150_writeSensor(0x01, 0x80);

  MPU9150_writeSensor(0x34, 0x04); //set i2c slv4 delay
  MPU9150_writeSensor(0x64, 0x00); //override register
  MPU9150_writeSensor(0x6A, 0x00); //clear usr setting
  MPU9150_writeSensor(0x64, 0x01); //override register
  MPU9150_writeSensor(0x6A, 0x20); //enable master i2c mode
  MPU9150_writeSensor(0x34, 0x13); //disable slv4
}

////////////////////////////////////////////////////////////
///////// I2C functions to get easier all values ///////////
////////////////////////////////////////////////////////////

int MPU9150_readSensor(int addrL, int addrH){
  Wire.beginTransmission(MPU9150_I2C_ADDRESS);
  Wire.write(addrL);
  Wire.endTransmission(false);

  Wire.requestFrom(MPU9150_I2C_ADDRESS, 1, true);
  byte L = Wire.read();

  Wire.beginTransmission(MPU9150_I2C_ADDRESS);
  Wire.write(addrH);
  Wire.endTransmission(false);

  Wire.requestFrom(MPU9150_I2C_ADDRESS, 1, true);
  byte H = Wire.read();
  
  //For a range of +-2g, 4g, 8g or 16g, we need to divide the raw values by 16384, 8192, 4096 or 2048 according to the datasheet
  return (int16_t)(((H<<8)+L)/4096);
}

int MPU9150_writeSensor(int addr,int data){
  Wire.beginTransmission(MPU9150_I2C_ADDRESS);
  Wire.write(addr);
  Wire.write(data);
  Wire.endTransmission(true);

  return 1;
}
