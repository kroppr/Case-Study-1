%% First file

data = load('COVIDbyCounty.mat');
[dates, CNTY_CENSUS,CNTY_COVID, divisionLabels, divisionNames] = deal(data.dates, data.CNTY_CENSUS, data.CNTY_COVID, data.divisionLabels, data.divisionNames);

collect = zeros(225,2);
i = 0;
while i < size(CNTY_COVID, 1)
   j = 0;
   i = i + 1;
   val = max(CNTY_COVID(i,:));
   while j < size(CNTY_COVID, 2)
       j = j + 1;
       if CNTY_COVID(i,j) == val
           collect(i,:) = [i j];
       end
   end
end



%%      PLOT STUFF

n = 1;
while n < 10
    figure(n);                          %New figure for each iteration
    i = 1;
    while i <= size(divisionLabels,1)   %Runs until i exceeds 226, the size of our dataset
        if divisionLabels(i,1) == n     %Checks to make sure the region assignment matches the current plot number
            hold on                     %Holds this plot state so subsequent "plot" commands don't overwrite plot data
            disp([n i])                 %Shows which indeces correspond to which plot
            plot(CNTY_COVID(i,:));      %Plots the ith entry of covid data, knowing its region matches plot number
        end
        i = i + 1;                      %Runs through all 225, could make it more efficient but runs pretty quick already
        hold off                        %Turn "hold" off, not sure this is necessary given we define new figure but oh well
    end
    n = n + 1;
end



%%

% region1 = CNTY_COVID(1:25,:);
% ave1 = mean(region1,1);
% region2 = CNTY_COVID(26:50,:);
% ave2 = mean(region2,1);
% region3 = CNTY_COVID(51:75,:);
% ave3 = mean(region3,1);
% region4 = CNTY_COVID(76:100,:);
% ave4 = mean(region4,1);
% region5 = CNTY_COVID(101:125,:);
% ave5 = mean(region5,1);
% region6 = CNTY_COVID(126:150,:);
% ave6 = mean(region6,1);
% region7 = CNTY_COVID(151:175,:);
% ave7 = mean(region7,1);
% region8 = CNTY_COVID(176:200,:);
% ave8 = mean(region8,1);
% region9 = CNTY_COVID(201:225,:);
% ave9 = mean(region9,1);


i = 1;
maxes = [];
while i <= sz
    arr = CNTY_COVID(i,:);
    m = max(arr);
    idx = find(CNTY_COVID(i,:) == m,1);
    maxes(end + 1) = idx;
    i = i + 1;
    if rem(i,26) == 0
        disp(mean(maxes))
        maxes = [];
    end
end
disp(mean(maxes))


% figure(10);
% plot(ave1);
% hold on
% plot(ave2);
% plot(ave3);
% plot(ave4);
% plot(ave5);
% plot(ave6);
% plot(ave7);
% plot(ave8);
% plot(ave9);
% legend("1","2","3","4","5","6","7","8","9");
% hold off

%%


scale = 100;

table = cat(1,ave1,ave2,ave3,ave4,ave5,ave6,ave7,ave8,ave9);








