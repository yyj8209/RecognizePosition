function [Value1,Value2,Value3,Lat,Lon,Height] = readDataFromCom1(data,FrameLength)
% [Value1,Value2,Value3,Lat,Lon] = readDataFromCom1(data,FrameLength,Type)
% ���룺data Ϊ��COM2��ȡ�����ݣ�FrameLength Ϊÿһ��Э��֡�ĳ��ȣ�TypeΪ�Ƕ�������������룬LatLonΪ��γ�����룬AngleΪ�ǶȰ뾶���롣
% �����Value1,Value2,Value3���ֱ�Ϊ����ͨ������ֵ��Lat ������γ��,Lon Ϊ�����ľ��ȡ�

Value1 = [];
Value2 = [];
Value3 = [];
Lon = [];
Lat = [];
Height = [];
% Angle = [];
% Radius = [];
HeadLen = 4;
Value1Len = 4;
Value2Len = 4;
Value3Len = 4;
LonLen = 4;
LatLen = 4;
ReservedLen = 4;
R1 = HeadLen+1;
R2 = Value1Len+R1;
R3 = Value2Len+R2;
R4 = Value3Len+R3;
R5 = LonLen+R4;
R6 = LatLen+R5;
R7 = ReservedLen+R6;

HexData = dec2hex(data);
len = length(data);
HexRow = [];
for i=1:len
    HexRow = strcat(HexRow,HexData(i,:));   % һ��������
end
Index = strfind(HexRow,'55AA0120');   % ����ͷ

for k = 1:length(Index)
    if(len*2<Index(k)+FrameLength*2-1)
        continue;
    end
    c = HexRow(Index(k):Index(k)+FrameLength*2-1);   
    HexColumn = [];
    for i = 1:FrameLength
        HexColumn = vertcat(HexColumn,c(2*i-1:2*i));     % 
    end
    DecColumn = hex2dec(HexColumn);
    DecLen = length(DecColumn);
    [~,CRC16] = CRC16_MODBUS(DecColumn(1:DecLen-2));
    if(~strcmp(CRC16,HexColumn(DecLen-1:DecLen,:)))
        continue;
    end    
    Value1 = [Value1;CHValueTransform(HexColumn(R1:R2-1,:),2)];
    Value2 = [Value2;CHValueTransform(HexColumn(R2:R3-1,:),2)];
    Value3 = [Value3;CHValueTransform(HexColumn(R3:R4-1,:),2)];
    Lon = [Lon;CHValueTransform(HexColumn(R4:R5-1,:),2)];
    Lat = [Lat;CHValueTransform(HexColumn(R5:R6-1,:),2)];
    Height = [Height;CHValueTransform(HexColumn(R6:R7-1,:),2)];
end

% else
%     Angle = [Angle;LatLonTransform(HexColumn(R4:R5-1,:),2)];
%     Radius = [Radius;LatLonTransform(HexColumn(R5:R6-1,:),2)];
%     Lon = Radius.*sin((pi/2-Angle)*pi/180);     % �ٶ����ʽ����ֵ�洢��ʽһ�¡�ʵ�ʻ�Ҫ�����任�ͼӻ�׼��
%     Lat = Radius.*cos((pi/2-Angle)*pi/180);
% end