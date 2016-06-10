function [FrameFeature] = getHolisticFeatures(FeatureName, path, opt)

if nargin < 2
    error('In getHolisticFeatures(FeatureName, path, opt): Too few parameters!');
end
if nargin < 3
    opt.isoutput = 1;
    opt.fea_only_roi = 1;
    opt.gt_only_roi_count = 1;
    D = dir([path.origin_image_dir, '/*.png']);
    opt.num_frame = length(D(not([D.isdir])));
    opt.frame_index = 0;
end
if opt.isoutput == 1
    output_path = 'temp_output'; mkdir(output_path);
    grayMask_path = 'temp_output/grayMask'; mkdir(grayMask_path);
    foreground_path = 'temp_output/foreground'; mkdir(foreground_path);
end
if length(fieldnames(path)) < 5
    error('In getHolisticFeatures(FeatureName, path, opt): Too few elements in path!');
end


% load ROI, dmap and ground truth
load(path.roi_path);    roi = roi.mask;
load(path.dmap_path);   dmap = dmap.pmapxy;
load(path.groundtruth_path);
[size_x, size_y] = size(roi);

% boundary
tmp = roi - (1-imdilate(1-roi,strel('diamond',1)));
tmp(1:end,1)=1;tmp(1:end,end)=1;tmp(1,1:end)=1;tmp(end,1:end)=1;
boundary = tmp & roi;
if opt.isoutput
    imwrite(boundary, [output_path '/boundary.png']);
    imwrite(roi, [output_path '/ROI.png']);
end

%% extract features for each image
FrameFeature = [];
frame_index = opt.frame_index;

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
    
    % get holistic features
    feat = blob2feature(original_img, foreground_mask, dmap, FeatureName);

    % grount truth number
    gtc = 0;
    for i=1:size(fgt.frame{file}.loc, 1)
        y = round(fgt.frame{file}.loc(i,1));
        x = round(fgt.frame{file}.loc(i,2));
        if x<=0 || y<=0 || x>size_x || y>size_y
            continue;
        end
        
        if opt.gt_only_roi_count && roi(x,y)==0
            continue
        end
        gtc = gtc + 1;
    end

    feat = [feat, gtc];
    FrameFeature = [FrameFeature; feat];
end

end