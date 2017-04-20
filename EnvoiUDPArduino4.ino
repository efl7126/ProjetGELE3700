#include <ESP8266WiFi.h>
//#include <WiFi.h>
#include <WiFiUdp.h>
#include <Wire.h>
#include <MPU6050.h>


//Defines pour débogage
#undef TEST
#define TESTTABLEAU
#undef TESTBUFFER


#define NBDONNEESMAXENVOI (8)    // Nombre de donnees double envoyes par UDP dans un meme buffer
                                  // Exemple : 8 x (8 donnees acceleration) x (4 bytes par float) = 256
#define SIZETABLEAU (NBDONNEESMAXENVOI)         // Taille maximale des tableaux recueillant les donnees d'acceleration

#define TAILLEMAXBUFFERUDP (256) // Je ne suis pas sur de cette valeur, il faudra tester
#define FREQUENCEMESURE (10)     // Frequence de mesure en ms

// =======================================================================
// ========== Déclarations et initialisations generales ==================
// =======================================================================
// - Un objet mpu de la classe MPU6050 est instancié pour être capable de 
// recevoir les données de l'accéléromètre MPU6050.
// - Un objet Udp de la classe WiFiUDP est instancié pour être capable de 
// connecter au réseau WiFi par protocole UDP.  


// Structure de donnees pour stocker les valeurs mesurees par l'accelerometre

struct BufferDonnees
{
  double valeursX[SIZETABLEAU] = {0};
  double valeursY[SIZETABLEAU] = {0};
  double valeursZ[SIZETABLEAU] = {0};
  double valeursXGyro[SIZETABLEAU] = {0};
  double valeursYGyro[SIZETABLEAU] = {0};
  double valeursZGyro[SIZETABLEAU] = {0};
  int longueur = 0;
  int marqueur = 9999;
  
} ts_BufferDonnees;


// Prototypes de fonctions utilitaires

void checkSettings();
void udpOutInt(int val0);
void udpOutDouble(double val0);
void afficherStructure(BufferDonnees &StructDonnees);
void afficherBuffer(BufferDonnees &StructDonnees);
void udpOutBuffer(BufferDonnees &bufferDonnees);
void udpOutBuffer2(BufferDonnees &bufferDonnees);


MPU6050 mpu; 

// Nom du reseau
const char* ssid     = "umcm-projets";

// Password du reseau
const char* password = "7XQ59vidWz";

WiFiUDP Udp;                  // Instanciation d'un objet global Udp

// Configuration du port UDP
int localUdpPort = 2640;      // udp port to listen on
char udpBuffer[255];          // buffer to hold incoming packet
char incomingPacket[255];     // buffer for incoming packets


// Ajouts par Francois pour le tableau de donnees

int indiceTableau = 0;      
 


// =======================================================================
// =================== Fonction d'initialisation =========================
// =======================================================================
// Initialisation de la communication Wifi UDP et du recueil des données
// de l'accéléromètre MPU6050

void setup() 
{
    Serial.begin(115200);   // Instancie la communication serielle a 115 200 bauds
    Serial.println();
  
  //============Wifi.initialize()===============   
    Serial.printf("Connecting to %s ", ssid);
    //WiFi.disconnect(true); delay(300);// delete old config
    //WiFi.persistent(true);
    WiFi.mode(WIFI_STA);
    WiFi.begin(ssid, password);   // Connection a l'aide de l'objet Wifi
    
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

    checkSettings();    // Fonction qui initialise les paramètres du MPU6050
    
}


// =======================================================================
// =================== Fonction en boucle infinie ========================
// =======================================================================
// - À chaque itération de la boucle infinie, l'accélération brute est recueillie
// du capteur MPU6050. 
// - Un paquet de données est recueilli par communication UDP. Dépendant de la valeur
// du premier byte, différentes données sont renvoyées par UDP. 
// - La boucle est reprise à chaque 10 millisecondes (délai).

void loop()
{

  int indiceTableau = 0;
  (ts_BufferDonnees.longueur) = 0;

  while(indiceTableau < SIZETABLEAU)
  {  
      Vector rawAccel = mpu.readRawAccel();           // Recueil de l'accélération brute dans un objet de classe Vector
      // Vector normAccel = mpu.readNormalizeAccel(); // Recueil de l'accélération normalisée dans un objet de classe Vector
      Vector rawGyro = mpu.readRawGyro();           // Recueil des données gyroscope brute dans un objet de classe Vector
      //Vector normGyro = mpu.readNormalizeGyro();    // Recueil des données gyroscope normalisée dans un objet de classe Vector
    
    
      // Valeurs d'accélération
      ts_BufferDonnees.valeursX[indiceTableau] = rawAccel.XAxis;
      ts_BufferDonnees.valeursY[indiceTableau] = rawAccel.YAxis;
      ts_BufferDonnees.valeursZ[indiceTableau] = rawAccel.ZAxis;
      // Valeurs du gyroscope
      ts_BufferDonnees.valeursXGyro[indiceTableau] = rawGyro.XAxis;
      ts_BufferDonnees.valeursYGyro[indiceTableau] = rawGyro.YAxis;
      ts_BufferDonnees.valeursZGyro[indiceTableau] = rawGyro.ZAxis;
    
      indiceTableau++;
      (ts_BufferDonnees.longueur)++;


      delay(FREQUENCEMESURE);
  }
  
  if (Udp.parsePacket())
  {    
      
     Serial.printf("Received bytes from %s, port %d\n", Udp.remoteIP().toString().c_str(), Udp.remotePort());

     // CHANGEMENT
     if(Udp.read(incomingPacket, 10)) // Si des caracteres sont recus
        {  
             
             udpOutBuffer(ts_BufferDonnees);           
                                   
        } 
      
     /*
     if( Udp.read(incomingPacket, 10) == 1) // Si retourne 1, la réception de 10 bytes a fonctionné.
        {  
          if(incomingPacket[0] == 55)       // Si le premier byte de la réception est de 55.        
          {     
               
             udpOutBuffer(ts_BufferDonnees);           
                              
          } 
        }
      */
             
  }


  // Données mesurées par le capteur et envoyées sur le port série
  // du microcontrôleur pour fins de testing
  
#ifdef TEST

  
  Serial.print(" Xraw = ");
  Serial.print(ts_bufferDonnees.valeursX[indiceTableau]);
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
  

#endif

#ifdef TESTTABLEAU

  afficherStructure(ts_BufferDonnees);

#endif

 

}
 

// =======================================================================
// ============== Définitions de fonctions utilitaires ===================
// =======================================================================

void afficherStructure(BufferDonnees &StructDonnees)
{ 
   for(int i = 0; i < SIZETABLEAU; i++)
   {
      Serial.print(" Accel_DataX = ");
      Serial.print(StructDonnees.valeursX[i]);
      Serial.print(" Accel_DataY = ");
      Serial.print(StructDonnees.valeursY[i]);
      Serial.print(" Accel_DataZ = ");
      Serial.println(StructDonnees.valeursZ[i]);
      Serial.print(" Gyro_DataX = ");
      Serial.print(StructDonnees.valeursXGyro[i]);
      Serial.print(" Gyro_DataY = ");
      Serial.print(StructDonnees.valeursYGyro[i]);
      Serial.print(" Gyro_DataZ = ");
      Serial.println(StructDonnees.valeursZGyro[i]);
      
   }
    
}

void afficherBuffer(BufferDonnees &StructDonnees, int donneeTemps)
{ 

      Serial.println(" ENVOIE VERS UDP ");
      Serial.print(" Numero = ");
      Serial.print(donneeTemps);
      Serial.print(" Marqueur = ");
      Serial.print((float)(StructDonnees.marqueur));
      Serial.print(" DataX = ");
      Serial.print((float)(StructDonnees.valeursX[donneeTemps]));
      Serial.print(" DataY = ");
      Serial.print((float)(StructDonnees.valeursY[donneeTemps]));
      Serial.print(" DataZ = ");
      Serial.println((float)(StructDonnees.valeursZ[donneeTemps]));
      
    
}

void udpOutInt(int val0)
{ 
   
    char c00=val0/256;  Udp.write(c00); c00=val0 - val0/256;  Udp.write(c00);
    Udp.endPacket();
}

void udpOutDouble(double val0)
{
            
    byte* array = (byte*) &val0;  
    for(int i=0;i<8;i++) 
    {
      char c00=*(array+i);  
      Udp.write(c00);       // Ecrit des bytes a chaque fois
    }   
    //Udp.endPacket();
}

void udpOutFloat(float val0)
{
            
    byte* array = (byte*) &val0;  
    for(int i=0; i<4 ;i++)  // Il y a 4 bytes dans un float
    {
      char c00=*(array+i);  
      Udp.write(c00);       // Ecrit des bytes a chaque fois
    }   
    //Udp.endPacket();
}


void udpOutBuffer(BufferDonnees &bufferDonnees)
{

  Udp.beginPacket(Udp.remoteIP(), Udp.remotePort());
  float marqueur = 9999; // Marqueur qui separe chaque temps de donnees accélerometre
  //float marqueur = 9999; // Marqueur qui separe chaque temps de donnees gyroscope
  for(int indiceTableau = 0; indiceTableau < NBDONNEESMAXENVOI; indiceTableau++)
  {

    
    
    
    udpOutFloat(marqueur);                                          //marqueur accelerometre
    udpOutFloat((float)ts_BufferDonnees.valeursX[indiceTableau]);   //Valeur X accelerometre
    udpOutFloat((float)ts_BufferDonnees.valeursY[indiceTableau]);   //Valeur Y accelerometre
    udpOutFloat((float)ts_BufferDonnees.valeursZ[indiceTableau]);   //Valeur Z accelerometre

    udpOutFloat(marqueur);                                          //marqueur gyroscope
    udpOutFloat((float)ts_BufferDonnees.valeursXGyro[indiceTableau]);   //Valeur X gyroscope
    udpOutFloat((float)ts_BufferDonnees.valeursYGyro[indiceTableau]);   //Valeur Y gyroscope
    udpOutFloat((float)ts_BufferDonnees.valeursZGyro[indiceTableau]);   //Valeur Z gyroscope
    
      

#ifdef TESTBUFFER      
      afficherBuffer(ts_BufferDonnees,donneeTemp);
#endif
     
    
  }

  Udp.endPacket();    // Fonction d'envoi du paquet
            
}


void udpOutBuffer2(BufferDonnees &bufferDonnees)
{

  for(int indiceTableau = 0; indiceTableau < (bufferDonnees.longueur); indiceTableau++)
  {

      for(int i = 0; i < 4; i++)
      {

        if(i == 0)
        {
            Udp.beginPacket(Udp.remoteIP(), Udp.remotePort());
            float marqueur = 9999; // Marqueur qui separe chaque temps de donnees
            udpOutFloat(marqueur);
            Serial.print(marqueur);
            Udp.endPacket();    // Fonction d'envoi du paquet
          
        }
        else if(i == 1)
        {
            Udp.beginPacket(Udp.remoteIP(), Udp.remotePort());
           
            udpOutFloat((float)ts_BufferDonnees.valeursX[indiceTableau]);
            Serial.print((float)ts_BufferDonnees.valeursX[indiceTableau]);
            Udp.endPacket();    // Fonction d'envoi du paquet
        }   
        else if(i == 2)
        {   
          
            Udp.beginPacket(Udp.remoteIP(), Udp.remotePort());
            udpOutFloat((float)ts_BufferDonnees.valeursY[indiceTableau]);
            Serial.print((float)ts_BufferDonnees.valeursY[indiceTableau]);
            Udp.endPacket();    // Fonction d'envoi du paquet
        }
        else if(i == 3)
        {
            Udp.beginPacket(Udp.remoteIP(), Udp.remotePort());
           
            udpOutFloat((float)ts_BufferDonnees.valeursZ[indiceTableau]);
            Serial.print((float)ts_BufferDonnees.valeursZ[indiceTableau]);
            Udp.endPacket();    // Fonction d'envoi du paquet        
        }
        

      }
    
    
  }
            
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
  
  Serial.print(" * Gyroscope:         ");
  switch(mpu.getScale())
  {
    case MPU6050_SCALE_2000DPS:        Serial.println("2000 dps"); break;
    case MPU6050_SCALE_1000DPS:        Serial.println("1000 dps"); break;
    case MPU6050_SCALE_500DPS:         Serial.println("500 dps"); break;
    case MPU6050_SCALE_250DPS:         Serial.println("250 dps"); break;
  } 
  
  Serial.print(" * Gyroscope offsets: ");
  Serial.print(mpu.getGyroOffsetX());
  Serial.print(" / ");
  Serial.print(mpu.getGyroOffsetY());
  Serial.print(" / ");
  Serial.println(mpu.getGyroOffsetZ());
  
  Serial.println();
}
