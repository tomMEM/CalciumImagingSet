function varargout = Main(varargin)
% MAIN MATLAB code for Main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Main

% Last Modified by GUIDE v2.5 08-Apr-2015 23:19:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Main_OpeningFcn, ...
                   'gui_OutputFcn',  @Main_OutputFcn, ...
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


% --- Executes just before Main is made visible.
function Main_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<*INUSL>
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Main (see VARARGIN)

% Choose default command line output for Main
handles.output = hObject;
root = [fileparts(fileparts(mfilename('fullpath'))) filesep];
set(handles.dirfile,'string',[root 'Images' filesep]);
set(handles.savedir,'string',[root 'Files' filesep]);
set(handles.iminit,'string','1');
set(handles.imstep,'string','1');
set(handles.imfinal,'string','1000');
set(handles.amin,'string','40');
set(handles.amax,'string','400'); 
set(handles.xmin,'string','700');
set(handles.xmax,'string','1000');
set(handles.ymin,'string','700');
set(handles.ymax,'string','1000');
set(handles.neurons,'string','0');
set(handles.excentmax,'string','0.85');

% Set toolbar to figure
set(hObject, 'Toolbar', 'figure')

clc
handles.D = struct('directory', '', ...
                   'image', NaN, ...
                   'dt', NaN, ...
                   'mask',NaN, ...
                   'ROI', NaN, ...
                   'drift',NaN, ...
                   'imagenorm',NaN,...
                   'STATS',NaN, ...
                   'L',NaN, ...
                   'wneuron',NaN, ...
                   'Lcorrect',NaN, ...
                   'signal',NaN, ...
                   'background',NaN, ...
                   'DFF',NaN, ...
                   'baseline',NaN, ...
                   'calcium',NaN, ...
                   'Nneurons',NaN, ...
                   'range', NaN, ...
                   'STATSCOMPLET',NaN, ...
                   'PCuse',NaN);
                   

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function dirfile_Callback(hObject, eventdata, handles)
% hObject    handle to dirfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dirfile as text
%        str2double(get(hObject,'String')) returns contents of dirfile as a double
directory=get(handles.dirfile,'String');
filelist=dir([directory '*.tif']);
Nimages=size(filelist,1);
% set(handles.savedir,'String',get(hObject,'String'));

set(handles.Nfiles,'string',int2str(Nimages));
set(handles.imfinal,'string',int2str(Nimages));

im=imread([directory filelist(1).name],'tif');
im2=imread([directory filelist(2).name],'tif');
handles.D.image=im;
dt=get_timestamp(im2)-get_timestamp(im);
handles.D.range=[1 1 Nimages];
handles.D.dt=dt;
handles.D.directory=directory;

info=imfinfo([directory filelist(1).name],'tif');
width=info.Width;
height=info.Height;
xmin=width-width; xmax=width;ymin=height-height;ymax=height;
ROIpreset(hObject,handles,im,xmin,xmax,ymin,ymax); handles=guidata(handles.output);%important for stable transfer
handles=guidata(handles.output);
himageall = imhandles(gcf);
delete(himageall);
%im=transpose((1:100))*(1:100);
 imshow(rescalegd(im),'parent',handles.axes1); 
%  imcontrast(gcf);
 
guidata(handles.output);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function dirfile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dirfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ROI.
function ROI_Callback(hObject, eventdata, handles)
% hObject    handle to ROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ROI
axes(handles.axes1);
set(handles.message,'String','Select Region Of interest');
% guidata(hObject, handles);
wpoly=roipoly;
set(handles.message,'String','');
guidata(hObject, handles);
[xpoly, ypoly]=find(wpoly==1);
xmin=min(xpoly);
xmax=max(xpoly);
ymin=min(ypoly);
ymax=max(ypoly);
%x=[xmin xmin xmax xmax xmin];
%y=[ymin ymax ymax ymin ymin];
wpoly=double(wpoly);
mask=wpoly(xmin:xmax,ymin:ymax);
im=double(handles.D.image);
imcrop=mask.*im(xmin:xmax,ymin:ymax);
imshow(rescalegd(imcrop),'DisplayRange', [0 1]);
handles.D.ROI=[xmin xmax ymin ymax];
handles.D.mask=mask;
set(handles.xmin,'string',num2str(xmin));
set(handles.ymin,'string',num2str(ymin));
set(handles.xmax,'string',num2str(xmax));
set(handles.ymax,'string',num2str(ymax));
set(hObject,'Value',0);
guidata(handles.output,handles);guidata(hObject, handles);




function Nfiles_Callback(hObject, eventdata, handles)
% hObject    handle to Nfiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Nfiles as text
%        str2double(get(hObject,'String')) returns contents of Nfiles as a double


% --- Executes during object creation, after setting all properties.
function Nfiles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Nfiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ymin_Callback(hObject, eventdata, handles)
% hObject    handle to ymin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ymin as text
%        str2double(get(hObject,'String')) returns contents of ymin as a double


% --- Executes during object creation, after setting all properties.
function ymin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ymin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xmin_Callback(hObject, eventdata, handles)
% hObject    handle to xmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xmin as text
%        str2double(get(hObject,'String')) returns contents of xmin as a double


% --- Executes during object creation, after setting all properties.
function xmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ymax_Callback(hObject, eventdata, handles)
% hObject    handle to ymax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ymax as text
%        str2double(get(hObject,'String')) returns contents of ymax as a double


% --- Executes during object creation, after setting all properties.
function ymax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ymax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xmax_Callback(hObject, eventdata, handles)
% hObject    handle to xmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xmax as text
%        str2double(get(hObject,'String')) returns contents of xmax as a double


% --- Executes during object creation, after setting all properties.
function xmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4


% --- Executes on button press in togglebutton5.
function togglebutton5_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton5



function iminit_Callback(hObject, eventdata, handles)
% hObject    handle to iminit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
range=handles.D.range;
range(1)=str2double(get(hObject,'String'));%changed to str2double TB
handles.D.range=range;
guidata(hObject, handles);
% handles.D.range
% Hints: get(hObject,'String') returns contents of iminit as text
%        str2double(get(hObject,'String')) returns contents of iminit as a double


% --- Executes during object creation, after setting all properties.
function iminit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to iminit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function imstep_Callback(hObject, eventdata, handles)
% hObject    handle to imstep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
range=handles.D.range;
range(2)=str2double(get(hObject,'String'));
handles.D.range=range;
guidata(hObject, handles);
handles.D.range

% Hints: get(hObject,'String') returns contents of imstep as text
%        str2double(get(hObject,'String')) returns contents of imstep as a double


% --- Executes during object creation, after setting all properties.
function imstep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imstep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function imfinal_Callback(hObject, eventdata, handles)
% hObject    handle to imfinal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
range=handles.D.range;
range(3)=str2double(get(hObject,'String'));
handles.D.range=range;
guidata(hObject, handles);
handles.D.range
% Hints: get(hObject,'String') returns contents of imfinal as text
%        str2double(get(hObject,'String')) returns contents of imfinal as a double


% --- Executes during object creation, after setting all properties.
function imfinal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imfinal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cor4drift.
function cor4drift_Callback(hObject, eventdata, handles)
% hObject    handle to cor4drift (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cor4drift


% --- Executes on button press in GO_createim.
function GO_createim_Callback(hObject, eventdata, handles)
% hObject    handle to GO_createim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

changeimarray=get(handles.changeimarray,'value');
writeaverage=get(handles.writeaverage,'value');

cor4drift=get(handles.cor4drift,'value');


   


init=str2double(get(handles.iminit,'String'));
final=str2double(get(handles.imfinal,'String'));
steps=str2double(get(handles.imstep,'String'));
Nimages=final-init+1;
directory=get(handles.dirfile,'String');
filelist=dir([directory '*.tif']);
xmin=str2double(get(handles.xmin,'String'));
xmax=str2double(get(handles.xmax,'String'));
ymin=str2double(get(handles.ymin,'String'));
ymax=str2double(get(handles.ymax,'String'));
set(handles.message,'String',' ');drawnow;

if cor4drift
    dx1=zeros(Nimages,1);
    dy1=dx1;
    imref=0;
    for i=init:(init+4) %steps
        im=imread([directory filelist(i).name]);
        imref=double(im)+imref;
    end
    imref=imref/i;%steps TB CHANGE; 
%     [xim,yim]=meshgrid(1:size(imref,2),1:size(imref,1));surf(xim,yim); tb
    imshow(rescalegd(imref(xmin:xmax,ymin:ymax)),[0 1],'parent',handles.axesplot);drawnow;
end
     new=0;
     
Fxy=0;
tic
for i=1:steps:Nimages;
    h=i/Nimages;
    mesg=hbargd(h,100,'-');
    set(handles.message,'String',['calculating...' mesg]);drawnow;
%     guidata(hObject, handles);
    im=imread([directory filelist(i+init-1).name]);
    im=double(im);
    if cor4drift
            dXinit=0;
            dYinit=0;
        if i>1
            dXinit=round(dx1(i-steps));
            dYinit=round(dy1(i-steps));
        end
       [dx1(i),dy1(i)]=correct_drift4(imref(xmin:xmax,ymin:ymax),im(xmin:xmax,ymin:ymax),dXinit,dYinit,20,handles);
       if i>1
           plot(dx1(dx1 ~= 0),dy1(dx1 ~= 0),'Parent',handles.axesplot)
           title('2-D Line Plot');
            xlabel('shift x');
            ylabel('shift y')   
%            xlim([floor(min(dx1)) ceil(max(dx1))]);
%            ylim([floor(min(dy1)) ceil(max(dy1))]);
            axis equal 
            drawnow;
       end
        im=bilinearshift(im,dx1(i),dy1(i));
       %[yim,xim]=meshgrid(1:size(imref,2),1:size(imref,1));
       %im=interp2(yim,xim,im,yim-dy(i),xim-dx(i),'Linear',0);
       %im=interp2(xim,yim,im,xim-dx(i),yim-dy(i),'Linear',0);
    end
    
%      if changeimarray
%         newpicarray(:,:,i)=Fxy;
%         writeframes(hObject,handles,im,writeaverage,changeimarray,newfilename)
%     end
   
        if changeimarray
            if new==0
                overwrite='overwrite';        
                new=1;           
            else
                overwrite='append'; 
            end    
            newfilename='seq_calcium';
            if cor4drift
                   diffile=strcat('Dif_',newfilename,'.tif');
            else
                   diffile=strcat('Origin_',newfilename,'.tif');
            end  
            writeframes(hObject,handles,im(xmin:xmax,ymin:ymax),diffile,overwrite);
        end
      
    Fxy=Fxy+im;
  
    
end

if cor4drift
    t1=(1:steps:Nimages);
    t=(1:Nimages);
    %dxfilt=medfilt1(dx(t1),3*steps);
    %dyfilt=medfilt1(dy(t1),3*steps);
    %dx1=interp1(t1,dxfilt,t,'linear',0);
    %dy1=interp1(t1,dyfilt,t,'linear',0);
    dx=interp1(t1,dx1(t1),t,'spline',0);
    dy=interp1(t1,dy1(t1),t,'spline',0); 
    
%     plot(handles.axes1,dx1(t1),dy1(t1))
%     hold on
%     plot(handles.axes1,dx(t),dy(t),'Parent',handles.axes1);
% %     pause(10)
%     hold off
    
%     plot(dx1,dy1,'parent',handles.axes1);
    handles.D.drift=[transpose(dx) transpose(dy)];
end

Fxy=Fxy/fix(Nimages/steps);

handles.D.image=Fxy;

imshow(rescalegd(Fxy(xmin:xmax,ymin:ymax)),[0 1],'parent',handles.axes1);drawnow;
if writeaverage
    if cor4drift
        newfilename='driftcorrected';
    else
        newfilename='notcorrected';
    end
    avefile=strcat('Ave_',newfilename,'.tif');
    overwrite='overwrite';
    writeframes(hObject,handles,Fxy(xmin:xmax,ymin:ymax),avefile,overwrite);
end
% i=45
toc
set(hObject,'Value',0);
set(handles.message,'String','finished');drawnow;
guidata(hObject, handles);

% Hint: get(hObject,'Value') returns toggle state of GO_createim


% --- Executes during object creation, after setting all properties.
function plot1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plot1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate plot1


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes on button press in segment.
function segment_Callback(hObject, eventdata, handles)
% hObject    handle to segment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% 
% h = get(handles.axes1,'Children')

haxesplot = findobj(handles.axesplot,'Type','image');
himageall = imhandles(gcf);
delete(himageall);

set(handles.message,'String','segmentation start...');drawnow;

im=handles.D.image;
mask=handles.D.mask;


xmin=str2double(get(handles.xmin,'String'));
xmax=str2double(get(handles.xmax,'String'));
ymin=str2double(get(handles.ymin,'String'));
ymax=str2double(get(handles.ymax,'String'));

% create a well contrasted image for display
smwindow=str2double(get(handles.pixkernel,'String'));

minvalue=floor(smwindow^2*0.1);
maxvalue=floor(smwindow^2*0.8);

im2=im(xmin:xmax,ymin:ymax);

B = ordfilt2(im2,minvalue,true(smwindow));
C = ordfilt2(im2,maxvalue,true(smwindow)); % prend la valeur du dernier décile

% imagenorm=rescalegd((im2-B)./(C-B));
imagenorm=im;%(im2-B)./(C-B);
imagenorm=imclearborder(imagenorm);
imshow(imagenorm(xmin:xmax,ymin:ymax),[0 max(imagenorm(:))/20],'parent',handles.axes1);

set(handles.message,'String','segmentation normalized image ...');drawnow;
handles.D.imagenorm=imagenorm;

areamax=str2double(get(handles.amax,'String'));
areamin=str2double(get(handles.amin,'String'));
excentmax=str2double(get(handles.excentmax,'String'));

%---------------------------------------------------
L=segmentgd(handles,imagenorm(xmin:xmax,ymin:ymax));
%---------------------------------------------------


STATS = regionprops(double(L).*mask, 'Area','PixelIdxList','Eccentricity','Centroid');
a=field2num(STATS,'Area');
ex=field2num(STATS,'Eccentricity');
wneuron=ones(size(a,1),1);
w= a>areamax | a<areamin | ex>excentmax;
wneuron(w)=0;  

% Nneurons=squeeze(sum(wneuron)); 

handles.D.STATSCOMPLET=STATS;
handles.D.STATS=STATS(wneuron==1);

% size(STATS(wneuron(find(wneuron==1))))

handles.D.L=L;
handles.D.wneuron=wneuron;
guidata(handles.output);

set(handles.message,'String','segmentation ROIs ...');drawnow;
handles=disp_segment(hObject, handles);

set(hObject,'Value',0);
set(handles.message,'String','finished');drawnow;

guidata(hObject, handles);




% Hint: get(hObject,'Value') returns toggle state of segment


function amin_Callback(hObject, eventdata, handles)
% hObject    handle to amin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of amin as text
%        str2double(get(hObject,'String')) returns contents of amin as a double


handles=update_constraints(hObject,handles);
guidata(hObject, handles);
handles=disp_segment(hObject,handles);

% --- Executes during object creation, after setting all properties.
function amin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to amin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function amax_Callback(hObject, eventdata, handles)
% hObject    handle to amax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles=update_constraints(hObject,handles);
handles=disp_segment(hObject,handles);
guidata(hObject, handles);

% Hints: get(hObject,'String') returns contents of amax as text
%        str2double(get(hObject,'String')) returns contents of amax as a double


% --- Executes during object creation, after setting all properties.
function amax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to amax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function excentmax_Callback(hObject, eventdata, handles)
% hObject    handle to excentmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles=update_constraints(hObject,handles);
handles=disp_segment(hObject,handles);
guidata(hObject, handles);


% Hints: get(hObject,'String') returns contents of excentmax as text
%        str2double(get(hObject,'String')) returns contents of excentmax as a double


% --- Executes during object creation, after setting all properties.
function excentmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to excentmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function neurons_Callback(hObject, eventdata, handles)
% hObject    handle to neurons (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of neurons as text
%        str2double(get(hObject,'String')) returns contents of neurons as a double


% --- Executes during object creation, after setting all properties.
function neurons_CreateFcn(hObject, eventdata, handles)
% hObject    handle to neurons (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% Hint: get(hObject,'Value') returns toggle state of deleteneuron


% --- Executes on button press in delreseneuron.
function delreseneuron_Callback(hObject, eventdata, handles)
% hObject    handle to delreseneuron (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
L=handles.D.L;

while get(hObject,'Value')==1
    wneuron=handles.D.wneuron;
    k = waitforbuttonpress;
    p = get(gca,'CurrentPoint'); 
    x = ceil(p(1,2));
    y = ceil(p(1,1));
    if get(hObject,'Value')==0;
        break
    end
    if (x < size(L,1) && x >0 && y < size(L,2) && y >0)
        if L(x,y)>0
            wneuron(L(x,y))=mod((1+wneuron(L(x,y))),2);
        end
    end
    handles.D.wneuron=wneuron;
    guidata(hObject, handles);
    handles=disp_segment(hObject, handles);
end
set(hObject,'Value',0);
guidata(hObject, handles);
handles=disp_segment(hObject, handles);
guidata(hObject, handles);

% Hint: get(hObject,'Value') returns toggle state of delreseneuron


% --- Executes on button press in delregion.
function delregion_Callback(hObject, eventdata, handles)
% hObject    handle to delregion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
wneuron=handles.D.wneuron;
L=handles.D.L;
axes(handles.axesplot); title('Select Area');
wpoly=roipoly;
temp=find(wpoly==1);
indneur=unique(L(temp));
indneur=indneur(indneur>0);% indices of the neurons within the polygone
for i=1:size(indneur)
    wneuron(indneur(i))=0;%mod((1+wneuron(indneur(i))),2);
end
handles.D.wneuron=wneuron;
guidata(hObject, handles);
handles=disp_segment(hObject, handles);
set(handles.delregion,'Value',0)

% Hint: get(hObject,'Value') returns toggle state of delregion




function [handles_out]=disp_segment(hObject, handles)
% This function plot the segmented image based on the 
% current value of active neurons
im=handles.D.imagenorm;
mincentile=fix(min(im(:)));
maxcentile=fix(max(im(:))/100);
im=(im-mincentile)/(maxcentile-mincentile);


xmin=str2double(get(handles.xmin,'String'));
xmax=str2double(get(handles.xmax,'String'));
ymin=str2double(get(handles.ymin,'String'));
ymax=str2double(get(handles.ymax,'String'));
L=handles.D.L;
STATS=handles.D.STATSCOMPLET;%---------------------
mask=handles.D.mask;
wneuron=handles.D.wneuron;

Nneurons=sum(wneuron);
wnoneuron=1-wneuron;

temp=ismember(L,wnoneuron.*transpose((1:size(wneuron,1))));
% produce a matrix of size identical to L with value 1
% where the neuron is to be deleted
w= temp(:) == 1;
L(w)=0;  
L=double(L).*mask;

coloredLabels = label2rgb (L, 'hsv', 'k', 'shuffle'); % pseudo random color labe

% Fxy=rescalegd(im)/1.1; 
Fxy=im(xmin:xmax,ymin:ymax); %tb
% equalize Fxy
imcolor=zeros(size(Fxy,1),size(Fxy,2),3);
Fxy (L>0)=0;
imcolor(:,:,2)=Fxy;
Fxy (L>0)=0;
imcolor(:,:,3)=Fxy;
% Fxy(L==0)=1;%1.5*Fxy(L==0);
Fxy (L>0)=1;
imcolor(:,:,1)=Fxy;
 
halphablend = vision.AlphaBlender('Opacity',0.86);
J = step(halphablend,imcolor,double(coloredLabels));
%----------------------------------------------------------
%figure(5);
imshow(J,[0 max(J(:))],'Parent',handles.axesplot);
drawnow;
%----------------------------------------------------------

handles.D.Lcorrect=L; 
handles.D.STATS=STATS(wneuron==1);
handles.D.Nneurons=Nneurons;

set(handles.neurons,'string',int2str(Nneurons));
set(handles.axes1,'NextPlot','replacechildren');
% himage = imhandles(gca);
% delete(himage);
handles_out=handles; 
guidata(hObject, handles);
    

function [handles_out]=update_constraints(hObject, handles)
areamin=str2double(get(handles.amin,'String'));
areamax=str2double(get(handles.amax,'String'));
excentmax=str2double(get(handles.excentmax,'String'));
wneuron=handles.D.wneuron;
STATS=handles.D.STATSCOMPLET;
a=field2num(STATS,'Area');
ex=field2num(STATS,'Eccentricity');
wneuron=ones(size(a,1),1);
w=find(a>areamax | a<areamin | ex>excentmax);
wneuron(w)=0; 
w=find(a<=areamax & a>=areamin & ex<=excentmax);
wneuron(w)=1; 
disp('update constraints')
Nneurons=sum(wneuron)
handles.D.wneuron=wneuron;
handles_out=handles;
guidata(hObject, handles);

% --- Executes on button press in get_signal.
function get_signal_Callback(hObject, eventdata, handles)
% hObject    handle to get_signal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.axes1,'NextPlot','replace');
L=handles.D.L;
mask=handles.D.mask;
imref=handles.D.image;
STATS=handles.D.STATS;
wneuron=handles.D.wneuron;
cor4drift=get(handles.cor4drift,'value');
extractfluo=get(handles.extract_fluorescence,'value');
extractDFF=get(handles.extract_DFF,'value');
extractcal=get(handles.extract_calcium,'value');
cor4motionart=get(handles.cor4motionart,'value');
init=str2double(get(handles.iminit,'String'));
final=str2double(get(handles.imfinal,'String'));
steps=str2double(get(handles.imstep,'String'));
Nimages=final-init+1;
directory=get(handles.dirfile,'String');
filelist=dir([directory '*.tif']);
xmin=str2double(get(handles.xmin,'String'));
xmax=str2double(get(handles.xmax,'String'));
ymin=str2double(get(handles.ymin,'String'));
ymax=str2double(get(handles.ymax,'String'));
if cor4drift
    drift=handles.D.drift;
    dx=drift(:,1);
    dy=drift(:,2);
end
w=find(wneuron == 1);
neurons=STATS; %(w);
Nneurons=size(neurons,1);
signalmat=zeros(Nimages,Nneurons);
[xim,yim]=meshgrid(1:(ymax-ymin+1),1:(xmax-xmin+1));

% get background if extract DFF
if extractDFF
    set(handles.message,'String','Select background region');
    guidata(hObject, handles);
    imshow(rescalegd(imref));
    wpoly=roipoly;
    imshow(rescalegd(imref));
    temp=wpoly.*imref;
    Npix=size(find(wpoly==1),1);
    background=sum(temp(:))/Npix;
    handles.D.background=background;
    set(handles.message,'String','v ');
    guidata(hObject, handles);
end


% Extract fluorescence signal 
if extractfluo
    set(handles.message,'String','extracting fluorescence ...');
    pause(0.001)
    %guidata(hObject, handles);
    for t=1:Nimages;
        h=double(t/Nimages);
        mesg=hbargd(h,100,'-');
        set(handles.message,'String',['extracting fluorescence ...' mesg]);
        pause(0.001)
        %guidata(hObject, handles);
%         if mod(t,100)==0
%         disp(t)
%         end
        im=imread([directory filelist(t+init-1).name]);
        im=double(im(xmin:xmax,ymin:ymax));
        if cor4drift
            im=bilinearshift(im,dx(t),dy(t));
        end
        for i=1:Nneurons
            pixelidxlist=neurons(i).PixelIdxList;
            intens=mean(im(pixelidxlist));
            signalmat(t,i)=intens;
        end
    end
    handles.D.signal=signalmat;
    guidata(hObject, handles);
end

% Extract DF/F
if extractDFF
    set(handles.message,'String','extracting DFF ...');
    pause(0.001);
    signalmat=handles.D.signal;
    %signalmat=signalmat(init:final,:);
    Ntimes=size(signalmat,1);
    dt=handles.D.dt;
    window=fix(30/dt); % baseline is calculated for a window of 30s)
    order=fix(0.08*window);
    set(handles.message,'String','start calculating baseline...');
    pause(0.001);
    dbg =1 % tracking
    window = 63; % manual
    baseline=ordfilt2(signalmat, order, (1:window)')-background;
    baselinesm=filter(ones(1,window)/window,1,baseline);
    t1=min(fix(1.5*window), size(baselinesm,1)-1);
    ai=baselinesm(t1,:);
    bi=repmat(ai,t1,1);
    baselinesm(1:t1,:)=bi;
    af=baselinesm(Ntimes-t1,:);
    bf=repmat(af,t1,1);
    baselinesm((Ntimes-t1+1):Ntimes,:)=bf;
    dbg = 2 %tracking
    DFF=(signalmat-baselinesm-background)./baselinesm;
    
    DFF(DFF==Inf)=0;
    DFF(isnan(DFF)) = 0 ;
    DFFdisp=DFF;
    DFFdisp(find(DFF<0.02))=0;
    imshow(rescalegd(DFFdisp));
    %image(256*rescalegd(transpose(DFFdisp)));
    pause(3);
    handles.D.baseline=baselinesm;
    handles.D.DFF=DFF;
    set(handles.message,'String',['done extracting DFF. ']);
    pause(0.001);
    guidata(hObject, handles);
    disp('done')
end



if extractcal
    DFF=handles.D.DFF;
    for i=1:Nneurons
        h=i/Nneurons;
        mesg=hbargd(h,100,'-');
        set(handles.message,'String',['extracting calcium signal ...     ' mesg]);
        guidata(hObject, handles);
%         i=i;
        sig=DFF(:,i);
        sigdiff=sig;
        ntimes=size(sig,1);
        spikes=zeros(ntimes-1,1);
        sigpred=zeros(ntimes,1);
        for j=1:2
            [ spikestemp, sigpredtemp ] = analyse_calcium( sigdiff );
            sigpred=sigpred+sigpredtemp;
            sigdiff=sig-sigpred;
            spikes=spikes+spikestemp;
        end
%         subplot(3,1,1)
         plot(sig)
        hold on
        plot(sigpred,'-r')
        hold off
%         subplot(3,1,2)
%         plot(spikes)
%         hold off
%         subplot(3,1,3)
       % plot(sig-sigpred)
        ylim([0 0.5])
        pause(.1)
        spikes_raster(:,i)=spikes;
    end
    handles.D.calcium=spikes_raster;
    set(handles.message,'String',['done extracting calcium signal.']);
    pause(1)
    guidata(hObject, handles);
end


if cor4motionart
    handles=correct4motionartefacts(hObject, handles, 20, 1);
    DFFcor=handles.D.DFFcor;
    imshow(DFFcor)
    guidata(hObject, handles);
end


guidata(hObject, handles);
set(hObject,'Value',0);


 



% Hint: get(hObject,'Value') returns toggle state of get_signal


% --- Executes during object creation, after setting all properties.
function get_signal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to get_signal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function savedir_Callback(hObject, eventdata, handles)
% hObject    handle to savedir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of savedir as text
%        str2double(get(hObject,'String')) returns contents of savedir as a double


% --- Executes during object creation, after setting all properties.
function savedir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to savedir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
savedir=get(handles.savedir,'String');
%STATS=handles.D.STATS;
%wneuron=handles.D.wneuron;
Nneurons=str2double(get(handles.neurons,'String'));
handles.D.Nneurons=Nneurons;
handles.D.directory=get(handles.dirfile,'String');
%D=handles.D;
if ~exist(savedir, 'dir')
    mkdir(savedir)
end
save([savedir 'D.mat'],'D','-v7.3');
set(handles.message,'String',['data saved in ' savedir 'D.mat']);
set(hObject,'Value',0);

% Hint: get(hObject,'Value') returns toggle state of save


% --- Executes on button press in Load_data.
function Load_data_Callback(hObject, eventdata, handles)
% hObject    handle to Load_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
savedir=get(handles.savedir,'String');
load([savedir 'D.mat']);
handles.D=D;
ROI=D.ROI;
range=D.range;
Nimages=range(3)-range(1)+1;
set(handles.xmin,'String',int2str(ROI(1)));
set(handles.xmax,'String',int2str(ROI(2)));
set(handles.ymin,'String',int2str(ROI(3)));
set(handles.ymax,'String',int2str(ROI(4)));
set(handles.neurons,'String',int2str(D.Nneurons));
set(handles.dirfile,'String',D.directory);
set(handles.iminit,'String',int2str(range(1)));
set(handles.imfinal,'String',int2str(range(3)));
set(handles.imstep,'String',int2str(range(2)));
set(handles.Nfiles,'String',int2str(Nimages));
im=D.image;
xmin=ROI(1);xmax=ROI(2); ymin=ROI(3); ymax=ROI(4); 
imshow(rescalegd(im(xmin:xmax,ymin:ymax)));
guidata(hObject, handles);
set(hObject,'Value',0);

% Hint: get(hObject,'Value') returns toggle state of Load_data


% --- Executes on button press in get_calcium.
function get_calcium_Callback(hObject, eventdata, handles)
% hObject    handle to get_calcium (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of get_calcium


% --- Executes on button press in cor4motionart.
function cor4motionart_Callback(hObject, eventdata, handles) %#ok<*INUSD>
% hObject    handle to cor4motionart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cor4motionart


% --- Executes on button press in extract_calcium.
function extract_calcium_Callback(hObject, eventdata, handles)
% hObject    handle to extract_calcium (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of extract_calcium


% --- Executes on button press in extract_DFF.
function extract_DFF_Callback(hObject, eventdata, handles)
% hObject    handle to extract_DFF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of extract_DFF


% --- Executes on button press in extract_fluorescence.
function extract_fluorescence_Callback(hObject, eventdata, handles)
% hObject    handle to extract_fluorescence (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of extract_fluorescence



function message_Callback(hObject, eventdata, handles)
% hObject    handle to message (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of message as text
%        str2double(get(hObject,'String')) returns contents of message as a double


% --- Executes during object creation, after setting all properties.
function message_CreateFcn(hObject, eventdata, handles)
% hObject    handle to message (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function [handles_out]=correct4motionartefacts(hObject, handles, window, thresh)
%window=200;
%thresh=0.2;
drift=handles.D.drift;
DFF=handles.D.DFF;
Ntimes=size(drift,1);
a=diff(drift(:,1)).^2+diff(drift(:,2)).^2;
w=find(a >thresh);
s=zeros(Ntimes,1);
s(w)=1;
filt=ones((2*window+1),1);
filt(1:window-5)=0;
s2=imdilate(s,filt);
w2=find(s2>0);
size(w2)
DFFcor=DFF;
m=median(DFF,1);
plot(1-s);
ylim([-0.5 1.5]);
pause(3)
DFFcor(w2,:)=repmat(m,size(w2));
handles.D.cor4motion=1-s;
handles.D.DFFcor=DFFcor;
handles_out=handles;


% --- Executes on button press in loadimages.
function loadimages_Callback(hObject, eventdata, handles) %#ok<*DEFNU>
% hObject    handle to loadimages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of loadimages
dirfile_Callback(hObject, eventdata, handles);

handles=guidata(handles.output);%important to load new handels in
guidata(handles.output);


% --- Executes on button press in adjustcontrast.
function adjustcontrast_Callback(hObject, eventdata, handles)
% hObject    handle to adjustcontrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of adjustcontrast
handles=guidata(handles.output);
himaxes = findobj(gca,'Type','image');
% hi = imhandles(gcf);%
imcontrast(himaxes);
handles=guidata(handles.output);
guidata(hObject, handles);


% --- Executes on button press in runtimeseries.
function runtimeseries_Callback(hObject, eventdata, handles)
% hObject    handle to runtimeseries (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=guidata(handles.output);
himageall = imhandles(gcf);
delete(himageall);

elapsedTime=runtimeseries(hObject, eventdata, handles) ;
handles=guidata(handles.output);


duration=num2str(elapsedTime);
stringtime=strcat('took___ ',duration,'  :  sec');
set(handles.message,'String',stringtime);

guidata(hObject, handles);


% --- Executes on button press in writeaverage.
function writeaverage_Callback(hObject, eventdata, handles)
% hObject    handle to writeaverage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of writeaverage


% --- Executes on button press in changeimarray.
function changeimarray_Callback(hObject, eventdata, handles)
% hObject    handle to changeimarray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of changeimarray



function pixkernel_Callback(hObject, eventdata, handles)
% hObject    handle to pixkernel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pixkernel as text
%        str2double(get(hObject,'String')) returns contents of pixkernel as a double


% --- Executes during object creation, after setting all properties.
function pixkernel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pixkernel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in clusterTB.
function clusterTB_Callback(hObject, eventdata, handles)
% hObject    handle to clusterTB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles=guidata(handles.output);
kClusteringTB(hObject, eventdata, handles);

guidata(hObject, handles);


function numbercluster_Callback(hObject, eventdata, handles)
% hObject    handle to numbercluster (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numbercluster as text
%        str2double(get(hObject,'String')) returns contents of numbercluster as a double


% --- Executes during object creation, after setting all properties.
function numbercluster_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numbercluster (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function FrameRate_Callback(hObject, eventdata, handles)
% hObject    handle to FrameRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FrameRate as text
%        str2double(get(hObject,'String')) returns contents of FrameRate as a double


% --- Executes during object creation, after setting all properties.
function FrameRate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FrameRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% START of execute scrips from 2009 paper----------------------------------
% --- Executes on button press in PCA.
function PCA_Callback(hObject, eventdata, handles)
% hObject    handle to PCA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=guidata(handles.output);
changeimarray=get(handles.changeimarray,'value');
cor4drift=get(handles.cor4drift,'value');

set(handles.message,'String','PCA ');drawnow;

if changeimarray            
            newfilename='seq_calcium';
            if cor4drift
                   diffile=strcat('Dif_',newfilename,'.tif');
            else
                   diffile=strcat('Origin_',newfilename,'.tif');
            end  
end
savedir=get(handles.savedir,'String');
fn=[savedir diffile] ;
FlimStart=str2double(get(handles.FlimStart,'String'));
FlimEnd=str2double(get(handles.FrameEnd,'String'));
flims=[FlimStart FlimEnd];%TB change to indicate, '' empty all images;% - optional two-element vector of frame limits to be read

%flims=[1 200];
nPCs='';%60;%as in choose pc TB needs to be added to GUI
dsamp='';
outputdir=savedir;
badframes='';
[ mixedsig, mixedfilters, CovEvals, covtrace, movm, ...
    movtm,fnmat]=CellsortPCA(fn, flims, nPCs, dsamp, outputdir, badframes); 

set(handles.Databname,'string',fnmat);
set(handles.message,'String','End: PCA ');drawnow;
% Hint: get(hObject,'Value') returns toggle state of PCA
guidata(hObject, handles);


% --- Executes on button press in chosePC.
function chosePC_Callback(hObject, eventdata, handles)
% hObject    handle to chosePC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=guidata(handles.output);
changeimarray=get(handles.changeimarray,'value');
cor4drift=get(handles.cor4drift,'value');

set(handles.message,'String','chosePC ');drawnow;

if changeimarray            
            newfilename='seq_calcium';
            if cor4drift
                   diffile=strcat('Dif_',newfilename,'.tif');
            else
                   diffile=strcat('Origin_',newfilename,'.tif');
            end  
end
savedir=get(handles.savedir,'String');
fn=[savedir diffile] ;
% PCdatabase=strcat('Dif_seq_calcium_1,200_01-Apr-2015','.mat');
% PCdatabaseloc=[savedir PCdatabase];
PCdatabaseloc=get(handles.Databname,'string');
load(PCdatabaseloc, 'mixedfilters');
PCuse=CellsortChoosePCs(fn, mixedfilters,handles);
handles.D.PCuse=PCuse;
% Hint: get(hObject,'Value') returns toggle state of chosePC
guidata(hObject, handles);


% --- Executes on button press in PlotPC.
function PlotPC_Callback(hObject, eventdata, handles)
% hObject    handle to PlotPC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=guidata(handles.output);
changeimarray=get(handles.changeimarray,'value');
cor4drift=get(handles.cor4drift,'value');
set(handles.message,'String',' PlotPC ');drawnow;

if changeimarray            
            newfilename='seq_calcium';
            if cor4drift
                   diffile=strcat('Dif_',newfilename,'.tif');
            else
                   diffile=strcat('Origin_',newfilename,'.tif');
            end  
end
savedir=get(handles.savedir,'String');
fn=[savedir diffile] ;
% PCdatabase=strcat('Dif_seq_calcium_1,200_01-Apr-2015','.mat');
% PCdatabaseloc=[savedir PCdatabase];
PCdatabaseloc=get(handles.Databname,'string');

load(PCdatabaseloc, 'CovEvals');
PCuse=handles.D.PCuse;

CellsortPlotPCspectrum(fn, CovEvals, PCuse);

% Hint: get(hObject,'Value') returns toggle state of chosePC
guidata(hObject, handles);


% --- Executes on button press in CellsortICA.
function CellsortICA_Callback(hObject, eventdata, handles)
% hObject    handle to CellsortICA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=guidata(handles.output);
changeimarray=get(handles.changeimarray,'value');
cor4drift=get(handles.cor4drift,'value');
set(handles.message,'String',' CellsortICA ');drawnow;

if changeimarray            
            newfilename='seq_calcium';
            if cor4drift
                   diffile=strcat('Dif_',newfilename,'.tif');
            else
                   diffile=strcat('Origin_',newfilename,'.tif');
            end  
end
% savedir=get(handles.savedir,'String');
% fn=[savedir diffile] ;
% PCdatabase=strcat('Dif_seq_calcium_1,200_01-Apr-2015','.mat');%database file
% PCdatabaseloc=[savedir PCdatabase];
PCdatabaseloc=get(handles.Databname,'string');
load(PCdatabaseloc, 'mixedsig','mixedfilters','CovEvals');

PCuse=handles.D.PCuse;
mu=0;
nIC=length(PCuse);%nIC must be same or smaller PCuse
ica_A_guess='';%if empty uses presets
termtol='';%if empty uses presets
maxrounds=100;

[ica_sig, ica_filters, ica_A, numiter] = CellsortICA(mixedsig, ...
    mixedfilters, CovEvals, PCuse, mu, nIC, ica_A_guess, termtol, maxrounds);
save(PCdatabaseloc,'ica_sig','ica_filters','ica_A', ...
    'numiter','PCuse','-append');
fprintf(' CellsortICA: saving appended data ; ');

set(handles.message,'String',' End: CellsortICA ');drawnow;
% Hint: get(hObject,'Value') returns toggle state of chosePC
guidata(hObject, handles);


% --- Executes on button press in CellsortICAplot.
function CellsortICAplot_Callback(hObject, eventdata, handles)
% hObject    handle to CellsortICAplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=guidata(handles.output);
changeimarray=get(handles.changeimarray,'value');
cor4drift=get(handles.cor4drift,'value');
set(handles.message,'String',' CellsortICAplot ');drawnow;

if changeimarray            
            newfilename='seq_calcium';
            if cor4drift
                   diffile=strcat('Dif_',newfilename,'.tif');
            else
                   diffile=strcat('Origin_',newfilename,'.tif');
            end  
end
% savedir=get(handles.savedir,'String');
% fn=[savedir diffile] ;
% PCdatabase=strcat('Dif_seq_calcium_1,200_01-Apr-2015','.mat');
PCdatabaseloc=get(handles.Databname,'string');

% PCdatabaseloc=[savedir PCdatabase];
load(PCdatabaseloc, 'ica_sig','ica_filters','movm');
%load(PCdatabaseloc, 'ica_filters');
mode='series'; %or'contours'
spt=4; spc=4;
f0=movm; %or handles.D.image;%average image
tlims='';%will be calculated
dt=str2double(get(handles.dt,'String'));%dt=30;%time step what unit TB?
ratebin=10;%tb ? bin to calculate spikes
plottype=str2double(get(handles.PlotType,'String'));%tb '' empty is 1
%plottype = 1: plot cellular signals
 %         plottype = 2: plot cellular signals together with spikes
 %         plottype = 3: plot spikes only
 %         plottype = 4: plot spike rate over time

ICuse='';%calculated TB
CellsortICAplot(mode, ica_filters, ica_sig, f0, tlims, dt, ratebin, plottype, ICuse, spt, spc);
set(handles.message,'String',' End: choose plot type');drawnow;
% Hint: get(hObject,'Value') returns toggle state of chosePC
guidata(hObject, handles);


% --- Executes on button press in CellsortSegmentation.
function CellsortSegmentation_Callback(hObject, eventdata, handles)
% hObject    handle to CellsortSegmentation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=guidata(handles.output);
changeimarray=get(handles.changeimarray,'value');
cor4drift=get(handles.cor4drift,'value');
set(handles.message,'String',' CellsortSegmentation ');drawnow;

if changeimarray            
            newfilename='seq_calcium';
            if cor4drift
                   diffile=strcat('Dif_',newfilename,'.tif');
            else
                   diffile=strcat('Origin_',newfilename,'.tif');
            end  
end
% PCdatabase=strcat('Dif_seq_calcium_1,200_01-Apr-2015','.mat');
% 
% PCdatabaseloc=[savedir PCdatabase];
PCdatabaseloc=get(handles.Databname,'string');

load(PCdatabaseloc, 'ica_filters');
%load(PCdatabaseloc, 'ica_filters');
 smwidth=1;%2 15012020 TB ? /standard deviation of Gaussian smoothing kernel (pixels)
 thresh='';%TB Thresh 1 finds many default 2 /threshold for spatial filters (standard deviations)
 arealims='';%tb calculated / 2-element vector specifying the minimum and maximum area
%      (in pixels) of segments to be retained; if only one element is
%      specified, use this as the minimum area
 plotting=1;%tb default 0, no/  [0,1] whether or not to show filters

[ica_segments, segmentlabel, segcentroid] = CellsortSegmentation(ica_filters, smwidth, thresh, arealims, plotting);

save(PCdatabaseloc,'ica_segments','segmentlabel','segcentroid', ...
    '-append');
fprintf(' CellsortSegmentation: saving appended data ; ');
set(handles.message,'String',' End: CellsortSegmentation');drawnow;
% Hint: get(hObject,'Value') returns toggle state of chosePC
guidata(hObject, handles);


% --- Executes on button press in CellsortApplyFilter.
function CellsortApplyFilter_Callback(hObject, eventdata, handles)
% hObject    handle to CellsortApplyFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=guidata(handles.output);
changeimarray=get(handles.changeimarray,'value');
cor4drift=get(handles.cor4drift,'value');
set(handles.message,'String',' CellsortApplyFilter :flims=[1 200]');drawnow;

if changeimarray            
            newfilename='seq_calcium';
            if cor4drift
                   diffile=strcat('Dif_',newfilename,'.tif');
            else
                   diffile=strcat('Origin_',newfilename,'.tif');
            end  
end
savedir=get(handles.savedir,'String');
fn=[savedir diffile] ;
% PCdatabase=strcat('Dif_seq_calcium_1,200_01-Apr-2015','.mat');
% PCdatabaseloc=[savedir PCdatabase];
PCdatabaseloc=get(handles.Databname,'string');

load(PCdatabaseloc, 'ica_segments','movm');
FlimStart=str2double(get(handles.FlimStart,'String'));
FlimEnd=str2double(get(handles.FrameEnd,'String'));
flims=[FlimStart FlimEnd];%TB change to indicate, '' empty all images;% - optional two-element vector of frame limits to be read

subtractmean='';% default 1 /- boolean specifying whether or not to subtract the mean
 %     fluorescence of each time frame

cell_sig = CellsortApplyFilter(fn, ica_segments, flims, movm, subtractmean);
save(PCdatabaseloc,'cell_sig','-append');

    scrsz = get(0,'ScreenSize');%TB to replot in same figure
    hICSegments = findobj('type', 'figure', 'Name','Signals per ROI');    
    if  ishandle(hICSegments)
        set(0, 'currentfigure', hICSegments);
        figure(hICSegments);clf;
    else
        figure('Name','Signals per ROI','Position',[scrsz(3)/50 scrsz(4)/5 scrsz(3)/1.06 scrsz(4)/1.5],'NumberTitle','off');
        %figure('Name','IC and Segements','Position',[scrsz(3)/50 scrsz(4)/5 scrsz(3)/1 scrsz(4)/1])
        hICSegments = findobj('type', 'figure', 'Name','Signals per ROI'); 
    end


    plot(cell_sig','DisplayName','cell_sig');% transpose for array
    hold off;
    legend('show','Location','bestoutside');%TB
    legend('boxoff');
    

fprintf(' CellsortApplyFilter: saving appended data ; ');
set(handles.message,'String','FINISHED: CellsortApplyFilter');drawnow;
% Hint: get(hObject,'Value') returns toggle state of chosePC
guidata(hObject, handles);


% --- Executes on button press in CellsortFindspikes.
function CellsortFindspikes_Callback(hObject, eventdata, handles)
% hObject    handle to CellsortFindspikes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=guidata(handles.output);
changeimarray=get(handles.changeimarray,'value');
cor4drift=get(handles.cor4drift,'value');
set(handles.message,'String','  CellsortFindspikes');drawnow;

if changeimarray            
            newfilename='seq_calcium';
            if cor4drift
                   diffile=strcat('Dif_',newfilename,'.tif');
            else
                   diffile=strcat('Origin_',newfilename,'.tif');
            end  
end
% savedir=get(handles.savedir,'String');
% fn=[savedir diffile] ;
% PCdatabase=strcat('Dif_seq_calcium_1,200_01-Apr-2015','.mat');
% PCdatabaseloc=[savedir PCdatabase];
PCdatabaseloc=get(handles.Databname,'string');

load(PCdatabaseloc, 'ica_sig','ica_segments');
dt=str2double(get(handles.dt,'String'));%dt=30;%time step what unit TB?
thresh=1;
deconvtau=0;%time constant for temporal deconvolution (Butterworth
%   filter); if deconvtau=0 or [], no deconvolution is performed
normalization=0;%0  Absolute units/ 1  Standard-deviation
        
[spmat, spt, spc] = CellsortFindspikes(ica_sig, thresh, dt, deconvtau, normalization);


set(handles.message,'String','  CellsortFindspikes: saving appended data ');drawnow;
save(PCdatabaseloc,'spmat','spt','spc','-append');
set(handles.message,'String',' End: CellsortFindspikes');drawnow;
% Hint: get(hObject,'Value') returns toggle state of chosePC
guidata(hObject, handles);



function dt_Callback(hObject, eventdata, handles)
% hObject    handle to dt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dt as text
%        str2double(get(hObject,'String')) returns contents of dt as a double


% --- Executes during object creation, after setting all properties.
function dt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function FlimStart_Callback(hObject, eventdata, handles)
% hObject    handle to FlimStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FlimStart as text
%        str2double(get(hObject,'String')) returns contents of FlimStart as a double


% --- Executes during object creation, after setting all properties.
function FlimStart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FlimStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function FrameEnd_Callback(hObject, eventdata, handles)
% hObject    handle to FrameEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FrameEnd as text
%        str2double(get(hObject,'String')) returns contents of FrameEnd as a double


% --- Executes during object creation, after setting all properties.
function FrameEnd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FrameEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PlotType_Callback(hObject, eventdata, handles)
% hObject    handle to PlotType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PlotType as text
%        str2double(get(hObject,'String')) returns contents of PlotType as a double


% --- Executes during object creation, after setting all properties.
function PlotType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PlotType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Databname_Callback(hObject, eventdata, handles)
% hObject    handle to Databname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Databname as text
%        str2double(get(hObject,'String')) returns contents of Databname as a double


% --- Executes during object creation, after setting all properties.
function Databname_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Databname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
