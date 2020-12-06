function results = targetRecognizeInTable(dat,FileCoef,FileSettings)

%% �������������á�
load(FileCoef);
inputps = Coef.inputps;
w1 = Coef.w1;
b1 = Coef.b1;
w2 = Coef.w2;
b2 = Coef.b2;

load(FileSettings);
INPUTNUM    = InputLayerNum;
OUTPUTNUM   = OutputLayerNum;     % ���ࣺ4��Ϊ����š�С���š�Ŀ�ꡢ������3��Ϊ����š�С���š�Ŀ�ꡣ���ݾ��飬����������ǰʶ��   2019.05.03

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
Data = zeros(1,INPUTNUM);


    r = 5000/32768;
    x = r*dat';
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
    [PeakValue,~,~] = peakValue(Sign.*y,200,2);     % leftStart:rightEnd�ľ�ֵ����������ֵ���źŷ���⣩��
    Data(1:3) = PeakValue';
    Data(4) = PeakValue(1)/PeakValue(3);

%% �ġ�BP���������?
% ?��ѵ���õ�BP��������������źţ����ݷ���������BP���������������

% �����źŷ���
FileNumSel = 1;
input_test = Data';
inputn_test = mapminmax('apply',input_test,inputps);
fore = zeros(OUTPUTNUM,1);
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


