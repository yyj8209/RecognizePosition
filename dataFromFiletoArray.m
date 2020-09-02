function [Array1,Array2,Array3,DataPath] = dataFromFiletoArray(SignalWidth,MaxTargetNum)
    % % ѡ�������ļ�·��
    FolderName = uigetdir('..\OriginDat','��ѡ�������ļ�·����');   
    % FolderName = 'E:\matlab\OriginDat\20190305';    % ����ʱ�����Ĭ��·����
    A = dir(fullfile(FolderName,'*.dat'));
    % %�б�ѡ��Ի���
    AllFileNames = cell(size(A));
    for i=1:size(A,1)
        AllFileNames{i,1} = A(i,1).name;
    end
    [Sel,Ok]=listdlg('liststring',AllFileNames,...
        'listsize',[360 480],'OkString','ȷ��','CancelString','ȡ��',...
        'promptstring','��ѡ�������ļ�','name','��ѡ�������ļ�����ѡ��',...
        'selectionmode','multiple');
    if(Ok == 0)
        msgbox('��ȡ����ѡ���ļ���');
        return;
    end
    FileName = A(Sel,1);
    FullName = A(Sel,1);
    FileNumSel = size(FileName,1);
    Array = cell(size(FileName));
    DataPath = [];

    for k=1:FileNumSel
        FullName(k,1).name = strcat(FolderName,'\', FileName(k,1).name);
        DataPath(k).filename = FileName(k,1).name;
        DataPath(k).fullname = FullName(k,1).name;
    end

%     Fpass = 1;   Fstop = 5;  fs = 100; rpL = 1; rsL = 60;
%     [bL,~] = LPFDesign(Fpass,Fstop,fs,rpL,rsL);
    load('.\Settings\LPFParameter.mat');     % �����˲���ϵ����
    count = zeros(size(FileName));
    MeanValue = zeros(3,FileNumSel);
    for i = 1:FileNumSel
    % 1����ȡǰ���У���������Чͨ�������ݣ�
    % ----------------------------------------------------------------- %
        fid = fopen(FullName(i,1).name);
        fseek(fid,0,'eof');
        filelength = ftell(fid);
        fseek(fid,0,'bof');
        [A,count(i)]=fread(fid,(filelength)/4,'float32');
        fclose(fid);
        A = reshape(A,6,count(i)/6);
        x = ([A(1,:);A(2,:);A(3,:)])*5000/32768;

        y = zeros(size(x));
        for k1 = 3:-1:1     % x ��3��ͨ��������������ɡ�
            x1 = x(k1,:);
            % ����һ��ȥ������ĺ������ٶ����ֻ��һ�����壩������˼·�ǣ���Ծ����200ʱ��ȷ���õ�Ϊ���壬ȥ��֮��2019.03.19
            [loc] = find(abs(diff(x1))>200);   % 
            if(~isempty(loc))     % ����ȥ����㡣���ж��������find������
                x1(loc+1) = x1(loc+3);
            end
            x2 = x1 - mean(x1);      % ȥֱ����

            y1 = [zeros(1,length(bL)),x2,zeros(1,length(bL))];    % �˲������źŵ���β�������䣬���ü����ݷ�������
            y2 = filtfilt(bL,1,y1);                               % ���е�ͨ�˲�
            y3 = y2(length(bL)+1:length(y2)-length(bL));
            y(k1,:) = y3 - mean(y3) + mean(x1);    % ����һ���Ѿ��ָ����źš�
            [~,MeanValue(k1,i),~,~] = peakValue(y(k1,:),SignalWidth,MaxTargetNum);
        end
        Array{i} = {y};
    end
    Array1 = zeros(FileNumSel,max(count)/6);     % ��ÿ�����ݳ��Ȳ�һ��ȡ���ֵ��Ϊ���ȣ�����Ĳ��㡣
    Array2 = Array1;
    Array3 = Array1;
    for i = 1:FileNumSel
        tmp = cell2mat(Array{i,1});
        [n] = size(tmp,2);
        Array1(i,1:n) = tmp(1,:);
        Array1(i,n:end) = MeanValue(1,i);
        Array2(i,1:n) = tmp(2,:);
        Array2(i,n:end) = MeanValue(2,i);
        Array3(i,1:n) = tmp(3,:);
        Array3(i,n:end) = MeanValue(3,i);
    end
end