clear; clc; close all;

Pedes_number = 'f';
dataset_path = '../../ucsd_original/';

% load ROI
roi_path = [dataset_path sprintf('ucsdpeds_gt/vid%s/roi.mat',Pedes_number)];
groundtruth_dir = [dataset_path sprintf('ucsdpeds_gt/vid%s/',Pedes_number)];
load(roi_path); roi = roi.mask;
[size_x, size_y] = size(roi);

if strcmp(Pedes_number, 'f') nDir = 2;
else nDir = 4; end
for i=1:nDir
    dirLabel{i} = zeros(4000, 1);
end
inROI_All = zeros(4000, 1);
inROI_Move = zeros(4000, 1);

for dir=0:19
    groundtruth_path = [groundtruth_dir sprintf('%02d_frame_full.mat', dir)];
    load(groundtruth_path);

    for i=1:length(fgt.frame)
        all = 0;
        move = 0;
        for j=1:length(fgt.frame{i}.id)
            y = round(fgt.frame{i}.loc(j, 1));
            x = round(fgt.frame{i}.loc(j, 2));
            if x<=0 || y<=0 || x>size_x || y>size_y
                continue;
            end

            if roi(x, y) == 0
                continue;
            end

            all = all + 1;
            if strcmp(Pedes_number, 'f')
                switch fgt.frame{i}.tdir{j}
                    case 'ls'
                        dirLabel{1}(200*dir+i) = dirLabel{1}(200*dir+i) + 1;
                        move = move + 1;
                    case 'lf'
                        dirLabel{1}(200*dir+i) = dirLabel{1}(200*dir+i) + 1;
                        move = move + 1;
                    case 'rs'
                        dirLabel{2}(200*dir+i) = dirLabel{2}(200*dir+i) + 1;
                        move = move + 1;
                    case 'rf'
                        dirLabel{2}(200*dir+i) = dirLabel{2}(200*dir+i) + 1;
                        move = move + 1;
                    case 'n'
                    otherwise
                        error('Unknown direction name!');
                end
            else
                switch fgt.frame{i}.tdir{j}
                    case 'ls'
                        dirLabel{1}(200*dir+i) = dirLabel{1}(200*dir+i) + 1;
                        move = move + 1;
                    case 'lf'
                        dirLabel{2}(200*dir+i) = dirLabel{2}(200*dir+i) + 1;
                        move = move + 1;
                    case 'rs'
                        dirLabel{3}(200*dir+i) = dirLabel{3}(200*dir+i) + 1;
                        move = move + 1;
                    case 'rf'
                        dirLabel{3}(200*dir+i) = dirLabel{4}(200*dir+i) + 1;
                        move = move + 1;
                    case 'n'
                    otherwise
                        error('Unknown direction name!');
                end
            end
        end
        inROI_All(200*dir+i) = all;
        inROI_Move(200*dir+i) = move;
    end
end
inROI_All = reshape(inROI_All, length(inROI_All), 1);
inROI_Move = reshape(inROI_Move, length(inROI_Move), 1);

ROI.all  = inROI_All;
ROI.move = inROI_Move;
ROI.dir  = dirLabel;

%Chan Label
if strcmp(Pedes_number, 'f')
    testFile = [dataset_path 'ucsdpeds_feats/features/Peds1_feats.mat'];
    load(testFile);
    Chan.label = cnt{3}';
    Chan.dir{1} = cnt{1}';
    Chan.dir{2} = cnt{2}';
else
    testFile = [dataset_path 'ucsdpeds_feats/features/Peds2_feats.mat'];
    load(testFile);
    Chan.label = cnt{5}';
    Chan.dir{1} = cnt{2}';
    Chan.dir{2} = cnt{1}';
    Chan.dir{3} = cnt{4}';
    Chan.dir{4} = cnt{3}';
end

save(sprintf('ucsd_%s_GroundTruth.mat', Pedes_number), 'Chan', 'ROI');