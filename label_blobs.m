function [cur_idx, tmp_consistance, tmp_SC, touch_boundary, max_idx] = label_blobs(cur_frame, last_frame, last_frame_idx, frame_id, max_idx, boundary)
    threshold = 0.8;
    idx_candidate = cell(length(cur_frame), 1);
    idx_candidate_inv = cell(length(last_frame), 1);
    temp_consistance = [];
    for i=1:length(cur_frame)
        for j=1:length(last_frame)
            overlap_area = length(find(cur_frame{i} & last_frame{j}));
            if (double(overlap_area) / length(find(cur_frame{i})) > threshold) || ...
                    (double(overlap_area) / length(find(last_frame{j})) > threshold)
                idx_candidate{i} = [idx_candidate{i}, j];
                idx_candidate_inv{j} = [idx_candidate_inv{j}, i];
            end
        end
    end
    
    cur_idx = zeros(length(cur_frame), 1);
    tmp_consistance = [];
    for i=1:length(cur_frame)
        if cur_idx(i) > 0
            continue
        end
        if (length(idx_candidate{i}) == 1)
            if length(idx_candidate_inv{idx_candidate{i}}) == 1
                %same blob
                cur_idx(i) = last_frame_idx(idx_candidate{i});
            else
                %split
                tmp = [];
                for j=1:length(idx_candidate_inv{idx_candidate{i}})
                    max_idx = max_idx + 1;
                    cur_idx(idx_candidate_inv{idx_candidate{i}}(j)) = max_idx;
                    tmp = [tmp, max_idx];
                end
                s = struct('last', last_frame_idx(idx_candidate{i}), 'current', tmp, 'f', frame_id);
                tmp_consistance = [tmp_consistance, s];
            end
        elseif (length(idx_candidate{i}) > 1)
            %merge
            max_idx = max_idx + 1;
            cur_idx(i) = max_idx;
            s = struct('last', [last_frame_idx(idx_candidate{i})], 'current', cur_idx(i), 'f', frame_id);
            tmp_consistance = [tmp_consistance, s];
        elseif (length(idx_candidate{i}) == 0)
            %new
            %also handle for initial frame
            max_idx = max_idx + 1;
            cur_idx(i) = max_idx;
        end
    end
    
    touch_boundary = zeros(length(cur_frame), 1);
    for i=1:length(cur_frame)
        if (isempty(find(cur_frame{i} & boundary)))
            touch_boundary(i) = 1;
        else
            touch_boundary(i) = 0;
        end
    end
    
    
    tmp_SC = [];
    for i=1:length(cur_frame)
        for j=i+1:length(cur_frame)
            if length(find(imdilate(cur_frame{i}, strel('diamond',1)) & imdilate(cur_frame{j}, strel('diamond',1)))) > 0
                s = struct('blobs', [cur_idx(i), cur_idx(j)], 'f', frame_id);
                tmp_SC = [tmp_SC, s];
            end
        end
    end
end