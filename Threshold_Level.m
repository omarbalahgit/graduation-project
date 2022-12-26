function level=Threshold_Level(Image)
Image=im2uint8(Image(:));
[Histogram_count,Bin_number]=imhist(Image);
i=1;
cumlative_sum=cumsum(Histogram_count);
T(i)=(sum(Bin_number.*Histogram_count))/cumlative_sum(end);
T(i)=round(T(i));
cumlative_sum_2=cumsum(Histogram_count(1:T(i)));
MBT=sum(Bin_number(1:T(i)).*Histogram_count(1:T(i)))/cumlative_sum_2(end);
cumulative_sum_3=cumsum(Histogram_count(T(i):end));
MAT=sum(Bin_number(T(i):end).*Histogram_count(T(i):end))/cumulative_sum_3(end);
i=i+1;
T(i)=round((MAT+MBT)/2);
while abs(T(i)-T(i-1))>=1
cumlative_sum_2=cumsum(Histogram_count(1:T(i)));
MBT=sum(Bin_number(1:T(i)).*Histogram_count(1:T(i)))/cumlative_sum_2(end);
cumulative_sum_3=cumsum(Histogram_count(T(i):end));
MAT=sum(Bin_number(T(i):end).*Histogram_count(T(i):end))/cumulative_sum_3(end);
i=i+1;
T(i)=round((MAT+MBT)/2);        
    Threshold=T(i);
end
level=(Threshold-1)/(Bin_number(end)-1);
end