function track_array = msdAnalyzerImport(tracks)

% PURPOSE:
% Produce a cell array with each cell containing trajectory data for a 
% single particle that can then be analyzed using MSDAnalyszer.
% MSDAnalyzer requires that each track be contained within a cell and each
% cell contain trajectory data contained within three columns


% INPUT: 
% 
%        tracks: tracks matrix generated by track.m
%        column1: x-position
%        column2: y-position
%        column3: frame
%        column4: track number

% OUTPUT:
%
%        tracks_array: a 1xN array containg N number of cell trajectories
%        formated as follows
%        column1: frame
%        column2: x-position
%        column3: y-position

track_array = {};

totalTracks = unique(tracks(:,4));

for i = totalTracks'
    T = tracks(tracks(:,4) == i, :);
    track_matrix = [T(:,3), T(:,1), T(:,2)];
    track_array{1,i} = track_matrix;
end
    
