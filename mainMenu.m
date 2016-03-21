function varargout = mainMenu(varargin)
% MAINMENU M-file for mainMenu.fig

% Last Modified by Sarit 29-July-2006 

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mainMenu_OpeningFcn, ...
                   'gui_OutputFcn',  @mainMenu_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before mainMenu is made visible.
%---------------------------------------------------------------------
function mainMenu_OpeningFcn(h, eventdata, handles, varargin)
handles.output = h;
guidata(h, handles);

%---------------------------------------------------------------------
function varargout = mainMenu_OutputFcn(h, eventdata, handles)
varargout{1} = handles.output;

%---------------------------------------------------------------------
function ButtonDownFcn_Callback(h,eventdata,handles,varargin)
handle_ccp=findobj('Tag','area_spec');                          % Here, we construct 'param' and initialize it.
if ~isempty(handle_ccp)
    hh=guihandles(handle_ccp);
    param=getappdata(hh.text1,'param')
    handles=setfield(handles,'param',param);
    guidata(h,handles);
end

%---------------------------------------------------------------------
function checkbox1_Callback(h, eventdata, handles)

if(get(h,'value')==get(h,'max'))                                % check box 'image' ticked
    set(findobj('String','Browse'),'Enable','on');              % enabling the "browse" button.
else 
    delete(findobj('type','image'));
end

%---------------------------------------------------------------------
function pushbuttonBrowse_Callback(h, eventdata, handles)

hh=Browse;uiwait;
if ~isempty(findobj('Tag','Browser'))                           % Here, we use the browse subroutine to search
    if isfield(handles,'filenames');                            %  for the file which we wish to run..
        delete(findobj('type','image'));                       
        delete(findobj(gcf,'color','y'));
    end
    h1=guihandles(hh);
    
end
    images2=getappdata(h1.Browser,'Images2');      

    pathname2=getappdata(h1.Browser,'pathname2');               % getting the pathname and filename of the file

    filename2=getappdata(h1.Browser,'filename2');

    handles.NumFrames2=getappdata(h1.Browser,'NumFrames2');
    filenames= filename2;

    handles.images2=images2;

    
    handles.pathname2=pathname2;                                % storing them using handles
    handles.filenames=filenames;
    handles.index1=1;
    handles.index2=2;
    close(hh);
    
    set(findobj('Tag','pushbuttonmesh'),'Enable','on');         % enabling the "Tube parameters" button.
    
    set(findobj('Tag','Text3'),'Enable','on');           
    set(findobj('Tag','Text4'),'Enable','on');
    
    guidata(h,handles); 
    
    images=images2;
    handles.images=images2;
    handles.imagesbw=images2;                                   % storing the images using the handles
    %----------------------------------------------------------------

    guidata(h,handles);
    
    iptsetpref('ImshowAxesVisible','on');                        % we adjust the intensity of the image and
    images{1}=imadjust(images{1},[0.50 0.80],[0 1]);             % project this image in the graphic window.
    imshow(images{1});
        
    set(handles.mainfig,'Name',['Fly Track Version 1.0 ',[filenames(:,1:end-4),num2str(handles.index2),'.PLT']]);
    watchoff;
    set(findobj('Type','image'),'ButtonDownFcn','mainMenu(''ButtonDownFcn_Callback'',gcbo,[],guidata(gcbo))')
 
    guidata(h,handles);   

    hold on;


%---------------------------------------------------------------------
function pushbuttonmesh_Callback(h, eventdata, handles, varargin)

                                                                    % From here, we mark the region of interest, i.e.
 uiwait(msgbox('Mark area of the tube excluding the cap zone'));    % the boundary of the tube..also, we acquire the
 [xrect,yrect]=ginput(5);hold off;                                  % coordinates of these points and store them.
                                                                   


uiwait(msgbox('Mark the start points of the flies in all the tubes'));  % for getting the start points(centroids) 
[xrect1,yrect1]=ginput(5);                                              % of the flies in first frame and store them.


%-------selecting the region of interest------------------------------
  hold on;
  uiwait(msgbox('Mark area of the caps'));                         % we select the rings and crop it. This is done to 
  ring=imcrop;                                                      % serve as a basis upon which the region of interest
  level = graythresh(ring);                                         % can be drawn.. This is done by changing the rgb 
  ring = im2bw(ring,level);                                         % image into bw image, complementing it and removing
  ring=imcomplement(ring);                                          % small background noise.. Then, imdilate and imfill 
  ring_edge=edge(ring,'sobel');                                     % functions are used to enhance the ring region, which
  ring_area=bwareaopen(ring_edge,8);                                % gives the region properties.. "Extrema values"

  se=strel('disk',7,6);                                             % do not change these values.
  ring_area=imdilate(ring_edge,se);
  ring_area=imfill(ring_area,'holes');
  [rings,nos]=bwlabel(ring_area,8);

  ring_area=regionprops(rings,'FilledArea');                        % the Extrema values gives the coordinates of the 
  bbox=regionprops(rings,'Extrema');                                % enhanced ring region.. which is later used to draw
  n=size(bbox);                                                     % the region of interest.

%---------finding the coordinates of the region of interest ------------
global cen;
global rect_val;

rect_val=[];
  l_vertical=sqrt((xrect(2)-xrect(3))^2+(yrect(2)-yrect(3))^2);
  for i=1:n(1)

       if (ring_area(i).FilledArea >= 350)           
           corners=bbox(i).Extrema;
           
           l_horizontal=sqrt((corners(3,1)-corners(7,1))^2+(corners(3,2)-corners(7,2))^2);
           x_points=[corners(3,1),corners(7,1),corners(7,1),corners(3,1),corners(3,1)];
           y_points=[yrect(3)-l_vertical,yrect(3)-l_vertical,yrect(3),yrect(3),yrect(3)-l_vertical];
           
           x_data{i}=x_points;
           y_data{i}=y_points;
           
           hold on;                                                      % drawing the region of interest 
           rect=line('XData',x_data{i},'YData',y_data{i},'Color','g');   % for all the six tubes..
           plot(rect);
           
           rect_val=[rect_val;x_data{i};y_data{i}];
       end
  end

%---developing the array for coordinates of the rectangle.---------------

rect_val=transpose(rect_val);                           % array built to store the coordinates of region of interest.
cen=[xrect1,yrect1];                                    % array built to store the start points of the flies..

set(findobj('Tag','pushbutton_process'),'Enable','on');         % enabling the "Track" button.

%------------------------------------------------------------------------
function pushbutton_process_Callback(h, eventdata, handles)     % process function which is built to successively
handles=Process(handles,h);                                     % process the movie frames and store the centroids
guidata(h,handles);                                             % is being called here.. Check Process.m file..
set(findobj('Tag','pushbutton_output'),'Enable','on');          % enabling the "Output" button.
                                                                                                                          
%------------------------------------------------------------------------
function pushbutton_output_Callback(h, eventdata, handles)
  hh=Output(handles);
     uiwait(Output);                                            % output function which is built to show the 
if ~isempty(findobj('Tag','Output'))                            % tracks and store the data in a dat file is 
   h1=guihandles(hh);                                           % being called here.. Check Output.m file..
   handles.savefilename=getappdata(h1.Output,'savefilename');
   handles.savepathname=getappdata(h1.Output,'savepathname');
    close(hh);
   guidata(h,handles);
end

%---------------------------------------------------------------------
function pushbutton_outputplot_Callback(h, eventdata, handles)

outputplot;

%---------------------------------------------------------------------
function pushbutton7_Callback(h, eventdata, handles)

close(mainMenu);

%---------------------------------------------------------------------
function popupmenu5_CreateFcn(h, eventdata, handles)

if ispc
    set(h,'BackgroundColor','white');
else
    set(h,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
%---------------------------------------------------------------------
function popupmenu6_CreateFcn(h, eventdata, handles)

if ispc
    set(h,'BackgroundColor','white');
else
    set(h,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
%---------------------------------------------------------------------
function popupmenu6_Callback(h, eventdata, handles)
%---------------------------------------------------------------------
function popupmenu7_CreateFcn(h, eventdata, handles)

if ispc
    set(h,'BackgroundColor','white');
else
    set(h,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
%---------------------------------------------------------------------
function popupmenu7_Callback(h, eventdata, handles)
%---------------------------------------------------------------------
function popupmenu8_CreateFcn(h, eventdata, handles)

if ispc
    set(h,'BackgroundColor','white');
else
    set(h,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
%---------------------------------------------------------------------
function popupmenu9_CreateFcn(h, eventdata, handles)

if ispc
    set(h,'BackgroundColor','white');
else
    set(h,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
%---------------------------------------------------------------------
function popupmenu9_Callback(h, eventdata, handles)
%---------------------------------------------------------------------
function popupmenu10_CreateFcn(h, eventdata, handles)

if ispc
    set(h,'BackgroundColor','white');
else
    set(h,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
%---------------------------------------------------------------------
function popupmenu10_Callback(h, eventdata, handles)
%---------------------------------------------------------------------
function popupmenu11_CreateFcn(h, eventdata, handles)

if ispc
    set(h,'BackgroundColor','white');
else
    set(h,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
%---------------------------------------------------------------------
function popupmenu11_Callback(h, eventdata, handles)

%---------------------------------------------------------------------
function pushbutton_properties_Callback(h, eventdata, handles)

trackProperties;

%---------------------------------------------------------------------

% function pushbuttonFinalPlot_Callback(h, eventdata, handles)
% 
% FinalTrack;



