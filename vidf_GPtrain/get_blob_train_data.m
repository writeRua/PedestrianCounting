%To get the features of blobs, and the corresponding ground_truth.

clear

%===============basic settings:
imagepath='D:\lab\People_Counting\UCSD_data\vidf_first4000\video'; %the path of the fileset that countains images of the dataset
maskpath='D:\lab\People_Counting\UCSD_data\vidf_first4000\segm'; %the path of the fileset that countains masks of the dataset
gt_path='D:\lab\People_Counting\UCSD_data\gt\vidf'; %The path which contains all the groundtruth data.

addpath('D:\lab\People_Counting\ucsdpeds_feats\features'); %path of gp_train.m and gp_predict.m
run('D:\lab\People_Counting\ucsdpeds_feats\gpml-matlab-v3.4-2013-11-11\startup.m');%To initialize gpml library.

load('D:\lab\People_Counting\UCSD_data\gt\vidf_dmap'); %load dmap;
dmap=dmap.pmapxy;

load('D:\lab\People_Counting\UCSD_data\gt\vidf_roi'); %load roi of vidf
roi=roi.mask;

addpath('D:\lab\People_Counting\code\NewFeatureExtraction'); %the path of code for FeatureExtraction

savepath='D:\lab\People_Counting\blob_feat_and_gt\blob_feat_and_gt'; %The path of fileset, in which to save the feat & gt of each blob.

%addpath('D:\lab\People_Counting\code\MakeDemo');

%range=14:19;
range=0:19;
image_size=[158,238];


features_kind={'Area','Perimeter','PerimeterOrientation','Ratio','Edge','EdgeOrientation','FractalDim','GLCM'};



%==========
%Debug_inf.image={};
%Debug_inf.mask={};

for i =range
    load( strcat(gt_path,'\vidf1_33_',sprintf('%03d',i),'_frame_full.mat') );
    %load( strcat(gt_path,'\vidf1_33_',sprintf('%03d',i),'_count_2K_roi_mainwalkway.mat') );
    imagepath_temp=strcat(imagepath,'\vidf1_33_',sprintf('%03d',i),'.y');
    maskpath_temp=strcat(maskpath,'\vidf1_33_',sprintf('%03d',i),'.segm');
    
    blob_data.features=[];
    blob_data.gt=[];
    for j=1:200
        disp(['Dealing with the frame ',num2str(j),'of fileset ',num2str(i)]);
        image=imread( strcat(imagepath_temp,'\vidf1_33_',sprintf('%03d',i),'_f',sprintf('%03d',j),'.png') );
        mask=imread( strcat(maskpath_temp,'\vidf1_33_',sprintf('%03d',i),'_f',sprintf('%03d',j),'.png') );
        
        blobs=get_blob_mask(mask);
        
        for k=1:length(blobs)
            blob_feature=FeatureExtraction(image,blobs{k},dmap,roi,features_kind);
            %Debug:
            %if blob_feature.Area==0
            %    Debug_inf.image=image;
            %    Debug_inf.mask=blobs{k};
            %end
            %end Debug
            blob_feature=gather_frame_feature(blob_feature,features_kind);
            if(any( isnan(blob_feature)~=0 ))
                continue;
            end
            blob_gt=count_blob_person(blobs,fgt.frame{j}.loc,image_size);
            blob_data.features=[blob_data.features;blob_feature];
            blob_data.gt=[blob_data.gt;blob_gt(k)];
            
        end
    end
    save([savepath,sprintf('%03d',i)],'blob_data');
end

%save('D:\lab\People_Counting\blob_feat_Debug','Debug_inf');