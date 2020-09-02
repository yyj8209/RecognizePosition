function [pv,MeanValue,leftStart,rightEnd] = peakValue(y,SignalWidth,MaxTargetNum)
% function val = peakValue(varargin)
% ���ֵ�ĺ���Ҫ�Ż���

    [~,n] = size(y);
    [~,lsor] = findpeaks(y(1,:),'NPeaks',MaxTargetNum,'SortStr','descend');
    leftStart = lsor(1) - SignalWidth - 40;
    leftEnd   = lsor(1) - SignalWidth - 20;
    rightStart= lsor(1) + SignalWidth + 20;
    rightEnd  = lsor(1) + SignalWidth + 40;   % �����ź�ΪleftStart �� rightEnd ��һ�Ρ�
    if(leftStart<0)
        MeanValue = mean(y(:,rightStart:rightEnd),2);
    elseif(rightEnd>n)
        MeanValue = mean(y(:,leftStart:leftEnd),2);
    else
        MeanValue = 0.5*mean(y(:,leftStart:leftEnd),2)+ 0.5*mean(y(:,rightStart:rightEnd),2);
    end
    pv = abs(y(:,lsor(1)) - MeanValue);     % ȡ��ֵ���ĵ㡣

end 