# -*- coding: utf-8 -*-

# -----------------------------------------------------------------------------
# ----------- Interface entre le port serie et mySQL --------------------------
# -----------------------------------------------------------------------------

import serial 
import pymysql.cursors
import datetime
# import time
# import MySQLdb

#establish connection to MySQL. You'll have to change this for your database.
#==============================================================================
# dbConn = MySQLdb.connect("localhost","root","Poseidon1242","weather")
# cursor = dbConn.cursor()
#==============================================================================

connection = pymysql.connect(host='localhost', user='root', password='Poseidon1242', db='weather', charset='utf8mb4', cursorclass=pymysql.cursors.DictCursor)

# Recueil du numéro d'utilisateur
idUtilisateur = input("Entrez un numéro d'utilisateur : ")

# -----------------------------------------------------------------------------
# ----------- Ouverture du port serie et collecte des donnees -----------------
# -----------------------------------------------------------------------------

device = 'COM3' #this will have to be changed to the serial port you are using
try:
  print("Trying...",device) 
  arduino = serial.Serial('COM3', 9600)
  print("Successfully connected on port :", arduino.name)
  
except: 
  print("Failed to connect on",device)    

data = []
for iter in range(1000):

    try:
        dataLine = arduino.readline()  #read the data from the arduino
        data.append((dataLine.decode("utf-8"))[:5])
        print(data[iter])
      
        try:
          
            with connection.cursor() as cursor:  
          
                donneesTemps = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")  
                
                # Create a new record
                sql = "INSERT INTO `weatherdata` VALUES (NULL, %s, %s, %s)"
                cursor.execute(sql, (idUtilisateur, data[iter], donneesTemps))
                
                # connection is not autocommit by default. So you must commit to save
                # your changes.
                connection.commit()
              
                print("Envoi reussi a mySQL")
        except:
            print("Envoi echoué à mySQL")
    
    except:      
        print("Failed to get data from Arduino!")
      
# Deconnection du port serie
arduino.close()
# Deconnection de la database mySQL
connection.close() 