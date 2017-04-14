# -*- coding: utf-8 -*-


import socket


#'10.5.64.33'

UDP_IP = "0.0.0.0"
UDP_PORT = 2640

MESSAGE = "55"

sock = socket.socket(socket.AF_INET, # Internet
                     socket.SOCK_DGRAM) # UDP
sock.bind((UDP_IP, UDP_PORT))

while True:
    
    #sock.sendto(MESSAGE, (UDP_IP, UDP_PORT))
    
    data, addr = sock.recvfrom(1) # buffer size is 1024 bytes
    print("received message:", data)

    
    
