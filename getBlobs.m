function [blobs_mask, blobFeatures] = getBlobs(original_img,foreground_mask,dmap,roi,fg_info,FeatureName,opt)

	% find all blobs and get features of each blob

	if nargin < 7
		opt.min_blob = 10;
		opt.gt_boundary_count = 1;
		opt.gt_nodirection_count = 1;
		opt.gt_only_roi_count = 1;
	end

	[size_x, size_y] = size(roi);

    blobs_mask = {};  		% mask of each blob in current frame
    blobFeatures = [];		% features of each blob in current frame

    while find(foreground_mask>0)>0
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

        % get features of current blob
        feat = blob2feature(original_img, cur_mask, dmap, FeatureName);
        blobs_mask{length(blobs_mask)+1} = cur_mask;
        
        % direction
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
        end

        % get grount truth number of current blob
        gtc = 0;
        for i=1:size(fg_info.loc, 1)
            y = round(fg_info.loc(i,1));
            x = round(fg_info.loc(i,2));

            % what if the position of a pedestrian outside of the boundary
            % (maybe a part of the blob in the ROI)
            if opt.gt_boundary_count
                if (x<=0); x = 1; end
                if (x>size_x); x = size_x; end
                if (y<=0); y = 1; end
                if (y>size_y); y = size_y; end
            elseif x <= 0 || x > size_x || y <=0 || y > size_y
                continue
            end

            % static pedestrian
            if opt.gt_nodirection_count == 0 && fg_info.tdir{i} == 'n'
                continue
            end

            if opt.gt_only_roi_count && roi(x,y)==0
                continue
            end
            if cur_mask(x, y)==0
                continue
            end

            gtc = gtc + 1;
        end

        feat = [tmp_dir, gtc, feat];
        blobFeatures = [blobFeatures; feat];
    end
end