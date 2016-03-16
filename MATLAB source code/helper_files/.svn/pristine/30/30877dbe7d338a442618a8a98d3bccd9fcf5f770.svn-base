% function filtereddata = tower_filter_data(Xdata,Fdata,Frange,inout)

function filtereddata = tower_filter_data(Xdata,Fdata,Frange,inout)

switch lower(inout)
    case {'exclude','include'}
    otherwise
        return
end

% look at values
x = Xdata.val;
xt = Xdata.date;
xQC = Xdata.flags;
xnp = Xdata.npoints;

f = Fdata.val;
ft = Fdata.date;

% estimate the time resolution
dt = diff(xt);
tres = min(dt(dt>=0));

% look for those that match to within 1 second
[tc,xi,fi] = get_common_times(xt,ft,tres/10);

% get the conincident data
x = x(xi);
xt = xt(xi);
xQC = xQC(xi);
xnp = xnp(xi);

% and the value fo the filter at this time
f = f(fi);

% find the data that meet the requirements
fi =[];
switch lower(inout)
    case 'include'
        if all(isnumeric(Frange))
            fi = (f > min(Frange)) & (f < max(Frange));
        elseif isstr(Frange)
            
        end
    case 'exclude'
        if all(isnumeric(Frange))
            fi = (f < min(Frange)) | (f > max(Frange));
        elseif isstr(Frange)
            
        end        
end

% and export the filtered data
filtereddata.label = Xdata.label;
% add some info
fstring  =[inout 's ' Fdata.label ' ' num2str(min(Frange)) ':' num2str(max(Frange)) ' ' Fdata.units ];
if isfield(Xdata,'filter')
    filtereddata.filter = Xdata.filter;
    filtereddata.filter{end+1} = fstring;
else
    filtereddata.filter{1} = fstring;
end
filtereddata.units = Xdata.units;
filtereddata.height = Xdata.height;
% and values
filtereddata.val = x(fi);
filtereddata.date = xt(fi);
filtereddata.flags = xQC(fi);
filtereddata.npoints = xnp(fi);

