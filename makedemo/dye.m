function [ new_image ] = dye( image,roi,color )
%To dye the specified area(roi) using the specified color.

new_image=image;
for x=1:size(image,1)
    for y=1:size(image,2)
        if roi(x,y)>0
            new_image(x,y,:)=color;
        end
    end
end


end

