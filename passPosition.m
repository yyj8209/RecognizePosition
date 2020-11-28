function [Order] = passPosition(Lon,Lat,x,y,SequenceNumber,TotalNumber)
%[Order] = controlOrder(Lat,Lon,OrderType)
%   �˴���ʾ��ϸ˵��
% ���룺Lon��ʾ���ȣ�Lat��ʾγ�ȣ�OrderType��ʾ��������
% �����Order Ϊ��CRC16У��������

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

% ���������ʽ����ο�Э�顣
    InitialOrder = ['55';'AA';'03';'18';...    % �ֽ�ͷ
        '00';'00';'00';'00';'00';...           % ����
        '00';'00';'00';'00';'00';...           % γ��
        '00';'00';'00';'00';...                % ƽ������X
        '00';'00';'00';'00';...                % ƽ������Y 
        '00';'00';...                          % �������͡��������/����
        '00';'00';'00';'00'];                  % ����4 .
    
    InitialOrder(R1:R2-1,:) = Lon;
    InitialOrder(R2:R3-1,:) = Lat;
    InitialOrder(R3:R4-1,:) = x;
    InitialOrder(R4:R5-1,:) = y;
    InitialOrder(R5:R6-1,:) = SequenceNumber;
    InitialOrder(R6,:) = TotalNumber;

    [Order,~] = CRC16_MODBUS(hex2dec(InitialOrder));
    Order = hex2dec(Order);
end

