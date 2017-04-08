# Code Arduino

Mettre tous les fichiers de code Arduino.

  Test_com.ino : contient toute les améliorations ajoutées au codes le vendredi 5/4/2017.

Le dossier compresser Arduino-MPU6050-master.zip comprend la bibliotheque et les exemples permettant d'avoir les données de l'accélérometre et du gyroscope.

L'instruction suivante permet de modifier le range de mesure de l'accelerometre : "mpu.setRange(MPU6050_RANGE_16G);"

L'instruction suivante permet de modifier le range de mesure du gyroscopee : "mpu.setScale(MPU6050_SCALE_250DPS);"

Les exemples les plus utiles sont : "MPU6050_accel_simple" et "MPU6050_gyro_simple".

Quelques sites utiles :

  - https://github.com/jarzebski/Arduino-MPU6050 : Lien vers la bibliotheque.
  
  - https://www.i2cdevlib.com/docs/html/class_m_p_u6050.html#abd8fc6c18adf158011118fbccc7e7054 : Liste et description de toute les fonctions de la bibliotheque.
  
  - http://samselectronicsprojects.blogspot.ca/2014/07/processing-data-from-mpu-6050.html : Explique comment le range du gyroscope et de l'accélerometre fonctionnent.
  - https://www.invensense.com/wp-content/uploads/2015/02/MPU-6000-Datasheet1.pdf : Datasheet du composant (MPU5060) Très Utile !!!
  
  - http://tiptopboards.free.fr/arduino_forum/viewtopic.php?f=2&t=28 : Explique le fonctionnement du gyroscope et de l'accélerometre et donne des exemples de conversions (accéleration -> vitesse -> distance).
  
  - https://diyhacking.com/arduino-mpu-6050-imu-sensor-tutorial/ : Arduino MPU 6050 Setup and 3D processng
