function [result] = requeteSQL()

% -------------------------------------------------------------------------
% -------------- Configuration de l'interface Matlab/mySQL ----------------
% -------------------------------------------------------------------------

%% set path
addpath(fullfile(pwd, 'queryMySQL/src'));
javaaddpath('queryMySQL/lib/mysql-connector-java-5.1.6/mysql-connector-java-5.1.6-bin.jar');

%% import classes
import MySQLDatabase;

%% create database connection
db = MySQLDatabase('localhost', 'weather', 'root', 'Poseidon1242');


% -------------------------------------------------------------------------
% -------------- Recueil des données de la base de données ----------------
% -------------------------------------------------------------------------

db.prepareStatement('SELECT * FROM weatherdata', 10001);
result = db.query();
