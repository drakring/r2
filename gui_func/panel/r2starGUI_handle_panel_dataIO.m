%% h = r2starGUI_handle_panel_dataIO(hParent,h,position)
%
% Input
% --------------
% hParent       : parent handle of this panel
% h             : global structure contains all handles
% position      : position of this panel
%
% Output
% --------------
% h             : global structure contains all new and other handles
%
% Description: This GUI function creates a panel for I/O control
%
% Kwok-shing Chan @ DCCN
% k.chan@donders.ru.nl
% Date created: 21 April 2018
% Date last modified: 14 June 2018
%
%
function h = r2starGUI_handle_panel_dataIO(hParent,h,position)

h.StepsPanel.dataIO = uipanel(hParent,'Title','I/O',...
    'Position',[position(1) position(2) 0.98 0.3],...
    'backgroundcolor',get(h.fig,'color'));
    % input
    h.dataIO.text.input = uicontrol(h.StepsPanel.dataIO,'Style','text','String','mGRE image:',...
        'Units','normalized','Position', [0.01 0.8 0.2 0.15],...
        'HorizontalAlignment','left',...
        'backgroundcolor',get(h.fig,'color'),...
        'tooltip','Input directory contains NIfTI file');
    h.dataIO.edit.input = uicontrol('Parent',h.StepsPanel.dataIO,'Style','edit',...
        'units','normalized','position',[0.21 0.8 0.68 0.15],...
        'HorizontalAlignment','left',...
        'backgroundcolor','white');
    h.dataIO.button.input = uicontrol('Parent',h.StepsPanel.dataIO,'Style','pushbutton','String','open',...
        'units','normalized','position',[0.89 0.8 0.1 0.15],...
        'backgroundcolor','white');
    
    % output
    h.dataIO.text.output = uicontrol('Parent',h.StepsPanel.dataIO,'Style','text','String','Output dir:',...
        'units','normalized','Position',[0.01 0.64 0.2 0.15],...
        'HorizontalAlignment','left',...
        'backgroundcolor',get(h.fig,'color'),...
        'tooltip','Output directory');
    h.dataIO.edit.output = uicontrol('Parent',h.StepsPanel.dataIO,'Style','edit',...
        'units','normalized','position',[0.21 0.64 0.68 0.15],...
        'HorizontalAlignment','left',...
        'backgroundcolor','white');
    h.dataIO.button.output = uicontrol('Parent',h.StepsPanel.dataIO,'Style','pushbutton','String','open',...
        'units','normalized','position',[0.89 0.64 0.1 0.15],...
        'backgroundcolor','white');
    
    % mask files
    h.dataIO.text.maskdir = uicontrol('Parent',h.StepsPanel.dataIO,'Style','text','String','Brain mask file:',...
        'units','normalized','Position',[0.01 0.48 0.2 0.15],...
        'HorizontalAlignment','left',...
        'backgroundcolor',get(h.fig,'color'),...
        'tooltip','Specify mask file (NIfTI format). If the input directory contains NIfTI file with *mask* in the file name then it will be read automatically.');
    h.dataIO.edit.maskdir = uicontrol('Parent',h.StepsPanel.dataIO,'Style','edit',...
        'units','normalized','position',[0.21 0.48 0.68 0.15],...
        'HorizontalAlignment','left',...
        'backgroundcolor','white');
    h.dataIO.button.maskdir = uicontrol('Parent',h.StepsPanel.dataIO,'Style','pushbutton','String','open',...
        'units','normalized','position',[0.89 0.48 0.1 0.15],...
        'backgroundcolor','white');
    
    % TE file
    h.dataIO.text.teFile = uicontrol('Parent',h.StepsPanel.dataIO,'Style','text','String','TE file',...
        'units','normalized','Position',[0.01 0.32 0.2 0.15],...
        'HorizontalAlignment','left',...
        'backgroundcolor',get(h.fig,'color'),...
        'tooltip','Use FSL brain extraction (bet)');
    h.dataIO.edit.teFile = uicontrol('Parent',h.StepsPanel.dataIO,'Style','edit',...
        'units','normalized','position',[0.21 0.32 0.68 0.15],...
        'HorizontalAlignment','left',...
        'backgroundcolor','white');
    h.dataIO.button.teFile = uicontrol('Parent',h.StepsPanel.dataIO,'Style','pushbutton','String','open',...
        'units','normalized','position',[0.89 0.32 0.1 0.15],...
        'backgroundcolor','white');
    
    % user TE input
    h.dataIO.text.userTE = uicontrol('Parent',h.StepsPanel.dataIO,'Style','text','String','or user input TEs:',...
        'units','normalized','Position',[0.01 0.16 0.2 0.15],...
        'HorizontalAlignment','left',...
        'backgroundcolor',get(h.fig,'color'),...
        'tooltip','Specify mask file (NIfTI format). If the input directory contains NIfTI file with *mask* in the file name then it will be read automatically.');
    h.dataIO.edit.userTE = uicontrol('Parent',h.StepsPanel.dataIO,'Style','edit',...
        'units','normalized','position',[0.21 0.16 0.78 0.15],...
        'HorizontalAlignment','left',...
        'backgroundcolor','white',...
        'String','[]');

% set callbacks
set(h.dataIO.button.input,      'Callback', {@ButtonOpen_Callback,h,'input'});
set(h.dataIO.button.output,    	'Callback', {@ButtonOpen_Callback,h,'output'});
set(h.dataIO.button.maskdir,   	'Callback', {@ButtonOpen_Callback,h,'mask'});
set(h.dataIO.button.teFile,    	'Callback', {@ButtonOpen_Callback,h,'te'});
    
end

%% Callback
function ButtonOpen_Callback(source,eventdata,h,field)
% get directory and display it on GUI

% output base name
prefix = 'squirrel';

switch field
    case 'te'
        % te file can be text file or mat file
        [tefileName,pathDir] = uigetfile({'*.mat;*.txt'},'Select TE file');
        
        % display file directory
        if pathDir ~= 0
            set(h.dataIO.edit.teFile,'String',fullfile(pathDir,tefileName));
        end

    case 'mask'
        % only read NIfTI file for mask
        [maskfileName,pathDir] = uigetfile({'*.nii;*.nii.gz','NIfTI file (*.nii,*.nii.gz)'},'Select mask file');

        if pathDir ~= 0
            set(h.dataIO.edit.maskdir,'String',fullfile(pathDir,maskfileName));
        end
        
    case 'input'
        % get directory for NIfTI files
        [greFileName,pathDir] = uigetfile({'*.nii;*.nii.gz','NIfTI file (*.nii,*.nii.gz)'},'Select multi-echo GER file');

        if pathDir ~= 0
            % set input edit field for display
            set(h.dataIO.edit.input,'String',fullfile(pathDir,greFileName));
            % automatically set default output field
            set(h.dataIO.edit.output,   'String',[pathDir 'output' filesep prefix]);
        end
        
    case 'output'
        % get directory for output
        pathDir = uigetdir;

        if pathDir ~= 0
            set(h.dataIO.edit.output,'String',[pathDir filesep prefix]);
        end
end

end
