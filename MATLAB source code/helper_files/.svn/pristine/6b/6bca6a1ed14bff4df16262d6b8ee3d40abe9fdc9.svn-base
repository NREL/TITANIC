function SubWriteRawDataASCII(raw_data,...
	data_path,data_file,...
	output_path)

%% empty variables, labels, data and attributes
VAL = {};
VLABEL= {};
UNITS = {};
HEIGHT = {};

%% time
VAL{end+1} = (raw_data.time_UTC.val-raw_data.time_UTC.val(1))*60*24*60;
VLABEL{end+1} = 'Time (elapsed)';
UNITS{end+1} = 'Matlab datenum';
HEIGHT{end+1} = 0;

%% individual channel statistics
raw_data_fieldnames = fieldnames(raw_data);
for di = 1:numel(raw_data_fieldnames)
	switch raw_data_fieldnames{di}
		case {'tower'}
		otherwise
			try
				VAL{end+1} = raw_data.(raw_data_fieldnames{di}).val;
				VLABEL{end+1} = raw_data_fieldnames{di};
				UNITS{end+1} =  raw_data.(raw_data_fieldnames{di}).units;
				HEIGHT{end+1} =  raw_data.(raw_data_fieldnames{di}).height;
			catch
				disp(raw_data_fieldnames{di})
			end
	end
end

%% export the data
data_out = NaN*ones(length(VAL{1}),numel(VLABEL));
for vi = 1:numel(VLABEL)
	% make a new variable	
	npoints = numel(VAL{vi});
	data_out(1:npoints,vi) =  reshape(VAL{vi},[],1);
	headers.label{vi} = VLABEL{vi};
	headers.units{vi} = UNITS{vi};
	headers.height{vi} = HEIGHT{vi};
end

%% and write it out
fid = fopen(fullfile(output_path,strrep(data_file,'.mat','.txt')),'w');

% write the headers
% 1. Label
l = sprintf('%s, ',headers.label{1:end});
fprintf(fid,'%s\n',l(1:end-2));

% 2. Units
l = sprintf('%s, ',headers.units{1:end});
fprintf(fid,'%s\n',l(1:end-2));

% 3. Height
l = sprintf('%d, ',headers.height{1:end});
fprintf(fid,'%s\n',l(1:end-2));

% 4. values
for rowi = 1:length(data_out)
	l = sprintf('%6.4g, ',data_out(rowi,:));
	fprintf(fid,'%s\n',l(1:end-2));
end

%% close
fclose(fid);