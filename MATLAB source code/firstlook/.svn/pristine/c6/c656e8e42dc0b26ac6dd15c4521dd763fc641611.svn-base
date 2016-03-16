
function hostname = gethostname

if ispc
    hostname = getenv('COMPUTERNAME');
elseif ismac
    [idum,hostname]= system('hostname');
else
    hostname = 'unknownhost';
end
hostname = deblank(hostname);
