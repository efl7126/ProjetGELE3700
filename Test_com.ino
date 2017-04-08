
#include <WiFi.h>
#include <WiFiUdp.h>
#include <Wire.h>
#include <MPU6050.h>

MPU6050 mpu; 

const char* ssid     = "umcm-projets";
const char* password = "7XQ59vidWz";

WiFiUDP Udp;

  
 int localUdpPort = 2640;      // udp port to listen on
 char udpBuffer[255];           // buffer to hold incoming packet
char incomingPacket[255];  // buffer for incoming packets


 void udpOutInt(int val0);
void udpOutDouble(double val0);
 
void setup() 
{
    delay(1000);
    Serial.begin(115200);
    Serial.println();
  
  //============Wifi.initialize()===============   
    Serial.printf("Connecting to %s ", ssid);
    //WiFi.disconnect(true); delay(300);// delete old config
    //WiFi.persistent(true);
    WiFi.mode(WIFI_STA);
    WiFi.begin(ssid, password); 
    
    while (WiFi.status() != WL_CONNECTED)   { delay(500);    Serial.print(".");   }
    Serial.println("WiFi connected"); 
    Serial.println("IP address: "); Serial.println(WiFi.localIP()); 
    Serial.println("gateway: ");    Serial.println(WiFi.gatewayIP() );
         
    //  UdpRemoteIp =WiFi.gatewayIP() ;
    //
 
   Udp.begin(localUdpPort);
    //Serial.printf("\n Listening at IP: %s, on UDP port: %d \n", myIP.toString().c_str(), localUdpPort);
    Serial.printf("\n Listening at IP: %s, on UDP port: %d \n", WiFi.localIP().toString().c_str(), localUdpPort);

    delay(1000);
    Serial.println("Initialize MPU6050");

    while(!mpu.begin(MPU6050_SCALE_2000DPS, MPU6050_RANGE_2G))
    {
    Serial.println("Could not find a valid MPU6050 sensor, check wiring!");
    delay(500);
    }

    checkSettings();

    
}



void loop()
{

  Vector rawAccel = mpu.readRawAccel();
  Vector normAccel = mpu.readNormalizeAccel();
  
double valuex = rawAccel.XAxis;
double valuey = rawAccel.YAxis;
double valuez = rawAccel.ZAxis;
     if (Udp.parsePacket())
     {    Serial.printf("Received bytes from %s, port %d\n", Udp.remoteIP().toString().c_str(), Udp.remotePort());
          
          if( Udp.read(incomingPacket, 10) == 1)
             if( incomingPacket[0]==55)
               {
                   // send back a reply, to the IP address and port we got the packet from
                   Udp.beginPacket(Udp.remoteIP(), Udp.remotePort());
                
                    udpOutDouble(valuex); 
                                 
                 } 

                 if( incomingPacket[0]==56)
               {
                   // send back a reply, to the IP address and port we got the packet from
                   Udp.beginPacket(Udp.remoteIP(), Udp.remotePort());
                
                    udpOutDouble(valuey); 
                                 
                 } 

                 if( incomingPacket[0]==57)
               {
                   // send back a reply, to the IP address and port we got the packet from
                   Udp.beginPacket(Udp.remoteIP(), Udp.remotePort());
                
                    udpOutDouble(valuez); 
                                 
                 } 
     }

  

  Serial.print(" Xraw = ");
  Serial.print(rawAccel.XAxis);
  Serial.print(" Yraw = ");
  Serial.print(rawAccel.YAxis);
  Serial.print(" Zraw = ");

  Serial.println(rawAccel.ZAxis);
  Serial.print(" Xnorm = ");
  Serial.print(normAccel.XAxis);
  Serial.print(" Ynorm = ");
  Serial.print(normAccel.YAxis);
  Serial.print(" Znorm = ");
  Serial.println(normAccel.ZAxis);

delay(10);


  
}


 


 void udpOutInt(int val0)
{ 
   
    char c00=val0/256;  Udp.write(c00); c00=val0 - val0/256;  Udp.write(c00);
    Udp.endPacket();
}

void udpOutDouble(double val0)
{
            
    byte* array = (byte*) &val0;  for(int i=0;i<8;i++) {char c00=*(array+i);  Udp.write(c00);}   
    Udp.endPacket();
}

void checkSettings()
{
  Serial.println();
  
  Serial.print(" * Sleep Mode:            ");
  Serial.println(mpu.getSleepEnabled() ? "Enabled" : "Disabled");
  
  Serial.print(" * Clock Source:          ");
  switch(mpu.getClockSource())
  {
    case MPU6050_CLOCK_KEEP_RESET:     Serial.println("Stops the clock and keeps the timing generator in reset"); break;
    case MPU6050_CLOCK_EXTERNAL_19MHZ: Serial.println("PLL with external 19.2MHz reference"); break;
    case MPU6050_CLOCK_EXTERNAL_32KHZ: Serial.println("PLL with external 32.768kHz reference"); break;
    case MPU6050_CLOCK_PLL_ZGYRO:      Serial.println("PLL with Z axis gyroscope reference"); break;
    case MPU6050_CLOCK_PLL_YGYRO:      Serial.println("PLL with Y axis gyroscope reference"); break;
    case MPU6050_CLOCK_PLL_XGYRO:      Serial.println("PLL with X axis gyroscope reference"); break;
    case MPU6050_CLOCK_INTERNAL_8MHZ:  Serial.println("Internal 8MHz oscillator"); break;
  }
  
  Serial.print(" * Accelerometer:         ");
  
  mpu.setRange(MPU6050_RANGE_16G);
  
  switch(mpu.getRange())
  {
    case MPU6050_RANGE_16G:            Serial.println("+/- 16 g"); break;
    case MPU6050_RANGE_8G:             Serial.println("+/- 8 g"); break;
    case MPU6050_RANGE_4G:             Serial.println("+/- 4 g"); break;
    case MPU6050_RANGE_2G:             Serial.println("+/- 2 g"); break;
  }  

  Serial.print(" * Accelerometer offsets: ");
  Serial.print(mpu.getAccelOffsetX());
  Serial.print(" / ");
  Serial.print(mpu.getAccelOffsetY());
  Serial.print(" / ");
  Serial.println(mpu.getAccelOffsetZ());
  
  Serial.println();
}
