function [ new_image ] = dye( image,roi,color )
%To convert the color of all the pixels in 'roi' of 'image' into 'color'

new_image=image;
for x=1:size(image,1)
    for y=1:size(image,2)
        if roi(x,y)>0
            new_image(x,y,:)=color;
        end
    end
end


end

