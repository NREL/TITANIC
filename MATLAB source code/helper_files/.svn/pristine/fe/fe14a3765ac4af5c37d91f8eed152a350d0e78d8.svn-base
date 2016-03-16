function lock(pathToFile,fname)

pathToLockFile = [pathToFile,'.lock'];

%% Now create a lock file for this file
fIDlock = fopen(pathToLockFile,'w');
fprintf(fIDlock, '%s %i %i %i %i %i %f \n', fname, datevec(now));
fclose(fIDlock);
