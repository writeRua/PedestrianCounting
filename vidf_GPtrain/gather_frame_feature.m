function [ feat ] = gather_frame_feature( features, features_kind )
%To gather the features of one frame into a vector.
%features is a struct, just as the struct that FeatureExtraction.m output.

temp=[];
%features
for i=1:length(features_kind)
    %features
    %eval( strcat('temp=cat(1,temp,features.',features_kind{i},');') );
    s = strcat('temp=cat(2,temp,features.',features_kind{i},');') ;
    eval(s);
end
feat=temp;
end

