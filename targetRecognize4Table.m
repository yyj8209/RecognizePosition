function results = targetRecognize4Table(app,FullName,FileName,SignalWidth,MaxTargetNum)

%% �������������á�
load(app.FileCoef);
inputps = Coef.inputps;
w1 = Coef.w1;
b1 = Coef.b1;
w2 = Coef.w2;
b2 = Coef.b2;

load(app.FileSettings);
INPUTNUM    = InputLayerNum;
OUTPUTNUM   = OutputLayerNum;     % ���ࣺ4��Ϊ����š�С���š�Ŀ�ꡢ������3��Ϊ����š�С���š�Ŀ�ꡣ���ݾ��飬����������ǰʶ��   2019.05.03
FileNumSel = size(FileName,1);

%% ��ȡ����ֵ
% ----------------- ��ÿ�������ļ�������¼������----------------- %
% 1����ȡǰ���У���������Чͨ�������ݣ�
% 2����ȡÿ��ͨ���ĵ�һ����ֵ�����ͷ����8������ֵ��'CH1','CH2','CH3','Kr','V1/V3','VAR1','VAR2','VAR3'��
% 3��
% 4��
% ----------------------------------------------------------------- %
%     Fpass = 1;   Fstop = 5;  fs = 100; rpL = 1; rsL = 60;
%     [bL,~] = LPFDesign(Fpass,Fstop,fs,rpL,rsL);
load('.\Settings\LPFParameter.mat');     % �����˲���ϵ����
% Header = {'�ļ���','CH1','CH2','CH3','Kr','V1/V3','VAR1','VAR2','VAR3'};   % 8������ֵ
Data = zeros(FileNumSel,INPUTNUM);


for i = 1:FileNumSel
% 1����ȡǰ���У���������Чͨ�������ݣ�
% ----------------------------------------------------------------- %
    fid = fopen(FullName);
    fseek(fid,0,'eof');
    filelength = ftell(fid);
    fseek(fid,0,'bof');
    [A,count]=fread(fid,(filelength)/4,'float32');
    fclose(fid);
    A = reshape(A,8,count/8);
    x = ([A(1,:);A(2,:);A(3,:)])*5000/32768;

% 2����ȡ'ͨ��1��ֵV1','ͨ��2��ֵV2','ͨ��3��ֵV3','Kr=б��1/б��2','V1/V3','��ֵEV1','EV2','����DV1','DV2'��
% ----------------------------------------------------------------- %
    y = zeros(size(x));
    Sign = 1;
    for k1 = 3:-1:1     % x ��3��ͨ��������������ɡ�
        x1 = x(k1,:);
        % ����һ��ȥ������ĺ���������˼·�ǣ���Ծ����500ʱ��ȷ���õ�Ϊ���壬ȥ��֮��2019.03.19
        [loc] = find(abs(diff(x1))>200);   % 
        if(~isempty(loc))     % ����ȥ����㡣���ж��������find������
            x1(loc+1) = x1(loc+3);
        end
        x2 = x1 - mean(x1);      % ȥֱ����

        y1 = [zeros(1,length(bL)),x2,zeros(1,length(bL))];    % �˲������źŵ���β�������䣬���ü����ݷ�������
        y2 = filtfilt(bL,1,y1);                               % ���е�ͨ�˲�
        y3 = y2(length(bL)+1:length(y2)-length(bL));
        y(k1,:) = y3 - mean(y3) + mean(x1);    % ����һ���Ѿ��ָ����źš�

        [Value] = find(y(k1,:) >  mean(x1));
        if(sum(Value)>0.5*length(y(k1,:)))
            Sign = -1;    % �ȵ���״����Ҫ��ת�����ֵ��
        end
    end
    % ��ͨ��1�����ֵ�㣬ȷ��Ϊ�о��õĵ㡣
%     [~,lsor] = findpeaks(Sign*y(1,:),'SortStr','descend');
%     pv = y(1:3,lsor(1));     % ȡ��ֵ���ĵ㡣
    [PeakValue,~,~] = peakValue(Sign.*y,SignalWidth,MaxTargetNum);     % leftStart:rightEnd�ľ�ֵ����������ֵ���źŷ���⣩��
    Data(i,1:3) = PeakValue';
    Data(i,4) = PeakValue(1)/PeakValue(3);
end

%% �ġ�BP���������?
% ?��ѵ���õ�BP��������������źţ����ݷ���������BP���������������

% �����źŷ���
input_test = Data';
inputn_test = mapminmax('apply',input_test,inputps);
fore = zeros(OUTPUTNUM,FileNumSel);
for i=1:FileNumSel  %TOTALSAMPLE
    %���������
    I    = (inputn_test(:,i)'*w1')+ b1';
    Iout =1./(1+exp(-I));

    fore(:,i)=w2'*Iout'+b2;
end
[~,OutputType]=max(fore);

%% ���б�������������溯��������������ĺ�����ʵ����ʾ��
% ��Table����ʾ
res = {'�����','С����','��','��Ŀ��'};
results = res(OutputType);


