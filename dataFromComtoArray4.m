function [Array1,Array2,Array3,UTME,UTMN] = dataFromComtoArray4(AreaData)
% [Array1,Array2,Array3,UTME,UTMN] = dataFromComtoArray4(AreaData)
% 插值，以最多的数据为准，不扩展坐标范围，而是给内圈插值补齐。
% 输入：AreaData ，cell类型，每个cell是一个结构体，包含 SQNumber、Value（V1、V2、V3、UTME1、UTMN1、offsetX、offsetY、RobotYaw 共8个值）。
% 输出： Array1，CH1数据矩阵,
%       Array2，CH2数据矩阵，
%       Array3，CH3数据矩阵，
%       UTME，  数据的在坐标X位置，
%       UTMN，  数据的在坐标Y位置，

    if(~iscell(AreaData))
        error('用来成像的数据格式不正确！');
    end
    AreaData(1) = [];% 第一个是空元组，去掉。
    CellLen = length(AreaData);
    r = 5000/32768;

    load('.\Settings\LPFParameter.mat');     % 载入滤波器系数。
    countValue = zeros(1,CellLen);
    Data = cell(5,CellLen);   % 个人习惯每行为一次数据，输出的数据为5个值：V1、V2、V3、UTME、UTMN
    ValueLen = zeros(1,CellLen);
    offsetX = zeros(1,CellLen);
    offsetY = zeros(1,CellLen);
    Yaw = zeros(1,CellLen);
%     A0 = double(AreaData{1}.Value)';
%     offsetX = A0(6,1);  % 以区域探扫开始时机器人的位置为基准旋转，未考虑曲线行进
%     offsetY = A0(7,1);  % 个人习惯每行为一次数据
%     RobotYaw = A0(8,1);  % 个人习惯每行为一次数据
    for i = 1:CellLen
    % 1、读取三个有效通道及位置的数据；
    % ----------------------------------------------------------------- %
        A = double(AreaData{i}.Value)';
        countValue(i) = size(A,2);
        x = A(1:3,:)*r;
        y = zeros(size(x));
        for k1 = 3:-1:1     % x 由3个通道的数据向量组成。
            x1 = x(k1,:);
            % 增加一个去除脉冲的函数（假定最多只有一个脉冲）。基本思路是，跳跃大于200时，确定该点为脉冲，去除之。2019.03.19
            [loc] = find(abs(diff(x1))>200);   % 
            if(~isempty(loc))     % 这里去脉冲点。若有多个，可用find函数。
                x1(loc+1) = x1(loc+3);
            end
            x2 = x1 - mean(x1);      % 去直流。
            y1 = [x2(1)*ones(1,length(bL)),x2,x2(end)*ones(1,length(bL))];    % 滤波器对信号的首尾产生畸变，采用加数据法消除。
            y2 = filtfilt(bL,1,y1);               
            % 进行低通滤波
            y3 = y2(length(bL)+1:length(y2)-length(bL));
            y(k1,:) = y3 - mean(y3) + mean(x1);    % 到这一步已经恢复了信号。
        end
        ValueLen(i) = size(y,2);
        Data{1,i} = y(1,:);  % 个人习惯每行为一次数据
        Data{2,i} = y(2,:);  % 个人习惯每行为一次数据
        Data{3,i} = y(3,:);  % 个人习惯每行为一次数据
%         UTME1 = A(4,:);  % 个人习惯每行为一次数据  % 读取绝对坐标的情况
%         UTMN1 = A(5,:);  % 个人习惯每行为一次数据
%         [UTME, UTMN] = myRotate(UTME1,UTMN1,offsetX,offsetY,270-RobotYaw);    % 使之旋转到航向角为270的易处理角度，
        Data{4,i} = A(4,:);  % 个人习惯每行为一次数据  % 读取绝对坐标的情况
        Data{5,i} = A(5,:);  % 个人习惯每行为一次数据
        offsetX(i) = mean(A(6,:));    % 每一次探扫，对应一个唯一的偏移量和航向角。
        offsetY(i) = mean(A(7,:));
        Yaw(i) = mean(A(8,:));
    end

    % ============================= 整理数据 ============================== %
%     1、第一步插值
%     2、第二步Y轴对齐
%     3、每行元素个数调整到相同
    MinValue = zeros(1,CellLen);
    MaxValue = zeros(1,CellLen);
    LenofData = zeros(1,CellLen);
    for i = 1:CellLen   % 找出X的最小范围
        MinValue(i) = min(Data{4,i});     % 假设每次探扫的采样速率相同，只需要定下X的一条边位置
        MaxValue(i) = max(Data{4,i});     % 假设每次探扫的采样速率相同，只需要定下X的一条边位置
        LenofData(i) = length(Data{4,i});
    end
    MaxLength = max(LenofData);     % 采集数据点最多的一次探扫。
    
    for i = 1:CellLen   % 
%         Interval = (LenofData(i)-1)*(1:MaxLength-1)/(MaxLength-1);
        x_pre = (0:LenofData(i)-1)/(LenofData(i)-1);
        x_pro = (0:MaxLength-1)/(MaxLength-1);
        Data{1,i} = interp1(x_pre,Data{1,i},x_pro);
        Data{2,i} = interp1(x_pre,Data{2,i},x_pro);
        Data{3,i} = interp1(x_pre,Data{3,i},x_pro);
        Data{4,i} = interp1(x_pre,Data{4,i},x_pro);
        Data{5,i} = interp1(x_pre,Data{5,i},x_pro);
        if(~mod(i,2))
            Data{4,i} = fliplr(Data{4,i});   % 来/回扫时，幅值与坐标会左右相反。
            Data{5,i} = fliplr(Data{5,i});
        end
    end
    
%     % 对齐左边
%     yMaxLoc = zeros(1,CellLen);
%     for i = CellLen
%         [~, yMaxLoc(i)] = max(Data{5,i}); % 每行的Y最大值及位置，用以对准航向角270
%     end
%     [~, refLine] = min(abs(yMaxLoc - MaxLength/2));    % 探扫角度左右最对称的一次探扫。
% %     [~, leftLine] = min(yMaxLoc - MaxLength/2);    % 探扫角度左侧最小的一次探扫。
% %     [~, rightLine] = max(yMaxLoc - MaxLength/2);    % 探扫角度右侧最小的一次探扫。
%     
%     tLoc = yMaxLoc - yMaxLoc(refLine);    % 正Y轴对应点的偏移。
%     for i = 1:CellLen
%         tmp = [Data{1,i};Data{2,i};Data{3,i};Data{4,i};Data{5,i}];
%         if(tLoc(i)>0)
%             tmp(:,1:tLoc(i)) = [];  % 左侧探扫角度大就裁部分数据
%         elseif(tLoc(i)<0)
%             tmp = [repmat(tmp(:,1),1,abs(tLoc(i))),tmp];  % 右侧探扫角度大就在左侧添加部分数据
%         end
%         Data{1,i} = tmp(1,:);
%         Data{2,i} = tmp(2,:);
%         Data{3,i} = tmp(3,:);
%         Data{4,i} = tmp(4,:);
%         Data{5,i} = tmp(5,:);
% 
%     end
%     % 对齐右边
%     LenXMin = zeros(1,CellLen);
%     for i = 1:CellLen
%         LenXMin(i) = length( Data{4,i}); 
%     end
%     [LenMin,~] = min(LenXMin);    % 最短的那组。
%     tLen = LenXMin - LenMin;  
% %     tmpAngle = cell(1,Columns);
%     for i = 1:CellLen
%         if(~tLen(i)) % 不用补的情况。
%             continue;
%         end
%         tmp = [Data{1,i};Data{2,i};Data{3,i};Data{4,i};Data{5,i}];
%         tmp(:,1+LenMin:end) = [];  % 个人习惯每行为一次数据
%         Data{1,i} = tmp(1,:);
%         Data{2,i} = tmp(2,:);
%         Data{3,i} = tmp(3,:);
%         Data{4,i} = tmp(4,:);
%         Data{5,i} = tmp(5,:);
%     end

    % 输出为后期处理需要的格式
    Array1 = zeros(CellLen,MaxLength);
    Array2 = Array1;
    Array3 = Array1;
    UTME = Array1;
    UTMN = Array1;
    for i = 1:CellLen
        Array1(i,:) = Data{1,i};
        Array2(i,:) = Data{2,i};
        Array3(i,:) = Data{3,i};
        UTME(i,:) = Data{4,i};
        UTMN(i,:) = Data{5,i};
%         [UTME(i,:), UTMN(i,:)] = myRotate(Data{4,i}+offsetX(i),Data{5,i}+offsetY(i),offsetX(i),offsetY(i),270-Yaw(i));    % 使之从航向角270旋转到实际角度。
    end
end