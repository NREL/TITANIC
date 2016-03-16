function [ipass,iflag,ifail]=flagstopassflagfail(flags)

ipass= [];
iflag = [];
ifail = [];

for i = 1:numel(flags)
    if isempty(flags{i})
        ipass= [ipass i];
    elseif max(flags{i})>5000
        ifail = [ifail i];
    elseif max(flags{i})>1000
        iflag = [iflag i];
    end
end