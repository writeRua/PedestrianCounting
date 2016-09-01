function [ rgb_image ] = gray2rgb( gray_image )
%To convert gray image into rgb_image.

rgb_image=cat(3,gray_image,gray_image,gray_image);


end

