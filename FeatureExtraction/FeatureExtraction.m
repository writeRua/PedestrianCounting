function features=FeatureExtract(images,masks,dmap,features_kind)
%Here images and masks should be cell of strings,where each string is a path of an image. Eg: images={'../data/1','../data/2'}. The two cells should have same length!
%dmap is a matrix,which has the same size as each image.
%features_kind has default value as below.You can set features_kind by yourself, but it should be a subset of the default value.
if (nargin<3)
	error('In FeatureExtract(images,masks,dmap,features):Too few parameters!');
end
if (nargin>4)
	error('In FeatureExtract(images,masks,dmap,features):Too many parameters!');
end
if (nargin==3)
	features_kind={'SLF','Area','Perimeter','Edge','FractalDim','Ratio'};
end

if (length(images)~=length(masks))
	error('In FeatureExtract(images,masks,dmap,features):The number of images and masks should be the same!');
end
%features=[];
%for i = features_kind
%	if (strcmp(i,'slf'))
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
		warning(strcat(masks{iter}), 'is a logical matrix!');
		mask=uint8(mask)*255;
	end
	for i = features_kind
		if (strcmp(i,'SLF'))
			features.SLF=cat(1,features.SLF,GetSLF(image,mask));
		elseif(strcmp(i,'Area'))
			features.Area=cat(1,features.Area,GetArea(image,dmap));
		elseif(strcmp(i,'Perimeter'))
			features.Perimeter=cat(1,features.Perimeter,GetPerimeter(image,dmap));
		elseif(strcmp(i,'Edge'))
			features.Edge=cat(1,features.Edge,GetEdge(image,mask,dmap));
		elseif(strcmp(i,'FractalDim'))
			features.FractalDim=cat(1,features.FractalDim,GetFractalDim(image,mask));
		elseif(strcmp(i,'Ratio'))
			features.Ratio=cat(1,features.Ratio,GetRatio(image,dmap));
		else
			error(strcat(i,' is not an available kind of feature!'));
		end
	end
	iter=iter+1;
end
