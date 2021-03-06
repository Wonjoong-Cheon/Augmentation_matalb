%%
%  Dicom -> ROI cropping -> Augmentation (flip(l,r,u,d),rotate(+,-45
%  degree) -> PNG
%
%  1 image will be 8 image
%


clc
clear
close all

%% SET PARAMETERS



%%
% Select the folder containning dicom files
folder_dir = uigetdir('Select a folder!');
folders = dir(fullfile(folder_dir));
addpath(folder_dir);

folders(1:2,:) = [];

Label_Png = {'Augmentation'};

for iter3 = 1:size(Label_Png,2)
    New_folder_name_png = [folder_dir '\' Label_Png{1,iter3}];
    mkdir(New_folder_name_png);
end

%%
circles = zeros(size(folders,1),4);
index_front = 1;
index_back = 1;
flag = true;
for iter1 = 1:20
        DicomImgName = [folder_dir '\' folders(iter1).name];
        DicomImg = dicomread(DicomImgName);
        DicomImg_gray = rgb2gray(DicomImg);
        DicomImg_gray_boolian = DicomImg_gray<50;
        circles_buffer = houghcircles(DicomImg_gray_boolian, 1600, 1650);
        circles_buffer_sz = size(circles_buffer,1);
        if flag 
            circles(iter1:circles_buffer_sz,1:4) = houghcircles(DicomImg_gray_boolian, 1600, 1650);
            index_back = circles_buffer_sz;
            flag = false;
        else
            circles(index_back+1:index_back+circles_buffer_sz-1,1:4) = houghcircles(DicomImg_gray_boolian, 1600, 1650);
            index_back = index_back+circles_buffer_sz-1;
        end
        
        clear DicomImgName DicomImg DicomImg_gray DicomImg_gray_boolian
end













