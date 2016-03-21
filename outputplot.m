function varargout = outputplot(varargin)
% OUTPUTPLOT M-file for outputplot.fig

% Last Modified by Sarit 16-Nov-2006 12:15:54

% ---------------Begin initialization code - DO NOT EDIT-----------------------
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @outputplot_OpeningFcn, ...
                   'gui_OutputFcn',  @outputplot_OutputFcn, ...
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
% -------------End initialization code - DO NOT EDIT---------------------------


% --- Executes just before outputplot is made visible.-------------------------
function outputplot_OpeningFcn(h, eventdata, handles, varargin)

handles.output = h;
guidata(h, handles);

% --- Outputs from this function are returned to the command line.-------------
function varargout = outputplot_OutputFcn(h, eventdata, handles)

varargout{1} = handles.output;

% -----------------------------------------------------------------------------
function filename_Callback(h, eventdata, handles)

% --- Executes on button press in browse.--------------------------------------
function browse_Callback(h, eventdata, handles)

[filename,pathname]=uigetfile('*.dat','DataFile Selection');
set(handles.filename,'String',[filename]);
set(handles.pathname,'String',[pathname]);
handles.datfilename=filename;
handles.datpathname=pathname;
guidata(h,handles);

% --- Executes on button press in ok.------------------------------------------
function ok_Callback(h, eventdata, handles)

filename=getfield(handles,'datfilename');
pathname=getfield(handles,'datpathname');


[h, m]=hdrload([pathname,filename]);                           % Store file contents into matrix
[r,c]=size(m);

figure,plot(m(:,1:2:end-1),m(:,2:2:end-1));                    % displaying the tracks of all the tubes.
axis ij;
grid on;

lineobject=findobj('type','line');
set(lineobject,'linewidth',2);
set(gcf,'Name',['Tracks of ' [filename]]);

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

toplevel=0;
bottomlevel=0;

x=m(:,1:2:end-11);
y=m(:,2:2:end-11);


ytubedata=m(1:4,end-1);                                     % getting data about the tube's y-coordinates
tubelength=(ytubedata(3)-ytubedata(2));                     % measuring the tube length
tubezones=tubelength/4;             
toplevel=ytubedata(2)+tubezones;                            % defining the tube zones
bottomlevel=ytubedata(3)-tubezones;
middlelevel=ytubedata(2)+(2*tubezones);

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

z=[];
t=0;
for j=2:2:11                                                % finding the row no. from where the top zone starts
    t=t+1;
    for i=1:r
        if m(i,j)<toplevel
            z=[z;i];
            break;
        end
    end
    if size(z,1)<t
       z=[z;0];
    end
end


t=0;
for j=1:2:10                                                % extracting data starting from the top zone
    data=[];
    n=z(j-t);
    if n>0 
        for i=n:r  
        data=[data;m(i,j),m(i,j+1)];
        end
    else
        data=[];
    end
    t=t+1;
    if j==1                                                 % placing data into respective tube arrays
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

% --- Executes on button press in Analyze.-------------------------------------
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


%----------------Separating the visit and interval data -----------------------
    visit=[];
    interval=[];

for i=1:size(tube,1)                                           % separating the visit and interval data
    if tube(i,2)>toplevel
        visit=[visit;tube(i,1),tube(i,2),i];
    else
        interval=[interval;tube(i,1),tube(i,2),i];
    end
end       

iterv=[visit(1,3)];                                            % finding the visit iteration jumps
for i=1:size(visit,1)-1
    if (visit(i,3)+1)~=visit(i+1,3)
        iterv=[iterv;visit(i+1,3)];
    end
end

itern=[interval(1,3)];                                         % finding the interval iteration jumps
for i=1:size(interval,1)-1
    if (interval(i,3)+1)~=interval(i+1,3)
        itern=[itern;interval(i+1,3)];
    end
end
    

% ----------------------plotting the interval data----------------------------- 
j=1;
totalarr=[];
while j<=size(itern,1)
      p=itern(j);
      arr=[];
      for k=1:size(interval,1)
          if p==interval(k,3)
             for i=k:(size(interval,1)-1)
                 if (interval(i,3)+1)==interval(i+1,3)    
                    arr=[arr;interval(i,1),interval(i,2)];          % extracting the each interval into an array
                 else
                    break;
                 end
             end
          end
       end      
             [p,q]=size(arr);
             [m,n]=size(totalarr);
             if m==0;
                totalarr=[arr];                     
             else
                t=p-m;
                if t>0
                    totalarr=padarray(totalarr,[t 0],0,'post');     % storing the extracted array into another array
                else
                    t=abs(t);
                    arr=padarray(arr,[t 0],0,'post');               % use of padarray to make arrays of equal length
                end
                totalarr=[totalarr,arr];
             end
         
      j=j+1;
end

[u,v]=size(totalarr);
w=v/2;
y=fix(w/4);
z=mod(w,4);

    if y<1
       figure; 
       for i=1:z     
             temp=[];
             for j=1:u
                if totalarr(j,i*2-1)~=0
                    temp=[temp;totalarr(j,i*2-1),totalarr(j,i*2)];  % storing each interval into a temp array  
                end
             end
             figure(gcf);
             subplot(2,2,i);
             plot(temp(:,1),temp(:,2),'r-',tubedata(:,1),tubedata(:,2),'b-');
             axis([100 650 200 500]);                               
             axis ij;                                               % plotting the temp array in a subplot(2*2)
             grid on; 
             lineobject=findobj('type','line');
             set(lineobject,'linewidth',2);
             set(gcf,'Name',['Tracks of ' [filename]]);
         end
     end

     if y>=1
         for k=0:y
             figure;
                for i=1:4     
                    temp=[];
                    if (k*8+i*2)<=v
                        for j=1:u
                            if totalarr(j,k*4+i*2-1)~=0
                            temp=[temp;totalarr(j,k*4+i*2-1),totalarr(j,k*4+i*2)];
                            end
                                           
                        figure(gcf);
                        subplot(2,2,i);
                        plot(temp(:,1),temp(:,2),'r-',tubedata(:,1),tubedata(:,2),'b-');
                        axis([100 650 200 500]);
                        axis ij;
                        grid on; 
                        lineobject=findobj('type','line');
                        set(lineobject,'linewidth',2);
                        set(gcf,'Name',['Tracks of ' [filename]]);
                        end
                    end
                end
         end
     end     
     
    
% ----------------------- plotting the visit data -----------------------------
j=1;
totalarr=[];
while j<=size(iterv,1)
      p=iterv(j);
      arr=[];
      for k=1:size(visit,1)
          if p==visit(k,3)
             for i=k:(size(visit,1)-1)
                 if (visit(i,3)+1)==visit(i+1,3)    
                    arr=[arr;visit(i,1),visit(i,2)];
                 else
                    break;
                 end
             end
          end
       end      
             [p,q]=size(arr);
             [m,n]=size(totalarr);
             if m==0;
                totalarr=[arr];                     
             else
                t=p-m;
                if t>0
                    totalarr=padarray(totalarr,[t 0],0,'post'); 
                else
                    t=abs(t);
                    arr=padarray(arr,[t 0],0,'post');
                end
                totalarr=[totalarr,arr];
             end
         
      j=j+1;
end

[u,v]=size(totalarr);
w=v/2;
y=fix(w/4);
z=mod(w,4);

    if y<1
       figure;
       for i=1:z     
             
             temp=[];
             for j=1:u
                if totalarr(j,i*2-1)~=0
                    temp=[temp;totalarr(j,i*2-1),totalarr(j,i*2)];
                end
             end
             figure(gcf);
             subplot(2,2,i);
             plot(temp(:,1),temp(:,2),'r-',tubedata(:,1),tubedata(:,2),'b-');
             axis([100 650 200 500]);
             axis ij;
             grid on; 
             lineobject=findobj('type','line');
             set(lineobject,'linewidth',2);
             set(gcf,'Name',['Tracks of ' [filename]]);
         end
     end     

     if y>=1
         for k=0:y
             figure;
             
             for i=1:4     
                 temp=[];
                 if (k*8+i*2)<=v
                     for j=1:u
                        if (totalarr(j,k*8+i*2-1)~=0)
                            temp=[temp;totalarr(j,k*8+i*2-1),totalarr(j,k*8+i*2)];
                        end
                 
                        figure(gcf);
                        subplot(2,2,i);
                        plot(temp(:,1),temp(:,2),'r-',tubedata(:,1),tubedata(:,2),'b-');
                        axis([100 650 200 500]);
                        axis ij;
                        grid on; 
                        lineobject=findobj('type','line');
                        set(lineobject,'linewidth',2);
                        set(gcf,'Name',['Tracks of ' [filename]]);
                     end
                end
             end
             
         end
     end     
             

   close(outputplot);



% --- Executes on button press in Tube1.---------------------------------------
function Tube1_Callback(h, eventdata, handles)
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
% --- Executes on button press in Tube2.---------------------------------------
function Tube2_Callback(h, eventdata, handles)
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
% --- Executes on button press in Tube3.---------------------------------------
function Tube3_Callback(h, eventdata, handles)
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
% --- Executes on button press in Tube4.---------------------------------------
function Tube4_Callback(h, eventdata, handles)
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
% --- Executes on button press in Tube5.---------------------------------------
function Tube5_Callback(h, eventdata, handles)
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

%------------------------------------------------------------------------------
function Outputplot_DeleteFcn(h, eventdata, handles)

% --- Executes during object creation, after setting all properties.-----------
function filename_CreateFcn(h, eventdata, handles)

if ispc
    set(h,'BackgroundColor','white');
else
    set(h,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on button press in pushbuttonclose.-----------------------------
function pushbuttonclose_Callback(h, eventdata, handles)

close(outputplot);

% ---------------------end of the code----yuppie!!!----------------------------