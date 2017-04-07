% ConnectionUDP (PILOTE) -------------------------------------------
%
% DESCRIPTION : Recueil des données sur le port UDP.
%
% ENTRÉE : 
%
% SORTIE : 
%
% ------------------------------------------------------------------------- 

intervalleAttente = 0.01;   % Intervalle de recueil de donnees
attenteMax = 0.1;           % Intervalle d'attente maximale

IdAccX = 55;
IdAccY = 56;
IdAccZ = 57;

    try
        echoudp('on',2640)  % Active le UDP echo server
                            % 2e argument : numéro de port du serveur
        
       
        monudp = udp('10.5.64.33',2640,'TimeOut',attenteMax);   % Connect the UDP object to the host.
                            % 1er argument : Remote host
                            % 2e argument : Remote port
                            % 3e argument : TimeOut pour la réception d'un
                            %               paquet                                       
        
        fopen(monudp); % Write to the host and read from the host.
    
        
        for i = 1:100

            
            % ==================== Recueil acc X =======================
            
            fwrite(monudp,IdAccX);  % Envoie 55 vers l'hôte
            % Faire des delais avec matlab t0=tic; whil% Faire des delais avec matlab t0=tic; while((tic-t0)< 2e8)  (tic-t0)  ;ende((tic-t0)< 2e8)  (tic-t0)  ;end

            UdpData = fread(monudp,8);  % Recueille 8 bits à partir de l'hôte   
            
            Valeur = typecast(uint8(UdpData),'double');
            % Cast la valeur obtenue, sur 8 bits, vers une valeur double
            
            fprintf('Valeur acc x : %d \n', Valeur);
            
            
            
              % ==================== Recueil acc Y =======================
            
            fwrite(monudp,IdAccY);  % Envoie 55 vers l'hôte
            % Faire des delais avec matlab t0=tic; whil% Faire des delais avec matlab t0=tic; while((tic-t0)< 2e8)  (tic-t0)  ;ende((tic-t0)< 2e8)  (tic-t0)  ;end

            UdpData = fread(monudp,8);  % Recueille 8 bits à partir de l'hôte   
            
            Valeur = typecast(uint8(UdpData),'double');
            % Cast la valeur obtenue, sur 8 bits, vers une valeur double
            
            fprintf('Valeur acc y : %d \n', Valeur);
            
            
            
              % ==================== Recueil acc Z =======================
            
            fwrite(monudp,IdAccZ);  % Envoie 55 vers l'hôte
            % Faire des delais avec matlab t0=tic; whil% Faire des delais avec matlab t0=tic; while((tic-t0)< 2e8)  (tic-t0)  ;ende((tic-t0)< 2e8)  (tic-t0)  ;end

            UdpData = fread(monudp,8);  % Recueille 8 bits à partir de l'hôte   
            
            Valeur = typecast(uint8(UdpData),'double');
            % Cast la valeur obtenue, sur 8 bits, vers une valeur double
            
            fprintf('Valeur acc z : %d \n', Valeur);
           
            
            
            % Pause avant de faire une requete pour une prochaine donnee
            pause(intervalleAttente);

        end

        echoudp('off'); % Ferme le UDP echo server

        fclose(monudp); % Desinstancie l'object UDP
         
    catch
          
        display('Il y a eu une erreur');
      
    end