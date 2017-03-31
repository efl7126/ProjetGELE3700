% -------------------------------------------------------------------------
% ------------- GUI pour l'analyse de données d'accélération --------------
% -------------------------------------------------------------------------

function varargout = GUI_accelerometre(varargin)
% GUI_ACCELEROMETRE MATLAB code for GUI_accelerometre.fig
%      GUI_ACCELEROMETRE, by itself, creates a new GUI_ACCELEROMETRE or raises the existing
%      singleton*.
%
%      H = GUI_ACCELEROMETRE returns the handle to a new GUI_ACCELEROMETRE or the handle to
%      the existing singleton*.
%
%      GUI_ACCELEROMETRE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_ACCELEROMETRE.M with the given input arguments.
%
%      GUI_ACCELEROMETRE('Property','Value',...) creates a new GUI_ACCELEROMETRE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_accelerometre_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_accelerometre_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_accelerometre

% Last Modified by GUIDE v2.5 07-Mar-2017 22:42:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_accelerometre_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_accelerometre_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% -------------------------------------------------------------------------
% ------------- Fonction d'initialisation ---------------------------------
% -------------------------------------------------------------------------

% --- Executes just before GUI_accelerometre is made visible.
function GUI_accelerometre_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_accelerometre (see VARARGIN)

% Choose default command line output for GUI_accelerometre
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using GUI_accelerometre.
if strcmp(get(hObject,'Visible'),'off')
    plot(rand(5));
end

% UIWAIT makes GUI_accelerometre wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% ------- Élimination des données initialement sur le graphique -----------

axes(handles.axes1);
cla;


% --- Outputs from this function are returned to the command line.
function varargout = GUI_accelerometre_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% -------------------------------------------------------------------------
% ------------- Bouton de visualisation -----------------------------------
% -------------------------------------------------------------------------

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)

% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% ---------- Collecte de la prominence minimale des pics ------------------

 prominence = str2double(get(handles.edit5,'String'));
 if isempty(prominence)
    prominence = 0.3; % Valeur par défaut
 else
   % Ne fait rien
 end

% ---------- Graphique 1 --------------------------------------------------

axes(handles.axes1);
cla;

% Exécution du graphique
plot(handles.structDataUtilisateur.weatherDataID, handles.structDataUtilisateur.tempC);
display('Visualisation demandée');
xlabel('Numéro d''échantillon', 'FontSize', 10);
ylabel('Température (degré celcius)', 'FontSize', 10);

% ---------- Graphique 2 --------------------------------------------------

axes(handles.axes2);
cla;

% Exécution du graphique

findpeaks(handles.structDataUtilisateur.tempC, ...
    handles.structDataUtilisateur.weatherDataID,'MinPeakProminence',prominence, ...
    'Annotate','extents'); % Affichage sur graphique (y a-t-il une meilleure facon qu'executer la commande deux fois?)
[pks, locs, width, prom] = findpeaks(handles.structDataUtilisateur.tempC, ...
    handles.structDataUtilisateur.weatherDataID,'MinPeakProminence',prominence, ...
    'Annotate','extents');

xlabel('Numéro d''échantillon', 'FontSize', 10);
ylabel('Température (degré celcius)', 'FontSize', 10);


% ---------- Données d'analyse --------------------------------------------

% Nombre de pics
nb_pics = length(pks);
set(handles.edit1, 'String', nb_pics);
assignin('base', 'pks', pks);

% Distance moyenne entre les pics
dist_moy_peaks = mean(diff(locs));
set(handles.edit2, 'String', dist_moy_peaks);
assignin('base', 'locs', locs);

% Largeur moyenne des pics
largeur_moy = mean(width);
set(handles.edit3, 'String', largeur_moy);
assignin('base', 'width', width);

% Prominence moyenne des pics
prominence_moy = mean(prom);
set(handles.edit4, 'String', prominence_moy);
assignin('base', 'prom', prom);



% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% -------------------------------------------------------------------------
% ------------- Callback : menu déroulant ---------------------------------
% -------------------------------------------------------------------------

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

listIdUtilisateur = get(hObject,'String');
valIdUtilisateur = get(hObject,'Value');
idUtilisateur = listIdUtilisateur(valIdUtilisateur,:);
idUtilisateur = str2double(idUtilisateur);

% Appel à la fonction RecueilDonneesUtilisateur
structDataUtilisateur = RecueilDonneesUtilisateur(idUtilisateur, handles.data);
assignin('base','structDataUtilisateur',structDataUtilisateur);


handles.structDataUtilisateur = structDataUtilisateur;
guidata(hObject, handles);




% -------------------------------------------------------------------------
% --------- Fonction appelée lors de la création du menu déroulant --------
% -------------------------------------------------------------------------

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end

% ------------- AJOUT -----------------------------------------------------
% ------------- Connection à mySQL ----------------------------------------

addpath('C:\Users\Francois\Documents\Hiver 2017\GELE3700 - Projet GE 1\Projet\Fichiers\Matlab\queryMySQL');

data = requeteSQL();
handles.data = data; % Pour rendre la variable data accessible aux autres fonctions
handles.idUtilisateur = 0;
guidata(hObject, handles);

assignin('base','data',data);

% ---------------- Identifier les différents utilisateurs -----------------

tableauIdDifferents = unique(handles.data.utilisateur);

set(hObject, 'String', tableauIdDifferents);


% ------- Appel à la fonction RecueilDonneesUtilisateur -------------------

handles.structDataUtilisateur = RecueilDonneesUtilisateur(handles.idUtilisateur, handles.data);
guidata(hObject, handles);
assignin('base','structDataUtilisateur',handles.structDataUtilisateur);

% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% ------------- Connection à mySQL ----------------------------------------

data = requeteSQL();
handles.data = data; % Pour rendre la variable data accessible aux autres fonctions
guidata(hObject, handles);
assignin('base','data',data);

popupmenu1_Callback(handles.popupmenu1, eventdata, handles);
pushbutton1_Callback(handles.pushbutton1, eventdata, handles);
