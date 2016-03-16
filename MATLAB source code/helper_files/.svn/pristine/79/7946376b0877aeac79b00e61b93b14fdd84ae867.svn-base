function data = WaitYourTurnToLoad(pathToFile)

waituntilunlock(pathToFile)
lock(pathToFile,'WaitYourTurnToLoad.m')
%% now load the data
data = load(pathToFile);

%% Now remove the lock file
unlock(pathToFile)