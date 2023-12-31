%Pasul 1

% Definirea statie de transmisie in MathWorks MathWorks (3 Apple Hill Dr, Natick, MA)

fq = 6e9; % 6 GHz
tx = txsite('Name','MathWorks', ...
'Latitude',42.3001, ...
'Longitude',-71.3504, ...
'Antenna',design(dipole,fq), ...
'AntennaHeight',60, ... % Unitati: metri
'TransmitterFrequency',fq, ... % Unitati: Hz
'TransmitterPower',15); % Unitati: Watts

%Pasul 2

% Definirea statiilor de receptive in cateva orase apropiate statiei de transmisie

rxNames = {...

'Boston, MA','Lexington, MA','Concord, MA','Marlborough, MA', ...
'Hopkinton, MA','Holliston, MA','Foxborough, MA','Quincy, MA'};

rxLocations = [...
42.3601 -71.0589; ... % Boston
42.4430 -71.2290; ... % Lexington
42.4604 -71.3489; ... % Concord
42.3459 -71.5523; ... % Marlborough
42.2287 -71.5226; ... % Hopkinton
42.2001 -71.4245; ... % Holliston
42.0654 -71.2478; ... % Foxborough
42.2529 -71.0023]; % Quincy

% Definiti senzitivitatea receptorului. Senzitivitatea reprezinta puterea minima necesara
% pentru un semnal pentru ca receptorul sa il poata receptiona corect

rxSensitivity = -90; % Units: dBm
rxs = rxsite('Name',rxNames, ...
'Latitude',rxLocations(:,1), ...
'Longitude',rxLocations(:,2),'Antenna',design(dipole,tx.TransmitterFrequency),'ReceiverSensitivity',rxSensitivity); % Units: dBm

%Pasul 3

viewer = siteviewer;
show(tx)
show(rxs)

%Pasul 4

viewer.Basemap = "openstreetmap";

%Pasul 5

coverage(tx,'freespace', ...
'SignalStrengths',rxSensitivity)

%Pasul 6

link(rxs,tx,'freespace')

%Pasul 7

coverage(tx,'rain','SignalStrengths', rxSensitivity)

link(rxs,tx,'rain')

%Pasul 8

% Definirea unei antene Yagi-Uda potrivita pentru frecventa transmitatorului nostrum

yagiAnt = design(yagiUda,tx.TransmitterFrequency);

% Modificarea inclinatiei entenei pentru a radia direct in campul XY (azimuth geographic)

yagiAnt.Tilt = 90;
yagiAnt.TiltAxis = 'y';
f = figure;
% Afisarea directivitatii

patternAzimuth(yagiAnt,tx.TransmitterFrequency)


%Pasul 9

%Inchiderea imaginii precedente (directivitatea antenei)

if (isvalid(f))
close(f);
end

% Modificarea antenei
tx.Antenna = yagiAnt;

% focalizarea lobului principal al antenei inspre Boston, MA prin stabilirea
% unghiului de azimuth intre transmitator si receptorul din Boston

tx.AntennaAngle = angle(tx, rxs(1));

% Actualizarea hartii, folosind �Ploaie� ca model de propagare
coverage(tx,'rain','SignalStrengths',rxSensitivity)

link(rxs,tx,'rain')

%Pasul 10

% Definirea puterilor semnalului intre nivelul de senzitivitate

% si valoarea maxima de -60 dB
sigStrengths = rxSensitivity:5:-60;

% Actualizarea hartii

coverage(tx,'rain','SignalStrengths',sigStrengths)

