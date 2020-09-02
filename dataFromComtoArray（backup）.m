function [Array1,Array2,Array3,Direction,Angle,AccumulateDeltaY] = dataFromComtoArray(AreaData,CH1Mean,CH2Mean,CH3Mean)
% [Array1,Array2,Array3,Deriction,Angle,AccumulateDeltaY] = dataFromComtoArray(AreaData)
% ���룺AreaData ��cell���ͣ�ÿ��cell��һ���ṹ�壬���� SQNumber��Direction��Angle��Value��AccumulateDeltaY��
% ����� Array1��CH1���ݾ���,
%       Array2��CH2���ݾ���
%       Array3��CH3���ݾ���
%       Direction������������0 ��ʾ˳ʱ�룬1 ��ʾ��ʱ�룬
%       Angle���Ƕ����ݾ����Ѳ�ֵ��ϣ�
%       AccumulateDeltaY����ǰY ��ƫ��������

    if(~iscell(AreaData))
        error('������������ݸ�ʽ����ȷ��');
    end
    AreaData(1) = [];% ��һ���ǿ�Ԫ�飬ȥ����
    [Rows,Columns] = size(AreaData);
    Direction = zeros(Rows,Columns);
    AccumulateDeltaY = zeros(Rows,Columns);
    y0 = cell(3,Columns);

%     Fpass = 1;   Fstop = 5;  fs = 100; rpL = 1; rsL = 60;
%     [bL,~] = LPFDesign(Fpass,Fstop,fs,rpL,rsL);
    load('.\Settings\LPFParameter.mat');     % �����˲���ϵ����
    countValue = zeros(Rows,Columns);
    countAngle = zeros(Rows,Columns);
    ValueLen = zeros(1,Columns);
    LocYMax = zeros(1,Columns);     % ���ݷ�ֵ���λ��
    LenMax = zeros(1,Columns);     % ���ݳ���
    tmpAngle = cell(Rows,Columns);
    for i = 1:Columns
    % 1����ȡ������Чͨ�������ݣ�
    % ----------------------------------------------------------------- %
        A = AreaData{i}.Value;
        countValue(i) = size(A,2);
        A = reshape(A,6,countValue(i)/6);   % ��6·���ݣ�ֻ��ǰ����ͨ�����źš�
        x = ([A(1,:);A(2,:);A(3,:)])*5000/32768;
        y = zeros(size(x));
        for k1 = 3:-1:1     % x ��3��ͨ��������������ɡ�
            x1 = x(k1,:);
            % ����һ��ȥ������ĺ������ٶ����ֻ��һ�����壩������˼·�ǣ���Ծ����200ʱ��ȷ���õ�Ϊ���壬ȥ��֮��2019.03.19
            [loc] = find(abs(diff(x1))>500);   % 
            if(~isempty(loc))     % ����ȥ����㡣���ж��������find������
                x1(loc+1) = x1(loc+3);
            end
            x2 = x1 - mean(x1);      % ȥֱ����
            y1 = [zeros(1,length(bL)),x2,zeros(1,length(bL))];    % �˲������źŵ���β�������䣬���ü����ݷ�������
            y2 = filtfilt(bL,1,y1);                               % ���е�ͨ�˲�
            y3 = y2(length(bL)+1:length(y2)-length(bL));
            y(k1,:) = y3 - mean(y3) + mean(x1);    % ����һ���Ѿ��ָ����źš�
            y0{k1,i} = y(k1,:);
        end
        ValueLen(i) = size(y,2);
    % 2����ȡ�������ݣ�
    % ----------------------------------------------------------------- %
        Direction(i) = AreaData{i}.Direction;
    % 3����ȡY��ƫ�����ݣ�
    % ----------------------------------------------------------------- %
        AccumulateDeltaY(i) = AreaData{i}.AccumulateDeltaY;
    % 4����ȡ�Ƕ����ݣ�
    % Ϊ��ȥ��������ֹͣʱ�ĽǶȶ���
    % ----------------------------------------------------------------- %
        yAngle = AreaData{i}.Angle;
        countAngle(i) = length(yAngle);
        xAngle = 1:countAngle(i);
        xi = linspace(xAngle(1),xAngle(end),ValueLen(i));
        VibrateAngle = interp1(xAngle,yAngle,xi,'spline');   % ��ֵ�������ݳ���һ�¡�  
        x2 = [VibrateAngle(1)*ones(1,length(bL)),VibrateAngle,...
            VibrateAngle(end)*ones(1,length(bL))];    % �˲������źŵ���β�������䣬���ü����ݷ�������
        y1 = x2 - mean(x2);      % ȥֱ����
        y2 = filtfilt(bL,1,y1);                               % ���е�ͨ�˲�
        y3 = y2(length(bL)+1:length(y2)-length(bL));
        NoneVibrateAngle = y3 - mean(y3) + mean(x2);    % ����һ���Ѿ��ָ����źš�
        % �Ƕȵ��ӳٴ���
        [loc] = find(abs(diff(NoneVibrateAngle))>0.05);   % 
        Delay = loc(1)-20;
        Padding = ones(1,Delay-1)*NoneVibrateAngle(end);
        NoneDelayAngle = [NoneVibrateAngle(Delay:end),Padding];
        tmpAngle{i} = NoneDelayAngle;   % ������á�
    end

    % ============================= �������� ============================== %
    y1 = cell(3,Columns);   % ��ǰ�õ�������
    y2 = cell(3,Columns);   % ����õ�������
    CHMean = [CH1Mean CH2Mean CH3Mean];
    % ��ǰ������ݺͽǶȡ�
    for i = 1:Columns
        [~,LocYMax(i)] = min(abs(tmpAngle{i}-90));   % ��ӽ���Y��������ݵ�
    end
    [~,Locate] = max(LocYMax);
    tLoc = LocYMax(Locate) - LocYMax;    % ��Y���Ӧ���ƫ�ơ�
    for i = 1:Columns
        if(~tLoc(i)) % ���ò�����������ö��롣
            for k1 = 1:3     % x ��3��ͨ��������������ɡ�
                y1{k1,i} = y0{k1,i};
            end
            continue;
        end
        for k1 = 1:3     % x ��3��ͨ��������������ɡ�
%             vPaddingPre = mean(y0{k1,i})*ones(1,tLoc(i));
            vPaddingPre = CHMean(k1)*ones(1,tLoc(i));
            vPaddingPre(1) = vPaddingPre(1) + 1;
            vPaddingPre(2) = vPaddingPre(2) - 1;
            y1{k1,i} = [vPaddingPre,y0{k1,i}];
        end
        tmp = tmpAngle{i};
        tPaddingPre = tmp(1)*ones(1,tLoc(i));
        tmpAngle{i} = [tPaddingPre,tmp];
    end
    % ����������ݺͽǶȡ�
    for i = 1:Columns
        LenMax(i) = length(tmpAngle{i});
    end
    [~,Len] = max(LenMax);
    tLen = LenMax(Len) - LenMax;  
%     tmpAngle = cell(1,Columns);
    for i = 1:Columns
        if(~tLen(i)) % ���ò��������
            for k1 = 1:3     % x ��3��ͨ��������������ɡ�
                y2{k1,i} = y1{k1,i};
            end
            continue;
        end
        for k1 = 1:3     % x ��3��ͨ��������������ɡ�
%             vPaddingPro = mean(y0{k1,i})*ones(1,tLen(i));
            vPaddingPro = CHMean(k1)*ones(1,tLen(i));
            vPaddingPro(1) = vPaddingPro(1) + 1;
            vPaddingPro(2) = vPaddingPro(2) - 1;
            y2{k1,i} = [y1{k1,i},vPaddingPro];
        end
        tmp = tmpAngle{i};
        tPaddingPro = tmp(end)*ones(1,tLen(i));
        tmpAngle{i} = [tmp,tPaddingPro];
    end
    
    % ���Ϊ���ڴ�����Ҫ�ĸ�ʽ
    Array1 = zeros(Columns,max(LenMax));
    Array2 = Array1;
    Array3 = Array1;
    Angle = Array1;
    for i = 1:Columns
        Array1(i,:) = y2{1,i};
        Array2(i,:) = y2{2,i};
        Array3(i,:) = y2{3,i};
        Angle(i,:) = tmpAngle{i};
    end
end