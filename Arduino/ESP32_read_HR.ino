  /*
     https://github.com/ThingEngineer/ESP32_BLE_client_uart/blob/master/src/ESP32_BLE_client_uart.ino
  */
#include "BLEDevice.h"


// The remote Nordic UART service service we wish to connect to.
// This service exposes two characteristics: one for transmitting and one for receiving (as seen from the client).
static BLEUUID serviceUUID("0000180d-0000-1000-8000-00805f9b34fb");

// The characteristics of the above service we are interested in.
// The client can send data to the server by writing to this characteristic.
static BLEUUID charUUID_RX("00002a37-0000-1000-8000-00805f9b34fb");   // RX Characteristic

// If the client has enabled notifications for this characteristic,
// the server can send data to the client as notifications.
static BLEUUID charUUID_TX("00002a37-0000-1000-8000-00805f9b34fb");   // TX Characteristic

static BLEAddress *pServerAddress;
static boolean doConnect = false;
static boolean connected = false;
static BLERemoteCharacteristic* pTXCharacteristic;
static BLERemoteCharacteristic* pRXCharacteristic;

static void notifyCallback(
  BLERemoteCharacteristic* pBLERemoteCharacteristic,
  uint8_t* pData,
  size_t length,
  bool isNotify) {
  Serial.println("Notify callback for TX characteristic received. Data:");
  for (int i = 0; i < length; i++) {
    // Serial.print((char)pData[i]);     // Print character to uart
    Serial.print(pData[i]);           // print raw data to uart
    Serial.print(" ");
  }
  Serial.println();
}

bool connectToServer(BLEAddress pAddress) {
  Serial.print("Establishing a connection to device address: ");
  Serial.println(pAddress.toString().c_str());

  BLEClient*  pClient  = BLEDevice::createClient();
  Serial.println(" - Created client");

  // Connect to the remove BLE Server.
  pClient->connect(pAddress);
  Serial.println(" - Connected to server");

  // Obtain a reference to the Nordic UART service on the remote BLE server.
  BLERemoteService* pRemoteService = pClient->getService(serviceUUID);
  if (pRemoteService == nullptr) {
    Serial.print("Failed to find Nordic UART service UUID: ");
    Serial.println(serviceUUID.toString().c_str());
    return false;
  }
  Serial.println(" - Remote BLE service reference established");


  // Obtain a reference to the TX characteristic of the Nordic UART service on the remote BLE server.
  pTXCharacteristic = pRemoteService->getCharacteristic(charUUID_TX);
  if (pTXCharacteristic == nullptr) {
    Serial.print("Failed to find TX characteristic UUID: ");
    Serial.println(charUUID_TX.toString().c_str());
    return false;
  }
  Serial.println(" - Remote BLE TX characteristic reference established");

  // Read the value of the TX characteristic.
  std::string value = pTXCharacteristic->readValue();
  Serial.print("The characteristic value is currently: ");
  Serial.println(value.c_str());

  pTXCharacteristic->registerForNotify(notifyCallback);

  // Obtain a reference to the RX characteristic of the Nordic UART service on the remote BLE server.
  pRXCharacteristic = pRemoteService->getCharacteristic(charUUID_RX);
  if (pRXCharacteristic == nullptr) {
    Serial.print("Failed to find our characteristic UUID: ");
    Serial.println(charUUID_RX.toString().c_str());
    return false;
  }
  Serial.println(" - Remote BLE RX characteristic reference established");

  // Write to the the RX characteristic.
  String helloValue = "Hello Remote Server";
  pRXCharacteristic->writeValue(helloValue.c_str(), helloValue.length());
}


/**
   Scan for BLE servers and find the first one that advertises the Nordic UART service.
*/
class MyAdvertisedDeviceCallbacks: public BLEAdvertisedDeviceCallbacks {
    /**
        Called for each advertising BLE server.
    */
    void onResult(BLEAdvertisedDevice advertisedDevice) {
      Serial.print("BLE Advertised Device found - ");
      Serial.println(advertisedDevice.toString().c_str());

      // We have found a device, check to see if it contains the Nordic UART service.
      if (advertisedDevice.haveServiceUUID() && advertisedDevice.getServiceUUID().equals(serviceUUID)) {

        Serial.println("Found a device with the desired ServiceUUID!");
        advertisedDevice.getScan()->stop();

        pServerAddress = new BLEAddress(advertisedDevice.getAddress());
        doConnect = true;

      } // Found our server
    } // onResult
}; // MyAdvertisedDeviceCallbacks


void setup() {
  Serial.begin(115200);
  Serial.println("Starting Arduino BLE Central Mode (Client) Nordic UART Service");

  BLEDevice::init("");

  // Retrieve a Scanner and set the callback we want to use to be informed when we
  // have detected a new device. Specify that we want active scanning and start the
  // scan to run for 30 seconds.
  BLEScan* pBLEScan = BLEDevice::getScan();
  pBLEScan->setAdvertisedDeviceCallbacks(new MyAdvertisedDeviceCallbacks());
  pBLEScan->setActiveScan(true);
  pBLEScan->start(30);
} // End of setup.


const uint8_t notificationOff[] = {0x0, 0x0};
const uint8_t notificationOn[] = {0x1, 0x0};
bool onoff = true;

void loop() {

  // If the flag "doConnect" is true then we have scanned for and found the desired
  // BLE Server with which we wish to connect.  Now we connect to it.  Once we are
  // connected we set the connected flag to be true.
  if (doConnect == true) {
    if (connectToServer(*pServerAddress)) {
      Serial.println("We are now connected to the BLE Server.");
      connected = true;
    } else {
      Serial.println("We have failed to connect to the server; there is nothin more we will do.");
    }
    doConnect = false;
  }

  // If we are connected to a peer BLE Server perform the following actions every five seconds:
  //   Toggle notifications for the TX Characteristic on and off.
  //   Update the RX characteristic with the current time since boot string.
  if (connected) {
    if (onoff) {
      Serial.println("Notifications turned on");
      pTXCharacteristic->getDescriptor(BLEUUID((uint16_t)0x2902))->writeValue((uint8_t*)notificationOn, 2, true);
    } else {
      Serial.println("Notifications turned off");
      pTXCharacteristic->getDescriptor(BLEUUID((uint16_t)0x2902))->writeValue((uint8_t*)notificationOff, 2, true);
    }

    // Toggle on/off value for notifications.
    onoff = onoff ? 0 : 1;

    // Set the characteristic's value to be the array of bytes that is actually a string
    String timeSinceBoot = "Time since boot: " + String(millis()/1000);
    pRXCharacteristic->writeValue(timeSinceBoot.c_str(), timeSinceBoot.length());
  }

  delay(1000); // Delay seconds between loops.
} // End of loop
