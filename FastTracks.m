function varargout = FastTracks(varargin)
% FASTTRACKS MATLAB code for FastTracks.fig
%      FASTTRACKS, by itself, creates a new FASTTRACKS or raises the existing
%      singleton*.
%
%      H = FASTTRACKS returns the handle to a new FASTTRACKS or the handle to
%      the existing singleton*.
%
%      FASTTRACKS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FASTTRACKS.M with the given input arguments.
%
%      FASTTRACKS('Property','Value',...) creates a new FASTTRACKS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FastTracks_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FastTracks_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FastTracks

% Last Modified by GUIDE v2.5 15-Dec-2016 12:02:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FastTracks_OpeningFcn, ...
                   'gui_OutputFcn',  @FastTracks_OutputFcn, ...
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


% --- Executes just before FastTracks is made visible.
function FastTracks_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FastTracks (see VARARGIN)

% Choose default command line output for FastTracks
handles.output = hObject;

clear global hFig1

global hFig1

set(handles.figure1, 'name', 'FastTracks');

% create directory to export data into
mkdir([pwd filesep 'FastTracksData']);

hFig1.diameter = str2double(get(handles.nuclei_diameter_edit,'String'));
hFig1.maxDisp = str2double(get(handles.max_displacement_edit, 'String'));
hFig1.tracks = [];
hFig1.exptName = get(handles.experiment_name_edit, 'String');
hFig1.axes1 = handles.axes1;
hFig1.export_what = 0;
hFig1.stat_table = handles.stat_table;
hFig1.mem = str2double(get(handles.memory_edit,'String'));
hFig1.frames = str2double(get(handles.min_frames_edit,'String'));

% see tracks.m function for description of param settings
handles.param.mem = hFig1.mem;
handles.param.dim = 2;
handles.param.good = hFig1.frames;
handles.param.quiet = 1;
hFig1.parameters = struct(handles.param);

% prevent user from initiating callback before necessary information is
% present
set(handles.nuclei_diameter_edit, 'enable', 'off');
set(handles.threshold_edit, 'enable', 'off');
set(handles.memory_edit, 'enable', 'off');
set(handles.min_frames_edit, 'enable', 'off');
set(handles.max_displacement_edit, 'enable', 'off');
set(handles.roi_blackout_edit, 'enable', 'off');
set(handles.generate_tracks_pb, 'enable', 'off');
set(handles.export_tracks_file, 'enable', 'off');
set(handles.nuclei_movies, 'enable', 'off');
set(handles.nuclei_tracks_movie, 'enable', 'off');
set(handles.distance_unit_popup, 'enable', 'off');
set(handles.time_unit_popup, 'enable', 'off');
set(handles.summary_analysis_pb, 'enable', 'off');
set(handles.statistics_statistics, 'enable', 'off');
set(handles.export_figure_file, 'enable', 'off');
set(handles.population_statistics, 'enable', 'off');
set(handles.delete_tracks, 'enable', 'off');
set(handles.batch_processing, 'enable', 'off');

addpath('functions', 'FastTracksData');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FastTracks wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FastTracks_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in import_stack_pb.
function import_stack_pb_Callback(hObject, eventdata, handles)
% hObject    handle to import_stack_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


global hFig1

hFig1.tracks = [];
if isfield(hFig1, 'ht') == 1
    
    clear hFig1.ht;
end

hFig1.img = load_tif;
[x, y, handles.maxZ] = size(hFig1.img);
hFig1.zSlice = 1;
set(handles.frames_slider, 'Value', 1);

% set(handles.axes1, 'XLim', [0.5 x], 'YLim', [0.5 y]); 
set(handles.axes1, 'XLim', [0 y], 'YLim', [0 x]); 
set(handles.frame_number_edit, 'String', num2str(hFig1.zSlice));
handles.hImage = imagesc(hFig1.img(:,:,hFig1.zSlice)); colormap('gray');
set(gca, 'xtick', [], 'ytick', []);

% enable functions that can be called only when image is imported
set(handles.nuclei_diameter_edit, 'enable', 'on');
set(handles.threshold_edit, 'enable', 'on');
set(handles.memory_edit, 'enable', 'on');
set(handles.min_frames_edit, 'enable', 'on');
set(handles.max_displacement_edit, 'enable', 'on');
set(handles.export_figure_file, 'enable', 'on');
set(handles.batch_processing, 'enable', 'on');

guidata(hObject, handles);





% --- Executes on button press in generate_tracks_pb.
function generate_tracks_pb_Callback(hObject, eventdata, handles)
% hObject    handle to generate_tracks_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global hFig1

if isfield(hFig1, 'ht')
    delete(hFig1.ht);
end

% evaluate positions of centroids
hFig1.centroids = centroid_array(hFig1.img, hFig1.diameter, hFig1.threshold);
pos = position(hFig1.centroids);

% generate error message if track.m crashes for any reason
try
    hFig1.tracks = track(pos, hFig1.maxDisp, hFig1.parameters);
catch

    errordlg('Alter tracking paramaters and try again');
end
    

hFig1.colorSpec = repmat({'b', 'g', 'r', 'w', 'm', 'c', 'y'}, 1, 1000);

% overlay cell tracks onto axes1
cell_num = unique(hFig1.tracks(:,4));
for i = cell_num'
    T = hFig1.tracks(hFig1.tracks(:,4)==i, :);
    x = T(:,1);
    y = T(:,2);
    hFig1.ht(i) = plot(hFig1.axes1, x, y, hFig1.colorSpec{i});
    text(x(1), y(1), num2str(i), 'color', 'g');
    hold on
end

% enable functions that can be called only when the tracks variable is
% present
if isempty(hFig1.tracks) == 0
    
    set(handles.export_tracks_file, 'enable', 'on');
    set(handles.nuclei_movies, 'enable', 'on');
    set(handles.nuclei_tracks_movie, 'enable', 'on');    
    set(handles.delete_tracks, 'enable', 'on');
end
guidata(hObject, handles);


% --- Executes on slider movement.
function threshold_slider_Callback(hObject, eventdata, handles)
% hObject    handle to threshold_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global hFig1


% enable functions that can be called only when threshold is set
set(handles.roi_blackout_edit, 'enable', 'on');
set(handles.generate_tracks_pb, 'enable', 'on');

handles.astr = num2str( get(handles.threshold_slider,'Value') );
set(handles.threshold_edit,'String', handles.astr);
hFig1.threshold = get(handles.threshold_slider, 'Value');

% update axes1 window when threshold_slider is moved
centroid_validation(hFig1.img, hFig1.zSlice, hFig1.diameter, hFig1.threshold);

set(hFig1.axes1, 'xtick', [], 'ytick', []);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function threshold_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to threshold_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function nuclei_diameter_edit_Callback(hObject, eventdata, handles)
% hObject    handle to nuclei_diameter_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nuclei_diameter_edit as text
%        str2double(get(hObject,'String')) returns contents of nuclei_diameter_edit as a double
global hFig1

hFig1.diameter = str2double(get(handles.nuclei_diameter_edit,'String'));

% nuclei_diameter (lobject in track.m) only accepts even numbers
if mod(hFig1.diameter, 2) == 0
    % number is even
    hFig1.diameter = hFig1.diameter;
else
    % number is odd
    hFig1.diameter = hFig1.diameter + 1;
end

% update axes1 window when diameter is changed
if isfield(hFig1, 'threshold') == 1

centroid_validation(hFig1.img, hFig1.zSlice, hFig1.diameter, hFig1.threshold);

end

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function nuclei_diameter_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nuclei_diameter_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function threshold_edit_Callback(hObject, eventdata, handles)
% hObject    handle to threshold_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of threshold_edit as text
%        str2double(get(hObject,'String')) returns contents of threshold_edit as a double
global hFig1

% enable functions that can be called only when threshold is set
set(handles.roi_blackout_edit, 'enable', 'on');
set(handles.generate_tracks_pb, 'enable', 'on'); 

handles.anum = str2num( get(hObject,'String') );
set(handles.threshold_slider,'Value',handles.anum);
hFig1.threshold = handles.anum;

centroid_validation(hFig1.img, hFig1.zSlice, hFig1.diameter, hFig1.threshold);

set(hFig1.axes1, 'xtick', [], 'ytick', []);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function threshold_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to threshold_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function memory_edit_Callback(hObject, eventdata, handles)
% hObject    handle to memory_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of memory_edit as text
%        str2double(get(hObject,'String')) returns contents of memory_edit as a double
global hFig1

hFig1.mem = str2double(get(handles.memory_edit,'String'));
handles.param.mem = hFig1.mem;
hFig1.parameters = struct(handles.param);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function memory_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to memory_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function min_frames_edit_Callback(hObject, eventdata, handles)
% hObject    handle to min_frames_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of min_frames_edit as text
%        str2double(get(hObject,'String')) returns contents of min_frames_edit as a double
global hFig1

hFig1.frames = str2num(get(handles.min_frames_edit, 'String'));
handles.param.good = hFig1.frames;
hFig1.parameters = struct(handles.param);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function min_frames_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to min_frames_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on slider movement.
function frames_slider_Callback(hObject, eventdata, handles)
% hObject    handle to frames_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global hFig1

if isfield(hFig1, 'img') == 0 
    
    errordlg('Import .tif image stack'); 
end


if isfield(handles, 'hp') == 1
    delete(handles.hp);
end

set(hObject, 'max', handles.maxZ);

set(hObject, 'SliderStep', [1/(handles.maxZ-1) 1]);
hFig1.zSlice = round(get(hObject, 'Value'));
set(hObject, 'Value', hFig1.zSlice);

% update axes1 window to display tracks and/or appropriate for frame
% number
if isempty(hFig1.tracks) == 1

    centroid_validation(hFig1.img, hFig1.zSlice, hFig1.diameter, hFig1.threshold);
    
else
    
    a = double(hFig1.img(:,:,hFig1.zSlice));
    b = bpass(a, 1, hFig1.diameter);
    colormap('gray'); image(b);
    hold on
    handles.hp = plot(hFig1.axes1, hFig1.centroids{hFig1.zSlice}(:,1), hFig1.centroids{hFig1.zSlice}(:,2), 'bo');
    hFig1.ht = tracks_plot(hFig1.tracks, hFig1.colorSpec, hFig1.img, hFig1.zSlice, hFig1.diameter, hFig1.threshold);

    
end

astr = num2str(hFig1.zSlice);
set(handles.frame_number_edit, 'String', astr);

guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function frames_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frames_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function max_displacement_edit_Callback(hObject, eventdata, handles)
% hObject    handle to max_displacement_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of max_displacement_edit as text
%        str2double(get(hObject,'String')) returns contents of max_displacement_edit as a double
global hFig1 

hFig1.maxDisp = str2num( get(hObject,'String') );
 guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function max_displacement_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to max_displacement_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in summary_analysis_pb.
function summary_analysis_pb_Callback(hObject, eventdata, handles)
% hObject    handle to summary_analysis_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global hFig1

% proceed only if tracks have been generated 
if isempty(hFig1.tracks) == 0
    
    [handles.speed, handles.distance, handles.euclid, handles.persistence,... 
        handles.theta, handles.yfmi, handles.xfmi, handles.deltaY,... 
        handles.deltaX, handles.frames_tracked] = migrationStats(hFig1.tracks, hFig1.time, hFig1.pixel_micron);

    handles.N = size(handles.speed, 1);
    
    % alter table display if only one track is present
    if handles.N == 1
    
        col1 = [handles.N; nan(5, 1)];
        col2 = [nan(6, 1)];
        handles.table = [col1, col2];
        set(handles.stat_table, 'data', handles.table); 
    
    else
    
    stats = [handles.speed handles.distance handles.euclid handles.yfmi handles.xfmi];

    stats_mu = mean(stats)';
    stats_sd = std(stats)';
    col1 = [handles.N; stats_mu];
    col2 = [NaN; stats_sd];
    handles.table = [col1, col2];
    set(hFig1.stat_table, 'data', handles.table);

    end

else
    
    errordlg('Generate or import tracks before calling Summary Analysis');
end


guidata(hObject, handles);



function unit_conversion_edit_Callback(hObject, eventdata, handles)
% hObject    handle to unit_conversion_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of unit_conversion_edit as text
%        str2double(get(hObject,'String')) returns contents of unit_conversion_edit as a double
global hFig1

hFig1.pixel_micron = str2num( get(handles.unit_conversion_edit,'String') );

% a time and unit value must be entered before Summary Analysis and
% statistics options become enabled
if isfield(hFig1, 'time') == 1 & hFig1.pixel_micron > 0
    set(handles.summary_analysis_pb, 'enable', 'on');
    set(handles.population_statistics, 'enable', 'on');
    set(handles.statistics_statistics, 'enable', 'on');
end

set(handles.distance_unit_popup, 'enable', 'on');

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function unit_conversion_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to unit_conversion_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function time_interval_eidt_Callback(hObject, eventdata, handles)
% hObject    handle to time_interval_eidt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of time_interval_eidt as text
%        str2double(get(hObject,'String')) returns contents of time_interval_eidt as a double
global hFig1

hFig1.time = str2num( get(handles.time_interval_eidt,'String') );

% a time and unit value must be entered before Summary Analysis and
% statistics options become enabled
if isfield(hFig1, 'pixel_micron') == 1 & hFig1.time > 0
    set(handles.summary_analysis_pb, 'enable', 'on');
    set(handles.population_statistics, 'enable', 'on');
    set(handles.statistics_statistics, 'enable', 'on');
end

set(handles.time_unit_popup, 'enable', 'on');

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function time_interval_eidt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to time_interval_eidt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function file_Callback(hObject, eventdata, handles)
% hObject    handle to file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function file_import_Callback(hObject, eventdata, handles)
% hObject    handle to file_import (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function import_stack_file_Callback(hObject, eventdata, handles)
% hObject    handle to import_stack_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global hFig1

% clear tracks matrix filled with tracks from prexisting image
hFig1.tracks = [];

% clear overlaid tracks from axes1
if isfield(hFig1, 'ht') == 1
    
    clear hFig1.ht;
end

% load new image
hFig1.img = load_tif;
handles.maxZ = size(hFig1.img, 3);
[x, y, handles.maxZ] = size(hFig1.img);
hFig1.zSlice = 1;
set(handles.frames_slider, 'Value', 1);
set(handles.frame_number_edit, 'String', num2str(hFig1.zSlice));
set(handles.axes1, 'XLim', [0 y], 'YLim', [0 x]); 
handles.hImage = image(hFig1.img(:,:,hFig1.zSlice)); colormap('gray');
set(gca, 'xtick', [], 'ytick', []);

set(handles.nuclei_diameter_edit, 'enable', 'on');
set(handles.threshold_edit, 'enable', 'on');
set(handles.memory_edit, 'enable', 'on');
set(handles.min_frames_edit, 'enable', 'on');
set(handles.max_displacement_edit, 'enable', 'on');
set(handles.export_figure_file, 'enable', 'on')
set(handles.batch_processing, 'enable', 'on');

guidata(hObject, handles);

% --------------------------------------------------------------------
function import_tracks_file_Callback(hObject, eventdata, handles)
% hObject    handle to import_tracks_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global hFig1

% import tracks from a .mat file containing a single variable containing
% tracks data
[FileName PathName] = uigetfile;
importTracks = load([PathName filesep FileName]);

for f = fieldnames(importTracks)'
    % dont' assume variable name is tracks
    data=importTracks.(f{1:end});

end
% rename viable containing tracks data 'tracks'
hFig1.tracks = data;

set(handles.population_statistics, 'enable', 'on');
set(handles.statistics_statistics, 'enable', 'on');

guidata(hObject, handles);



% --------------------------------------------------------------------
function movie_Callback(hObject, eventdata, handles)
% hObject    handle to movie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function nuclei_movies_Callback(hObject, eventdata, handles)
% hObject    handle to nuclei_movies (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global hFig1

nucleiVideo(hFig1.img, hFig1.diameter, hFig1.threshold, hFig1.exptName);

% --------------------------------------------------------------------
function nuclei_tracks_movie_Callback(hObject, eventdata, handles)
% hObject    handle to nuclei_tracks_movie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global hFig1

nucleiTracksVideo(hFig1.img, hFig1.tracks, hFig1.diameter, hFig1.threshold, hFig1.exptName);


function experiment_name_edit_Callback(hObject, eventdata, handles)
% hObject    handle to experiment_name_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of experiment_name_edit as text
%        str2double(get(hObject,'String')) returns contents of experiment_name_edit as a double
global hFig1

hFig1.exptName = get(hObject, 'String');

guidata(hObject, handles)


% --- Executes during object creation, after setting all properties.
function experiment_name_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to experiment_name_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function frame_number_edit_Callback(hObject, eventdata, handles)
% hObject    handle to frame_number_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of frame_number_edit as text
%        str2double(get(hObject,'String')) returns contents of frame_number_edit as a double

global hFig1

if isfield(hFig1, 'img') == 0 
    
    errordlg('Import .tif image stack');
    
end

anum = str2double(get(hObject, 'String'));

if anum > handles.maxZ
    h = warndlg({'Index exceeds number of frames.'; 'Reset frame number.'});
end

if isfield(handles, 'hp') == 1
    delete(handles.hp);
end

hFig1.zSlice = anum;
set(handles.frames_slider, 'Value', anum);

% update axes1 window to display tracks and/or appropriate for frame
% number
if isempty(hFig1.tracks) == 1

    centroid_validation(hFig1.img, hFig1.zSlice, hFig1.diameter, hFig1.threshold);
    
else 

    a = double(hFig1.img(:,:,hFig1.zSlice));
    b = bpass(a, 1, hFig1.diameter);
    colormap('gray'); image(b);
    hold on
    handles.hp = plot(hFig1.axes1, hFig1.centroids{hFig1.zSlice}(:,1), hFig1.centroids{hFig1.zSlice}(:,2), 'bo');
    hFig1.ht = tracks_plot(hFig1.tracks, hFig1.colorSpec, hFig1.img, hFig1.zSlice, hFig1.diameter, hFig1.threshold);

end

guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function frame_number_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frame_number_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function statsistics_toolbar_Callback(hObject, eventdata, handles)
% hObject    handle to statsistics_toolbar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function statistics_statistics_Callback(hObject, eventdata, handles)
% hObject    handle to statistics_statistics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global hFig1

% if tracks are present generate statistics 
if isempty(hFig1.tracks) == 0
    
    [handles.speed, handles.distance, handles.euclid, handles.persistence,... 
        handles.theta, handles.yfmi, handles.xfmi, handles.deltaY,... 
        handles.deltaX, handles.frames_tracked] = migrationStats(hFig1.tracks, hFig1.time, hFig1.pixel_micron);
    
    handles.theta = (handles.theta).*(360/(2*pi));
    sz = size(handles.speed, 1); 
    handles.cell_number = 1:sz;
    handles.cell_number = handles.cell_number';
    
    hFig1.cell_stats = table(handles.cell_number, handles.speed,... 
        handles.distance, handles.euclid, handles.persistence,...
        handles.theta, handles.yfmi, handles.xfmi, handles.deltaY,...
        handles.deltaX, handles.frames_tracked);
    
    hFig1.cell_stats.Properties.VariableNames = {'Cell_Number', 'Speed',...
        'Distance','Displacement', 'Persistence', 'Angle', 'YFMI', 'XFMI',...
        'Y_displacement', 'X_displacement', 'Frames'};

    % Open ExportData GUI
    ExportData;

else
     errordlg('Generate or import tracks before calling Summary Analysis');
end

guidata(hObject, handles)



% --------------------------------------------------------------------
function plot_Axes1_Callback(hObject, eventdata, handles)
% hObject    handle to plot_Axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function file_export_Callback(hObject, eventdata, handles)
% hObject    handle to file_export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function export_figure_file_Callback(hObject, eventdata, handles)
% hObject    handle to export_figure_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Dispays contents of axes1 at larger size in a new figure
global hFig1

hf = figure;

[M, N, C] = size(hFig1.img);
set(hf, 'Units', 'Pixels', 'Position', [50 50 N M]);

% Copy the axes and size it to the figure
axes1copy = copyobj(hFig1.axes1, hf);
colormap gray

set(axes1copy, 'Units', 'Normalized', 'Position', [0 0 1 1]);


% --- Executes on selection change in distance_unit_popup.
function distance_unit_popup_Callback(hObject, eventdata, handles)
% hObject    handle to distance_unit_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns distance_unit_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from distance_unit_popup

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function distance_unit_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to distance_unit_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --------------------------------------------------------------------
function delete_tracks_toolbar_Callback(hObject, eventdata, handles)
% hObject    handle to delete_tracks_toolbar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on selection change in time_unit_popup.
function time_unit_popup_Callback(hObject, eventdata, handles)
% hObject    handle to time_unit_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns time_unit_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from time_unit_popup
%

guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function time_unit_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to time_unit_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function batch_process_toolbar_Callback(hObject, eventdata, handles)
% hObject    handle to batch_process_toolbar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function population_statistics_Callback(hObject, eventdata, handles)
% hObject    handle to population_statistics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global hFig1

% if tracks are present generate statistics
if isempty(hFig1.tracks) == 0
    % indicates to ExportData GUI that population statistics are to be
    % exported
    hFig1.export_what = 2;

    [handles.speed, handles.distance, handles.euclid, handles.persistence,...
        handles.theta, handles.yfmi, handles.xfmi, handles.deltaY,... 
        handles.deltaX, handles.frames_tracked] = migrationStats(hFig1.tracks, hFig1.time, hFig1.pixel_micron);

stats = [handles.speed, handles.distance, handles.euclid, handles.persistence,...
    handles.yfmi, handles.xfmi, handles.deltaY, handles.deltaX, handles.frames_tracked];

stats = array2table(stats);

% have grpstats fcn generate statistics
row1 = table2array(grpstats(stats, [], {'mean', 'std', 'median', 'min', 'max'}, 'datavars', 'stats1'));
row2 = table2array(grpstats(stats, [], {'mean', 'std', 'median', 'min', 'max'}, 'datavars', 'stats2'));
row3 = table2array(grpstats(stats, [], {'mean', 'std', 'median', 'min', 'max'}, 'datavars', 'stats3'));
row4 = table2array(grpstats(stats, [], {'mean', 'std', 'median', 'min', 'max'}, 'datavars', 'stats4'));
row5 = table2array(grpstats(stats, [], {'mean', 'std', 'median', 'min', 'max'}, 'datavars', 'stats5'));
row6 = table2array(grpstats(stats, [], {'mean', 'std', 'median', 'min', 'max'}, 'datavars', 'stats6'));
row7 = table2array(grpstats(stats, [], {'mean', 'std', 'median', 'min', 'max'}, 'datavars', 'stats7'));
row8 = table2array(grpstats(stats, [], {'mean', 'std', 'median', 'min', 'max'}, 'datavars', 'stats8'));

% compute sum of cos and sin of angles
r = sum(exp(1i*handles.theta));

% obtain mean angle 
meanTheta = angle(r);
degrees = meanTheta/pi*180;
row9 = [row1(1,1), degrees, nan, nan, nan, nan];

% data to be sent to ExportData GUI where table will be generated
hFig1.pop_stats = [row1;row2;row3;row4;row5;row6;row7;row8;row9];

ExportData;


else
    
    errordlg('Generate or import tracks before calling exporting statistics');
    
end


guidata(hObject, handles);


% --------------------------------------------------------------------
function export_tracks_file_Callback(hObject, eventdata, handles)
% hObject    handle to export_tracks_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global hFig1

% indicates to ExportData GUI that tracks are to be exported
hFig1.export_what = 1;
ExportData;

% --------------------------------------------------------------------
function edit_Callback(hObject, eventdata, handles)
% hObject    handle to edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function roi_blackout_edit_Callback(hObject, eventdata, handles)
% hObject    handle to roi_blackout_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global hFig1


% define vertices of polygon that is to be filled
[handles.x handles.y, handles.BW, handles.xi, handles.yi] = roipoly;

for i = 1:handles.maxZ
    % fill region for every frame in the stack
    hFig1.img(:, :, i) = regionfill(hFig1.img(:, :, i), handles.xi, handles.yi);
    
end
% updata axes1
centroid_validation(hFig1.img, hFig1.zSlice, hFig1.diameter, hFig1.threshold);

guidata(hObject, handles);


% --------------------------------------------------------------------
function delete_tracks_Callback(hObject, eventdata, handles)
% hObject    handle to delete_tracks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


DeleteTracks;


% --------------------------------------------------------------------
function batch_processing_Callback(hObject, eventdata, handles)
% hObject    handle to batch_processing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global hFig1

BatchProcessing

guidata(hObject, handles);
