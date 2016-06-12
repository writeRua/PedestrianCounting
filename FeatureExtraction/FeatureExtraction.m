function features=FeatureExtraction(image,mask,dmap,features_kind)
%extracat fetures of image.
%image: a matrix. Maybe you can construct it by imread('the path of image').
%mask: a matrix. Maybe you can construct it by imread('the path of image').
%dmap is a matrix,which has the same size as each image and each mask.
%features_kind has default value as below.You can also set features_kind by yourself, but it should be a subset of the default value.
if (nargin<3)
	error('In FeatureExtract(images,masks,dmap,features):Too few parameters!');
end
if (nargin>4)
	error('In FeatureExtract(images,masks,dmap,features):Too many parameters!');
end
if (nargin==3)
	features_kind={'SLF','Area','Perimeter','Edge','FractalDim','Ratio'};
end

%if (length(images)~=length(masks))
%	error('In FeatureExtract(images,masks,dmap,features):The number of images and masks should be the same!');
%end
%features=[];
%for i = features_kind
%	if (strcmp(i,'SLF'))
%		features.SLF=[];
%	elseif(strcmp(i,'Area'))
%		features.Area=[];
%	elseif(strcmp(i,'Perimeter'))
%		features.Perimeter=[];
%	elseif(strcmp(i,'Edge'))
%		features.Edge=[];
%	elseif(strcmp(i,'FractalDim'))
%		features.FractalDim=[];
%	elseif(strcmp(i,'Ratio'))
%		features.Ratio=[];
%	else
%		error(strcat(i,' is not an available kind of feature!'));
%	end
%end

%try
	%map=load(dmap);
%catch
%	error('In FeatureExtract(images,masks,dmap,features):Can not read dmap');
%end

	if(strcmp(class(mask),'logical'))
		warning('In FeatureExtraction(image,mask,dmap,features): Mask is a logical matrix!');
		mask=uint8(mask)*255;
	end
for i = features_kind
	if (strcmp(i,'SLF'))
		features.SLF=GetSLF(image,mask);%cat(1,features.SLF,GetSLF(image,mask));
	elseif(strcmp(i,'Area'))
		features.Area=GetArea(image,dmap);%cat(1,features.Area,GetArea(image,dmap));
	elseif(strcmp(i,'Perimeter'))
		features.Perimeter=GetPerimeter(image,dmap);%cat(1,features.Perimeter,GetPerimeter(image,dmap));
	elseif(strcmp(i,'Edge'))
		features.Edge=GetEdge(image,mask,dmap);%cat(1,features.Edge,GetEdge(image,mask,dmap));
	elseif(strcmp(i,'FractalDim'))
		features.FractalDim=GetFractalDim(image,mask);%cat(1,features.FractalDim,GetFractalDim(image,mask));
	elseif(strcmp(i,'Ratio'))
		features.Ratio=GetRatio(image,dmap);%cat(1,features.Ratio,GetRatio(image,dmap));
	else
		error(strcat(i,' is not an available kind of feature!'));
	end
end
