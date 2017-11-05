function ht = tracks_plot(tracks, ColorSpecs, stack, slice, lobject, threshold)

% NAME:
%       tracks_plot
%
% PURPOSE:
%
%       Create an overlay of trajectories onto the current frame of the 
%       imported image stacke 
%       
%
% CATEGORY:
%               
% INPUT:
%
%       tracks: tracks matrix generated by track.m
%       ColorSpecs: cell array containing RGB specs for lines that will
%       represent particle trajectories
%       stack: 3D matrix loaded to workspace from .tif stack
%       slice: frame within the stack to be evaluated
%       lobject: Integer length in pixels somewhat larger than a 
%                typical object.  See bpass.m function.
%       threshold: the minimum brightness of a pixel that might be local 
%       maxima.(NOTE: Make it big and the code runs faster
%       but you might miss some particles.  Make it small and you'll get
%       everything and it'll be slow.) See pkfnd.m function.


% 
% OUTPUT:
%
%       ht: object handle to each line ploted within the current axes
%
%


a = double(stack(:,:,slice));
b = bpass(a, 1, lobject);
colormap('gray'), image(b);
hold on
pk = pkfnd(b, threshold, lobject+1);
cnt = cntrd(b, pk, lobject+1);
plot(cnt(:,1), cnt(:,2), 'bo');

cell_num = unique(tracks(:,4));
for i = cell_num'
    T = tracks(tracks(:,4)==i, :);
    x = T(:,1);
    y = T(:,2);
    ht(i) = plot(x, y, ColorSpecs{i});
    text(x(1), y(1), num2str(i), 'color', 'g')
    hold on
end

end
  

   