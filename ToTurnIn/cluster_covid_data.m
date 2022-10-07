%% Generate test and sample matrices
% Set split variable equal to augmentation of whole data set, instead of
% "newData"
% Will have to import centroids, ref before running. Also multiply raw data
% by A before running kmeans.


split = newData;
sample = zeros(180,130);                                               % Initialize matrices for two data sets; one helps identify centroids, other is clustered
test = zeros(45,130);                                                  % using those.

i = 1;
j = 1;
k = 1;
while i <= 225
    if rem(i,5) ~= 0                                                   % Every 5th element is put into test data set, while the rest goes to sample set. Data is
        sample(j,:) = split(i,:);                                      % ordered by population, so taking data all throughout the whole is necessary for test diversity.
        j = j + 1;                                                     
    end
    if rem(i,5) == 0
        test(k,:) = split(i,:);
        k = k + 1;
    end
    i = i + 1;
end


%% Test function on 45 county test group

[IDXresult, C1] = kmeans(test,9,'start',centroids);                    % Generates the kmeans results, including cluster assignment for each index

i = 1;
j = 1;
total = 0;
while i <= 45
    if IDXresult(i,1) == ref(1,j)                                      % Loop that checks results of test kmeans against ref array, counting the number of successes
        total = total + 1;
    end
    if rem(i,5) == 0
        j = j + 1;
    end
    i = i + 1;
end