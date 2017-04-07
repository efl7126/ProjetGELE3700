function [  ] = ConnectionUDP( )
% ConnectionUDP (FONCTION) -------------------------------------------
%
% DESCRIPTION : Recueil des données sur le port UDP.
%
% ENTRÉE : 
%
% SORTIE : 
%
% ------------------------------------------------------------------------- 

fwrite(monudp,55);  % Envoie 55 vers l'hôte
% Faire des delais avec matlab t0=tic; whil% Faire des delais avec matlab t0=tic; while((tic-t0)< 2e8)  (tic-t0)  ;ende((tic-t0)< 2e8)  (tic-t0)  ;end

UdpData = fread(monudp,8);  % Recueille 8 bits à partir de l'hôte   
            
Valeur = typecast(uint8(UdpData),'double');
% Cast la valeur obtenue, sur 8 bits, vers une valeur double
            
display(Valeur);