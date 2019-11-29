%convert tables of data(values = sound, values2 = accelerometer)
tt = table2array(time);
v1 = table2array(values);
v2 = table2array(values2);

%force the accelerometer data to be on the same scale as sound (0-2)
v2 = v2/10000;

%set window size of averager
windowSize = 4; 

%create variable in case of later use
a = 1;

%create vector of window size, multiplied by 
%the reciprocal to average the data
b = (1/windowSize)*ones(1,windowSize);

%plot the unfiltered data
subplot(3,1,1);
plot(tt,v2, 'r', tt, v1, 'g');
title("Unfiltered Data");
xlabel("Time(in minutes after start)");
ylabel("Amount in arbitrary units");

%v2 is accelerometer data, v1 is sound data throughout the night
legend("Accelerometer", "Sound");

%put both v1 and v2 into a filter with a windowSize averager
out1 = filter(b,a,v1);
out2 = filter(b,a,v2);

%plot the filtered data points
subplot(3,1,2);
plot(tt,out2, 'r', tt, out1, 'g');
title("Filtered with a " + windowSize + "-point averager");
xlabel("Time(in minutes after start)");
legend("Accelerometer", "Sound");

%force outTotal to be the average of both, not addition of both
outTotal = (out1+out2)/2;

%plot the combination of both previous plots
subplot(3,1,3);
plot(tt, outTotal);
title("Average of both plots");
xlabel("Time(in minutes after start)");
legend("Combination of both");



%ave is the average of the combined and filtered data
ave = mean(outTotal);

%counter of deep sleep cycles
deepSlp = 0;

%flag for upcoming for statement
current = true;

%use of a for statement to check for sleep cycles 
for i = 1:length(outTotal)
    %if the data at i dips below the average
    if outTotal(i) < ave
        %we run this code only if we haven't 
        %already since the drop below average
        if current == false
            %add one to sleep counter
            deepSlp = deepSlp + 1;
            
            %this flag means we have already added to 
            %deepSlp once this cycle.
            current = true;  
        end
    else
        %flag is set to false if the data point is above average
        current = false;
    end
end

%displays the calculated number of sleep cycles
disp("The amount of deep sleep cycles was: " + deepSlp);