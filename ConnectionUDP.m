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

    try
        echoudp('on',2640)  % Active le UDP echo server
                            % 2e argument : numéro de port du serveur
        
        
        monudp = udp('10.5.64.33',2640,'TimeOut',10);   % Connect the UDP object to the host.
                            % 1er argument : Remote host
                            % 2e argument : Remote port
                            % 3e argument : TimeOut pour la réception d'un
                            %               paquet                                       
        
        fopen(monudp); % Write to the host and read from the host.
    
        
        for i = 1:10

            fwrite(monudp,55);  % Envoie 55 vers l'hôte
            % Faire des delais avec matlab t0=tic; while((tic-t0)< 2e8)  (tic-t0)  ;end

            UdpData = fread(monudp,8);  % Recueille 8 bits à partir de l'hôte   
            
            Valeur = typecast(uint8(UdpData),'double');
            % Cast la valeur obtenue, sur 8 bits, vers une valeur double
            
            display(Valeur);

        end

        echoudp('off'); % Ferme le UDP echo server

        fclose(monudp); % Desinstancie l'object UDP
         
    catch
          
      
    end