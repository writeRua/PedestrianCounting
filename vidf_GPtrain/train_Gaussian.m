%To train Gaussian for UCSD dataset
%The first several lines should be set by user.

clear

%================basic setting:

addpath('D:\lab\People_Counting\ucsdpeds_feats\features'); %path of gp_train.m and gp_predict.m
savepath='D:\lab\People_Counting\gpm\gpm3.mat'; %path to save gpm
load('D:\lab\People_Counting\UCSD_feature'); %load the features.
load('D:\lab\People_Counting\vidf_Y.mat'); %load the ground_truth
training_set=[1401:2600];
test_set=[1:1400,2601:4000];

blob_information_path='D:\lab\People_Counting\blob_feat_and_gt\blob_feat_and_gt';%the fileset contains the feature&gt information extracted from the blobs.
blob_training_set=[7:9];
blob_test_set=[0:6,13:19];

%feature_kind={'Area','Perimeter','PerimeterOrientation','Ratio','Edge','EdgeOrientation','FractalDim','GLCM','SLF'};
feature_kind={'Area','Perimeter','PerimeterOrientation','Ratio','Edge','EdgeOrientation','FractalDim','GLCM'};
run('D:\lab\People_Counting\ucsdpeds_feats\gpml-matlab-v3.4-2013-11-11\startup.m');%To initialize gpml library.

%load('D:\lab\People_Counting\blob_feat_and_gt\blob_feat_and_gt009');
%===============GP parameters:

covfunc = {'covLINone'};
%covfunc={'covSEiso'};
gpnorm   = 'Xy';
gptrials = 1;

%covfunc = {'covSum', {'covSEiso', 'covSEiso'}};
%covfunc = {'covSum', {'covLINone', 'covSEiso'}};
%gptrials = 5;
%gpnorm  = 'X';


%=================to gather fatures into a matrix:
%if your features are already in the form of matrix, please delete the next line
features=gather_features(features,feature_kind,[1:20]);

%=====================================

trainingX=features(training_set,:);
testX=features(test_set,:);
trainingY=Y(training_set,:);
testY=Y(test_set,:);

trainingX=trainingX';
trainingY=trainingY';
testX=testX';
%testY=testY';

%=======add blob training data

for i=blob_training_set
    %s=sprintf('D:\lab\People_Counting\blob_feat_and_gt\blob_feat_and_gt%03d',i)
    load(['D:\lab\People_Counting\blob_feat_and_gt\blob_feat_and_gt',sprintf('%03d',i)]);
    
    trainingX=[trainingX,blob_data.features'];
    trainingY=[trainingY,blob_data.gt'];
end
%=======

disp('Begin training gp');

gpm=gp_train(trainingX, trainingY, covfunc, gpnorm, gptrials);

disp('Begin predicting by gp');

[predictY,varianceY]=gp_predict(testX,gpm);

[mae,mse]=error_rate(predictY,testY);

mae
mse

%============

blob_testX=[];
blob_testY=[];
for i=blob_test_set
    load(['D:\lab\People_Counting\blob_feat_and_gt\blob_feat_and_gt',sprintf('%03d',i)]);
    blob_testX=[blob_testX,blob_data.features'];
    blob_testY=[blob_testY;blob_data.gt];
    
    [blob_predictY,blob_varianceY]=gp_predict(blob_testX,gpm);
    [blob_mae,blob_mse]=error_rate(blob_predictY,blob_testY);
end


save(savepath,'gpm');
blob_mae
blob_mse





