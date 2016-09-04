The branch 'makedemo' is used to make a demo for GP on dataset vidf.

================scripts:

make_color_bar.m:
    To make a picture of colorbar, which shows a mapping from color to num. You can see it on the most right side of the demo.
    The mapping satisfy the property below:
        It maps the base_color to the corresponding base_num.
        It's linearly fitted between every pair of neighboring base points. 


makedemo.m:
    To make a demo for PedestrianCounting using GP.
    To run it, you should first have a colorbar(you can run make_color_bar to get it), which you can see on the most right side of the demo.


=================functions:

blob_color_allocate.m:
    To get which colors are used to represent the blobs in one frame of the demo.
    This function allocate the same color for the same blob in different frames.
        last_blobs: a cell, contains the blobs in the last frame.
        last_blob_color: a vector, indicating the color allocating in the last frame. (We use num 1,2,...,n to represent n kinds of color)
        total_color_kinds: how many kinds of colors can be used. 

dye.m:
    To dye the specified area using the specified color.

gray2rgb.m:
    To convert gray image into rgb_image.

if_overlap.m:
    To judge if there is overlap between two areas.
    We use this function to judge blobs in 2 neighboring frmae are acttualy the same blob.

num2color.m:
    It's a mapping from num to color. 
    base_num and base_color are parameters of the mapping.
    The mapping satisfy the property below:
        It maps the base_color to the corresponding base_num.
        It's linearly fitted between every pair of neighboring base points. 

put_color_on.m:
    Ahh, I'm sorry that I can't think up a suitable name for this function.
    Anyway this function is to change the specific channel(rgb_channel).
    If the r(g,b) channel is >0, then change the r(g,b) channel in roi to the same as color's r(g,b) channel.

write_text_to_image.m:
    To write text on the aim image.













