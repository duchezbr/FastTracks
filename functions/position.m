function pos = position(centroids)

% PURPOSE: 
%       Create a position list for centroids that can be used as an
%       input for the track.m fucntion (see track.m doucmentation Inputs: 
%       positionlist). 

% INPUT:
%       centroid: Output of the centroid_array function consisting of a 
%       cell array with each cell containing centroid positions
%       corresponding to a specific frame
%           centroid{i}(:, 1) = x-postion of centroid
%           centroid{i}(:, 2) = y-postion of centroid
%           centroid{i}(:, 3) = brightness 
%           centroid{i}(:, 4) = square of the radius of gyration

% OUTPUT:
%       pos: an N x 3 array containing:
%           pos(:,1) is the x-coordinates
%           pos(:,2) is the y-coordinates
%           pos(:,3) is the frame number of coordinates

% NOTES:
% restructure the centroid_array output by maintaining x and y-ccordinates 
% positions for each frame while removing columns containing brightness and 
% square of gyration outputs. Frame number is identifier added to column
% 3 of pos output depending on where coordinate position was identified.


for i = 1:length(centroids)
centroids{i}(:, 3:4) = [];
end

% create a frame label for each array of centroid data
for k = 1:length(centroids)
    b = repmat(k, 1, size(centroids{k},1));
    centroids{k} = [centroids{k} b'];
end

% create an N x 3 array that contains centroid data in sequential order by
% frame

m = zeros(1,3);
for j = 1:length(centroids)
    m = [m; centroids{j}];
end
pos = m(2:end, :); %remove the first row containing only zeros

end

