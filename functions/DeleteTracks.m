function varargout = DeleteTracks(varargin)
% DELETETRACKS MATLAB code for DeleteTracks.fig
%      DELETETRACKS, by itself, creates a new DELETETRACKS or raises the existing
%      singleton*.
%
%      H = DELETETRACKS returns the handle to a new DELETETRACKS or the handle to
%      the existing singleton*.
%
%      DELETETRACKS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DELETETRACKS.M with the given input arguments.
%
%      DELETETRACKS('Property','Value',...) creates a new DELETETRACKS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DeleteTracks_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DeleteTracks_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DeleteTracks

% Last Modified by GUIDE v2.5 27-Oct-2016 16:25:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DeleteTracks_OpeningFcn, ...
                   'gui_OutputFcn',  @DeleteTracks_OutputFcn, ...
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


% --- Executes just before DeleteTracks is made visible.
function DeleteTracks_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DeleteTracks (see VARARGIN)

% Choose default command line output for DeleteTracks
handles.output = hObject;

global hFig1


[M, N, C] = size(hFig1.img(:,:,:));


handles.hFigure = handles.figure1;
handles.hAxes = handles.axes1;

% create size and position of DeleteTracks window
set(handles.hFigure, 'color', [0.9 0.9 0.9],'name', 'Delete Tracks',...
    'units', 'pixels', 'position', [100 100 N+100 M+100], 'numbertitle', 'off');

% set axes position witin the figure window
set(handles.hAxes, 'box', 'off', 'tickdir', 'out', 'units', 'pixels', ...
    'position', [50 50 N M], 'nextplot', 'replacechildren', ...
    'xlimMode', 'manual', 'xlim', [1 N], 'ylimMode', 'manual',...
    'Ylim', [1 M], 'ydir', 'reverse', 'xtick', [], 'ytick', []);

% postion for pushbutton to initiate select_positions function
set(handles.select_positions_pushbutton, 'units', 'pixels', ...
    'position', [50 M+60 150 35]);
% position for pushbutton that will update tracks, Summary Analysis table 
% and axes1 in FastTracks GUI
set(handles.update_tracks_pushbutton, 'units', 'pixels', ...
    'position', [50 10 150 35]);

% display current frame in axes1
a = double(hFig1.img(:,:,hFig1.zSlice));
b = bpass(a, 1, hFig1.diameter);
colormap('gray');
handles.hImage = image(b);

hold on

% overlay tracks 
cell_num = unique(hFig1.tracks(:,4));
for i = cell_num'
    T = hFig1.tracks(hFig1.tracks(:,4)==i, :);
    x = T(:,1);
    y = T(:,2);
    h(i) = plot(x, y, hFig1.colorSpec{i});
    
    set(gca, 'Color', 'none');
    hold on
end
set(gca, 'ydir', 'reverse');


% isolate initial coordinate positions for each track 
handles.pos1 = [];
cell_num = unique(hFig1.tracks(:,4));
for i = cell_num'
    data = hFig1.tracks(hFig1.tracks(:,4) == i, :);
    first = data(1, :);
    handles.pos1 = [handles.pos1; first];
end


handles.Axes2 = axes('Parent', handles.hFigure);

% plot initial coordinate positions in axis that overlays the axes that
% contains tracks
scatter(handles.Axes2, handles.pos1(:,1), handles.pos1(:,2), 'bo',...
    'markerfacecolor', [0 0 1]);
% make sure axes containg initial coordinates has the same dimensions as
% the axes containing the tracks data
set(handles.Axes2, 'units', 'pixels', 'position', [50 50 N M],... 
    'YLim', [0 M], 'XLim', [0 N], 'xtick', [], 'ytick', [],... 
    'ydir', 'reverse', 'box', 'off','color', 'none');


guidata(hObject, handles);

% UIWAIT makes DeleteTracks wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DeleteTracks_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in select_positions_pushbutton.
function select_positions_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to select_positions_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[handles.p handles.x handles.y] = selectdata('selectionmode', 'brush');

guidata(hObject, handles);

% --- Executes on button press in update_tracks_pushbutton.
function update_tracks_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to update_tracks_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global hFig1



%% Reset handles.axes1 with updated tracks
xy = [handles.x, handles.y];

% find cooresponding coordinate values between list of selected coordinates
% and list containg all initial coordinate positions
idx = ismember(handles.pos1(:,1:2), xy);

% TODO: quick fix -- idx is a 2 column vector
% extract the track number for trajectories that have been selected with 
% the selectdata function
id = handles.pos1(idx(:,1), 4);

% delete tracks that contain the track ID identified with selectdata.m
for i = id'
     idx = hFig1.tracks(:, 4) == i;
     hFig1.tracks(idx, :) = [];
end

% renumber tracks ID sequentially starting with track ID = 1
hFig1.tracks = number_first_traxID_1(hFig1.tracks);

% delete handle that identifies line objects contained in axes1
delete(hFig1.ht); 

% plot updated tracks on axes1 
cell_num = unique(hFig1.tracks(:,4));
for i = cell_num'
    T = hFig1.tracks(hFig1.tracks(:,4)==i, :);
    x = T(:,1);
    y = T(:,2);
    hFig1.ht(i) = plot(hFig1.axes1, x, y, hFig1.colorSpec{i});
    text(x(1), y(1), num2str(i), 'color', 'g');
    hold on
end

% reset summary analysis table
% TODO: Fix it
if isfield(hFig1, 'time') & isfield(hFig1, 'pixel_micron') 
    [handles.speed, handles.distance, handles.euclid, handles.persistence,... 
        handles.theta, handles.yfmi, handles.xfmi, handles.deltaY,... 
        handles.deltaX, handles.frames_tracked] = migrationStats(hFig1.tracks, hFig1.time, hFig1.pixel_micron);

    handles.N = size(handles.speed, 1);

    if handles.N == 1
    
        col1 = [handles.N; nan(5, 1)];
        col2 = [nan(6, 1)];
        handles.table = [col1, col2];
        set(hFig1.stat_table, 'data', handles.table); 
    
    else
    
    stats = [handles.speed handles.distance handles.euclid handles.yfmi handles.xfmi];

    stats_mu = mean(stats)';
    stats_sd = std(stats)';
    col1 = [handles.N; stats_mu];
    col2 = [NaN; stats_sd];
    handles.table = [col1, col2];
    set(hFig1.stat_table, 'data', handles.table);
    
    end
end
%% Update axes in DeleteTracks window
cla(handles.hAxes)
cla(handles.Axes2)

% this is all the same as the DeleteTracks opnfcn
[M, N, C] = size(hFig1.img(:,:,:));


set(handles.hFigure, 'color', [0.9 0.9 0.9],'name', 'Image Display',...
    'units', 'pixels', 'position', [100 100 N+100 M+100], 'numbertitle', 'off');

set(handles.hAxes, 'box', 'off', 'tickdir', 'out', 'units', 'pixels', ...
    'position', [50 50 N M], 'nextplot', 'replacechildren', ...
    'xlimMode', 'manual', 'xlim', [1 N], 'ylimMode', 'manual',...
    'Ylim', [1 M], 'ydir', 'reverse', 'xtick', [], 'ytick', []);


a = double(hFig1.img(:,:,hFig1.zSlice));
b = bpass(a, 1, hFig1.diameter);
colormap('gray');
handles.hImage = image(b);

hold on


for i = cell_num'
    plot(hFig1.ht(i).XData, hFig1.ht(i).YData, hFig1.colorSpec{i});
    set(gca, 'Color', 'none');
    hold on
end
set(gca, 'ydir', 'reverse');


handles.pos1 = [];
for i = cell_num'
    data = hFig1.tracks(hFig1.tracks(:,4) == i, :);
    first = data(1, :);
    handles.pos1 = [handles.pos1; first];
end


handles.Axes2 = axes('Parent', handles.hFigure);
set(handles.Axes2, 'position',get(handles.hAxes,'position'));

scatter(handles.Axes2, handles.pos1(:,1), handles.pos1(:,2), 'bo',...
    'markerfacecolor', [0 0 1]);
set(handles.Axes2, 'units', 'pixels', 'position', [50 50 N M],... 
    'YLim', [0 M], 'XLim', [0 N], 'xtick', [], 'ytick', [],... 
    'ydir', 'reverse', 'box', 'off','color', 'none');



guidata(hObject, handles);
