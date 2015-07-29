% function [dataout] = load_tower_data(filename,mult,scale)
%

function [dataout] = load_NWTC_binary_tower_data(filename,mult,scale,datafile)

% Each record begins with a 4-byte word containing the integer 72.
% This is followed by 72 2-byte words, for a total of 148 bytes/record.

dummy = [ 1 2 3 ]; % just to fix UltraEdit syntax highlighting after transpose operator
                   % (UE thinks that the apostrophe is the start of a string)

% To convert binary data to engineering units:
%  - divide number of counts (read as signed 16-bit int) by mult[i]
%  - divide by scale[i]
% E.g., Air temp = 32767 counts (max positive value)
%  32767/6.5536 =~ 5000
%  5000/100 = 50 deg (which is max of eng unit range)

% 20110426 - changed 1.6264 to 1.6384 on sonic accels
% 20110428 - changed 1.6384 to 163.84 on sonic accels - output units are g
% 20110509 - changed 1000 to 100 on BP scale - outputs are mBar


mask15 = uint16(15*ones(datafile.nframes,1));
mask31 = uint16(31*ones(datafile.nframes,1));
mask1  = uint16(   ones(datafile.nframes,1));

fid=fopen(filename,'r'); % Open the file read-only
if(fid == -1)
  error([ 'Cannot open ' filename ]);
  dataout = [];
  return;
end

s = dir(filename);
filesize = s.bytes;
nrec = filesize / (2*datafile.framelength);
fprintf ('File %s has %d records in %d bytes \n', filename, nrec, filesize)

%Now read in the data

    
% Read and save only the variables that need to be decoded

data=fread(fid,[datafile.framelength,datafile.nframes],'uint16',0,'l')';  % little-endian
dummy = dummy'; % fix syntax highlighting in UE
if isfield(datafile,'dateword')
    datei = datafile.dateword;
else
    datei = 3;
end

dateval = uint16(data(:,datei));

hour = data(:,4);
mins = data(:,5);
sec  = data(:,6);
msec = data(:,7);

%dvec = [year mon day hour mins sec+0.001*msec];
dvec = sec+0.001*msec;

% get the digital words
pgu     = uint16(data(:,datafile.pguword));
aspr    = uint16(data(:,datafile.asprword));

% Clear data and rewind so we can re-read file as int16s

clear data;
frewind(fid);

% Read all variables as signed integers

data=fread(fid,[datafile.framelength,datafile.nframes],'int16',0,'l')';  %data is little-endian
dummy = dummy'; % fix syntax highlighting in UE

% precip  = bitand (bitshift(pgu, -15), mask1(1:nrec));
precip = bitget(pgu,1);
% gpslock = bitand (bitshift(pgu, -14), mask1(1:nrec));
gpslock = bitget(pgu,2);
% upsstat = bitand (bitshift(pgu, -13), mask1(1:nrec));
upsstat = bitget(pgu,3);

%asprl1  = bitand (bitshift(aspr, -12), mask1(1:nrec));
asprl1 = bitget(aspr,1);
%asprl2  = bitand (bitshift(aspr, -13), mask1(1:nrec));
asprl2 = bitget(aspr,2);
% asprl3  = bitand (bitshift(aspr, -14), mask1(1:nrec));
asprl3 = bitget(aspr,3);
% asprl4  = bitand (bitshift(aspr, -15), mask1(1:nrec));
asprl4 = bitget(aspr,4);

fclose(fid);
  
% Do the scaling as array operations

rawvals = data(:,datafile.scaledwords); % unscaled values
isamp = ones(size(rawvals,1),1);
[Xmult,Y]  = meshgrid(mult,isamp);
[Xscale,Y] = meshgrid(scale,isamp);

sclvals = rawvals ./ Xmult;
sclvals = sclvals ./ Xscale;

%----------------------------------------------------------------------

% GENERATE OUTPUT MATRIX
% note that double(dateval) will be 4 elements from January to September,
% and 5 elements from October to December
dataout = [double(dateval) hour mins sec msec sclvals ...
	double(precip) double(gpslock) double(upsstat) ...
	double(asprl1) double(asprl2) double(asprl3) double(asprl4)];
    
