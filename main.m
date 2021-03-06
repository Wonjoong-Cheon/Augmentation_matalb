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
DicomImgDimension = [3456 5184];
centers = [2592 1758];
radius = 1650;
% half_length_rentangle = radius*0.9;
% half_length_rentangle = radius/sqrt(2);
half_length_rentangle = radius;
croping_rect = [centers(1)-half_length_rentangle, centers(2)-half_length_rentangle,...
    half_length_rentangle*2, half_length_rentangle*2];
    
    

%%
% Select the folder containning dicom files
folder_dir = uigetdir('Select a folder!');
folders = dir(fullfile(folder_dir));
addpath(folder_dir);

folders(1:2,:) = [];

Label_Png = {'Augmentation'}

for iter3 = 1:size(Label_Png,2)
    New_folder_name_png = [folder_dir '\' Label_Png{1,iter3}];
    mkdir(New_folder_name_png);
end

%%

waitbar_maxsz = (size(folders,1));
h = waitbar(0,'Please wait...');
for iter1 = 1:size(folders,1)
    if ~folders(iter1).isdir
        a=0;
        DicomImgName = [folder_dir '\' folders(iter1).name];
        DicomImg = dicomread(DicomImgName);
        DicomImg_croped = imcrop(DicomImg,croping_rect);
        
        DicomImg_croped_r_d = DicomImg_croped;
        DicomImg_croped_r_d_rplus = imrotate(DicomImg_croped_r_d,45,'crop');
        DicomImg_croped_r_d_rminus= imrotate(DicomImg_croped_r_d,-45,'crop');
        
        DicomImg_croped_l = fliplr(DicomImg_croped);
        DicomImg_croped_l_d = flipud(DicomImg_croped_l);
        DicomImg_croped_l_d_rplus = imrotate(DicomImg_croped_l_d,45,'crop');
        DicomImg_croped_l_d_rminus= imrotate(DicomImg_croped_l_d,-45,'crop');
        
        %
        PngTarget_dir = [folder_dir ,'\', Label_Png{1}];
        Pngfile_name_r = [folders(iter1).name(1:end-4), '_r', '.png'];
        Pngfile_name_r_d = [folders(iter1).name(1:end-4), '_r_d', '.png'];
        Pngfile_name_r_d_rplus = [folders(iter1).name(1:end-4), '_r_d_rplus', '.png'];
        Pngfile_name_r_d_rminus = [folders(iter1).name(1:end-4), '_r_d_rminus', '.png'];
        
        Pngfile_name_l = [folders(iter1).name(1:end-4), '_l', '.png'];
        Pngfile_name_l_d = [folders(iter1).name(1:end-4), '_l_d', '.png'];
        Pngfile_name_l_d_rplus = [folders(iter1).name(1:end-4), '_l_d_rplus', '.png'];
        Pngfile_name_l_d_rminus = [folders(iter1).name(1:end-4), '_l_d_rminus', '.png'];
       
        imwrite(DicomImg_croped,fullfile(PngTarget_dir,Pngfile_name_r),'png');
        imwrite(DicomImg_croped_r_d,fullfile(PngTarget_dir,Pngfile_name_r_d),'png');
        imwrite(DicomImg_croped_r_d_rplus,fullfile(PngTarget_dir,Pngfile_name_r_d_rplus),'png');
        imwrite(DicomImg_croped_r_d_rminus,fullfile(PngTarget_dir,Pngfile_name_r_d_rminus),'png');
        
        imwrite(DicomImg_croped_l,fullfile(PngTarget_dir,Pngfile_name_l),'png');
        imwrite(DicomImg_croped_l_d,fullfile(PngTarget_dir,Pngfile_name_l_d),'png');
        imwrite(DicomImg_croped_l_d_rplus,fullfile(PngTarget_dir,Pngfile_name_l_d_rplus),'png');
        imwrite(DicomImg_croped_l_d_rminus,fullfile(PngTarget_dir,Pngfile_name_l_d_rminus),'png');
        
    end
    disp(iter1)
    waitbar(iter1/waitbar_maxsz)
end
close(h)
