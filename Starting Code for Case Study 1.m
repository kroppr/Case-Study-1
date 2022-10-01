CovidK=kmeans(CNTY_COVID, 9);

%CNTY_CENSUS_Cell=table2array(CNTY_CENSUS(:,4));

%CNTY_CENSUS_Double=cell2mat(CNTY_CENSUS_Cell);

CovidKvsState=cat(2,CovidK,divisionLabels);


CNTY_COVID_SCALED=CNTY_COVID;
for i=1:225
    for j=1:130
        if CNTY_COVID(i,j) < 20
        CNTY_COVID_SCALED(i,j) = 0.5*CNTY_COVID (i,j);
        end
        if 20 <= CNTY_COVID(i,j) && CNTY_COVID(i,j) < 50
        CNTY_COVID_SCALED(i,j) = 1.5*CNTY_COVID (i,j);
        end
        if 50 <= CNTY_COVID(i,j) && CNTY_COVID(i,j) < 100
        CNTY_COVID_SCALED(i,j) = 2.5*CNTY_COVID (i,j);
        end
        if 100 <= CNTY_COVID(i,j) && CNTY_COVID(i,j) < 150
        CNTY_COVID_SCALED(i,j) = 3.5*CNTY_COVID (i,j);
        end
        if 150 <= CNTY_COVID(i,j) && CNTY_COVID(i,j) < 225
        CNTY_COVID_SCALED(i,j) = 4.5*CNTY_COVID (i,j);
        end
        if 225 <= CNTY_COVID(i,j) && CNTY_COVID(i,j) < 300
        CNTY_COVID_SCALED(i,j) = 6*CNTY_COVID (i,j);
        end
        if CNTY_COVID(i,j) >= 300
        CNTY_COVID_SCALED(i,j) = 8*CNTY_COVID (i,j);
        end
    end
end

ScaledKmeans=kmeans(CNTY_COVID_SCALED,9);

figure()
silhouette(CNTY_COVID_SCALED(:,1),ScaledKmeans);

ScaledVsNormal=cat(2,ScaledKmeans,divisionLabels);