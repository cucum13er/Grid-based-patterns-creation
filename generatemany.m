% generate training data
%% setting some parameters 
clear;
clc;
close all;
% addpath('C:\Rui_Onedrive\OneDrive\2019Fall\project\superregistration');
image_size = 400;
pt_size = 20;
gap_x = 20;
gap_y = 20;
movefactor = 10;
distortion_factor = 1
distorted_perkind = 10;
base_path = '.\simulationData\';
if ~exist(base_path,'dir')
    mkdir(base_path);
end
pt_kinds = ["square","circle","hexagon"];
distortion_factor = "10";
%% loop for generating
for p = 1:length(pt_kinds)
    % generate undistorted images for each kind of pattern
    % image = drawGrid_multi(image_size, pt_kind, pt_size, gap_x, gap_y);
    % pt_kinds(p)
    [image, pt_pos, pt_kind, pt_size] = drawGrid_multi(image_size, pt_kinds(p), pt_size, gap_x, gap_y);
    % save undistorted image
    image_name = sprintf('%s_%s.tif', pt_kind,'undistorted');
    save_path = fullfile(base_path,pt_kind+distortion_factor);
    if ~exist(save_path,'dir')
        mkdir(save_path);
    end
    imwrite(image, fullfile(save_path,image_name));    
    for i = 1:distorted_perkind
        % change the distortion factor 
        warpFactor = distortion_factor * [10*pi/360, 0.1, 0.05]; % [5*pi/360, 0.1, 0.05]
        [Im, centers] = warpedImage_factor(image, pt_kind, pt_pos, pt_size, gap_x, gap_y, warpFactor,movefactor);
        % save each distorted image    
        image_name = sprintf('%s_%04d.tif', pt_kind,i);
        center_name = sprintf('%s_%04d.mat', pt_kind,i);
        save_path = fullfile(base_path,pt_kind+distortion_factor);
        if ~exist(save_path,'dir')
            mkdir(save_path);
        end
        imwrite(Im, fullfile(save_path, image_name));
        save(fullfile(save_path, center_name),'centers');
    end
end


