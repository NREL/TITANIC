% function data_out = SubWindWrapDir(data_in)
%
% wraps direction data to the range 0-360


function data_out = SubWindWrapDir(data_in)

data_out = data_in;

% scale the wind direction data to the range 0-360
i_over = data_in > 360;
data_out(i_over) = data_in(i_over)-360;

i_under = data_in < 0;
data_out(i_under) = 360 + data_in(i_under);
