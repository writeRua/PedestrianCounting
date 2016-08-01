function fea=gather_features(features,feature_kind,range)
%This function is to change the features in the form that FeatureExtraction_dataset.m or FeatureExtraction_file.m give out,to a matrix.

%features: The result of FeatureExtraction_dataset.m or FeatureExtraction_file.m

%feature_kind: The kinds of features you want to gather. It should be a cell of strings. It has default value as in FeatureExtraction.m

%range: It's a vector. Maybe you don't want to use the whole dataset, and you can use this parameter to control. It has default value=[1:length(features)]
%Note that if range=[1:10],it means to gather features in features[1] to features[10]. And in features[i] there are features in 200 frames

if (nargin>3)
    error('In gather_features(features,feature_kinds,range): Too many parameters!');
end
if (nargin<3)
    range=[1:length(features)];
end
if (nargin<2)
    feature_kind={'Area','Perimeter','PerimeterOrientation','Ratio','Edge','EdgeOrientation','FractalDim','GLCM','SLF'};
end
if (nargin<1)
    error('In gather_features(features,feature_kinds,range): Too few parameters!');
end

%===================the code above is to deal with the case of over_loading

fea=[];
for i = range
   temp=[];
   for j=feature_kind;
       s=strcat('temp=cat(2,temp,features(',int2str(i),').',j{1},');');
       eval(s);
   end
   fea=cat(1,fea,temp);
end


