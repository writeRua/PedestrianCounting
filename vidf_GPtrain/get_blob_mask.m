function [ blobs ]=get_blob_mask(mask)
%To get masks of every blob in one frame.
%blobs is a cell of gray picture.


blobs={};
shape_struct=strel('square', 3);
while find(mask>0)>0
    init_dot=find(mask>0);
    init_dot=init_dot(1);
    temp_mask=zeros(size(mask));
    temp_mask_old=zeros(size(mask));
    temp_mask(init_dot)=mask(init_dot);
    while ~isequal(temp_mask,temp_mask_old)
        temp_mask_old=temp_mask;
        temp_mask = imdilate(temp_mask,shape_struct);
        temp_mask=temp_mask.*(temp_mask==mask);
    end
    temp_mask=uint8(temp_mask);
    blobs=cat(1,blobs,temp_mask);
    mask=mask-temp_mask;
end

end