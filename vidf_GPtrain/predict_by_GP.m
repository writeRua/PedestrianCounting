function [ prediction ] = predict_by_GP( gpm,image,mask,dmap,roi,features_kind )
% Use the trained model 'gpm' to predict the num of people in 'image'

features=FeatureExtraction(image,mask,dmap,roi,features_kind);
temp=[];
for i=1:length(features_kind)
    %eval( strcat('temp=cat(1,temp,features.',features_kind{i},');') );
    s = strcat('temp=cat(2,temp,features.',features_kind{i},');') ;
    eval(s);
end
features=temp';
[prediction,variance]=gp_predict(features,gpm);

end

