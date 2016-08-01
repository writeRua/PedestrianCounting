function [mae,mse]=error_rate(y1,y2)

mae=mean(mean(abs(y2-y1),1),2);
mse=mean(mean((y2-y1).^2,1),2);