%This code is to get how many people in each frame in vidf(only first 4000 frame).
clear

%===================basic settings:

datapath='D:\lab\People_Counting\UCSD_data\gt\vidf\';%the path of thee groundtruth of vidf
savepath='D:\lab\People_Counting\vidf_Y';


%================================

%the_location_before=pwd;
%cd(datapath);
addpath(datapath);
Y=[];
for i = 0:19
    if i<10
        path=strcat('vidf1_33_00',int2str(i),'_count_2K_roi_mainwalkway'); 
    else
        path=strcat('vidf1_33_0',int2str(i),'_count_2K_roi_mainwalkway');
    end
    load(path);
    %for j=1:200
    Y=cat(1,Y,cgt.count{3}');
    %end
end
rmpath(datapath);
save(savepath,'Y');

