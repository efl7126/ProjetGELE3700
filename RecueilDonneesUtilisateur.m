function [ structDataUtilisateur ] = RecueilDonneesUtilisateur( idUtilisateur, structData )
% RecueilDonneesUtilisateur (FONCTION) -------------------------------------------
%
% DESCRIPTION : Collecte les données liées à un numéro d'utilisateur à
%               l'intérieur de l'ensemble des données fournies par mySQL
%
% ENTRÉE : idUtilisateur : numéro d'utilisateur
%          structData : structure contenant les données extraites de mySQL
%
% SORTIE : structDataUtilisateur : structure de même format que structData,
%                                  mais contenant seulement les données
%                                  de l'utilisateur spécifié
%
% -------------------------------------------------------------------------

% Trouver indices correspondant à l'utilisateur
vecIndicesUtilisateur = (structData.utilisateur == idUtilisateur);


% Bâtir la structure avec données de l'utilisateur
structDataUtilisateur = structData;

fields = fieldnames(structDataUtilisateur);
for i = 1:numel(fields)
    structDataUtilisateur.(fields{i}) = structDataUtilisateur.(fields{i})(vecIndicesUtilisateur);
end



end

