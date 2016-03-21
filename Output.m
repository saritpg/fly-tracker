function varargout = Output(varargin)
% OUTPUT M-file for Output.fig

% Last Modified by Sarit v1.0 29-July-2006 

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Output_OpeningFcn, ...
                   'gui_OutputFcn',  @Output_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end
% 
if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% ----------- Executes just before Output is made visible.---------------

function Output_OpeningFcn(h, eventdata, handles, varargin)

handles.output = h;
if size(varargin)>0
    handle_main=deal(varargin{1});
end
	
guidata(h, handles);

% --- Outputs from this function are returned to the command line.--------
function varargout = Output_OutputFcn(h, eventdata, handles)
varargout{1} = handles.output;

%------------calling the global arrays to be used here---------------------

global AllFlyCentroids;
global rect_val;
global loop;
global cen;

%---------drawing the rectangle and plotting the tracks successively-------

 figure(findobj('Tag','mainfig'));
 axis ij                                                    % to rescale or resize the x and y axis.
 hold on;

rect1=line(rect_val(:,1),rect_val(:,2),'color','b');        % drawing region of interest of all the tubes.
rect2=line(rect_val(:,3),rect_val(:,4),'color','b'); 
rect3=line(rect_val(:,5),rect_val(:,6),'color','b'); 
rect4=line(rect_val(:,7),rect_val(:,8),'color','b'); 
rect5=line(rect_val(:,9),rect_val(:,10),'color','b'); 


plot(cen(1,1),cen(1,2),'r+',cen(2,1),cen(2,2),'r+',cen(3,1),...
    cen(3,2),'r+',cen(4,1),cen(4,2),'r+',cen(5,1),cen(5,2),'r+');          % plotting the start point of the flies.


dum1=line('XData',AllFlyCentroids(:,1),'YData',AllFlyCentroids(:,2),'Color','g');   % joining the centroids to form complete track.
dum2=line('XData',AllFlyCentroids(:,3),'YData',AllFlyCentroids(:,4),'Color','g'); 
dum3=line('XData',AllFlyCentroids(:,5),'YData',AllFlyCentroids(:,6),'Color','g'); 
dum4=line('XData',AllFlyCentroids(:,7),'YData',AllFlyCentroids(:,8),'Color','g'); 
dum5=line('XData',AllFlyCentroids(:,9),'YData',AllFlyCentroids(:,10),'Color','g'); 

%-------------------------------------------------------------------------
function pushbutton1_Callback(h, eventdata, handles)

%------------calling the global arrays to be used here---------------------

global AllFlyCentroids;
global rect_val;
global loop;
global cen;
result=[];                                             % declaring the arrays to be used.          
pad1=[];
fm=[];
%-----------------------storing the data into a new array-----------------

[m,n]=size(AllFlyCentroids);
for i=1:n
    result=[result,AllFlyCentroids(:,i)];
    fm=[fm '%12.6f'];
end

%----entering values in the 'loop' array to make rows of equal length.-----

[r,c]=size(loop);

t=m-r;                                                  % replicating the last value and storing in the  
pad2=padarray(loop,[t 0],'replicate','post');           % same column to attain equal array row size.

%----entering values in the 'rect_val' array to make rows of equal length.-

[r,c]=size(rect_val);

t=m-r;
rect_val=rect_val';

for n=1:c
    pad=padarray(rect_val(n,:),[0 t],'replicate','post');
    pad1=[pad1;pad];
end
rect_val=rect_val';

pad1=pad1';
[r,c]=size(pad1);

%--------joining the pad1 and result array together------------------------
for i=1:c
    result=[result,pad1(:,i)];
    fm=[fm '%12.6f'];
end
     
%--------joining the pad2 and result array together------------------------

result=[result,pad2];
fm=[fm '%12.6f'];
result;
result';

%-----------------------writing the values in a file----------------------
fm=[fm '\n'];

[savefilename,savepathname]=fduiputfile({'*.dat','Data Files(*.dat)'},'Save Data file as','dat');
setappdata(handles.Output,'savefilename',savefilename);
setappdata(handles.Output,'savepathname',savepathname);
fid=fopen([savepathname,savefilename],'w'); 
fprintf(fid,fm,result');
    
fclose(fid);

uiresume(Output);
close(Output);

%------------------------------------------------------------------------
function pushbutton2_Callback(h, eventdata, handles)
close(Output);
%------------------------------------------------------------------------    
