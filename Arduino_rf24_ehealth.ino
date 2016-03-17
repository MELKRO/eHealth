/*  
*    eHealth arduino
*    Copyright (C) 2016  Harri Oikarinen & Ville Pieksämäki
*
*    This program is free software: you can redistribute it and/or modify
*    it under the terms of the GNU General Public License as published by
*    the Free Software Foundation, either version 3 of the License, or
*    (at your option) any later version.
*
*    This program is distributed in the hope that it will be useful,
*    but WITHOUT ANY WARRANTY; without even the implied warranty of
*    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*    GNU General Public License for more details.
*
*    You should have received a copy of the GNU General Public License
*   along with this program.  If not, see <http://www.gnu.org/licenses/>.
*   
*   All libraries used in this project are under the terms of their own licenses.
*/


#include <SPI.h>
#include "RF24.h"
#include "thingspeakrequest.h"

#include <DallasTemperature.h>
#include <OneWire.h>
#include <Wire.h>
#include <WireExt.h>

#include <Sensirion.h>

#define SERIAL_DEBUG  1   //1 = On, 0 = Off

//#define INTERVAL_MSEC 900000 //15 Minutes
#define INTERVAL_MSEC 16000 //16 sec

//Thingspeak upload data melkro
//#define TS_W_API_KEY  "NROVLPCQOD5HBUVF"
//#define TS_R_API_KEY  "EIS2QHC6USTCNRA2"
//#define TS_W_CH_NUM  "84035"

//Thingspeak upload data kamk
#define TS_W_API_KEY  "E4GT1U4KAYY8FSJD"
//#define TS_R_API_KEY  "H30SZN00KPNSHD45"
#define TS_W_CH_NUM  "33914"

int m_iBlockSize = 32;
char message[512];

/* Hardware configuration: Set up nRF24L01 radio on SPI bus plus pins 7 & 8 */
RF24 radio(7,8);
                     
byte addresses[][6] = {"1Node","3Node"}; 
void sendMessage(const char *msg);
ThingSpeakUploadRequest uploadRequest;

//Sensors variables
unsigned long lastReadTime = 0;
float sht_temp = 0;
float sht_hum = 0;
float dewpoint = 0;
float sht_dew = 0;

int photocellPin = 0;
float photocellReading;

//sht71 sensor connections
const uint8_t dataPin  =  2;  
const uint8_t clockPin =  3;

//Dallas sensor connections
OneWire ow(4);
DallasTemperature tempD_sensor1(&ow);
DallasTemperature tempD_sensor2(&ow);

//SHT71 sensor
Sensirion humiSensor = Sensirion(dataPin, clockPin);

//Prototypes
void readAllSensors();
float calcDewpoint(float, float);
void logData();

void setup()
{
    radio.begin();  
    
    radio.setAutoAck(1);                    // Ensure autoACK is enabled
    radio.enableAckPayload();               // Allow optional ack payloads
    radio.setRetries(0,15);                 // Smallest time between retries, max no. of retries
    radio.setPayloadSize(32);
    
    radio.openWritingPipe(addresses[1]);        // Both radios listen on the same pipes by default, but opposite addresses
    radio.openReadingPipe(1,addresses[0]);      // Open a reading pipe on address 0, pipe 1
    
    if(SERIAL_DEBUG) Serial.begin(9600);         
    
    if(SERIAL_DEBUG)Serial.print("\n"); 

    //1Wire
    Wire.begin(4);

    //Setting RF24 PA level to MAX for maximum range
    radio.setPALevel(RF24_PA_MAX);

}
void loop()
{ 
    readAllSensors(); //Read sensors that need datahandling

    //Send sensor data to thingspeak
    uploadRequest.SetApiKey(TS_W_API_KEY);
    tempD_sensor1.requestTemperatures();
    uploadRequest.SetFieldData(1,tempD_sensor1.getTempCByIndex(0)); //Livingroom temp
    tempD_sensor2.requestTemperatures();
    uploadRequest.SetFieldData(2,tempD_sensor2.getTempCByIndex(1)); //Outside temp
    uploadRequest.SetFieldData(3,sht_temp); //Bathroom temp
    uploadRequest.SetFieldData(4,sht_hum); //Bathroom Hum
    uploadRequest.SetFieldData(5,dewpoint); //Dewpoint
    uploadRequest.SetFieldData(6,photocellReading); //Livingroom light

    uploadRequest.ToString(message); 
    sendMessage(message);
    delay(INTERVAL_MSEC);
}

//This function send message via RF24 to raspberry pi, Which send it forward to thingspeak
void sendMessage(const char *msg)
{   
     unsigned int msgLen = strlen(msg);
     unsigned int fullBlocks = msgLen / m_iBlockSize;
     char lastBlock[m_iBlockSize];
     memset(lastBlock,0,sizeof(lastBlock));

     unsigned int block;

     for(block = 0; block < fullBlocks; block++)
     {
         radio.write(&msg[block*m_iBlockSize],m_iBlockSize);
     }

     strcpy(lastBlock,&msg[block*m_iBlockSize]);
     radio.write(&msg[block*m_iBlockSize],m_iBlockSize,0);
}

//This function read sensors which need datahandling 
 void readAllSensors()
{
  //Read SHT71 sensor
  humiSensor.measure(&sht_temp, &sht_hum, &sht_dew);

  //Call function which calculate dewpoint 
  dewpoint = calcDewpoint(sht_hum, sht_temp);

  //Read photocell sensor, which is in ad-converter
  photocellReading = readPhotocell();
}

//This function read photocell sensor, which is in ad-converter
int readPhotocell()
{
  int light;
  light = analogRead(photocellPin);  

  photocellReading = (float) light;
  return photocellReading;
}

//This function calculate dewpoint
float calcDewpoint(float h, float t)
{ 
  float k, dew_point;
  k = (log10(h) - 2) / 0.4343 + (17.62 * t) / (243.12 + t);
  dew_point = 243.12 * k / (17.62 - k);
  return dew_point;
}
