%To train Gaussian for UCSD dataset
%The first several lines should be set by user.

clear

%================basic setting:

addpath('D:\lab\People_Counting\ucsdpeds_feats\features'); %path of gp_train.m and gp_predict.m
load('D:\lab\People_Counting\UCSD_feature'); %load the features.
load('D:\lab\People_Counting\vidf_Y.mat'); %load the ground_truth
training_set=[1401:2600];
test_set=[1:1400,2601:4000];
%feature_kind={'Area','Perimeter','PerimeterOrientation','Ratio','Edge','EdgeOrientation','FractalDim','GLCM','SLF'};
feature_kind={'Area','Perimeter','PerimeterOrientation','Ratio','Edge','EdgeOrientation','FractalDim','GLCM'};
run('D:\lab\People_Counting\ucsdpeds_feats\gpml-matlab-v3.4-2013-11-11\startup.m');%To initialize gpml library.


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


disp('Begin training gp');

gpm=gp_train(trainingX, trainingY, covfunc, gpnorm, gptrials);

disp('Begin predicting by gp');

[predictY,varianceY]=gp_predict(testX,gpm);

[mae,mse]=error_rate(predictY,testY);
mae
mse




