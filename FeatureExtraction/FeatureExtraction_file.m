function features=FeatureExtraction_file(image,mask,dmap,roi,features_kind)
%To deal with the case that images are in one file, and the masks correspongding to it are in another file.
%image should be a string ,which is the path of the image file. 
%mask should be a string ,which is the path of the mask file.
%dmap is a matrix,which has the same size as each image.
%features_kind has default value as below.You can set features_kind by yourself, but it should be a subset of the default value.
if (nargin<4)
	error('In FeatureExtraction_file(images,masks,dmap,features):Too few parameters!');
end
if (nargin>5)
	error('In FeatureExtraction_file(images,masks,dmap,features):Too many parameters!');
end
if (nargin==4)
	features_kind={'Area','Perimeter','PerimeterOrientation','Ratio','Edge','EdgeOrientation','FractalDim','GLCM','SLF'};
end

images=FileLooper(image);
masks=FileLooper(mask);
if (length(images)~=length(masks))
	error('In FeatureExtraction_file(images,masks,dmap,features):The number of images and masks should be the same!');
end
%features=[];
%for i = features_kind
%	if (strcmp(i,'SLF'))
		features.SLF=[];
%	elseif(strcmp(i,'Area'))
		features.Area=[];
%	elseif(strcmp(i,'Perimeter'))
		features.Perimeter=[];
%	elseif(strcmp(i,'Edge'))
		features.Edge=[];
%	elseif(strcmp(i,'FractalDim'))
		features.FractalDim=[];
%	elseif(strcmp(i,'Ratio'))
		features.Ratio=[];
        features.GLCM=[];
        features.PerimeterOrientation=[];
        features.EdgeOrientation=[];
%	else
%		error(strcat(i,' is not an available kind of feature!'));
%	end
%end

%try
	%map=load(dmap);
%catch
%	error('In FeatureExtract(images,masks,dmap,features):Can not read dmap');
%end

iter=1;
while (iter <= length(images))
	image=(imread(images{iter}));
	mask=imread(masks{iter});
	if(strcmp(class(mask),'logical'))
		%warning(strcat(masks{iter}), 'is a logical matrix!');
		mask=uint8(mask)*255;
    end


    temp_feature=FeatureExtraction(image,mask,dmap,roi,features_kind);

	
    for i = features_kind
		if (strcmp(i,'SLF'))
			features.SLF=cat(1,features.SLF,temp_feature.SLF);
		elseif(strcmp(i,'Area'))
			features.Area=cat(1,features.Area,temp_feature.Area);
		elseif(strcmp(i,'Perimeter'))
			features.Perimeter=cat(1,features.Perimeter,temp_feature.Perimeter);
		elseif(strcmp(i,'Edge'))
			features.Edge=cat(1,features.Edge,temp_feature.Edge);
		elseif(strcmp(i,'FractalDim'))
			features.FractalDim=cat(1,features.FractalDim,temp_feature.FractalDim);
		elseif(strcmp(i,'Ratio'))
			features.Ratio=cat(1,features.Ratio,temp_feature.Ratio);
        elseif(strcmp(i,'PerimeterOrientation'))
            features.PerimeterOrientation=cat(1,features.PerimeterOrientation,temp_feature.PerimeterOrientation);
        elseif(strcmp(i,'EdgeOrientation'))
			features.EdgeOrientation=cat(1,features.EdgeOrientation,temp_feature.EdgeOrientation);
        elseif(strcmp(i,'GLCM'))
			features.GLCM=cat(1,features.GLCM,temp_feature.GLCM);
		else
			error(strcat(i,' is not an available kind of feature!'));
		end
	end
	iter=iter+1;
end
