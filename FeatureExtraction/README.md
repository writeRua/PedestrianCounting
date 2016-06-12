相对于version 1,改动了接口。请大家注意哟。以后应该不会再改动接口了。
（现在先写中文的readme方便大家交流。以后等代码结构基本定型之后我回补充成中英文对照版的）



FeatureExtraction.m是提取单张图片特征的一个接口。返回值是一个结构，包含了所有特征。需要传入的参数有：
	image：图片矩阵
	masks：图片对应的mask的矩阵
	dmap：normalize map 矩阵（注意不是数据集中自带的那个struct）
	features_kind：想要求哪些特征。default={'Area','Edge','FractalDim','Perimeter','Ratio','SLF'}
	返回值：一个结构体features。成员有:Area,Edge,FractalDim,Perimeter,Ratio,SLF。


FeatureExtraction_file.m是提取一个文件夹内所有图片的特征的接口
	image:存放图片的文件夹的路径
	mask:存放mask的文件夹的路径
	dmap：normalize map 矩阵（注意不是数据集中自带的那个struct）
	features_kind：想要求哪些特征。default={'Area','Edge','FractalDim','Perimeter','Ratio','SLF'}
	返回值：一个结构体features。成员有:Area,Edge,FractalDim,Perimeter,Ratio,SLF。


FeatureExtraction_dataset.m是提取一个数据集内所有图片的特征的接口。（现在只能做UCSD的）
	image_path:存放原始数据的路径。注意该路径下应该是有一些子文件夹，每个子文件夹中存放一部分数据
	mask_path:存放数据对应的mask的路径。注意该路径下应该是有许多子文件夹，每个子文件夹中存放一部分mask
	dmap：normalize map 矩阵（注意不是数据集中自带的那个struct）
	features_kind：想要求哪些特征。default={'Area','Edge','FractalDim','Perimeter','Ratio','SLF'}
	返回值：一个结构数组features。features(i)中存放第i个子文件夹的数据对应的特征。结构体features(i)的构成与FeatureExtraction_file.m中返回的结构体的构成相同。



这个接口的形式可能比较粗糙，大家如果有更好的idea请尽管提。


Get？.m是底层的特征提取函数

boxcount.m是被底层特征提取函数调用的函数

FileLooper.m是一个循环文件夹内所有（有对应后缀名的）文件的小工具。返回值是每个文件的路径的string构成的cell。参数有:
	path:所需要循环的文件夹的路径
	suffix:匹配的后缀名。这个参数可以没有。
注意：它并不会把文件夹下的子文件夹路径给返回出来，也不会将子文件夹下的文件的路径给返回出来。


有改动的地方：
	与version 1相比，接口变了，详见上文。
	FileLooper不再需要使用者手工调用。（如果大家对这个函数都没有使用需求的话，我会把它放在FeatureExtraction_file.m中，不再暴露在外）

	把所有底层特征提取函数接受的dmap参数，由原来接受一个结构体，变为现在直接接受dmap矩阵！！！！！！
	把SLF.m更名为GetSLF.m，以与其它底层特征提取函数对应。
	GetSLF.m所需接受的参数额外增加了一个mask。
		按原来的写法，调用它的方式应该为GetSLF(image.*(mask/255));
		改动后的调用方式为GetSLF(image,mask);
	在从图像文件中读入image和mask的时候，加了一次强制类型转换（如下）以保证鲁帮性（并对于mask是logical矩阵的情形进行类额外处理）。这里是否合理有待讨论，希望大家能给点建议
		image=uint8(image);
		mask=uint8(mask);

有疑问的地方：
	通过源代码的逻辑，个人觉得GetArea.m和GetPerimeter.m的正确参数应该是(mask,map)，而不是(image,map)？？？

