function varargout = trackProperties(varargin)
% TRACKPROPERTIES M-file for trackProperties.fig

% Last Modified by Sarit on 24-Jan-2007 18:02:20

% ------------Begin initialization code - DO NOT EDIT--------------------------
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @trackProperties_OpeningFcn, ...
                   'gui_OutputFcn',  @trackProperties_OutputFcn, ...
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
%---------- End initialization code - DO NOT EDIT------------------------------


% ---------- Executes just before trackProperties is made visible.-------------
function trackProperties_OpeningFcn(h, eventdata, handles, varargin)

handles.output = h;
if size(varargin)>0
    handle_main=deal(varargin{1});
    outfilename=getfield(handle_main,'savefilename');
    outpathname=getfield(handle_main,'savepathname');
 
    handles.outfilename=outfilename;
    handles.outpathname=outpathname;
    handles.mainhandles=handle_main;
end
 
 guidata(h, handles);

% -------- Outputs from this function are returned to the command line.--------
function varargout = trackProperties_OutputFcn(h, eventdata, handles)

varargout{1} = handles.output;


function filename_CreateFcn(h, eventdata, handles)

if ispc
    set(h,'BackgroundColor','white');
else
    set(h,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function filename_Callback(h, eventdata, handles)


% --------------- Executes on button press in Browse.--------------------------
function Browse_Callback(h, eventdata, handles)
[filename,pathname]=uigetfile('*.dat','DataFile Selection');
set(handles.filename,'String',[filename]);
set(handles.pathname,'String',[pathname]);
handles.datfilename=filename;
handles.datpathname=pathname;
guidata(h,handles);


% ---------------- Executes on button press in Ok.-----------------------------
function Ok_Callback(h, eventdata, handles)

filename=getfield(handles,'datfilename');
pathname=getfield(handles,'datpathname');

            
%----------------Storing the file contents into the matrix---------------------

[h,m]= hdrload([pathname,filename]);                        % placing the data in "m" array
[r,c]=size(m);

x=m(:,1:2:end-11);                                          % placing 'x' data in one array  
y=m(:,2:2:end-11);                                          % and 'y' data in another.

global toplevel;                                            % declaring global variables to be
global bottomlevel;                                         % called in subsequent functions.

global tube1;
global tube2;
global tube3;
global tube4;
global tube5;
global tubedata1;
global tubedata2;
global tubedata3;
global tubedata4;
global tubedata5;

toplevel=0;
bottomlevel=0;

ytubedata=m(1:4,end-1);                                     % getting data about the tube's y-coordinates
tubelength=(ytubedata(3)-ytubedata(2));                     % and measuring the tube length.
tubezones=tubelength/4;             
toplevel=ytubedata(2)+tubezones;                            % defining the tube zones
bottomlevel=ytubedata(3)-tubezones;


tdx=m(1:5,end-10);
tdy=m(1:5,end-9);
tubedata1=[tdx,tdy];                                        % storing the respective tube coordinates 

tdx=m(1:5,end-8);
tdy=m(1:5,end-7);
tubedata2=[tdx,tdy];

tdx=m(1:5,end-6);
tdy=m(1:5,end-5);
tubedata3=[tdx,tdy];

tdx=m(1:5,end-4);
tdy=m(1:5,end-3);
tubedata4=[tdx,tdy];

tdx=m(1:5,end-2);
tdy=m(1:5,end-1);
tubedata5=[tdx,tdy];

samplingVar=m(1:3,end);
Start=samplingVar(1);
Endat=samplingVar(2);                       
skip=samplingVar(3);
samplingRate=5;

global skip;
global samplingRate;


% ------------------placing data into respective tube arrays-------------------
t=0;
for j=1:2:10                                                
    data=[];
    
    for i=1:r  
        data=[data;m(i,j),m(i,j+1)];
    end
        
    if j==1                                                 
        tube1=data;
    elseif j==3
        tube2=data;
    elseif j==5
        tube3=data;
    elseif j==7
        tube4=data;
    elseif j==9
        tube5=data;
    end
end
% --------------- Executes on button press in Analyze.-------------------------
function Analyze_Callback(h, eventdata, handles)

filename=getfield(handles,'datfilename');

Tube01=handles.Tube01;
Tube02=handles.Tube02;
Tube03=handles.Tube03;
Tube04=handles.Tube04;
Tube05=handles.Tube05;

global toplevel;
global bottomlevel;

global tube1;
global tube2;
global tube3;
global tube4;
global tube5;

global tubedata1;
global tubedata2;
global tubedata3;
global tubedata4;
global tubedata5;

global skip;
global samplingRate;

if Tube01==1
    tube=tube1;
    tubedata=tubedata1;
end 

if Tube02==1
    tube=tube2;
    tubedata=tubedata2;
end

if Tube03==1
    tube=tube3;
    tubedata=tubedata3;
end

if Tube04==1
    tube=tube4;
    tubedata=tubedata4;
end

if Tube05==1
    tube=tube5;
    tubedata=tubedata5;
end

%----------------Separating the escape, visit and interval data ---------------
    escape=[];
    visit=[];
    interval=[];

for i=1:size(tube,1)-1                                         % separating the escape, visit and interval data
    if tube(i,2)<=toplevel
        escape=[escape;tube(i,1),tube(i,2),i];
    elseif tube(i,2)>=bottomlevel
        visit=[visit;tube(i,1),tube(i,2),i];
    elseif tube(i,2)<bottomlevel & tube(i,2)>toplevel
        interval=[interval;tube(i,1),tube(i,2),i];
    end
end       

itere=[escape(1,3)];                                           % finding the escape iteration jumps
for i=1:size(escape,1)-1
    if (escape(i,3)+1)~=escape(i+1,3)
        itere=[itere;escape(i+1,3)];
    end
end

iterv=[visit(1,3)];                                            % finding the visit iteration jumps
for i=1:size(visit,1)-1
    if (visit(i,3)+1)~=visit(i+1,3)
        iterv=[iterv;visit(i+1,3)];
    end
end

iteri=[interval(1,3)];                                         % finding the interval iteration jumps
for i=1:size(interval,1)-1
    if (interval(i,3)+1)~=interval(i+1,3)
        iteri=[iteri;interval(i+1,3)];
    end
end



% ------------------Calculating the parameters of the escape-------------------
etimeperEvent=[];
totaletime=0;
j=1;
totalarre=[];
while j<=size(itere,1)
      p=itere(j);
      
      for k=1:size(escape,1)
          if p==escape(k,3)
             arr=[escape(k,1),escape(k,2),p];
             for i=k:(size(escape,1)-1)
                 if (escape(i,3)+1)==escape(i+1,3)    
                    arr=[arr;escape(i+1,1),escape(i+1,2),p];       % extracting the each escape into an array
                 else
                    break;
                 end
             end
          end
      end 
     j=j+1;
      
     t=size(arr,1);
     NoOfFrames=t*skip;
     tracktime=NoOfFrames/samplingRate;
     etimeperEvent=[etimeperEvent;tracktime];
     totaletime=totaletime+tracktime;         
end

% ---------------Calculating the parameters of the visit-----------------------
vtimeperEvent=[];
totalvtime=0;
j=1;
totalarrv=[];
while j<=size(iterv,1)
      p=iterv(j);
      
      for k=1:size(visit,1)
          if p==visit(k,3)
             arr=[visit(k,1),visit(k,2),p];
             for i=k:(size(visit,1)-1)
                 if (visit(i,3)+1)==visit(i+1,3)    
                    arr=[arr;visit(i+1,1),visit(i+1,2),p];         % extracting the each visit into an array
                 else
                    break;
                 end
             end
          end
      end 
     j=j+1;
     
     t=size(arr,1);
     NoOfFrames=t*skip;
     tracktime=NoOfFrames/samplingRate;
     vtimeperEvent=[vtimeperEvent;tracktime];
     totalvtime=totalvtime+tracktime;
     
end

% ---------------Calculating the parameters of the interval--------------------
itimeperEvent=[];
totalitime=0;
j=1;
totalarri=[];
while j<=size(iteri,1)
      p=iteri(j);
      
      for k=1:size(interval,1)
          if p==interval(k,3)
             arr=[interval(k,1),interval(k,2),p];
             for i=k:(size(interval,1)-1)
                 if (interval(i,3)+1)==interval(i+1,3)    
                    arr=[arr;interval(i+1,1),interval(i+1,2),p];   % extracting the each interval into an array
                 else
                    break;
                 end
             end
          end
      end 
     j=j+1;
     
     t=size(arr,1);
     NoOfFrames=t*skip;
     tracktime=NoOfFrames/samplingRate;
     itimeperEvent=[itimeperEvent;tracktime];
     totalitime=totalitime+tracktime;
     
end

etimeperEvent
vtimeperEvent
itimeperEvent

totaletime
totalvtime
totalitime

%-----------Calculation of time in each zone for every minute bin--------------

    TotalFrames=size(tube,1)-1;
    TotalTime=(TotalFrames*skip)/(samplingRate*60);                % divided by 60 to convert the time into mins.
    FramesPerMin=TotalFrames/TotalTime;                            % calculating no. of frames for one min. bin.

m=1;
n=FramesPerMin;

EtimeperMin=[];
VtimeperMin=[];
ItimeperMin=[];


while n<TotalFrames+1
  
  escape=[];
  visit=[];
  interval=[];
  
    for i=m:n
        
        if tube(i,2)<=toplevel
            escape=[escape;tube(i,1),tube(i,2)];
        elseif tube(i,2)>=bottomlevel
            visit=[visit;tube(i,1),tube(i,2)];
        elseif tube(i,2)<bottomlevel & tube(i,2)>toplevel
            interval=[interval;tube(i,1),tube(i,2)];
        end
  
    end
        a=size(escape,1);
        b=size(visit,1);
        c=size(interval,1);
    
        escapetime=a*skip/samplingRate;
        visittime=b*skip/samplingRate;
        intervaltime=c*skip/samplingRate;
    
        EtimeperMin=[EtimeperMin;escapetime];
        VtimeperMin=[VtimeperMin;visittime];
        ItimeperMin=[ItimeperMin;intervaltime];
        
    m=m+FramesPerMin;
    n=n+FramesPerMin;
end

EtimeperMin
VtimeperMin
ItimeperMin


close(trackProperties);

% ----------------- Executes on button press in Tube01.------------------------
function Tube01_Callback(h, eventdata, handles)
Tube01=get(h,'value');
handles.Tube01=Tube01;
guidata(h,handles);

if(get(h,'value')==get(h,'max'))
    set(findobj('Tag','Tube2'),'value',0);
    set(findobj('Tag','Tube3'),'value',0);
    set(findobj('Tag','Tube4'),'value',0);
    set(findobj('Tag','Tube5'),'value',0);
end
Tube02=0;
handles.Tube02=Tube02;
Tube03=0;
handles.Tube03=Tube03;
Tube04=0;
handles.Tube04=Tube04;
Tube05=0;
handles.Tube05=Tube05;
guidata(h,handles);

% ----------------- Executes on button press in Tube02.------------------------
function Tube02_Callback(h, eventdata, handles)
Tube02=get(h,'value');
handles.Tube02=Tube02;
guidata(h,handles);

if(get(h,'value')==get(h,'max'))
    set(findobj('Tag','Tube1'),'value',0);
    set(findobj('Tag','Tube3'),'value',0);
    set(findobj('Tag','Tube4'),'value',0);
    set(findobj('Tag','Tube5'),'value',0);
end
Tube01=0;
handles.Tube01=Tube01;
Tube03=0;
handles.Tube03=Tube03;
Tube04=0;
handles.Tube04=Tube04;
Tube05=0;
handles.Tube05=Tube05;
guidata(h,handles);

% ---------------- Executes on button press in Tube03.-------------------------
function Tube03_Callback(h, eventdata, handles)
Tube03=get(h,'value');
handles.Tube03=Tube03;
guidata(h,handles);

if(get(h,'value')==get(h,'max'))
    set(findobj('Tag','Tube2'),'value',0);
    set(findobj('Tag','Tube1'),'value',0);
    set(findobj('Tag','Tube4'),'value',0);
    set(findobj('Tag','Tube5'),'value',0);
end
Tube02=0;
handles.Tube02=Tube02;
Tube01=0;
handles.Tube01=Tube01;
Tube04=0;
handles.Tube04=Tube04;
Tube05=0;
handles.Tube05=Tube05;
guidata(h,handles);

% ------------------- Executes on button press in Tube04.----------------------
function Tube04_Callback(h, eventdata, handles)
Tube04=get(h,'value');
handles.Tube04=Tube04;
guidata(h,handles);

if(get(h,'value')==get(h,'max'))
    set(findobj('Tag','Tube2'),'value',0);
    set(findobj('Tag','Tube3'),'value',0);
    set(findobj('Tag','Tube1'),'value',0);
    set(findobj('Tag','Tube5'),'value',0);
end
Tube02=0;
handles.Tube02=Tube02;
Tube03=0;
handles.Tube03=Tube03;
Tube01=0;
handles.Tube01=Tube01;
Tube05=0;
handles.Tube05=Tube05;
guidata(h,handles);

% ------------------ Executes on button press in Tube05.-----------------------
function Tube05_Callback(h, eventdata, handles)
Tube05=get(h,'value');
handles.Tube05=Tube05;
guidata(h,handles);

if(get(h,'value')==get(h,'max'))
    set(findobj('Tag','Tube2'),'value',0);
    set(findobj('Tag','Tube3'),'value',0);
    set(findobj('Tag','Tube4'),'value',0);
    set(findobj('Tag','Tube1'),'value',0);
end
Tube02=0;
handles.Tube02=Tube02;
Tube03=0;
handles.Tube03=Tube03;
Tube04=0;
handles.Tube04=Tube04;
Tube01=0;
handles.Tube01=Tube01;
guidata(h,handles);

% ----------------- Executes on button press in Close.-------------------------
function Close_Callback(h, eventdata, handles)
close(trackProperties);

% ----------------------------End of the code----------------------------------


