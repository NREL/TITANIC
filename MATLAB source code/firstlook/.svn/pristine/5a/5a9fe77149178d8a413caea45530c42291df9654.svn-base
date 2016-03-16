function SubDisplayWebpage(pageStruct,channelData,sonicData,images)

t = clock;
%% Make local directory for html and rss feed
if isfield(pageStruct,'process')
    procName = pageStruct.process;
else
    procName = 'WARNING_no_field_named_process';
end

%% Make HTML page
htmlFID = fopen([procName '.html'], 'w');
% HEAD & BROWSER TITLE
fprintf(htmlFID,'<html>\n');
fprintf(htmlFID,'<head>\n');
fprintf(htmlFID,'<title>%s</title>\n',procName);
fprintf(htmlFID,'<LINK REL="STYLESHEET" TYPE="text/css" HREF="towerstyles.css">');
fprintf(htmlFID,'</head>\n');

% BODY
fprintf(htmlFID,'<body style="background-color:rgb(200,200,200)">');

% HEADING
fprintf(htmlFID,'<h1>%s</h1>\n',pageStruct.description);

% INFORMATION ABOUT THE PERIOD
fprintf(htmlFID,'<p>Data for the period starting %s\n. Data are from file %s</p>\n',...
    pageStruct.datestring, pageStruct.filestring);

% timing
fprintf(htmlFID,'<h2>Timing</h2>\n');
fprintf(htmlFID,'<img src="%s" alt="Missing timing information" width="480"/img><br /> \n',images.timing);

% PROFILES
fprintf(htmlFID,'<h2>Profiles</h2>\n');
fprintf(htmlFID,'<img src="%s" alt="Missing Profiles of data" width="800"/img><br /> \n',images.profile);

% Channel Status
fprintf(htmlFID,'<h2>Channel Status</h2>\n');
fprintf(htmlFID,'<img src="%s" alt="Missing Channel status" width="800"/img><br /> \n',images.status);

% data by Channel
fprintf(htmlFID,'<h2>Data by Channel</h2>\n');
fprintf(htmlFID,'<table border="2" cellspacing="0" cellpadding="7">');
fprintf(htmlFID,'<caption>Data from each measurement channel</caption>');
% headers
fprintf(htmlFID,'<tr>\n');
% ID
fprintf(htmlFID,'<td>ID</td>\n');
% variable name
fprintf(htmlFID,'<td>Name</td>\n');
% Height
fprintf(htmlFID,'<td>Height [m]</td>\n');
% mean
fprintf(htmlFID,'<td>Mean</td>\n');
% min
fprintf(htmlFID,'<td>Min</td>\n');
% max
fprintf(htmlFID,'<td>Max</td>\n');
% npoints
fprintf(htmlFID,'<td>n. points</td>\n');
% n valid points
fprintf(htmlFID,'<td>n. valid</td>\n');
% percentage of ideal
fprintf(htmlFID,'<td>&#37; valid (required)</td>\n');
% flags
fprintf(htmlFID,'<td>QC Codes</td>\n');
% end of row
fprintf(htmlFID,'</tr>\n');
% data

nfields = numel(channelData);
for di = 1:nfields
    if ~isempty(channelData{di})
    fprintf(htmlFID,'<tr>\n');
    % ID
    fprintf(htmlFID,'<td>%s</td>\n',channelData{di}.id);
    % variable name
    fprintf(htmlFID,'<td>%s</td>\n',channelData{di}.name);
    % height
    fprintf(htmlFID,'<td>%s</td>\n',channelData{di}.height);
    % mean
    fprintf(htmlFID,'<td>%s</td>\n',channelData{di}.mean);
    % min
    fprintf(htmlFID,'<td>%s</td>\n',channelData{di}.min);
    % max
    fprintf(htmlFID,'<td>%s</td>\n',channelData{di}.max);
    % npoints
    fprintf(htmlFID,'<td>%s</td>\n',channelData{di}.npoints);
    % npoints
    fprintf(htmlFID,'<td>%s</td>\n',channelData{di}.nvalid);
    % percentage valid
    fprintf(htmlFID,'<td>%s</td>\n',channelData{di}.pcvalid);
    % flags
    fprintf(htmlFID,'<td>%s</td>\n',channelData{di}.flags);
    % end of row
    fprintf(htmlFID,'</tr>\n');
    end
end
fprintf(htmlFID,'</table>');

% SONIC DATA
fprintf(htmlFID,'<h2>Sonic Anemometer Data</h2>\n');
fprintf(htmlFID,'<h3>Power spectra</h3>\n');
fprintf(htmlFID,'<img src="%s" alt="Missing Sonic Spectra" width="800"/img><br /> \n',images.sonicspectra);

fprintf(htmlFID,'<h3>Derived Data</h3>\n');
fprintf(htmlFID,'<table border="2" cellspacing="0" cellpadding="7">');
fprintf(htmlFID,'<caption>Data by channel</caption>');
% headers
fprintf(htmlFID,'<tr>\n');
% Height
fprintf(htmlFID,'<td>Height [m]</td>\n');
% speed
fprintf(htmlFID,'<td>Speed</td>\n');
% percentage of ideal
fprintf(htmlFID,'<td>&#37; of required (target)</td>\n');
% Ti
fprintf(htmlFID,'<td>Ti</td>\n');
% npoints
fprintf(htmlFID,'<td>u_*</td>\n');
% MO length
fprintf(htmlFID,'<td>MO length (L)</td>\n');
fprintf(htmlFID,'<td>z/L</td>\n');
% n. points
fprintf(htmlFID,'<td>n. points</td>\n');
% percentage of ideal
fprintf(htmlFID,'<td>&#37; valid (required to rotate)</td>\n');
% flags
fprintf(htmlFID,'<td>QC Codes</td>\n');
% end of row
fprintf(htmlFID,'</tr>\n');
% data

nfields = numel(sonicData);
for di = 1:nfields
    fprintf(htmlFID,'<tr>\n');
    % height
    fprintf(htmlFID,'<td>%s</td>\n',sonicData{di}.height);
    % speed
    fprintf(htmlFID,'<td>%s</td>\n',sonicData{di}.horizspeed);
    % percentage valid used for speed
    fprintf(htmlFID,'<td>%s</td>\n',sonicData{di}.pcvalidspeed);        
    % Ti
    fprintf(htmlFID,'<td>%s</td>\n',sonicData{di}.Ti_horiz);
    % ustar
    fprintf(htmlFID,'<td>%s</td>\n',sonicData{di}.ustar);
    % MO length
    fprintf(htmlFID,'<td>%s</td>\n',sonicData{di}.MOlength);    
	fprintf(htmlFID,'<td>%s</td>\n',sonicData{di}.zoverMOlength);  
    % npoints
    fprintf(htmlFID,'<td>%s</td>\n',sonicData{di}.npoints);
    % percentage valid used for rotation
    fprintf(htmlFID,'<td>%s</td>\n',sonicData{di}.pcvalidrotation);    
    % flags
    fprintf(htmlFID,'<td>%s</td>\n',sonicData{di}.flags);
    % end of row
    fprintf(htmlFID,'</tr>\n');
end
fprintf(htmlFID,'</table>');

% write out the QC codes
fprintf(htmlFID,'<h2>QC codes</h2>\n');
fprintf(htmlFID,'<p>QC codes in the tables above set for the following reasons:</p>');

% write out the FLAG codes
fprintf(htmlFID,'<h3>Codes indicating flagging</h3>\n');
fprintf(htmlFID,'<p>1001: More than 1 &#37; of measurement are greater than 5&#37 from the target measurement frequency</p>');
fprintf(htmlFID,'<p>1002: Number of points between manufacturer''s limits is low </p>');
fprintf(htmlFID,'<p>1003: Number of points between user''s limits is low </p>');
fprintf(htmlFID,'<p>1004: The percentage of simultaneous good sonic measurements is below the threshold for analysis </p>');
fprintf(htmlFID,'<p>1005: Rain detected </p>');
fprintf(htmlFID,'<p>1006: Standard deviation of this channel is below 1E-5 </p>');
fprintf(htmlFID,'<p>1007: Magnitude of the Richardson number limited to 10 </p>');
fprintf(htmlFID,'<p>20nn: This channel has failed because channel nn has been flagged.</p>');

% write out the FAIL codes
fprintf(htmlFID,'<h3>Codes indicating failure</h3>\n');
fprintf(htmlFID,'<p>5001: No data points at all in the data stream </p>');
fprintf(htmlFID,'<p>5002: All data points are bad (e.g. equal to -999) </p>');
fprintf(htmlFID,'<p>5003: All data points are NaN after filtering for limits</p>');
fprintf(htmlFID,'<p>5004: Anemometer boom motion exceeded 0.1 m/s</p>');
fprintf(htmlFID,'<p>5005: Known outage (in outage file)</p>');
fprintf(htmlFID,'<p>50nn: Channel nn has failed.</p>');

% add some info about the page
fprintf(htmlFID,'<h2>About this page</h2>\n');
fprintf(htmlFID,'<p>Page created on %s </p>',pageStruct.hostname);
fprintf(htmlFID,'<p>Page name: %s.html </p>',procName);
fprintf(htmlFID,'<p>Page generated in %.3f seconds at %s by ',...
    etime(clock, t),datestr(now,'HH:MM:SS, dddd mmmm dd, yyyy' ));
fprintf(htmlFID,' <a href="mailto:andrew.clifton@nrel.gov">Andrew Clifton </a></p>');
fprintf(htmlFID,'</body></html>');
fclose(htmlFID);