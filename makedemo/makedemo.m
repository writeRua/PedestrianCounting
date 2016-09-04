%To make demo for PedestrianCounting using GP

clear

%===============basic settings:
imagepath='D:\lab\People_Counting\UCSD_data\vidf_first4000\video'; %the path of the fileset that countains images of the dataset
maskpath='D:\lab\People_Counting\UCSD_data\vidf_first4000\segm'; %the path of the fileset that countains masks of the dataset
gt_path='D:\lab\People_Counting\UCSD_data\gt\vidf'; %The path which contains all the groundtruth data.
demopath='D:\lab\People_Counting\MyDemo.avi'; %the path to save demo
load('D:\lab\People_Counting\gpm\gpm1.mat'); %load gpm
addpath('D:\lab\People_Counting\ucsdpeds_feats\features'); %path of gp_train.m and gp_predict.m
run('D:\lab\People_Counting\ucsdpeds_feats\gpml-matlab-v3.4-2013-11-11\startup.m');%To initialize gpml library.

load('D:\lab\People_Counting\UCSD_data\gt\vidf_dmap'); %load dmap;
dmap=dmap.pmapxy;

load('D:\lab\People_Counting\UCSD_data\gt\vidf_roi'); %load roi of vidf
roi=roi.mask;

addpath('D:\lab\People_Counting\code\NewFeatureExtraction'); %the path of code for FeatureExtraction
addpath('D:\lab\People_Counting\code\train_gp');%the path of code for dealing with blobs, like get_blob_mask.m and count_blob_person.m

range=14:19;  %which part of the dataset is to be dealt with. Dataset vidf has parts 0-19.(Actually more parts. But only these parts have groundtruth.) 
%range=19;
image_size=[158,238];
colors={[0,0,255],[0,255,0],[255,0,0],[0,255,255],[255,0,255],[255,255,0]};

feature_kind={'Area','Perimeter','PerimeterOrientation','Ratio','Edge','EdgeOrientation','FractalDim','GLCM'};

colorbar_basecolor={[0,255,0],[0,255,255],[0,0,255],[255,0,255],[255,0,0]}; %see base_color in num2color.m
colorbar_basenum={0,5,10,15,20}; %see base_num in num2color.m
colorbar=imread('D:\lab\People_Counting\colorbar.png');


vw=VideoWriter(demopath);
vw.FrameRate=20;





%===============
last_blobs={};
last_blob_color=[];

open(vw);
for i =range
    load( strcat(gt_path,'\vidf1_33_',sprintf('%03d',i),'_frame_full.mat') );
    load( strcat(gt_path,'\vidf1_33_',sprintf('%03d',i),'_count_2K_roi_mainwalkway.mat') );
    imagepath_temp=strcat(imagepath,'\vidf1_33_',sprintf('%03d',i),'.y');
    maskpath_temp=strcat(maskpath,'\vidf1_33_',sprintf('%03d',i),'.segm');
    for j=1:200
        disp(['Dealing with file ',num2str(i),', frame ',num2str(j)]);
        %image=imread( sprintf('%s \vidf1_33_%03d_f%03d.png',imagepath_temp,i,j) );
        %image=imread( strcat(imagepath_temp,'\vidf1_33_',sprintf('%03d',i),'_f',sprintf('%03d',j)),'.png' );
        image=imread( strcat(imagepath_temp,'\vidf1_33_',sprintf('%03d',i),'_f',sprintf('%03d',j),'.png') );
        %mask=imread( sprintf('%s\vidf1_33_%03d_f%03d.png',maskpath_temp,i,j) );
        mask=imread( strcat(maskpath_temp,'\vidf1_33_',sprintf('%03d',i),'_f',sprintf('%03d',j),'.png') );
        
        %======compute how to allocate colors for blobs in one frame.
        blobs=get_blob_mask(mask);
        blob_color=blob_color_allocate(blobs,last_blobs,last_blob_color,length(colors));
        last_blobs=blobs;
        last_blob_color=blob_color;
       
        
        %======get groundtruth and prediction.
        total_gt=cgt.count{3}(j);
        blob_gt=count_blob_person(blobs,fgt.frame{j}.loc,image_size);
        total_predict=predict_by_GP( gpm,image,mask,dmap,roi,feature_kind );
        blob_predict=zeros(length(blobs),1);
        for k=1:length(blobs)
            blob_predict(k)=predict_by_GP( gpm,image,blobs{k},dmap,roi,feature_kind );
            if isnan(blob_predict(k))
                blob_predict(k)=0;
            end
        end
        %for(k=1:length(blobs))
        %    if isnan(blob_predict(k))
        %        blob_predict(k)=0;
        %    end
        %end
        
        %======to make image1
        image1=gray2rgb(image);
        for k=1:length(blobs)
            image1=put_color_on(image1,blobs{k},colors{blob_color(k)});
        end
        text=['Truth:',num2str(total_gt),sprintf('\n'),'Pred:',num2str(total_predict)];
        image1=write_text_to_image(image1,text,[255,0,0],[1,1],15);
        
        %======to make image2
        image2=zeros([image_size,3],'uint8');
        for k=1:length(blobs)
            image2=dye(image2,blobs{k},colors{blob_color(k)});
        end
        
        %======to make image3
        image3=zeros([image_size,3],'uint8');
        for x=1:image_size(1)
            for y=1:image_size(2)
                image3(x,y,:)=colorbar_basecolor{1};
            end
        end
        for k=1:length(blobs)
            image3=dye(image3,blobs{k},num2color(blob_gt(k),colorbar_basenum,colorbar_basecolor));
        end
        text=['Truth:',num2str(total_gt)];
        image3=write_text_to_image(image3,text,[255,0,0],[1,1],15);
        
        %======to make image4
        image4=zeros([image_size,3],'uint8');
        for x=1:image_size(1)
            for y=1:image_size(2)
                image4(x,y,:)=colorbar_basecolor{1};
            end
        end
        for k=1:length(blobs)
            image4=dye(image4,blobs{k},num2color(blob_predict(k),colorbar_basenum,colorbar_basecolor));
        end
        text=['Truth:',num2str(total_predict)];
        image4=write_text_to_image(image4,text,[255,0,0],[1,1],15);
        
        %======to make the whole image and add it to the demo
        whole_image=uint8(255)*ones(2*image_size(1)+1,2*image_size(2)+5+size(colorbar,2),3,'uint8');
        whole_image(1:image_size(1),1:image_size(2),:)=image1;
        whole_image(1:image_size(1),image_size(2)+2:2*image_size(2)+1,:)=image2;
        whole_image(image_size(1)+2:2*image_size(1)+1,1:image_size(2),:)=image3;
        whole_image(image_size(1)+2:2*image_size(1)+1,image_size(2)+2:2*image_size(2)+1,:)=image4;
        whole_image(size(whole_image,1)-size(colorbar,1)+1:size(whole_image,1),size(whole_image,2)-size(colorbar,2)+1:size(whole_image,2),:)=colorbar;
        
        
        writeVideo(vw,whole_image);
    end
end
close(vw);


