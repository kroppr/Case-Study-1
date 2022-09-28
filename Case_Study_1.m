%Case Study 1
%Covid Data Study

%Import the provided data
COVIDbyCounty = load("COVIDbyCounty.mat");

%deal it out to each variable
[CNTY_CENSUS, CNTY_COVID, dates, divisionLabels, divisionNames] = deal(COVIDbyCounty.CNTY_CENSUS, COVIDbyCounty.CNTY_COVID, COVIDbyCounty.dates, COVIDbyCounty.divisionLabels, COVIDbyCounty.divisionNames);

