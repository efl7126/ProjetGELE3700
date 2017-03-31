function [ structDataUtilisateur ] = RecueilDonneesUtilisateur( idUtilisateur, structData )
% RecueilDonneesUtilisateur (FONCTION) -------------------------------------------
%
% DESCRIPTION : Collecte les donn�es li�es � un num�ro d'utilisateur �
%               l'int�rieur de l'ensemble des donn�es fournies par mySQL
%
% ENTR�E : idUtilisateur : num�ro d'utilisateur
%          structData : structure contenant les donn�es extraites de mySQL
%
% SORTIE : structDataUtilisateur : structure de m�me format que structData,
%                                  mais contenant seulement les donn�es
%                                  de l'utilisateur sp�cifi�
%
% -------------------------------------------------------------------------

% Trouver indices correspondant � l'utilisateur
vecIndicesUtilisateur = (structData.utilisateur == idUtilisateur);


% B�tir la structure avec donn�es de l'utilisateur
structDataUtilisateur = structData;

fields = fieldnames(structDataUtilisateur);
for i = 1:numel(fields)
    structDataUtilisateur.(fields{i}) = structDataUtilisateur.(fields{i})(vecIndicesUtilisateur);
end



end

