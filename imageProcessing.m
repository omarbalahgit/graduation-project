folder=fullfile('new image');
elll={'DR'};
imds=imageDatastore(fullfile(folder,elll),'labelSource','foldernames');
numberofimage=length(imds.Files);
for k= 1:numberofimage
    inputfileImage=imds.Files{k};
    img=imread(inputfileImage);

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
imshow(filterImg);
title('filter image')
substractedImage=imsubtract(filterImg,enhancedImg);
 level=Threshold_Level(substractedImage);
BinaryImg=im2bw(substractedImage,level-0.008);
;
 claen_image1=bwareaopen(BinaryImg,10);
 %save matlabtest.mat
gray_image=mat2gray(claen_image1);
    
img1=strcat('D:\object\new image\test\DB-img',num2str(k));
img=strcat(img1,'.png');
imwrite(gray_image,img);
    
    
end