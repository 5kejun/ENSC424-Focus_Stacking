%Clear everything from previous Matlab runs
clear all; close all; clc;
 
%Total images in focal stack
numImage=53;
 
%Number of the first image for the stack
numStart=0000;
 
%Path and start of filename
imgPath='C:\Users\Kurtis\Desktop\IMG_';
 
%Dilation parameters 
DilateImage=0; %Dilate  Enable (0=off)
dBallSize=16; %Size of dilation ball in pixels
 
%Stack blur parameters
BlurStack=0; %Blur Enable (0=off)
BlurSize=3; %Size of blur
 
%---------------------------------------------------------------
 
%Load images into memory
numStart=numStart-1;
ImageArray=cell(1,numImage); %Image array
ImageArrayBW=cell(1,numImage); %Image array for the black/white filtered
for i=1:numImage
    disp(strcat('Loading Image Num ',num2str(i),'/',num2str(numImage)));
    ImageArray{i}=imread(strcat(imgPath,num2str(numStart+i),'.jpg'));
end
 
%adjust image brightnesses to make all the same so filters apply properly
b1 = mean2(rgb2gray(ImageArray{1}));
for i=2:numImage
    b2 = mean2(rgb2gray(ImageArray{i}));
    ImageArray{i} = ImageArray{i} + (b1-b2);
end
 
%run edge detection on loaded images
for i=1:numImage
    disp(strcat('Edge Detecting Image Num ',num2str(i),'/',num2str(numImage)));
    
    Temp = conv2(double(ImageArray{i}(:,:,1))+double(ImageArray{i}(:,:,2))+double(ImageArray{i}(:,:,3)),fspecial('gaussian'),'same');
    ImageArrayBW{i} = conv2(Temp,fspecial('laplacian'),'same');
    ImageArrayBW{i} = abs(ImageArrayBW{i});
    
    figure(1); imshow(ImageArrayBW{i}); title('Laplacian Edge Detection');
    
    %do a dilate if output is grainy
    if (DilateImage==1)
        se = strel('ball',dBallSize,dBallSize);
        ImageArrayBW{i} = imdilate(ImageArrayBW{i},se,'same');
    end
end
 
%combine areas of highest sharpness
SizeS = size(ImageArrayBW{i});
Stack = ones(SizeS);
StackVal = zeros(SizeS);
for i=1:numImage
    disp(strcat('Stacking Image Num',num2str(i),'/',num2str(numImage)));
 
    for j=1:SizeS(1)
        for k=1:SizeS(2)
            if (ImageArrayBW{i}(j,k)>StackVal(j,k))
                StackVal(j,k)=ImageArrayBW{i}(j,k);
                Stack(j,k)=i;
            end
        end
    end
end
 
%blur final image if output is too sharp
if (BlurStack==1)
    Stack=conv2(Stack,fspecial('gaussian', [BlurSize BlurSize], 10),'same');
end
 
%get corresponding RGB value from selected sharp images
SharpImg=ImageArray{1};
SizeI=size(ImageArray{1});
for j=1:SizeI(1)
    for k=1:SizeI(2)
        Index=uint16(Stack(j,k));
        if (Index<1)
            Index=1;
        end
        if (Index>numImage)
            Index=numImage;
        end
        SharpImg(j,k,:)=ImageArray{Index}(j,k,:);
    end
end
 
%display and save final image
figure(2); imagesc(SharpImg); title('Final'); figure(gcf);
imwrite(SharpImg,'OutSharp.bmp');