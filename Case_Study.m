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


collect2 = zeros(225,5);
i = 0;
while i < size(CNTY_COVID, 1)
   j = 0;
   i = i + 1;
   val2 = maxk(CNTY_COVID(i,:), 4);
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





