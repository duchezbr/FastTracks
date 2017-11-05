function nucleiVideo(stack, lobject, threshold, experimentName)
% 
% NAME:
%               nucleiVideo
% PURPOSE:
%               validate centroid positions with current parameter settings 
%               
% INPUTS:
%               stack: 3D matrix loaded to workspace from .tif stack
%               lobject: (optional) Integer length in pixels somewhat 
%                       larger than a typical object. Can also be set to 
%                       0 or false, in which case only the lowpass 
%                       "blurring" operation defined by lnoise is done,
%                       without the background subtraction defined by
%                       lobject.  Defaults to false.
%               threshold: (optional) By default, after the convolution,
%                       any negative pixels are reset to 0.  Threshold
%                       changes the threshhold for setting pixels to
%                       0.  Positive values may be useful for removing
%                       stray noise or small particles.  Alternatively, can
%                       be set to -Inf so that no threshholding is
%                       performed at all.
%
% OUTPUTS:
%               .avi file containing timelapse movie of centroids

[x y slice] = size(stack);
fid = figure;
set(fid, 'Units', 'Pixels', 'Position', [50 50 y x])
ax = axes;
set(ax, 'units', 'normalized', 'position', [0 0 1 1]);

filename = strcat(experimentName, '_nucleiMovie.avi');
outputVideo = VideoWriter([pwd filesep 'FastTracksData' filesep filename]);
outputVideo.FrameRate = 15;
open(outputVideo);



for i = 1:slice
    
    % process images in stack
    a = double(stack(:,:,i));
    b = bpass(a, 1, lobject);
    % locate centroids of particles
    pk = pkfnd(b, threshold, lobject+1);
    cnt = cntrd(b, pk, lobject+1);
    
    colormap('gray'), hImg = image(b);
    hold on
    
    % create markers for identified particles
    plot(ax, cnt(:,1),cnt(:,2), 'bo', 'markersize', 12, 'linewidth', 2);
    set(gca, 'xtick', [], 'ytick', []);

    
    Frames = getframe(gcf);
          
writeVideo(outputVideo,Frames);
end
close(outputVideo);
