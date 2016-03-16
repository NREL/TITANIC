function [slope, offset, varname] = ParseSlopeOffset(data)
%Jason Roadman
%NREL NWTC
%5/7/12
%This function takes the output from TDMS_readTDMSFile.m and parses out the slopes and offsets from the TDMS file.

%inititialize
numfields = size(data.data,2)-2;
slope = struct();
offset = struct();

for ii = 1:numfields;
    %read field name
    field = CleanFieldname(cell2mat(data.propValues{ii+2}(11)));
    

    
    
    %save field name to cell array of field names
    varname{ii,1} = field;

    %build output structs
    slope = setfield(slope,field,str2double(data.propValues{ii+2}(4)));
    offset = setfield(offset,field,str2double(data.propValues{ii+2}(5)));
    
    
end



end
