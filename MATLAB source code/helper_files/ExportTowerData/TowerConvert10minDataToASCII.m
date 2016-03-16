function TowerConvert10minDataToASCII(all_data,ExPath,ExFilename)

%% EXTRA HEADERS
FileHeaders{1} = ['% File written: ' datestr(now,'dd-mm-yyyy HH:MM:SS') ' (dd-mm-yyyy HH:MM:SS).'];
FileHeaders{end+1} = '% ';
FileHeaders{end+1} = '% * CHANGE LOG *';
FileHeaders{end+1} = '% ** Export code last updated: 08-02-2013 11:00:00 (dd-mm-yyyy HH:MM:SS).';
FileHeaders{end+1} = '% *** Missing data indicated by -999';
FileHeaders{end+1} = '% * END CHANGE LOG *';

%% ORGANIZE DATA
% figure out how many data fields we have
myfields = fieldnames(all_data);
% remove raw data
exportfields = {};
fxi = [];
for fi =1:numel(myfields)
    if strfind(myfields{fi},'Raw_') | strfind(myfields{fi},'_NaN')
    elseif  isfield(all_data.(myfields{fi}),'flags')
        exportfields{end+1} = myfields{fi};
        fxi(end+1) = fi;
    end
end
nxf = numel(exportfields);
nrecs = numel(all_data.(exportfields{1}).val);
% create empty output fields
X = zeros(nrecs,0);

%% GATHER DATA FOR EXPORT
% get the date
DateStr = datestr(all_data.(myfields{fxi(1)}).date,'dd-mm-yyyy HH:MM:SS');
% get the version
VerNo = all_data.version.val;
% create a record number
RecNo =  reshape(1:numel(VerNo),[],1);

% create the format string. We know the first three columns (date, record,
% version number) have the same format in every file
fstring = '%s,%d,%3.3f';

% run through each field
Labels = {};
Variables = {};
Units = {};
for fi = 1:nxf
    if isfield(all_data.(exportfields{fi}),'label')
        % get the header
        Labels{end+1} = all_data.(exportfields{fi}).label;
        Variables{end+1} = [exportfields{fi} '.val'];
        % get the units
        Units{end+1} = all_data.(exportfields{fi}).units;
        % get the data
        X(:,end+1) = all_data.(exportfields{fi}).val;
        X(isnan(X(:,end)),end) = -999;
        
        % look to see if there is a QC field associated with this data
        if isfield(all_data.(exportfields{fi}),'flags')
            Labels{end+1} = [all_data.(exportfields{fi}).label ' QC'];
            Variables{end+1} = [exportfields{fi} '.flags'];
            Units{end+1} = 'pass/flag/fail [1/0/-1]';
            % export quality indicator
            QCcode = zeros(nrecs,1);
            [ipass,iflag,ifail] = flagstopassflagfail(all_data.(exportfields{fi}).flags);
            QCcode(ipass) = 1;
            QCcode(iflag) = 0;
            QCcode(ifail) = -1;
            X(:,end+1) = QCcode;
        end
        
        % create the format string
        if isfield(all_data.(exportfields{fi}),'flags')
            fstring = [fstring ',%f,%d'];
        else
            fstring = [fstring ',%f'];
        end
    end
end

%% export the data

if ~isdir(ExPath)
    mkdir(ExPath)
end

% check to see no-one else is writing to this file
waituntilunlock(fullfile(ExPath,ExFilename))
lock(fullfile(ExPath,ExFilename),'TowerConvert10minDataToASCII.m')

% open a file to write to
fo = fopen(fullfile(ExPath,ExFilename),'w');

% write the file header
for hi  = 1:numel(FileHeaders)
    fprintf(fo,'%s\r\n',FileHeaders{hi});
end
fprintf(fo,'\r\n');

% write the data header
fprintf(fo,'Date,Record,Version,');
for hi  = 1:numel(Labels)
    % clean up the headers so that we can use comma-delimited files
    fprintf(fo,'%s,',SubCleanStr(Labels{hi}));
end
fprintf(fo,'\r\n');

% write the variable name
fprintf(fo,'--,--,--,');
for hi  = 1:numel(Variables)
    % clean up the variable names so that we can use comma-delimited files
    fprintf(fo,'%s,',SubCleanStr(Variables{hi}));
end
fprintf(fo,'\r\n');

% write the units
fprintf(fo,'dd-mm-yyyy HH:MM:SS,Number,Code version,');
for hi  = 1:numel(Units)
    fprintf(fo,'%s,',SubCleanStr(Units{hi}));
end
fprintf(fo,'\r\n');

% write the data
for ri = 1:nrecs
    Xs = sprintf(fstring,DateStr(ri,:),RecNo(ri),VerNo(ri),X(ri,:));
    fprintf(fo,'%s\r\n',Xs);
end
fclose(fo);
unlock(fullfile(ExPath,ExFilename))

end

%% sub Function to clean the output string
function MyStr = SubCleanStr(MyStr)
MyStr = strrep(MyStr,'_ ','_');
MyStr = strrep(MyStr,'  ',' ');
MyStr = strrep(MyStr,',','_');
MyStr = strrep(MyStr,'__','_');

% check for empty strings
if isempty(MyStr)
    MyStr = '--';
end

end
