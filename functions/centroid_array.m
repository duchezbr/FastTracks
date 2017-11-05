function centroid = centroid_array(stack, lobject, threshold)

% NAME:
%       centroid_array
%
% PURPOSE:
%
%       create a cell array containing centroid data for particles 
%       identified in each imported image
%
% CATEGORY:
%               
% INPUT:
%
%       stack: 3D matrix loaded to workspace from .tif stack
%       lobject:(optional) Integer length in pixels somewhat larger than a 
%                typical object.  See bpass.m function.
%       threshold: the minimum brightness of a pixel that might be local 
%       maxima.(NOTE: Make it big and the code runs faster
%       but you might miss some particles.  Make it small and you'll get
%       everything and it'll be slow.) See pkfnd.m function.


% 
% OUTPUT:
%           centroid{i}(:, 1) = x-postion of centroid
%           centroid{i}(:, 2) = y-postion of centroid
%           centroid{i}(:, 3) = brightness 
%           centroid{i}(:, 4) = square of the radius of gyration

% determine the number of slices within the stack
[m n p] = size(stack);   

centroid = cell(1, p);                     
for i=1:p
    
    a = double(stack(:, :, i));
    b = bpass(a,1,lobject);
    pk = pkfnd(b,threshold,lobject+1);
    cnt = cntrd(b,pk,lobject+1);
    
    % array with single row with each column containing centroid output for 
    % each image
    try
        
        assert(isempty(cnt) == 0); 
        centroid{1,i}= cnt;
        
    catch

        errordlg(sprintf(['No centroids detectd in frame %d for %s',...
            '.\nCheck nuclei validation settings for this frame.'], i, 'this stack'))
        break
    end
               
      
end
end

