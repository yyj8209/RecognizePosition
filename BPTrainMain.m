function BPTrainMain(app)
%% �ô���Ϊ����BP���������ʶ��
% clc
% clear
tic
h = waitbar(0,'���ڼ��㣬���Ե�...');

% һ������ѡ��͹�һ��
% ÿ������Ϊ25ά����1άά����ʶ����8άΪ�����źš�3ά���������3�ֽ�������š�Ŀ�ꡢ��
% ��ȡ180��������Ϊѵ�����ݣ�42 ��������Ϊ�������ݣ��������ݽ��й�һ������
% ��������ʶ�趨ÿ���źŵ��������ֵ�����ʶ��Ϊ1ʱ�������������Ϊ[1 0 0]��
 
%% ��������
load(app.FileSettings);
INPUTNUM    = InputLayerNum;
MIDNUM      = MiddleLayerNum;
OUTPUTNUM   = OutputLayerNum;     % ���ࣺ4��Ϊ����š�С���š�Ŀ�ꡢ������3��Ϊ����š�С���š�Ŀ�ꡣ���ݾ��飬����������ǰʶ��   2019.04.16
TRAINSAMPLE = TrainSampleNum;
TESTSAMPLE  = TestSampleNum;
TOTALSAMPLE = TRAINSAMPLE + TESTSAMPLE;
THETA       = 0.05;
% ALPHA       = 0.01;
LOOPNUM     = LoopNum;
ISRANDOM    = 1;     % 0 ��ʾTESTSAMPLE���������ڱ����

% INPUTNUM    = 8;
% MIDNUM      = 12;
% OUTPUTNUM   = 3;     % ���ࣺ4��Ϊ����š�С���š�Ŀ�ꡢ������3��Ϊ����š�С���š�Ŀ�ꡣ���ݾ��飬����������ǰʶ��   2019.04.16
% TOTALSAMPLE = 344;
% TRAINSAMPLE = 270;
% TESTSAMPLE  = TOTALSAMPLE - TRAINSAMPLE;
% THETA       = 0.05;
% ALPHA       = 0.01;
% LOOPNUM     = 600;
% ISRANDOM    = 0;     % 0 ��ʾTESTSAMPLE���������ڱ����
%% ѵ������Ԥ��������ȡ
% �����ź�
% dat = xlsread('���ݵ���20190322-080708.xls','4���Ż�����',['A2:I',num2str(TOTALSAMPLE+1)]);
dat = xlsread(FileSavePath,SheetSelected,['A2:I',num2str(TOTALSAMPLE+1)]);
% �� 1 �� TOTALSAMPLE ��������򣬱������ȡѵ��������
k = rand(1,TOTALSAMPLE);
[~,n] = sort(k);
if(~ISRANDOM)
    TestFile   = (TRAINSAMPLE+1:TOTALSAMPLE)';
else
    TestFile   = (n(TRAINSAMPLE+1:TOTALSAMPLE))';
end
% �����������
X1 = dat(:,2:INPUTNUM+1);
Ytmp = dat(:,1);
 
% �������1����� 3 ��
Y = zeros(TOTALSAMPLE,OUTPUTNUM);
if(OUTPUTNUM == 4)
    for i=1:TOTALSAMPLE
        switch Ytmp(i)
            case 1  
                Y(i,:) = [1 0 0 0];
            case 2  
                Y(i,:) = [0 1 0 0];
            case 3  
                Y(i,:) = [0 0 1 0];
            case 4  
                Y(i,:) = [0 0 0 1];
            otherwise
        end
    end
end

if(OUTPUTNUM == 3)
    for i=1:TOTALSAMPLE
        switch Ytmp(i)
            case 1  
                Y(i,:) = [1 0 0];
            case 2  
                Y(i,:) = [0 1 0];
            case 3  
                Y(i,:) = [0 0 1];
            otherwise
        end
    end
end
 
% �����ȡ TRAINSAMPLE ������Ϊѵ��������TOTALSAMPLE ������ΪԤ������
input_train  = X1(n(1:TRAINSAMPLE),:)';
output_train = Y(n(1:TRAINSAMPLE),:)';
input_test   = X1(TestFile,:)';
output_test  = Y(TestFile,:)';

% ����BP������ṹ��ʼ�� 
% ���������ź��ص�ȷ��BP������ĽṹΪ 8-25-3�������ʼ��BP������Ȩֵ����ֵ��

% �������ݹ�һ��
[inputn,inputps] = mapminmax(input_train);   % y = (ymax-ymin)*(x-xmin)/(xmax-xmin) + ymin;

% ����ṹ��ʼ��
 
%Ȩֵ��ʼ��
w1   = rands(MIDNUM,INPUTNUM);
b1   = rands(MIDNUM,1);
w2   = rands(MIDNUM,OUTPUTNUM);
b2   = rands(OUTPUTNUM,1);

waitbar(0.1,h);
%% ����BP������ѵ��
% ��ѵ������ѵ��BP�����磬��ѵ�������и�������Ԥ�������������Ȩֵ����ֵ��
% [E,w1,b1,w2,b2] = BPTrain(LOOPNUM,TRAINSAMPLE,inputn,w1,b1,w2,b2,output_train,THETA);
[E,w1,b1,w2,b2] = BPTrain_mex(LOOPNUM,TRAINSAMPLE,inputn,w1,b1,w2,b2,output_train,THETA);

t1 = toc;
waitbar(0.8,h);

%% �ġ�BP���������?
% ?��ѵ���õ�BP��������������źţ����ݷ���������BP���������������

% �����źŷ���
inputn_test = mapminmax('apply',input_test,inputps);
fore = zeros(OUTPUTNUM,TESTSAMPLE);
for i=1:TESTSAMPLE%TOTALSAMPLE
    %���������
    I    = (inputn_test(:,i)'*w1')+ b1';
    Iout =1./(1+exp(-I));

    fore(:,i)=w2'*Iout'+b2;
end

%% �塢�������
% ����ʵ�������������ͼ��չʾ׼ȷ�ʡ�
% ������������ҳ�������������
SampleType = Ytmp(TestFile);

[~,OutputType]=max(fore);
[Loc, ~] = find(OutputType'-SampleType);
TypeNum = zeros(1,OUTPUTNUM);
ErrorNum = zeros(1,OUTPUTNUM);

if(OUTPUTNUM == 4)
    for k = 1:TESTSAMPLE
        switch SampleType(k)
            case 1
                TypeNum(1) = TypeNum(1)+1;
            case 2
                TypeNum(2) = TypeNum(2)+1;
            case 3
                TypeNum(3) = TypeNum(3)+1;
            case 4
                TypeNum(4) = TypeNum(4)+1;
        end
    end
    for k = 1:length(Loc)
        switch SampleType(Loc(k))
            case 1
                ErrorNum(1) = ErrorNum(1)+1;
            case 2
                ErrorNum(2) = ErrorNum(2)+1;
            case 3
                ErrorNum(3) = ErrorNum(3)+1;
            case 4
                ErrorNum(4) = ErrorNum(4)+1;
        end
    end
end

if(OUTPUTNUM == 3)
    for k = 1:TESTSAMPLE
        switch SampleType(k)
            case 1
                TypeNum(1) = TypeNum(1)+1;
            case 2
                TypeNum(2) = TypeNum(2)+1;
            case 3
                TypeNum(3) = TypeNum(3)+1;
        end
    end
    for k = 1:length(Loc)
        switch SampleType(Loc(k))
            case 1
                ErrorNum(1) = ErrorNum(1)+1;
            case 2
                ErrorNum(2) = ErrorNum(2)+1;
            case 3
                ErrorNum(3) = ErrorNum(3)+1;        
        end
    end
end

waitbar(1,h,'�������');

%��ȷ��
% �������ͼ
ax = app.UIAxes;
plot(ax,E);

% tb = axtoolbar(ax,{'zoomin','zoomout','datacursor','restoreview'});     % axtoolbar(ax,{'zoomin','zoomout','restoreview'});
radio = 1-ErrorNum./TypeNum;
xlabel(ax,['ѵ��������',num2str(LOOPNUM),'�Σ���ʱ��',num2str(t1),' ��']);
ylabel(ax,'�������');

if(OUTPUTNUM == 4)
    title(ax,['ʶ����ȷ�ʣ� Ŀ��-->',num2str(radio(3)*100), '%',newline,...
        '�����-->',num2str(radio(1)*100),'%�� С����-->',num2str(radio(2)*100),...
        '%�� ����-->',num2str(radio(4)*100),'%']);
end

if(OUTPUTNUM == 3)
    title(ax,['ʶ����ȷ�ʣ� Ŀ��-->',num2str(radio(3)*100),'%',newline...
        '�����-->',num2str(radio(1)*100),'%�� С����-->',num2str(radio(2)*100),'%']);

end
%% ����������
% ��Ȩֵ����������溯���������������ṩ�İ�ť���档
close(h);
Coef.inputps = inputps;
Coef.w1 = w1;
Coef.b1 = b1;
Coef.w2 = w2;
Coef.b2 = b2;
setCoefFile(app,Coef);
% save('CoefFile','w1','b1','w2','b2');

% ���б�������������溯��������������ĺ�����ʵ����ʾ��
[~,t,~] = xlsread(FileSavePath,SheetSelected,['F2:F',num2str(TOTALSAMPLE+1)]);
number = (1:length(OutputType))';
filename = t(TestFile);
results = cell(length(OutputType),1);
res = {'�����','С����','��','��Ŀ��'};
for i = 1:length(OutputType)
    results{i,1} = cell2mat(res(OutputType(i)));
end
TableColumnName = {'���','�ļ���','ʶ����'};
TableData = table(number,filename,results);
setTableView(app,TableColumnName,TableData);
            
