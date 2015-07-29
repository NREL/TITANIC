function [tc,ai,bi] = get_common_times(t1,t2,buff)

tc = [];
ai = [];
bi = [];

for i = 1:numel(t1)
	i1 = min(find(((abs(t2-t1(i)))<buff)));
	if ~isempty(i1)
		tc(end+1) = t1(i);
		ai(end+1) = i;
		bi(end+1) = i1;	
	end	
end