function [blobs_mask, blobs_Features] = getBlobs2(original_img,foreground_mask,dmap,roi,fg_info,FeatureName,opt)

	% find all blobs and get features of each blob

	if nargin < 7
		opt.min_blob = 10;
		opt.gt_nodirection_count = 1;
		opt.gt_only_roi_count = 1;
	end

	[size_x, size_y] = size(roi);

    blobs_mask = {};  		% mask of each blob in current frame
    blobs_Features = [];	% features of each blob in current frame
    blobs_dir = [];         % direction of each blob
    blobs_gt = [];          % ground truth of each blob


    while find(foreground_mask>0)>0
        % get blob mask
        init_dot = find(foreground_mask>0);
        init_dot = init_dot(1);
        cur_mask = zeros(size(foreground_mask));
        cur_mask(init_dot) = 1;
        last_size = 0;
        tmp_mask = foreground_mask == foreground_mask(init_dot);
        direction_number = foreground_mask(init_dot);
        while last_size ~= length(find(cur_mask))
            last_size = length(find(cur_mask));
            cur_mask = imdilate(cur_mask, strel('square', 3)) & tmp_mask;
        end
        foreground_mask(cur_mask) = 0;
        if length(find(cur_mask)) < opt.min_blob
            continue
        end
        blobs_mask{length(blobs_mask)+1} = cur_mask;

        % get features of current blob
        feat = blob2feature(original_img, cur_mask, dmap, FeatureName);
        blobs_Features = [blobs_Features; feat];
        
        % get direction of current blob
        switch direction_number
            case 128
                % r(right) or rs(right slow)
                tmp_dir = 1;
            case 255
                % l(left) or rf(right fast)
                tmp_dir = 2;
            case 64
                % ls(left slow)
                tmp_dir = 3;
            case 196
                % lf(left fast)
                tmp_dir = 4;
            otherwise
                error('Unknow direction!');
        end
        blobs_dir = [blobs_dir; tmp_dir];
    end
    
    % get ground truth of each blob
    blobs_gt = zeros(length(blobs_mask), 1);

    for i=1:size(fg_info.loc, 1)
        y = round(fg_info.loc(i,1));
        x = round(fg_info.loc(i,2));

        if x <= 0 || x > size_x || y <=0 || y > size_y
            continue
        end

        if opt.gt_only_roi_count && roi(x,y)==0
            continue
        end

        if opt.gt_nodirection_count == 0 && fg_info.tdir{i} == 'n'
            continue
        end
        
        blob_dist = zeros(length(blobs_mask), 1);
        for j=1:length(blobs_mask)
            [bx, by] = ind2sub([size_x, size_y], find(blobs_mask{j}));
            blob_dist(j) = min((bx-x).^2 + (by-y).^2);
        end
        [r, idx] = min(blob_dist);
        blobs_gt(idx) = blobs_gt(idx) + 1;
    end
    
    blobs_Features = [blobs_dir, blobs_gt, blobs_Features];
end
