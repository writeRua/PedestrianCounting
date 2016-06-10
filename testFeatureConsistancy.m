clear; clc; close all;
addpath('../');
addpath('../Feature extraction code');
clear('opt');
clear('path');

Pedes_number = 'f';
dataset_path = '../../ucsd_original/';

% optional parameters
opt.min_blob = 10;
opt.num_frame = 200;        % number of images in each video clip
opt.fea_only_roi = 1;       % extract features from ROI
opt.gt_boundary_count = 1;
opt.gt_only_roi_count = 1;
opt.gt_nodirection_count = 1;
opt.isoutput = 1;
opt.max_blob_index = 0;
opt.frame_index = 0;

FeatureName = {'Area', 'Perimeter', 'PerimeterEdgeOrientation', 'Ratio', ...
    'Edge', 'EdgeOrientation', 'FractalDim', 'GLCM'};

tic

% dataset path
path.dmap_path = [dataset_path sprintf('ucsdpeds_gt/vid%s/dmap3.mat',Pedes_number)];
if strcmp(Pedes_number, 'f')
    path.roi_path = [dataset_path sprintf('ucsdpeds_gt/vid%s/roi_mainwalkway.mat',Pedes_number)];
else
    path.roi_path = [dataset_path sprintf('ucsdpeds_gt/vid%s/vid%s1_33_roi.mat',Pedes_number, Pedes_number)];
end

Feature = [];
TC = [];
SC = [];

for par_dir=1:20
    dir = int32(par_dir - 1);
    path.groundtruth_path = [dataset_path sprintf('ucsdpeds_gt/vid%s/%02d_frame_full.mat',Pedes_number, dir)];
    path.origin_image_dir = [dataset_path sprintf('ucsdpeds_vid%s/video/%02d/',Pedes_number,dir)];
    path.foreground_mask_dir = [dataset_path sprintf('ucsdpeds_vid%s/segm/%02d/',Pedes_number,dir)];
    [FrameFeature,temproal_consistance,spacial_consistance,max_blob_index] = getFeatureConsistancy(FeatureName, path, opt);
    opt.max_blob_index = max_blob_index;                % opt.max_blob_index = 0;
    opt.frame_index = opt.frame_index + opt.num_frame;  % opt.frame_index = 0;
    
    Feature = [Feature; FrameFeature];
    TC = [TC; temproal_consistance'];
    SC = [SC; spacial_consistance'];
end
toc
% save(sprintf('ucsd_%s_feature.mat', Pedes_number), 'TotalFeature', 'temproal_consistance', 'spacial_consistance', 'max_blob_index');
