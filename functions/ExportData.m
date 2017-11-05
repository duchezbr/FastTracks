function varargout = ExportData(varargin)
% EXPORTDATA MATLAB code for ExportData.fig
%      EXPORTDATA, by itself, creates a new EXPORTDATA or raises the existing
%      singleton*.
%
%      H = EXPORTDATA returns the handle to a new EXPORTDATA or the handle to
%      the existing singleton*.
%
%      EXPORTDATA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EXPORTDATA.M with the given input arguments.
%
%      EXPORTDATA('Property','Value',...) creates a new EXPORTDATA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ExportData_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ExportData_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ExportData

% Last Modified by GUIDE v2.5 27-Oct-2016 16:09:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ExportData_OpeningFcn, ...
                   'gui_OutputFcn',  @ExportData_OutputFcn, ...
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


% --- Executes just before ExportData is made visible.
function ExportData_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ExportData (see VARARGIN)

% Choose default command line output for ExportData
handles.output = hObject;

global hFig1

set(handles.figure1, 'name', 'Export Data');

handles.chk1 = get(handles.mat_file, 'Value');
handles.chk2 = get(handles.csv_file, 'Value');
handles.chk3 = get(handles.xls_file, 'Value');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ExportData wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ExportData_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in mat_file.
function mat_file_Callback(hObject, eventdata, handles)
% hObject    handle to mat_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of mat_file
handles.chk1 = get(hObject, 'Value');

guidata(hObject, handles);

% --- Executes on button press in csv_file.
function csv_file_Callback(hObject, eventdata, handles)
% hObject    handle to csv_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of csv_file
handles.chk2 = get(hObject, 'Value');

guidata(hObject, handles);

% --- Executes on button press in xls_file.
function xls_file_Callback(hObject, eventdata, handles)
% hObject    handle to xls_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of xls_file
handles.chk3 = get(hObject, 'Value');

guidata(hObject, handles);

% --- Executes on button press in export_now.
function export_now_Callback(hObject, eventdata, handles)
% hObject    handle to export_now (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global hFig1

% export .mat file
if handles.chk1 == 1
    % export tracks
    if hFig1.export_what == 1

        tracks = hFig1.tracks;
        save([pwd filesep 'FastTracksData' filesep hFig1.exptName '_tracks.mat'], 'tracks');
    % export population statistics
    elseif hFig1.export_what == 2

        stats = array2table(hFig1.pop_stats, 'VariableNames', {'N', 'Mean', 'SD', 'Median', 'Min', 'Max'}); 
        Variable = categorical({'Speed'; 'Distance'; 'Displacement'; 'Persistence'; 'YFMI'; 'XFMI'; 'Y-Displacement'; 'X-Displacement'; 'Angle'});
        Variable = table(Variable);
        stats = [Variable, stats];
        save([pwd filesep 'FastTracksData' filesep hFig1.exptName '_Population.mat'], 'stats');
    % export individual cell stats
    else

        cell_stats = hFig1.cell_stats;
        save([pwd filesep 'FastTracksData' filesep hFig1.exptName '_cellStats.mat'], 'cell_stats');
    end

end

% Export .csv file
if handles.chk2 == 1

    if hFig1.export_what == 1

        tracks = hFig1.tracks;
        csvwrite([pwd filesep 'FastTracksData' filesep hFig1.exptName '_tracks.csv'], tracks);
    
    elseif hFig1.export_what == 2

        stats = array2table(hFig1.pop_stats, 'VariableNames', {'N', 'Mean', 'SD', 'Median', 'Min', 'Max'}); 
        Variable = categorical({'Speed'; 'Distance'; 'Displacement'; 'Persistence'; 'YFMI'; 'XFMI'; 'Y-Displacement'; 'X-Displacement'; 'Angle'});
        Variable = table(Variable);
        stats = [Variable, stats];
        writetable(stats, [pwd filesep 'FastTracksData' filesep hFig1.exptName '_Population.csv']);

    else

        writetable(hFig1.cell_stats, [pwd filesep 'FastTracksData' filesep hFig1.exptName '_cellStats.csv']);
    end

end

% Export .xls file
if handles.chk3 == 1

    if hFig1.export_what == 1

        tracks = hFig1.tracks;
        xlswrite([pwd filesep 'FastTracksData' filesep hFig1.exptName '_tracks.xls'], tracks);
    
    elseif hFig1.export_what == 2

        stats = array2table(hFig1.pop_stats, 'VariableNames', {'N', 'Mean', 'SD', 'Median', 'Min', 'Max'}); 
        Variable = categorical({'Speed'; 'Distance'; 'Displacement'; 'Persistence'; 'YFMI'; 'XFMI'; 'Y-Displacement'; 'X-Displacement'; 'Angle'});
        Variable = table(Variable);
        stats = [Variable, stats];
        writetable(stats, [pwd filesep 'FastTracksData' filesep hFig1.exptName '_Population.xls']);

    else

        writetable(hFig1.cell_stats, [pwd filesep 'FastTracksData' filesep hFig1.exptName '_cellStats.xls']);
    end

end

hFig1.export_what = 0;
close(ExportData);
