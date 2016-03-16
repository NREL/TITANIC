function waituntilunlock(pathToFile)

pathToLockFile = [pathToFile,'.lock'];

tstart = tic;
elapsed = 0;

if (exist(pathToFile,'file'))
fileInfo = dir(pathToFile);
newFileSize = fileInfo.bytes;
fileSizeChange = 0;
end
%% Check to see if there is a lock file for the file we want to read.
% make sure we wait for less than a minute.
pausetime = 1;
while exist(pathToLockFile,'file')
    % if there is, wait
    pause(pausetime);
    elapsed = tic - toc(tstart);    
    if (elapsed > 10) &(exist(pathToFile,'file'))
        % check the file size to see if it's changing
        oldFileSize = newFileSize;
        fileInfo = dir(pathToFile);
        newFileSize = fileInfo.bytes;
        fileSizeChange = abs(newFileSize - oldFileSize);        
        if (fileSizeChange < 1)
            % file size did not change.
            % Assume that something somewhere hung up
            break
        end        
        % increase the duration that we wait for
        pausetime = 10;
    end
    if (elapsed > 120) & ~(exist(pathToFile,'file'))
        break
    end
end
