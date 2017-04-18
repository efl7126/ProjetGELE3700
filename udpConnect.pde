/**
 * (./) udp.pde - how to use UDP library as unicast connection
 * (cc) 2006, Cousot stephane for The Atelier Hypermedia
 * (->) http://hypermedia.loeil.org/processing/
 *
 * Create a communication between Processing<->Pure Data @ http://puredata.info/
 * This program also requires to run a small program on Pd to exchange data  
 * (hum!!! for a complete experimentation), you can find the related Pd patch
 * at http://hypermedia.loeil.org/processing/udp.pd
 * 
 * -- note that all Pd input/output messages are completed with the characters 
 * ";\n". Don't refer to this notation for a normal use. --
 */

// import UDP library
import hypermedia.net.*;
import de.bezier.data.sql.*;

// ========= Declaration d'objets globaux ==========

UDP udp;  // define the UDP object
MySQL msql;
PFont f;

boolean udpActif = true;
boolean debogage = false;
int i = 0;
int userID = 101;


// ============================================================
// ================= Fonctions utilitaires ====================
// ============================================================


void afficherTableau(float[] trame, int longueurTrame) {
  
  for(int i = 0; i < longueurTrame; i++)
  {
    
    println(trame[i]);
    
  }
  
}


void afficherGUI(float[] donnee) {
  
  // ================ GUI ================================== 

  background(255);  
  int indent = 25;  

  // Set the font and fill for text  
  textFont(f);  
  fill(0);    
  
  // Display everything  
  fill(0, 102, 153);
  text("Mesures enregistrées", indent, 40);
  fill(0, 0, 0);
  text("Accélération X : ", indent, 80);
  text(donnee[1], indent + 130, 80);
  text("Accélération Y : ", indent, 100);
  text(donnee[2], indent + 130, 100);
  text("Accélération Z : ", indent, 120);
  text(donnee[3], indent + 130, 120);
  text("Gyroscope X : ", indent, 140);
  text(donnee[5], indent + 130, 140);
  text("Gyroscope Y : ", indent, 160);
  text(donnee[6], indent + 130, 160);
  text("Gyroscope Z : ", indent, 180);
  text(donnee[7], indent + 130, 180);  
  
}



void envoiTrameSQL(float[] trame, int longueurTrame) {
  
  float[] donnee = new float[8];
  int indiceDonnee = 0;
  
  for(int i = 0; i < longueurTrame; i++)
  {
    indiceDonnee = i % 8;
    donnee[indiceDonnee] = trame[i];
    
    if((indiceDonnee == 7) && (donnee[0] == 9999) && (donnee[4] == 9999))
    {
      
        // ================ MySQL ================================== 
  
        if ( msql.connect() )
        {
         
            msql.query( "INSERT INTO `acceleration` VALUES (NULL, %s, NULL, %s,%s,%s,%s,%s,%s)", 
                      userID, donnee[1], donnee[2], donnee[3], donnee[5], donnee[6], donnee[7]);
         
        }
        else
        {
            // connection failed !
            
            // - check your login, password
            // - check that your server runs on localhost and that the port is set right
            // - try connecting through other means (terminal or console / MySQL workbench / ...)
            println( "Connection failed" );
        }
        
        
        afficherGUI(donnee);
      
    }
    
  }
  
}




// ============================================================
// ========================= Setup ============================
// ============================================================
void setup() {

  
  if(udpActif)
  {    
    
    String ip       = "10.5.64.33";  // the remote IP address
    int port        = 2640;    // the destination port
    
    // create a new datagram connection on port 6000
    // and wait for incomming message
    udp = new UDP( this, port);
    //udp.log( true ); 		// <-- printout the connection activity
    udp.listen( true );
    
  }
  
    // ================ GUI ================================== 
  
    size(300, 220);  
   
    f = createFont("Arial", 16);
    
    background(255);  
    int indent = 25;  
  
    // Set the font and fill for text  
    textFont(f);  
    fill(0);    
    
    // Display everything  
    fill(0, 102, 153);
    text("Mesures enregistrées", indent, 40);
    fill(0, 0, 0);
    text("Accélération X : ", indent, 80);
    text("0", indent + 130, 80);
    text("Accélération Y : ", indent, 100);
    text("0", indent + 130, 100);
    text("Accélération Z : ", indent, 120);
    text("0", indent + 130, 120);
    text("Gyroscope X : ", indent, 140);
    text("0", indent + 130, 140);
    text("Gyroscope Y : ", indent, 160);
    text("0", indent + 130, 160);
    text("Gyroscope Z : ", indent, 180);
    text("0", indent + 130, 180);  
  
    
    
    // ================ MySQL ================================ 
    
    String user     = "root";
    String pass     = "Poseidon1242";
    String database = "acceleration";
    
    msql = new MySQL( this, "localhost", database, user, pass );
    
  
}

// ============================================================
// ==================== Infinite loop =========================
// ============================================================
void draw() {
  
  
  // ================ UDP ================================== 
  
  if(udpActif)
  {       
    String ip       = "10.5.64.33";  // the remote IP address
    int port        = 2640;    // the destination port
    
    String message = "55";
    udp.send( message, ip, port );
  }


  
    delay(1000); // Delai pour faire une requete a la base de donnees
}

/** 
 * on key pressed event:
 * send the current key value over the network
 */
void keyPressed() {
    
    
    
}

// ============================================================
// ================== Recueil paquet UDP ======================
// ============================================================
/**
 * To perform any action on datagram reception, you need to implement this 
 * handler in your code. This method will be automatically called by the UDP 
 * object each time he receive a nonnull message.
 * By default, this method have just one argument (the received message as 
 * byte[] array), but in addition, two arguments (representing in order the 
 * sender IP address and his port) can be set like below.
 */
// void receive( byte[] data ) { 			// <-- default handler
void receive( byte[] data, String ip, int port ) {	// <-- extended handler
  
  /*
  // get the "real" message =
  // forget the ";\n" at the end <-- !!! only for a communication with Pd !!!
  data = subset(data, 0, data.length-2);
  String message = new String( data );
  
  // print the result
  println( "receive: \""+message+"\" from "+ip+" on port "+port );
  */
  
  int longueurTrame = 32;
  float[] trame = new float[longueurTrame];
  
  for(int i = 0; i < 32; i++)
  {
    byte[] byte4Array = new byte[4];
    
    int debut = i;
    
    for(int j = 0; j < 4; j++)
    {
      byte4Array[j] = data[(debut*4) + j];
    }
    
    int asInt = (byte4Array[0] & 0xFF) 
            | ((byte4Array[1] & 0xFF) << 8) 
            | ((byte4Array[2] & 0xFF) << 16) 
            | ((byte4Array[3] & 0xFF) << 24);
    
    float asFloat = Float.intBitsToFloat(asInt);
    
    trame[i] = asFloat;    
  }
  
  // Affichage de la trame recue
  afficherTableau(trame, longueurTrame);
  
  // Envoi de la trame sur la base de donnees
  envoiTrameSQL(trame, longueurTrame);
  
}


