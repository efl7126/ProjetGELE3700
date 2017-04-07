function [  ] = ConnectionUDP( )
% ConnectionUDP (FONCTION) -------------------------------------------
%
% DESCRIPTION : Recueil des donn�es sur le port UDP.
%
% ENTR�E : 
%
% SORTIE : 
%
% ------------------------------------------------------------------------- 

fwrite(monudp,55);  % Envoie 55 vers l'h�te
% Faire des delais avec matlab t0=tic; whil% Faire des delais avec matlab t0=tic; while((tic-t0)< 2e8)  (tic-t0)  ;ende((tic-t0)< 2e8)  (tic-t0)  ;end

UdpData = fread(monudp,8);  % Recueille 8 bits � partir de l'h�te   
            
Valeur = typecast(uint8(UdpData),'double');
% Cast la valeur obtenue, sur 8 bits, vers une valeur double
            
display(Valeur);