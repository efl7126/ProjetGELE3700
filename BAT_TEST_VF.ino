/*
 * Niveau de charge d'une battrie
 */
 

// declaration des pins
int analogInput = 12;
int Pin_R = 26;
int Pin_G = 27;
int Pin_B = 14;
float vout = 0.0;
float vin = 0.0;
float R1 = 200000.0;    // !! resistance of R1 !!
float R2 = 10000.0;     // !! resistance of R2 !!
 
// Valeur de lecture
int value = 0;
 
void setup() {
  // declaration des pins
  Serial.begin(115200);
  pinMode(analogInput, INPUT);
  pinMode(Pin_R, OUTPUT);
  pinMode(Pin_B, OUTPUT);
  pinMode(Pin_G, OUTPUT);
 
}
 
void loop() {
  // lecture de la valeur de l'entree analogue
  value = analogRead(analogInput);
  
 // Conversion de la valeur de l'entree
 //une conversion de la valeur lue au niveau  
 //de la pin s'impose car elle la transmet en bytes.
 // Pour ce microcontrolleur 3.3V correspond a 4095.
  vout = (value * 3.3) / 4095.0;
   
  // Equation du diviseur de tension. 
  vin = vout / (R2/(R1+R2));       


Serial.print("vin= ");
 Serial.println(vin);
 
//Affichage de la LED
 if (vin == 4.2)
 {digitalWrite ( Pin_G, HIGH);
 digitalWrite (Pin_R,LOW );
 digitalWrite (Pin_B, HIGH);}
 

 if (vin>3.765 && vin<4.2)
 {digitalWrite ( Pin_G, HIGH);
 digitalWrite (Pin_R, LOW);
 digitalWrite (Pin_B, LOW);}
 
 if (vin>3.04 && vin<3.765)
 {digitalWrite (Pin_B, HIGH);
 digitalWrite (Pin_G, LOW);
 digitalWrite (Pin_R, LOW);}

if (vin<3.04 && vin>2.75)
 {digitalWrite ( Pin_R, HIGH);
  digitalWrite (Pin_B, LOW);
  digitalWrite (Pin_G, LOW);}
delay (2000);
}
