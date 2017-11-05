function varargout = BatchProcessing(varargin)
% BATCHPROCESSING MATLAB code for BatchProcessing.fig
%      BATCHPROCESSING, by itself, creates a new BATCHPROCESSING or raises the existing
%      singleton*.
%
%      H = BATCHPROCESSING returns the handle to a new BATCHPROCESSING or the handle to
%      the existing singleton*.
%
%      BATCHPROCESSING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BATCHPROCESSING.M with the given input arguments.
%
%      BATCHPROCESSING('Property','Value',...) creates a new BATCHPROCESSING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BatchProcessing_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BatchProcessing_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BatchProcessing

% Last Modified by GUIDE v2.5 11-Nov-2016 14:03:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BatchProcessing_OpeningFcn, ...
                   'gui_OutputFcn',  @BatchProcessing_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before BatchProcessing is made visible.
function BatchProcessing_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BatchProcessing (see VARARGIN)

% Choose default command line output for BatchProcessing
handles.output = hObject;
global hFig1

try
    assert(~isempty(hFig1.diameter) & ~isempty(hFig1.threshold) &...
        ~isempty(hFig1.maxDisp) & ~isempty(hFig1.time) & ~isempty(hFig1.pixel_micron))
catch
    errordlg(['Values must be entered for Nuclei validation, Tracking parameters,'... 
        ' and Analysis before performing Batch processing'])
end



% name figure window
set(handles.figure1, 'name', 'Batch Processing');

handles.chk1 = get(handles.checkbox1, 'Value');
handles.chk2 = get(handles.checkbox2, 'Value');
handles.chk3 = get(handles.checkbox3, 'Value');


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes BatchProcessing wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = BatchProcessing_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1



% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in process.
function process_Callback(hObject, eventdata, handles)
% hObject    handle to process (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global hFig1

try 
    assert(~isempty(handles.tifFiles));
catch
    errordlg('Select folder containing 8-bit .tif image stacks');
end

try
    assert(handles.chk1 == 1 | handles.chk2 == 1 | handles.chk3 == 1);
catch
    errordlg('Select file type for exported data');
    return
end

numfiles = length(handles.tifFiles);
mydata = cell(1, numfiles);

% set waitbar for image processing
hwb = waitbar(0,'Please wait...','Name','BatchProcessing',...
            'CreateCancelBtn',...
            'setappdata(gcbf,''canceling'',1)');
setappdata(hwb,'canceling',0);
for i = 1:numfiles
    
    % Check for Cancel button press
    if getappdata(hwb,'canceling')
        break
    end
    
    FileTif = fullfile(handles.Path, handles.tifFiles(i).name);
    [~, name]=fileparts(FileTif);

    InfoImage=imfinfo(FileTif);
    mImage=InfoImage(1).Width;
    nImage=InfoImage(1).Height;
    NumberImages=length(InfoImage);
    FinalImage=zeros(nImage,mImage,NumberImages,'uint8');

    
    TifLink = Tiff(FileTif, 'r');
    for p=1:NumberImages
        
        TifLink.setDirectory(p);
        FinalImage(:,:,p)=TifLink.read();
    end
    
    TifLink.close();

waitbar(i/numfiles, hwb, sprintf(['Image %d of %d being processed. Please wait...'], i, numfiles)); 
%% Evaluate centroids


% locate centroids
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
%       x-postion of centroid
%       y-postion of centroid
%       brightness 
%       square of the radius of gyration

% determine the number of slices within the stack
[m n p] = size(FinalImage);   

centroid = cell(1, p);                     
for s = 1:p

    
    % generate an 1xP array with each column containing centroid output for 
    % individual frames
    
    a = double(FinalImage(:, :, s));
    b = bpass(a,1,hFig1.diameter);
    pk = pkfnd(b,hFig1.threshold,hFig1.diameter+1);
    cnt = cntrd(b,pk,hFig1.diameter+1);
    
    % determine that frame s has at least 1 valid centroid

    try
                
        assert(isempty(cnt) == 0);  
        centroid{1,s}= cnt;
        
    catch

        errordlg(sprintf(['No centroids detectd in frame %d for %s',...
            '.\nCheck nuclei validation settings for this image stack.'], s, handles.tifFiles(i).name));
        break
    end


     
        
end

%% Position list (reformated centroid data for track.m input)

% Remove columns that contain brightness and sqare of radius of gyration
% this is the equivalent of position.m function

for t = 1:length(centroid)
    
    % retain only positional data by removing columns 3 and 4
    centroid{t}(:, 3:4) = [];
end

%create a frame(tau)label for each array of centroid data
for k = 1:length(centroid)
    
        b = repmat(k, 1, size(centroid{k},1));
        centroid{k} = [centroid{k} b'];

end



%create a matrix that contains centroid data in sequential order by
%frame(tau)

m = zeros(1,3);
for j = 1:length(centroid)
   
    m = [m; centroid{j}];
        
end

pos = m(2:end, :); %remove the first row containing only zeros


%% generate tracks

try
    
    tracks = track(pos, hFig1.maxDisp, hFig1.parameters);
    
catch
    errordlg(sprintf(['No tracks or statistics were produced for %s.\n'...
        'Reset tracking parameters for this image stack.'], handles.tifFiles(i).name));
    continue
end


%% Compute migration statistics and assemble into a table with Variable headers

[handles.speed, handles.distance, handles.euclid, handles.persistence, handles.theta, handles.yfmi,...
    handles.xfmi, handles.deltaY, handles.deltaX,...
    handles.frames_tracked] = migrationStats(tracks, hFig1.time, hFig1.pixel_micron);
    
    sz = size(handles.speed, 1); 
    handles.cell_number = 1:sz;
    handles.cell_number = handles.cell_number';
    cell_stats = table(handles.cell_number, handles.speed, handles.distance, handles.euclid, handles.persistence, handles.theta, handles.yfmi,...
        handles.xfmi, handles.deltaY, handles.deltaX, handles.frames_tracked);
    
    cell_stats.Properties.VariableNames = {'Cell_Number', 'Speed', 'Distance',... 
        'Displacement', 'Persistence', 'Degrees', 'YFMI', 'XFMI', 'Y_displacement', 'X_displacement', 'Frames'};
    
    
    % to organize population stats
    row1 = table2array(grpstats(cell_stats, [], {'mean', 'std', 'median', 'min', 'max'}, 'datavars', 'Speed'));
    row2 = table2array(grpstats(cell_stats, [], {'mean', 'std', 'median', 'min', 'max'}, 'datavars', 'Distance'));
    row3 = table2array(grpstats(cell_stats, [], {'mean', 'std', 'median', 'min', 'max'}, 'datavars', 'Displacement'));
    row4 = table2array(grpstats(cell_stats, [], {'mean', 'std', 'median', 'min', 'max'}, 'datavars', 'Persistence'));
    row5 = table2array(grpstats(cell_stats, [], {'mean', 'std', 'median', 'min', 'max'}, 'datavars', 'YFMI'));
    row6 = table2array(grpstats(cell_stats, [], {'mean', 'std', 'median', 'min', 'max'}, 'datavars', 'XFMI'));
    row7 = table2array(grpstats(cell_stats, [], {'mean', 'std', 'median', 'min', 'max'}, 'datavars', 'Y_displacement'));
    row8 = table2array(grpstats(cell_stats, [], {'mean', 'std', 'median', 'min', 'max'}, 'datavars', 'X_displacement'));
    
    % compute sum of cos and sin of angles
    r = sum(exp(1i*handles.theta));

    % obtain mean angle 
    meanTheta = angle(r);
    degrees = meanTheta/pi*180;
    row9 = [sz, degrees, nan, nan, nan, nan];
    
    pop_stats = [row1;row2;row3;row4;row5;row6;row7;row8;row9];
    pop_stats = array2table(pop_stats, 'VariableNames', {'N', 'Mean', 'SD', 'Median', 'Min', 'Max'}); 
    Variable = categorical({'Speed'; 'Total Displacement'; 'Euclidean Displacement'; 'Persistence'; 'YFMI'; 'XFMI'; 'Y-Displacement'; 'X-Displacement'; 'Angle'});
    Variable = table(Variable);
    pop_stats = [Variable, pop_stats];
%% Export Data

if handles.chk1 == 1
        
    save([pwd filesep 'FastTracksData' filesep name '_tracks.mat'], 'tracks');
    save([pwd filesep 'FastTracksData' filesep name '_cellStats.mat'], 'cell_stats');
    save([pwd filesep 'FastTracksData' filesep name '_pop_stats.mat'], 'pop_stats');
    
end

if handles.chk2 == 1
    
    csvwrite([pwd filesep 'FastTracksData' filesep name '_tracks.csv'], tracks);
    writetable(cell_stats, [pwd filesep 'FastTracksData' filesep name '_cellStats.csv']);
    writetable(pop_stats, [pwd filesep 'FastTracksData' filesep name '_pop_stats.csv']);
    
end
if handles.chk3 == 1
    
    xlswrite([pwd filesep 'FastTracksData' filesep name '_tracks.xls'], tracks);
    writetable(cell_stats, [pwd filesep 'FastTracksData' filesep name '_cellStats.xls']);
    writetable(pop_stats, [pwd filesep 'FastTracksData' filesep name '_pop_stats.xls']);
    
end


end
delete(hwb);
close(BatchProcessing);


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
handles.chk1 = get(hObject, 'Value');

guidata(hObject, handles);
% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2
handles.chk2 = get(hObject, 'Value');

guidata(hObject, handles);

% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3
handles.chk3 = get(hObject, 'Value');

guidata(hObject, handles);


% --- Executes on button press in get_tifs_pb.
function get_tifs_pb_Callback(hObject, eventdata, handles)
% hObject    handle to get_tifs_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% create structure of TIFF file info for images contained in the TIFF
% folder
handles.Path = uigetdir('Name', 'Select folder containg .tif stacks');
handles.tifFiles = dir([handles.Path filesep '*.tif']);

% print name of TIFF files to listbox
set(handles.listbox1,'string',{handles.tifFiles.name});

guidata(hObject, handles);
