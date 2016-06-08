function docs=FileLooper(path,suffix)

%This function is to loop all the documents in the file, having the same suffix as in parameters. It won't loop the documents in subfiles. It returns a cell contains all documents' path as string.

%path is a path of a file; suffix is a string,like '.png', or '.jpeg'. You need not to pass in the parameter suffix.

if (nargin==0)
	error('In FileLooper(path,suffix):Too few parameters!');
end
if (nargin>2)
	error('In FileLooper(path,suffix):Too many parameters!');
end
docs={};
i=0;
temp=dir(path);
while (i<length(temp))
	i=i+1;
	if (temp(i).isdir) 
		continue;
	end
	if(nargin==2)
		if (length(temp(i).name)<=length(suffix))
			continue;
		end
		if (~strcmp(temp(i).name(length(temp(i).name)-length(suffix):length(temp(i).name)),suffix))
			continue;
		end
	end
	docs{length(docs)+1}=strcat(path,'/',temp(i).name);
end 
