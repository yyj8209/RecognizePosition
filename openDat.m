function data = openDat
% 格式：Value1,Value2,Value3,UTME1,UTMN1,offsetX,offsetY,Yaw
[file,path] = uigetfile('*.dat');
fid = fopen([path,file]);
fseek(fid,0,'eof');
filelength = ftell(fid);
fseek(fid,0,'bof');
[dat,~]=fread(fid,filelength/4,'float32');
A = reshape(dat,8,length(dat)/8);
data = ([A(1,:),A(2,:),A(3,:)])*5000/32768;
fclose(fid);
figure;plot(data');
legend('ch1','ch2','ch3');
figure;plot(A(4,:),A(5,:));
title(['轨迹。文件名：',file]);



