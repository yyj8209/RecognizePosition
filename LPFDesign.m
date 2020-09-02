function [bL,NTapL] = LPFDesign(Fpass,Fstop,fs,rpL,rsL)
% function [bL,NTapL] = LPFDesign(fc,FpassL,FstopL,fs,rpL,rsL):��Ƶ�ͨ�˲���
% ���룺Fpass ͨ����,Fstop �����,fs ��������,rpL ���ڲ���(dB),rs���˥��(dB)��
% �����bL �˲���ϵ���� NTapL ��ͷ������
rp = rpL;
rs = rsL;
% fs = 8000;
f = [Fpass Fstop];
a = [1 0];
dev = [(10^(rp/20)-1)/(10^(rp/20)+1)  10^(-rs/20)];
[NTapL,fo,ao,w] = firpmord(f,a,dev,fs);
bL = firpm(NTapL,fo,ao,w);

