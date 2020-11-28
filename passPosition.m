function [Order] = passPosition(Lon,Lat,x,y,SequenceNumber,TotalNumber)
%[Order] = controlOrder(Lat,Lon,OrderType)
%   此处显示详细说明
% 输入：Lon表示经度，Lat表示纬度，OrderType表示命令类型
% 输出：Order 为带CRC16校验码的命令。

    HeadLen = 4;
    LonLen = 5;
    LatLen = 5;
    xLen = 4;
    yLen = 4;
    SNLen = 1;
    TNLen = 1;
    ReservedLen = 4;
    
    R1 = HeadLen+1;
    R2 = LonLen+R1;
    R3 = LatLen+R2;
    R4 = xLen+R3;
    R5 = yLen+R4;
    R6 = SNLen+R5;
    R7 = TNLen+R6;
    R8 = ReservedLen+R7;

% 控制命令格式，请参看协议。
    InitialOrder = ['55';'AA';'03';'18';...    % 字节头
        '00';'00';'00';'00';'00';...           % 经度
        '00';'00';'00';'00';'00';...           % 纬度
        '00';'00';'00';'00';...                % 平面坐标X
        '00';'00';'00';'00';...                % 平面坐标Y 
        '00';'00';...                          % 命令类型、坐标序号/总数
        '00';'00';'00';'00'];                  % 备用4 .
    
    InitialOrder(R1:R2-1,:) = Lon;
    InitialOrder(R2:R3-1,:) = Lat;
    InitialOrder(R3:R4-1,:) = x;
    InitialOrder(R4:R5-1,:) = y;
    InitialOrder(R5:R6-1,:) = SequenceNumber;
    InitialOrder(R6,:) = TotalNumber;

    [Order,~] = CRC16_MODBUS(hex2dec(InitialOrder));
    Order = hex2dec(Order);
end

