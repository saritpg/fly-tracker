function [handles]=process(varargin)

handles=deal(varargin{1});
mainhandle=deal(varargin{2});

%-----calling all the global arrays to be used here--------------

 global AllFlyCentroids; 
 global rect_val;
 global cen; 
 global loop;
 AllFlyCentroids=[];                                  % declaring array for storing the centroids successively.
 
 
%------Load all processing parameters from the handles--------------

images=handles.imagesbw;

counter=0;
start=get(handles.popupmenu9,'Value');                % taking values for iteration (start, end, skip)
endat=get(handles.popupmenu10,'Value');
skip=get(handles.popupmenu11,'Value');

handles.start=start;                                  % storing the iteration values using handles.
handles.endat=endat;
handles.skip=skip;

loop=[handles.start;handles.endat;handles.skip];      % storing the iteration values in an array.

handles.res=zeros(100,2,length([start:skip:endat]));

%-------------------------------------------------------------------
for fileind=start:skip:endat                          % start of loop of one frame
    setptr(handles.mainfig,'watch');
    counter= counter+1;
    handles.index1=fileind;
    mov2=aviread([handles.pathname2,handles.filenames],fileind);            % reading the movie file

    [handles.images2{1}]=deal(mov2.cdata);
    
     
        handles.images2{1}=im2double(rgb2gray(handles.images2{1}));         % changing  the image to b&w.
        handles.images2{1}=imcomplement(handles.images2{1});                % complementing the image.
        handles.images2{1}=imadjust(handles.images2{1},[0.25 0.60],[0 1]);  % adjusting the intensity of the image.
        
       
       set(handles.popupmenu9,'Value',fileind);                             % refreshes value of the start popupmenu to show
       imshow(handles.images2{1});                                          % the latest frame no. and displaying the image.
       
%---------Filtering the image of each tube successively---------------
%   for m=1            
            
    a=roipoly(handles.images2{1},rect_val(:,1),rect_val(:,2));
    z=fspecial('sobel');
    a1=roifilt2(z,handles.images2{1},a);
       
%   end  
  
%   for m=2
            
    a=roipoly(handles.images2{1},rect_val(:,3),rect_val(:,4));              % WARNING: Do not change any parameters.
    z=fspecial('sobel');
    a2=roifilt2(z,handles.images2{1},a);
          
%   end  
  
%   for m=3
            
    a=roipoly(handles.images2{1},rect_val(:,5),rect_val(:,6));
    z=fspecial('sobel');
    a3=roifilt2(z,handles.images2{1},a);
         
%   end  
  
%   for m=4
            
    a=roipoly(handles.images2{1},rect_val(:,7),rect_val(:,8));
    z=fspecial('sobel');
    a4=roifilt2(z,handles.images2{1},a);
          
%   end  
  
%   for m=5
            
    a=roipoly(handles.images2{1},rect_val(:,9),rect_val(:,10));
    z=fspecial('sobel');
    a5=roifilt2(z,handles.images2{1},a);
          
%   end 
  
%---improving the image and finding the centroids in all the tubes ---
%-------------- this is solely for the first frame--------------------
  
if counter==1  
    
for m=1
gh1=imsubtract(a1,handles.images2{1});                           % subtracting the filtered image(above)
gh1=imadjust(gh1,[0.25 0.60],[0 1]);                             % from the start image(after improving)
se=strel('square',9);                                            % other image processing functions 
gh1=imdilate(gh1,se);                                            % follow to improve the image.
gh1=imfill(gh1);    
AllFlyCentroid1=[cen(1,1),cen(1,2)];                             % getting the centroid points from the  
end                                                              % user input given earlier. 'cen' array.

for m=2
gh2=imsubtract(a2,handles.images2{1});
gh2=imadjust(gh2,[0.25 0.60],[0 1]);
se=strel('square',9);
gh2=imdilate(gh2,se);
gh2=imfill(gh2);    
AllFlyCentroid2=[cen(2,1),cen(2,2)];                             % WARNING: Do not change any parameters.
end

for m=3
gh3=imsubtract(a3,handles.images2{1});
gh3=imadjust(gh3,[0.25 0.60],[0 1]);
se=strel('square',9);
gh3=imdilate(gh3,se);
gh3=imfill(gh3);    
AllFlyCentroid3=[cen(3,1),cen(3,2)];
end

for m=4
gh4=imsubtract(a4,handles.images2{1});
gh4=imadjust(gh4,[0.25 0.60],[0 1]);
se=strel('square',9);
gh4=imdilate(gh4,se);
gh4=imfill(gh4);    
AllFlyCentroid4=[cen(4,1),cen(4,2)];
end

for m=5
gh5=imsubtract(a5,handles.images2{1});
gh5=imadjust(gh5,[0.25 0.60],[0 1]);
se=strel('square',9);
gh5=imdilate(gh5,se);
gh5=imfill(gh5);    
AllFlyCentroid5=[cen(5,1),cen(5,2)];
end

end       

%---improving the image and finding the centroids in all the tubes ---
%-------------- this is for the successive frames---------------------

if counter>1    
    
for m=1
    
gh1=imsubtract(a1,handles.images2{1});                      % subtracting the filtered image(above)
gh1=imadjust(gh1,[0.25 0.60],[0 1]);                        % from the start image(after improving)
se=strel('square',9);                                       % other image processing functions
gh1=imdilate(gh1,se);                                       % follow to improve the image.
gh1=imfill(gh1);
gh_bw1=bwareaopen(gh1,75);
[L1,numObjects1]=bwlabel(gh_bw1,4);                 

if numObjects1 > 0
    
    FlyData1=regionprops(L1,'basic');                        % region properties gives the centroid 
    AllFlyCentroid1=[FlyData1.Centroid];                     % of the fly.. which is stored.
    [p,q]=size(AllFlyCentroid1);
    if q>2
        d1=sqrt((AllFlyCentroids(r,1)-AllFlyCentroid1(1,1))^2+(AllFlyCentroids(r,2)-AllFlyCentroid1(1,2))^2);
        d2=sqrt((AllFlyCentroids(r,1)-AllFlyCentroid1(1,3))^2+(AllFlyCentroids(r,2)-AllFlyCentroid1(1,4))^2);
        if d1<d2
            AllFlyCentroid1=[AllFlyCentroid1(1,1),AllFlyCentroid1(1,2)];
        else
            AllFlyCentroid1=[AllFlyCentroid1(1,3),AllFlyCentroid1(1,4)];
        end
    end
else 
    
    AllFlyCentroid1=[AllFlyCentroids(r,1),AllFlyCentroids(r,2)];    % taking the centroid of the previous loop 
    break;                                                          % (from history) if the centroid is not detected.
    
end 

end

for m=2
    
gh2=imsubtract(a2,handles.images2{1});                      % WARNING: Do not change any parameters.
gh2=imadjust(gh2,[0.25 0.60],[0 1]);
se=strel('square',9);
gh2=imdilate(gh2,se);
gh2=imfill(gh2);
gh_bw2=bwareaopen(gh2,75);
[L1,numObjects1]=bwlabel(gh_bw2,4);

if numObjects1 > 0
    
FlyData1=regionprops(L1,'basic');
AllFlyCentroid2=[FlyData1.Centroid];
[p,q]=size(AllFlyCentroid2);
if q>2
        d1=sqrt((AllFlyCentroids(r,3)-AllFlyCentroid2(1,1))^2+(AllFlyCentroids(r,4)-AllFlyCentroid2(1,2))^2);
        d2=sqrt((AllFlyCentroids(r,3)-AllFlyCentroid2(1,3))^2+(AllFlyCentroids(r,4)-AllFlyCentroid2(1,4))^2);
        if d1<d2
            AllFlyCentroid2=[AllFlyCentroid2(1,1),AllFlyCentroid2(1,2)];
        else
            AllFlyCentroid2=[AllFlyCentroid2(1,3),AllFlyCentroid2(1,4)];
        end
    end
else
    
    AllFlyCentroid2=[AllFlyCentroids(r,3),AllFlyCentroids(r,4)];
    break;
    
end 

end

for m=3
    
gh3=imsubtract(a3,handles.images2{1});
gh3=imadjust(gh3,[0.25 0.60],[0 1]);
se=strel('square',9);
gh3=imdilate(gh3,se);
gh3=imfill(gh3);
gh_bw3=bwareaopen(gh3,75);
[L1,numObjects1]=bwlabel(gh_bw3,4);

if numObjects1>0
    
FlyData1=regionprops(L1,'basic');
AllFlyCentroid3=[FlyData1.Centroid];
[p,q]=size(AllFlyCentroid3);
if q>2
        d1=sqrt((AllFlyCentroids(r,5)-AllFlyCentroid3(1,1))^2+(AllFlyCentroids(r,6)-AllFlyCentroid3(1,2))^2);
        d2=sqrt((AllFlyCentroids(r,5)-AllFlyCentroid3(1,3))^2+(AllFlyCentroids(r,6)-AllFlyCentroid3(1,4))^2);
        if d1<d2
            AllFlyCentroid3=[AllFlyCentroid3(1,1),AllFlyCentroid3(1,2)];
        else
            AllFlyCentroid3=[AllFlyCentroid3(1,3),AllFlyCentroid3(1,4)];
        end
    end
else 
    
    AllFlyCentroid3=[AllFlyCentroids(r,5),AllFlyCentroids(r,6)];
    break;
    
end  

end

for m=4
    
gh4=imsubtract(a4,handles.images2{1});
gh4=imadjust(gh4,[0.25 0.60],[0 1]);
se=strel('square',9);
gh4=imdilate(gh4,se);
gh4=imfill(gh4);
gh_bw4=bwareaopen(gh4,75);
[L1,numObjects1]=bwlabel(gh_bw4,4);

if numObjects1>0
    
FlyData1=regionprops(L1,'basic');
AllFlyCentroid4=[FlyData1.Centroid];
[p,q]=size(AllFlyCentroid4);
if q>2
        d1=sqrt((AllFlyCentroids(r,7)-AllFlyCentroid4(1,1))^2+(AllFlyCentroids(r,8)-AllFlyCentroid4(1,2))^2);
        d2=sqrt((AllFlyCentroids(r,7)-AllFlyCentroid4(1,3))^2+(AllFlyCentroids(r,8)-AllFlyCentroid4(1,4))^2);
        if d1<d2
            AllFlyCentroid4=[AllFlyCentroid4(1,1),AllFlyCentroid4(1,2)];
        else
            AllFlyCentroid4=[AllFlyCentroid4(1,3),AllFlyCentroid4(1,4)];
        end
    end
else 
    
    AllFlyCentroid4=[AllFlyCentroids(r,7),AllFlyCentroids(r,8)];
    break;
    
end   

end

for m=5
    
gh5=imsubtract(a5,handles.images2{1});
gh5=imadjust(gh5,[0.25 0.60],[0 1]);
se=strel('square',9);
gh5=imdilate(gh5,se);
gh5=imfill(gh5);
gh_bw5=bwareaopen(gh5,75);
[L1,numObjects1]=bwlabel(gh_bw5,4);

if numObjects1>0
    
FlyData1=regionprops(L1,'basic');
AllFlyCentroid5=[FlyData1.Centroid];
[p,q]=size(AllFlyCentroid5);
if q>2
        d1=sqrt((AllFlyCentroids(r,9)-AllFlyCentroid5(1,1))^2+(AllFlyCentroids(r,10)-AllFlyCentroid5(1,2))^2);
        d2=sqrt((AllFlyCentroids(r,9)-AllFlyCentroid5(1,3))^2+(AllFlyCentroids(r,10)-AllFlyCentroid5(1,4))^2);
        if d1<d2
            AllFlyCentroid5=[AllFlyCentroid5(1,1),AllFlyCentroid5(1,2)];
        else
            AllFlyCentroid5=[AllFlyCentroid5(1,3),AllFlyCentroid5(1,4)];
        end
    end
else 
    
    AllFlyCentroid5=[AllFlyCentroids(r,9),AllFlyCentroids(r,10)];
    break;
    
end  

end

end  

%--------Forming an array of the centroids----------------------------

AllFlyCentroid=cat(2,AllFlyCentroid1,AllFlyCentroid2,...    % storing the latest centroid values in this array.
                     AllFlyCentroid3,AllFlyCentroid4,...
                     AllFlyCentroid5); 
                 
AllFlyCentroids=cat(1,AllFlyCentroids,AllFlyCentroid);      % storing the latest array values in this global array. 

%-----displaying the latest image with centroids marked on it---------

  x=imadd(gh1,gh2);                                         % for the latest frame, addition of individual 
  y=imadd(gh3,gh4);                                         % tube images done to get all the white spots 
  z=imadd(gh5,x);                                           % in one image.(gh1,gh2,.. taken from above)
  v=imadd(z,y);

 
  IM2 = imclearborder(v,8);
  IM2=bwareaopen(IM2,50);
  
   hold off;
   imshow(IM2);
   hold on;


%-------- plotting the latest centroids in this image.----------------

plot(AllFlyCentroid(:,1),AllFlyCentroid(:,2),'r+',AllFlyCentroid(:,3),...
    AllFlyCentroid(:,4),'r+',AllFlyCentroid(:,5),AllFlyCentroid(:,6),'r+',...
    AllFlyCentroid(:,7),AllFlyCentroid(:,8),'r+',AllFlyCentroid(:,9),...
    AllFlyCentroid(:,10),'r+');

drawnow;                                                    % to find the no. of rows, to be used when 
r=size(AllFlyCentroids,1);                                  % the need arises to extract history values.

watchoff(handles.mainfig)
    
end                                                         % end of loop of one frame

  
