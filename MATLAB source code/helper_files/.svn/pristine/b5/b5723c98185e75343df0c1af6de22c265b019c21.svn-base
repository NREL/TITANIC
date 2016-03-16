function [slope, offset, units, modulesn, varname] = ParseTDMSmetadata(data)
%Jason Roadman
%NREL NWTC
%9/11/12 - modified from ParseSlopeOffset.m
%This function takes the output from TDMS_readTDMSFile.m and parses out the slopes, 
% offsets, units, modules, and variable names from the TDMS file.
%USAGE: [slope, offset, units, modulesn, varname] = ParseTDMSmetadata(data)

%inititialize
numfields = size(data.data,2)-2;
slope = struct();
offset = struct();
units = struct();
modulesn = struct();

for ii = 1:numfields;
    %read field name
    field = CleanFieldname(cell2mat(data.propValues{ii+2}(11)));
    
    %save field name to cell array of field names
    varname{ii,1} = field;

    %build output structs
    slope = setfield(slope,field,str2double(data.propValues{ii+2}(4)));
    offset = setfield(offset,field,str2double(data.propValues{ii+2}(5)));
    units = setfield(units,field,cell2mat(data.propValues{ii+2}(6)));
    modulesn = setfield(modulesn,field,cell2mat(data.propValues{ii+2}(2)));
    
    
end



end
