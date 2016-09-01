function [ new_image ] = put_color_on( image,roi,color )
%Ahh, I'sorry that I can't think up a name suit for this function.
%Anyway this function is to change the specific channel(rgb_channel).
%If the r(g,b) channel is >0, then change the r(g,b) channel in roi to the same as color's r(g,b) channel.

for i=1:3
    if color(i)==0
        continue;
    end
    temp=image(:,:,i);
    for j=find(roi>0)
        temp(j)=color(i);
    end
    image(:,:,i)=temp;
end
new_image=image;

end

