load('M5_calibrations.mat')
fid = fopen('M5_calibrations_retrieved.txt','w');

%%
for cal = 1:numel(calibrations)
    try
        fprintf(fid,'calibrations{%i}.channel = %i;\n', cal, calibrations{cal}.channel);
    catch
        fprintf(fid,'calibrations{%i}.channel = ;\n', cal);
    end
    
    try
        fprintf(fid,'calibrations{%i}.startdatenum = datenum([%s]) ;\n', cal, datestr(calibrations{cal}.startdatenum,'yyyy mm dd HH MM SS'));
    catch
        fprintf(fid,'calibrations{%i}.startdatenum = ;\n', cal);
    end
    
    try
        fprintf(fid,'calibrations{%i}.stopdatenum = datenum([%s]) ;\n', cal, datestr(calibrations{cal}.stopdatenum,'yyyy mm dd HH MM SS'));
    catch
        fprintf(fid,'calibrations{%i}.stopdatenum = ;\n', cal);
    end
    
    try
        fprintf(fid,'calibrations{%i}.reason = ''%s'';\n', cal, calibrations{cal}.reason);
    catch
        fprintf(fid,'calibrations{%i}.reason = ;\n', cal);
    end
    
    try
        fprintf(fid,'calibrations{%i}.dateadded = datenum([%s]);\n', cal, datestr(calibrations{cal}.dateadded,'yyyy mm dd HH MM SS'));
    catch
        fprintf(fid,'calibrations{%i}.dateadded = ;\n', cal);
    end
    
    try
        fprintf(fid,'calibrations{%i}.from.gradient = %f;\n', cal, calibrations{cal}.from.gradient);
    catch
        fprintf(fid,'calibrations{%i}.from.gradient = ;\n', cal);
    end
    
    try
        fprintf(fid,'calibrations{%i}.from.offset = %f;\n', cal, calibrations{cal}.from.offset);
    catch
        fprintf(fid,'calibrations{%i}.from.offset = ;\n', cal);
    end
    
    try
        fprintf(fid,'calibrations{%i}.to.gradient = %f;\n', cal, calibrations{cal}.to.gradient);
    catch
        fprintf(fid,'calibrations{%i}.to.gradient = ;\n', cal);
    end
    
    try
        fprintf(fid,'calibrations{%i}.to.offset = %f;\n', cal, calibrations{cal}.to.offset);
    catch
        fprintf(fid,'calibrations{%i}.to.offset = ;\n', cal);
    end
    
    fprintf(fid,'\n')
end

fclose(fid)