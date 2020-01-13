  /*
     Arduino and MPU6050 Accelerometer and Gyroscope Sensor Tutorial
     by Dejan, https://howtomechatronics.com
     https://howtomechatronics.com/tutorials/arduino/arduino-and-mpu6050-accelerometer-and-gyroscope-tutorial/
  */
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>
//#include <Adafruit_MPU6050.h>
//#include <Adafruit_Sensor.h>
#include <Wire.h> 
#include <time.h>
//#include <DHT.h>
#include <iostream>
#include <string>
 
BLECharacteristic *pCharacteristic;
 
bool deviceConnected = false;
const int LED = 2; // Could be different depending on the dev board. I used the DOIT ESP32 dev board.
 
/*
 * Definição do DHT11
 */
//#define DHTPIN 23 // pino de dados do DHT11
//#define DHTTYPE DHT11 // define o tipo de sensor, no caso DHT11
 
//DHT dht(DHTPIN, DHTTYPE);
 
//int humidity;
//int temperature;
 
// Veja o link seguinte se quiser gerar seus próprios UUIDs:
// https://www.uuidgenerator.net/
 
#define SERVICE_UUID           "6E400001-B5A3-F393-E0A9-E50E24DCCA9E" // UART service UUID
#define CHARACTERISTIC_UUID_RX "6E400002-B5A3-F393-E0A9-E50E24DCCA9E"
#define DHTDATA_CHAR_UUID "6E400003-B5A3-F393-E0A9-E50E24DCCA9E" 
 
//Adafruit_MPU6050 mpu;

int valor = 0;
const int MPU = 0x68; // MPU6050 I2C address
float AccX, AccY, AccZ;
//float accAngleX, accAngleY;
//float AccErrorX, AccErrorY;
int c = 0;

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
 
void setup() {
  Serial.begin(115200);
  Wire.begin();                      // Initialize comunication
  Wire.beginTransmission(MPU);       // Start communication with MPU6050 // MPU=0x68
  Wire.write(0x6B);                  // Talk to the register 6B
  Wire.write(0x00);                  // Make reset - place a 0 into the 6B register
  Wire.endTransmission(true);        //end the transmission
  delay(20);
  
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
 
void loop() {
  if (deviceConnected) {
 /*
    humidity = dht.readHumidity();
    temperature = dht.readTemperature();
    // testa se retorno é valido, caso contrário algo está errado.
    if (isnan(temperature) || isnan(humidity)) 
    {
      Serial.println("Failed to read from DHT");
    }
    else
    {
      Serial.print("Umidade: ");
      Serial.print(humidity);
      Serial.print(" %\t");
      Serial.print("Temperatura: ");
      Serial.print(temperature);
      Serial.println(" *C");
    }
     
    char humidityString[2];
    char temperatureString[2];
    dtostrf(humidity, 1, 2, humidityString);
    dtostrf(temperature, 1, 2, temperatureString);
 
    char dhtDataString[16];
    sprintf(dhtDataString, "%d,%d", temperature, humidity);
    */

    // === Read acceleromter data === //
    Wire.beginTransmission(MPU);
    Wire.write(0x3B); // Start with register 0x3B (ACCEL_XOUT_H)
    Wire.endTransmission(false);
    Wire.requestFrom(MPU, 6, true); // Read 6 registers total, each axis value is stored in 2 registers
    
    //For a range of +-2g, we need to divide the raw values by 16384, according to the datasheet
    AccX = (Wire.read() << 8 | Wire.read()) / 16384.0; // X-axis value
    AccY = (Wire.read() << 8 | Wire.read()) / 16384.0; // Y-axis value
    AccZ = (Wire.read() << 8 | Wire.read()) / 16384.0; // Z-axis value
      
    // Print the values on the serial monitor
    Serial.print(AccX);
    Serial.print(",");
    Serial.print(AccY);
    Serial.print(",");
    Serial.println(AccZ);

    char accXString[5];
    char accYString[5];
    char accZString[5];
    
    //dtostrf(AccX, 5, 2, accXString);
    //dtostrf(AccY, 5, 2, accYString);
    //dtostrf(AccZ, 5, 2, accZString);

    char mpuDataString[30];
    //sprintf(mpuDataString, "%d,%d,%d,%d", a.acceleration.x, a.acceleration.y, a.acceleration.z, temp.temperature);
    //sprintf(mpuDataString, "%d", a.acceleration.x);

    /*
    Serial.println("Acc em string: ");
    Serial.print(accXString);
    Serial.print(",");
    Serial.print(accYString);
    Serial.print(",");
    Serial.println(accZString);
    */

    valor += 1;
    //sprintf(mpuDataString, "%d,%d", valor, AccX);
    sprintf(mpuDataString, "%f,%f,%f", AccX, AccY, AccZ);
    
    pCharacteristic->setValue(mpuDataString);
     
    pCharacteristic->notify(); // Envia o valor para o aplicativo!
    Serial.print("*** Dado enviado: ");
    Serial.print(mpuDataString);
    Serial.println(" ***");
  }
  delay(1000);
}
