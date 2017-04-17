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

UDP udp;  // define the UDP object
MySQL msql;

boolean udpActif = false;
PFont f;
int i = 0;

/**
 * init
 */
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
    
    
    // ================ MySQL ================================ 
    
    String user     = "root";
    String pass     = "Poseidon1242";
    String database = "acceleration";
    
    msql = new MySQL( this, "localhost", database, user, pass );
    
    if ( msql.connect() )
    {
     
        msql.query( "INSERT INTO `acceleration` VALUES (NULL, 1, NULL, 1,1,1,1,1,1)");
     
    }
    else
    {
        // connection failed !
        
        // - check your login, password
        // - check that your server runs on localhost and that the port is set right
        // - try connecting through other means (terminal or console / MySQL workbench / ...)
        println( "Connection failed" );
    }
  
}

//process events
void draw() {

  // ================ GUI ================================== 

  background(255);  
  int indent = 25;  

  // Set the font and fill for text  
  textFont(f);  
  fill(0);  

  i++;
  // Display everything  
  fill(0, 102, 153);
  text("Mesures enregistrées", indent, 40);
  fill(0, 0, 0);
  text("Accélération X : ", indent, 80);
  text(i, indent + 130, 80);
  text("Accélération Y : ", indent, 100);
  text(i, indent + 130, 100);
  text("Accélération Z : ", indent, 120);
  text(i, indent + 130, 120);
  text("Gyroscope X : ", indent, 140);
  text(i, indent + 130, 140);
  text("Gyroscope Y : ", indent, 160);
  text(i, indent + 130, 160);
  text("Gyroscope Z : ", indent, 180);
  text(i, indent + 130, 180);
  
  
  // ================ UDP ================================== 
  
  if(udpActif)
  {       
    String ip       = "10.5.64.33";  // the remote IP address
    int port        = 2640;    // the destination port
    
    String message = "55";
    udp.send( message, ip, port );
  }

  // ================ MySQL ================================== 
  
    if ( msql.connect() )
    {
     
        msql.query( "INSERT INTO `acceleration` VALUES (NULL, 1, NULL, %s,1,1,1,1,1)",i);
     
    }
    else
    {
        // connection failed !
        
        // - check your login, password
        // - check that your server runs on localhost and that the port is set right
        // - try connecting through other means (terminal or console / MySQL workbench / ...)
        println( "Connection failed" );
    }
  
    delay(100); // Delai pour faire une requete a la base de donnees
}

/** 
 * on key pressed event:
 * send the current key value over the network
 */
void keyPressed() {
    
    
    
}

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
    
    println(asFloat);
    
  }
  
}
