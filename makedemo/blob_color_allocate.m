function blob_color=blob_color_allocate(blobs,last_blobs,last_blob_color,total_color_kinds)
%To get which colors are used to represent the blobs in the demo.
%This function allocate the same color for the same blob in different frames.

%last_blobs: a cell, contains the blobs in the last frame.
%last_blob_color: a vector, indicating the color allocating in the last frame.
%total_color_kinds: how many kinds of colors can be used.
blob_color=zeros(length(blobs));
for i=1:length(blobs)
    temp=true;
    for j=1:length(last_blobs)
        if if_overlap(blobs{i},last_blobs{j})
            blob_color(i)=last_blob_color(j);
            temp=false;
            break;
        end
    end
    if temp
        blob_color(i)=unidrnd(total_color_kinds);
    end
end