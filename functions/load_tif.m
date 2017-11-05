function FinalImage = load_tif
% 
% NAME:
%               LoadTif
% PURPOSE:
%               Import a .tif stack containing fluorescently labeled point
%               particles to be tracked
% 
% INPUTS:
%
%               running LoadTif prompts user to navigate to a 8-bit .tif
%
% OUTPUTS:
%               FinalImage: a MxNxP matrix containg image data


[FileName PathName] =uigetfile('*.tif','MultiSelect','on');

FileTif = fullfile(PathName,FileName);

InfoImage=imfinfo(FileTif);
mImage=InfoImage(1).Width;
nImage=InfoImage(1).Height;
NumberImages=length(InfoImage);
FinalImage=zeros(nImage,mImage,NumberImages,'uint8');

hwb = waitbar(0,'Image loading. Please wait...');

TifLink = Tiff(FileTif, 'r');
for i=1:NumberImages
    
    TifLink.setDirectory(i);
    FinalImage(:,:,i)=TifLink.read();
    waitbar(i/NumberImages);
end
TifLink.close();
close(hwb);

