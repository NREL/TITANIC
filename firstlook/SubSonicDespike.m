function [good_index,spike_index,nspikes] = SubSonicDespike(y,ranges)

npoints = numel(y);

% try to find those spikes by looking at extreme changes
dy = diff(y);
% find the extreme changes
spikelow_logical = dy<prctile(dy,min(ranges));
spikehigh_logical = dy>prctile(dy,max(ranges));

% a spike is by definition a change up then down or down then up...
% look for up then down
positive_spike_logical = (spikehigh_logical(1:end-1) & spikelow_logical(2:end));
positive_spike_index = find(positive_spike_logical)+1;
% look for down then up
negative_spike_logical = (spikelow_logical(1:end-1) & spikehigh_logical(2:end));
negative_spike_index = find(negative_spike_logical)+1;

% get index of all bad data
spike_index = find(negative_spike_logical | positive_spike_logical)+1;
spike_index_logical = logical(zeros(npoints,1));
spike_index_logical(spike_index) = true;
spike_index = find(spike_index_logical);

% get index of all good data
good_index_logical = logical(ones(npoints,1));
good_index_logical(spike_index_logical) = false;
good_index = find(good_index_logical);

nspikes = sum(spike_index_logical);
