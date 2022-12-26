function varargout = testCnnAndImageProsesing(varargin)
% TESTCNNANDIMAGEPROSESING MATLAB code for testCnnAndImageProsesing.fig
%      TESTCNNANDIMAGEPROSESING, by itself, creates a new TESTCNNANDIMAGEPROSESING or raises the existing
%      singleton*.
%
%      H = TESTCNNANDIMAGEPROSESING returns the handle to a new TESTCNNANDIMAGEPROSESING or the handle to
%      the existing singleton*.
%
%      TESTCNNANDIMAGEPROSESING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TESTCNNANDIMAGEPROSESING.M with the given input arguments.
%
%      TESTCNNANDIMAGEPROSESING('Property','Value',...) creates a new TESTCNNANDIMAGEPROSESING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before testCnnAndImageProsesing_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to testCnnAndImageProsesing_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help testCnnAndImageProsesing

% Last Modified by GUIDE v2.5 06-Dec-2021 09:08:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @testCnnAndImageProsesing_OpeningFcn, ...
                   'gui_OutputFcn',  @testCnnAndImageProsesing_OutputFcn, ...
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


% --- Executes just before testCnnAndImageProsesing is made visible.
function testCnnAndImageProsesing_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to testCnnAndImageProsesing (see VARARGIN)

% Choose default command line output for testCnnAndImageProsesing
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes testCnnAndImageProsesing wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = testCnnAndImageProsesing_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure
axes(handles.image);
global name;
global path;
[name, path] = uigetfile('*.png','enter image');
global img;
img=imread(fullfile(path,name));
image(img);
   set(handles.reuslt,'String','');




% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global img;
global name;
global path;
img=imread(fullfile(path,name));

converImg=im2double(img);
labImg=rgb2lab(converImg);
fill=cat(3,1,0,0);
fillImg=bsxfun(@times,fill,labImg);
reshepedLabImg=reshape(fillImg,[],3);
[c,s]=pca(reshepedLabImg);
s=reshape(s,size(labImg));
s=s(:,:,1);
grayImg=(s-min(s(:)))./(max(s(:))-min(s(:)));
enhancedImg=adapthisteq(grayImg,'numTiles',[8 8],'nBins',128);
avgFilter=fspecial('average',[9 9]);
filterImg=imfilter(enhancedImg,avgFilter);

% axes(handles.filter);
% image(filterImg);
% imshow(filterImg);
% title('filter image')
substractedImage=imsubtract(filterImg,enhancedImg);
 level=Threshold_Level(substractedImage);
BinaryImg=im2bw(substractedImage,level-0.008);
% axes(handles.binary);
% imshow(BinaryImg);
% image(BinaryImg);
global gray_image;
 claen_image1=bwareaopen(BinaryImg,10);
%  save matlabtest.mat
gray_image=mat2gray(claen_image1);

img1=strcat('D:\object\new image\test\DB-img',num2str(3));
img=strcat(img1,'.png');
imwrite(gray_image,img);

msgbox('Susccessfully Processed')
% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


load('matlab5.mat','net','featureLayer','classifier');


rootFolder=fullfile('new image');
categories={'test'};
imds=imageDatastore(fullfile(rootFolder,categories),'labelSource','foldernames');


imgfeature=activations(net,imds,featureLayer,'miniBatchSize',32,'outputAs','columns');
labelimg=predict(classifier,imgfeature,'observationsIn','columns');

reuslt={'No_DR'};
reuslt=categorical(reuslt);
 if (labelimg==reuslt)
     set(handles.reuslt,'String','No_DR');
 else
   set(handles.reuslt,'String','Yes');
 end
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close