len = size(Data);
figure;
title('1ͨ������')
for i=1:len(2)
    hold on;
    if(mod(i,2))
        plot(Data{1,i});
    else
        plot(fliplr(Data{1,i}));
    end
    hold off;
end

figure;
title('̽ɨ�켣')
 for i=1:len(2)
    hold on;
    plot(Data{4,i},Data{5,i});
    hold off;
end
legend;