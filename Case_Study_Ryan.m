%% Import relevant stuff

data = load('COVIDbyCounty.mat');
[dates, CNTY_CENSUS,CNTY_COVID, divisionLabels, divisionNames] = deal(data.dates, data.CNTY_CENSUS, data.CNTY_COVID, data.divisionLabels, data.divisionNames);


%% Divide covid data by region

region1 = CNTY_COVID(1:25,:);
region2 = CNTY_COVID(26:50,:);
region3 = CNTY_COVID(51:75,:);
region4 = CNTY_COVID(76:100,:);
region5 = CNTY_COVID(101:125,:);
region6 = CNTY_COVID(126:150,:);
region7 = CNTY_COVID(151:175,:);
region8 = CNTY_COVID(176:200,:);
region9 = CNTY_COVID(201:225,:);

%% Calc average of each region

ave1 = mean(region1,1);
ave2 = mean(region2,1);
ave3 = mean(region3,1);
ave4 = mean(region4,1);
ave5 = mean(region5,1);
ave6 = mean(region6,1);
ave7 = mean(region7,1);
ave8 = mean(region8,1);
ave9 = mean(region9,1);

%% Calc standard deviation of each timepoint by region

S1 = std(region1,0,1);
S2 = std(region2,0,1);
S3 = std(region3,0,1);
S4 = std(region4,0,1);
S5 = std(region5,0,1);
S6 = std(region6,0,1);
S7 = std(region7,0,1);
S8 = std(region8,0,1);
S9 = std(region9,0,1);

comp = cat(1,S1,S2,S3,S4,S5,S6,S7,S8,S9);
all = std(comp,0,1);
[maxes,idxs] = maxk(all,10);

%% METHOD 1
% Generate ratio proportional to STDV of region 'x' divided by sum of STDVs
% of all other regions. Idea is small STDV makes ratio smaller, large STDVs
% for other regions makes ratio smaller. We want the indices with small
% values.

targetIDXs = zeros(9,130);

i = 1;
while i <= 9
    j = 1;
    while j <= 130
        targetIDXs(i,j) = comp(i,j) * 8 / (sum(comp(:,j)) - comp(i,j));
        j = j + 1;
    end
    i = i + 1;
end

[targets,mins] = mink(targetIDXs,20,2);

uniques = unique(mins);

%% Generating identity matrix that targets particular indeces

oddID = zeros(130,130);

i = 1;
while i <= size(uniques)
    oddID(uniques(i),uniques(i)) = 1;
    i = i + 1;
end

%% Multiplies data by this new identity matrix

newData = CNTY_COVID;

sz = 225;
i = 1;
while i <= sz
    ele = newData(i,:);
    newData(i,:) = ele * oddID;
    i = i + 1;
end


%% Generate test and sample matrices

split = CNTY_COVID;
sample = zeros(180,130);
test = zeros(45,130);

i = 1;
j = 1;
k = 1;
while i <= 225
    if rem(i,5) ~= 0
        sample(j,:) = split(i,:);
        j = j + 1;
    end
    if rem(i,5) == 0
        test(k,:) = split(i,:);
        k = k + 1;
    end
    i = i + 1;
end


%% Run Kmeans

[indeces, centroids] = kmeans(sample,9);

ref = zeros(1,9);
i = 1;
while i <= 9
    ref(1,i) = mode(indeces(((i-1)*20 + 1):i*20,1));
    i = i + 1;
end




%% Test function

[IDXresult, C] = kmeans(test,9,'start',centroids);

i = 1;
j = 1;
total = 0;
while i <= 45
    if IDXresult(i,1) == ref(1,j)
        total = total + 1;
    end
    if rem(i,5) == 0
        j = j + 1;
    end
    i = i + 1;
end



