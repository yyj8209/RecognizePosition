function [Lat,Lon] = UTM2LatLon(UTME,UTMN,Lat0,Lon0)

% a = 6378.137; e = 0.0818192; k0 = 0.9996; E0 = 500; N0 = 0;
% ZoneNum = fix(Lon/6)+31;
% Lamda0 = (ZoneNum - 1)*6 -180+ 3;
% Lamda0 = Lamda0*pi/180;
% Phi = Lat*pi/180;
% Lamda = Lon*pi/180;

% Lon0 = 117.303702;    % �ٶ����� ����ص㡣
% Lat0 = 31.951895;

R = 6371*1e3;
L = 2*pi*R;
Unit = pi/180;
L0 = L*cos(Lat0*Unit);

UnitLength2Longtitude = 360/L0;    % 1�׵ľ��Ȳ�
UnitLength2Latitude = 360/L;       % 1�׵�γ�Ȳ�
% UnitLength2Longtitude = L0/360;    % 1�����ȵĳ���
% UnitLength2Latitude = L/360;       % 1��γ�ȵĳ���

DeltaLon = UTME*UnitLength2Longtitude;
DeltaLat = UTMN*UnitLength2Latitude;

Lat = Lat0 + DeltaLat;
Lon = Lon0 + DeltaLon;

