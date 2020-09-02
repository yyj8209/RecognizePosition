function [Array1,Array2,Array3,UTME,UTMN] = dataFromComtoArray3(AreaData,Lat0,Lon0)
% [Array1,Array2,Array3,Deriction,Angle,AccumulateDeltaY] = dataFromComtoArray(AreaData)
% ���ǲ��룬������ɨ���������ٵ�Ϊ��׼��������ȥ������ɨ�����ݡ�
% ���룺AreaData ��cell���ͣ�ÿ��cell��һ���ṹ�壬���� SQNumber��Direction��Angle��Value��AccumulateDeltaY��
% Direction��Angle��AccumulateDeltaY �����������ڱ������ò���
% ����� Array1��CH1���ݾ���,
%       Array2��CH2���ݾ���
%       Array3��CH3���ݾ���
%       UTME��  ���ݵ��������Xλ�ã�
%       UTMN��  ���ݵ��������Yλ�ã�

    if(~iscell(AreaData))
        error('������������ݸ�ʽ����ȷ��');
    end
    AreaData(1) = [];% ��һ���ǿ�Ԫ�飬ȥ����
    CellLen = length(AreaData);
    r = 5000/32768;

    load('.\Settings\LPFParameter.mat');     % �����˲���ϵ����
    countValue = zeros(1,CellLen);
    Data = cell(5,CellLen);   % ����ϰ��ÿ��Ϊһ������
%     countAngle = zeros(Rows,Columns);
    ValueLen = zeros(1,CellLen);
%     LocYMin = zeros(1,Columns);     % ���ݷ�ֵ���λ��
%     LenMin = zeros(1,Columns);     % ���ݳ���
%     tmpAngle = cell(Rows,Columns);
%     MeanValue = zeros(1,3);   % ���ӳ��ȵĻ�����Ҫ�õ���
    for i = 1:CellLen
    % 1����ȡ������Чͨ����λ�õ����ݣ�
    % ----------------------------------------------------------------- %
        A = double(AreaData{i}.Value)';
        countValue(i) = size(A,2);
        x = A(1:3,:)*r;
        y = zeros(size(x));
        for k1 = 3:-1:1     % x ��3��ͨ��������������ɡ�
            x1 = x(k1,:);
            % ����һ��ȥ������ĺ������ٶ����ֻ��һ�����壩������˼·�ǣ���Ծ����200ʱ��ȷ���õ�Ϊ���壬ȥ��֮��2019.03.19
            [loc] = find(abs(diff(x1))>200);   % 
            if(~isempty(loc))     % ����ȥ����㡣���ж��������find������
                x1(loc+1) = x1(loc+3);
            end
            x2 = x1 - mean(x1);      % ȥֱ����
            y1 = [x2(1)*ones(1,length(bL)),x2,x2(end)*ones(1,length(bL))];    % �˲������źŵ���β�������䣬���ü����ݷ�������
            y2 = filtfilt(bL,1,y1);                               % ���е�ͨ�˲�
            y3 = y2(length(bL)+1:length(y2)-length(bL));
            y(k1,:) = y3 - mean(y3) + mean(x1);    % ����һ���Ѿ��ָ����źš�
        end
%         [~,MeanValue,~,~] = peakValue(y,SignalWidth,MaxTargetNum);
        ValueLen(i) = size(y,2);
        Data{1,i} = y(1,:);  % ����ϰ��ÿ��Ϊһ������
        Data{2,i} = y(2,:);  % ����ϰ��ÿ��Ϊһ������
        Data{3,i} = y(3,:);  % ����ϰ��ÿ��Ϊһ������
%         [Data{4,i},Data{5,i}] = LatLon2UTM(A(4,:),A(5,:),Lat0,Lon0);    % ��ȡ��γ�ȵ����
        Data{4,i} = A(4,:);  % ����ϰ��ÿ��Ϊһ������  % ��ȡ������������
        Data{5,i} = A(5,:);  % ����ϰ��ÿ��Ϊһ������
    end

    % ============================= �������� ============================== %
    V = zeros(1,CellLen);
    LocXMin = zeros(1,CellLen);
    LenXMin = zeros(1,CellLen);
    for i = 1:CellLen   % �ҳ�X����С��Χ
        [V(i),~] = min(Data{4,i});     % ����ÿ��̽ɨ�Ĳ���������ͬ��ֻ��Ҫ����X��һ����λ��
    end
    V1max = max(V);      % ÿ��̽ɨX����Сֵ�����X����ֵ
    
    
    for i = 1:CellLen
        [~,LocXMin(i)] = min(abs(V1max - Data{4,i}));   % ��ӽ�����С������ߵ����ݵ�
    end
    [~,Locate] = min(LocXMin);
    tLoc = LocXMin - LocXMin(Locate);    % ��Y���Ӧ���ƫ�ơ�
    for i = 1:CellLen
        if(~tLoc(i)) % ���ò�����������ö��롣
            continue;
        end
        if(tLoc(i)>length(Data{4,i})/2) % ��Ҫ��ת�������
            Data{1,i}(1+tLoc(i):end) = [];  % ����ϰ��ÿ��Ϊһ������
            Data{2,i}(1+tLoc(i):end) = [];  % ����ϰ��ÿ��Ϊһ������
            Data{3,i}(1+tLoc(i):end) = [];  % ����ϰ��ÿ��Ϊһ������
            Data{4,i}(1+tLoc(i):end) = [];  % ����ϰ��ÿ��Ϊһ������
            Data{5,i}(1+tLoc(i):end) = [];  % ����ϰ��ÿ��Ϊһ������
            Data{1,i} = fliplr(Data{1,i});
            Data{2,i} = fliplr(Data{2,i});
            Data{3,i} = fliplr(Data{3,i});
            Data{4,i} = fliplr(Data{4,i});
            Data{5,i} = fliplr(Data{5,i});
        else
            Data{1,i}(1:tLoc(i)) = [];  % ����ϰ��ÿ��Ϊһ������
            Data{2,i}(1:tLoc(i)) = [];  % ����ϰ��ÿ��Ϊһ������
            Data{3,i}(1:tLoc(i)) = [];  % ����ϰ��ÿ��Ϊһ������
            Data{4,i}(1:tLoc(i)) = [];  % ����ϰ��ÿ��Ϊһ������
            Data{5,i}(1:tLoc(i)) = [];  % ����ϰ��ÿ��Ϊһ������
        end

    end
    % ����������ݺͽǶȡ�
    for i = 1:CellLen
        LenXMin(i) = length( Data{4,i}); 
    end
    [LenMin,~] = min(LenXMin);    % ��̵����顣
    tLen = LenXMin - LenMin;  
%     tmpAngle = cell(1,Columns);
    for i = 1:CellLen
        if(~tLen(i)) % ���ò��������
            continue;
        end
        Data{1,i}(1+LenMin:end) = [];  % ����ϰ��ÿ��Ϊһ������
        Data{2,i}(1+LenMin:end) = [];  % ����ϰ��ÿ��Ϊһ������
        Data{3,i}(1+LenMin:end) = [];  % ����ϰ��ÿ��Ϊһ������
        Data{4,i}(1+LenMin:end) = [];  % ����ϰ��ÿ��Ϊһ������
        Data{5,i}(1+LenMin:end) = [];  % ����ϰ��ÿ��Ϊһ������
    end
    
    % ���Ϊ���ڴ�����Ҫ�ĸ�ʽ
    Array1 = zeros(CellLen,LenMin);
    Array2 = Array1;
    Array3 = Array1;
    UTME = Array1;
    UTMN = Array1;
    for i = 1:CellLen
        Array1(i,:) = Data{1,i};
        Array2(i,:) = Data{2,i};
        Array3(i,:) = Data{3,i};
        UTME(i,:)   = Data{4,i};
        UTMN(i,:)   = Data{5,i};
    end
end