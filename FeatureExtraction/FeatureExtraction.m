function features=FeatureExtraction(image,mask,dmap,roi,features_kind)
%extracat fetures of image.
%image: a matrix. Maybe you can construct it by imread('the path of image').
%mask: a matrix. Maybe you can construct it by imread('the path of image').
%dmap is a matrix,which has the same size as each image and each mask.
%features_kind has default value as below.You can also set features_kind by yourself, but it should be a subset of the default value.
if (nargin<4)
	error('In FeatureExtract(images,masks,dmap,features):Too few parameters!');
end
if (nargin>5)
	error('In FeatureExtract(images,masks,dmap,features):Too many parameters!');
end
if (nargin==4)
	features_kind={'Area','Perimeter','PerimeterOrientation','Ratio','Edge','EdgeOrientation','FractalDim','GLCM','SLF'};
end


    mask=uint8(logical(mask))*255;
    roi=uint8(logical(roi));
    mask=mask.*roi;
for i = features_kind
	
	if(strcmp(i,'Area'))
		features.Area=GetArea(mask,dmap);%cat(1,features.Area,GetArea(image,dmap));
	elseif(strcmp(i,'Perimeter'))
		features.Perimeter=GetPerimeter(mask,dmap);%cat(1,features.Perimeter,GetPerimeter(image,dmap));
    elseif(strcmp(i,'PerimeterOrientation'))
        features.PerimeterOrientation=GetPerimeterOrientation(mask,dmap);
    elseif(strcmp(i,'Ratio'))
		features.Ratio=GetRatio(mask,dmap);%cat(1,features.Ratio,GetRatio(image,dmap));
	elseif(strcmp(i,'Edge'))
		features.Edge=GetEdge(image,mask,dmap);%cat(1,features.Edge,GetEdge(image,mask,dmap));
    elseif(strcmp(i,'EdgeOrientation'))
        features.EdgeOrientation=GetEdgeOrientation(image,mask,dmap);
	elseif(strcmp(i,'FractalDim'))
		features.FractalDim=GetFractalDim(image,mask);%cat(1,features.FractalDim,GetFractalDim(image,mask));
    elseif(strcmp(i,'GLCM'))
        features.GLCM=GetGLCM(image.*(mask/255),dmap);%%%%%%%%%%%%%%%%%%%%%%%%%!!
    elseif(strcmp(i,'SLF'))
		features.SLF=GetSLF(image,mask);%cat(1,features.SLF,GetSLF(image,mask));
	else
		error(strcat(i{1},' is not an available kind of feature!'));
	end
end
