function htxt = centroid_validation(stack, slice, lobject, threshold)

% NAME:
%       centroid_validation
%
% PURPOSE:
%
%       validate lobject and threshold settings to acquire centroids
%       
%
% CATEGORY:
%               
% INPUT:
%
%       stack: variable name for the image stack 
%       slice: frame within the stack to be evaluated
%       lobject: Integer length in pixels somewhat larger than a 
%                typical object.  See bpass.m function.
%       threshold: the minimum brightness of a pixel that might be local 
%       maxima.(NOTE: Make it big and the code runs faster
%       but you might miss some particles.  Make it small and you'll get
%       everything and it'll be slow.) See pkfnd.m function.


% 
% OUTPUT:
%       figure containing current image frame with identified particles 
%       labeled with blue circles and numberical tags



a = double(stack(:,:,slice));
b = bpass(a, 1, lobject);

colormap('gray'); image(b);
hold on

pk = pkfnd(b, threshold, lobject+1);
cnt = cntrd(b, pk, lobject+1);


plot(cnt(:,1), cnt(:,2), 'bo');
labels = cellstr( num2str([1:size(cnt)]'));
htxt = text(cnt(:,1), cnt(:,2), labels, 'color', 'g');

end
 
