len = size(Data);
for k=1:3
    figure;
    title([num2str(k),'ͨ������']);
    for i=1:len(2)
        hold on;
        if(mod(i,2))
            plot(Data{k,i});
        else
            plot(fliplr(Data{k,i}));
        end
        hold off;
    end
    legend;
end

figure;
title('̽ɨ�켣')
 for i=1:len(2)
    hold on;
    plot(Data{4,i},Data{5,i});
    hold off;
end
legend;