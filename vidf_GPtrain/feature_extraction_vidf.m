%to extract features of vidf

clear

%===============basic settings:

image_path='D:\lab\People_Counting\UCSD_data\vidf_first4000\video';
mask_path='D:\lab\People_Counting\UCSD_data\vidf_first4000\segm';
map=load('D:\lab\People_Counting\UCSD_data\gt\vidf_dmap'); %load perspective map.(dmap)
map=map.dmap.pmapxy;

savepath='D:\lab\People_Counting\UCSD_feature';%where to save the features.
addpath('D:\lab\People_Counting\code\NewFeatureExtraction'); %The path of feature extraction code.(Actually, the path of the code under the branch FeatureExtraction)
load('D:\lab\People_Counting\UCSD_data\gt\vidf_roi'); %load roi of vidf
roi=roi.mask;

%feature_kinds={'Edge','Perimeter'};
%==========================

features=FeatureExtraction_dataset(image_path,mask_path,map,roi);
save(savepath,'features');