%Case Study 1
%Covid Data Study

%Import the provided data
COVIDbyCounty = load("COVIDbyCounty.mat");

%deal it out to each variable
[CNTY_CENSUS, CNTY_COVID, dates, divisionLabels, divisionNames] = deal(COVIDbyCounty.CNTY_CENSUS, COVIDbyCounty.CNTY_COVID, COVIDbyCounty.dates, COVIDbyCounty.divisionLabels, COVIDbyCounty.divisionNames);

%With the data defined, we need to cluster it, I think a K of 9 fits best
%as there are 9 major sections of the United States

clustered = kmeans(CNTY_COVID, 9, 'Replicates', 25);

%make a silhouette plot to see how good we are doing
silhouette(CNTY_COVID, clustered)

values = silhouette(CNTY_COVID, clustered);


