function features=FeatureExtraction_dataset(image_path,mask_path,dmap,roi,feature_kinds)
%Extract features from one whole dataset, like UCSD.

%image_path: a string, representing the path of images.Under the path there should be some subfiles, and in each subfile there is a part of dataset images.For example, '../../vidf/video/vidf'.
%mask_path: just as image_path.It's a string, representing the path of masks.Under the path there should be some subfiles, and in each subfile there is a part of dataset masks.For example, '../../vidf/segm/vidf'.
%dmap: a matrix. It's the prespective map.
%feature_kinds: It has default value,see in 'README.md'.You can also set features_kind by yourself, but it should be a subset of the default value.

%return an array of struct.features(i) is a struct, containing all the features of ith subfile.
if (nargin<4)
	error('In FeatureExtraction_dataset(image_path,mask_path,dmap,feature_kinds):Too few parameters!');
end
if (nargin>5)
	error('In FeatureExtraction_dataset(image_path,mask_path,dmap,feature_kinds):Too many parameters!');
end

image_files=get_subfiles(image_path);
mask_files=get_subfiles(mask_path);
if (length(image_files)~=length(mask_files));
	error('In FeatureExtraction_dataset(...):the number of image files do should be the same as the number of mask files!');
end

features=[];
for i=[1:length(image_files)]
	if (nargin==5)
		features=[features,FeatureExtraction_file(image_files{i},mask_files{i},dmap,roi,feature_kinds)];
	elseif (nargin==4)
		features=[features,FeatureExtraction_file(image_files{i},mask_files{i},dmap,roi)];
	end
end


function files=get_subfiles(file_path)
files={};
temp=dir(file_path);
for i=[1:length(temp)]
	if (temp(i).isdir)
		if ~(strcmp(temp(i).name,'.')||strcmp(temp(i).name,'..'))
		files=cat(2,files,strcat(file_path,'/',temp(i).name));
		end
	end
end
