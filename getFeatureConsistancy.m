function [FrameFeature,temproal_consistance,spacial_consistance,max_blob_index] = getFeatureConsistancy(FeatureName, path, opt)

% Input:
%   FeatureName: e.g. {'Area','Perimeter','PerimeterEdgeOrientation','Ratio','Edge','EdgeOrientation','FractalDim','GLCM'};
%   path: roi_path, dmap_path, groundtruth_path, origin_image_dir, foreground_mask_dir
%   opt: isoutput, min_blob, num_frame, gt_boundary_count, gt_nodirection_count, gt_only_roi_count, max_blob_index, frame_index
% Output:
%   FrameFeature: features of each blob {frame_number, blob_id,
%                   touch_boundary, direction, ground_truth, FeatureName(29)}
%   temproal_consistance
%   spacial_consistance
%   max_blob_index: maximum blob index

if nargin < 2
    error('In getFeatureConsistancy(FeatureName, path, opt): Too few parameters!');
end
if nargin < 3
    opt.isoutput = 1;
    opt.min_blob = 10;
    opt.gt_boundary_count = 1;
    opt.gt_nodirection_count = 1;
    opt.gt_only_roi_count = 1;
    D = dir([path.origin_image_dir, '/*.png']);
    opt.num_frame = length(D(not([D.isdir])))
    opt.max_blob_index = 0;
    opt.frame_index = 0;
end
if opt.isoutput == 1
    output_path = 'temp_output'; mkdir(output_path);
    grayMask_path = 'temp_output/grayMask'; mkdir(grayMask_path);
    rgbMask_path = 'temp_output/rgbMask'; mkdir(rgbMask_path);
    foreground_path = 'temp_output/foreground'; mkdir(foreground_path);
end
if length(fieldnames(path)) < 5
    error('In getFeatureConsistancy(FeatureName, path, opt): Too few elements in path!');
end


% load ROI and dmap and ground truth
load(path.roi_path);    roi = roi.mask;
load(path.dmap_path);   dmap = dmap.pmapxy;
load(path.groundtruth_path);


% boundary
tmp = roi - (1-imdilate(1-roi,strel('diamond',1)));
tmp(1:end,1)=1;tmp(1:end,end)=1;tmp(1,1:end)=1;tmp(end,1:end)=1;
boundary = tmp & roi;
if opt.isoutput
    imwrite(boundary, [output_path '/boundary.png']);
    imwrite(roi, [output_path '/ROI.png']);
end

FrameFeature = [];
temproal_consistance = [];
spacial_consistance = [];
max_blob_index = opt.max_blob_index;
frame_index = opt.frame_index;

last_frame_blobs_Mask = {};
last_frame_blobs_Idx = [];

for file=1:opt.num_frame
    frame_index = frame_index + 1;
    disp(sprintf('processing %d', frame_index));
    
    % load and preprocess foreground mask and original image whose file name is XXX.png (XXX = file)
    foreground_mask_name = [path.foreground_mask_dir sprintf('%03d.png',file)];
    original_img_name = [path.origin_image_dir sprintf('%03d.png',file)];
    foreground_mask = imread(foreground_mask_name);
    original_img = imread(original_img_name);
    if opt.fea_only_roi
        foreground_mask = foreground_mask .* uint8(roi);
    end
    
    if opt.isoutput
        outname = sprintf('%s/%d.png', grayMask_path, frame_index);
        imwrite(foreground_mask, outname);

        temp = uint8(foreground_mask > 0);
        outname = sprintf('%s/%d.png', foreground_path, frame_index);
        imwrite(original_img.*temp, outname);
    end

    % find all blobs and get features of each blob
    fg_info = fgt.frame{file};
    [current_frame_blobs_Mask,features] = getBlobs(original_img,foreground_mask,dmap,roi,fg_info,FeatureName,opt);
    
    % get indeces of current frame blobs, temproal_consistance, spacial_consistance and total blobs of all frames
    [current_frame_blobs_Idx,temp_consis,spat_consis,touch_boundary,max_blob_index] = label_blobs(current_frame_blobs_Mask,...
        last_frame_blobs_Mask,last_frame_blobs_Idx,frame_index,max_blob_index,boundary);
    
    features = [double(frame_index)*ones(length(current_frame_blobs_Mask), 1),current_frame_blobs_Idx,touch_boundary,features];
    if isempty(features)
        continue;
    end
    FrameFeature = [FrameFeature; features];
    temproal_consistance = [temproal_consistance, temp_consis];
    spacial_consistance = [spacial_consistance, spat_consis];
    last_frame_blobs_Mask = current_frame_blobs_Mask;
    last_frame_blobs_Idx = current_frame_blobs_Idx;

    if opt.isoutput
        outimg = zeros([size(foreground_mask), 3]);
        cmp = colormap('Lines');
        imgsize = size(outimg, 1) * size(outimg, 2);
        for i=1:length(current_frame_blobs_Mask)
            blob_color = cmp(mod(current_frame_blobs_Idx(i),size(cmp, 1))+1, :);
            outimg(find(current_frame_blobs_Mask{i})) = blob_color(1);
            outimg(imgsize + find(current_frame_blobs_Mask{i})) = blob_color(2);
            outimg(imgsize * 2 + find(current_frame_blobs_Mask{i})) = blob_color(3);
        end
        outname = sprintf('%s/%d.png', rgbMask_path, frame_index);
        imwrite(outimg, outname);
    end
end

end
