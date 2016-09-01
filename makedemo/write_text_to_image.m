function [ new_image ] = write_text_to_image( image,text,color,location,size )
%To write text on the aim image.
%color: the text color in the image
%location: the text location in the image
%size: the text size in the image

text=vision.TextInserter(text);
text.Color=color;
text.FontSize=size;
text.Location=location;
new_image=step(text,image);

end

