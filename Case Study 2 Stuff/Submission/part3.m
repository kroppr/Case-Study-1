%% Load data and plot

data = load("mockdata_v2.mat");
infected = transpose(deal(data.InfectedProportion));    % Turn these from rows to columns
deaths = transpose(deal(data.cumulativeDeaths));
data = [infected deaths];

figure(1);
hold on;
plot(deaths);                                   % Plot actual data
plot(infected);


%% Setup

A = [0 0 0 .99 .99 .99 .99];
b = 1;
Af = [0 0 0 1 1 1 1];                           
bf = 1;
ub = [1 1 1 1 1 1 1]';
lb = [0 0 0 0 0 0 0]';
x0 = [0 0 0 1 0 0 0];

%% First Segment: Days 1-100
t = 100;
seg1 = data(1:100,:);
                 
fun1= @(x)siroutput(x,t,seg1);      
x1 = fmincon(fun1,x0,A,b,Af,bf,lb,ub); 
Y_fit_1 = siroutput_full(x1,t);

New1(1) = Y_fit_1(100, 1);
New1(2) = Y_fit_1(100, 2);
New1(3) = Y_fit_1(100, 3);
New1(4) = Y_fit_1(100, 4);        

%% Second Segment
t = 25;                                         

seg2 = data(101:125, :);
fun2= @(x)siroutput(x,t,seg2);
params2 = [0 0 0 New1(1) New1(2) New1(3) New1(4)];
x2 = fmincon(fun2, x1, A, b, Af, bf, lb, ub);
Y_fit_2 = siroutput_full(x2, t);    

New2(1) = Y_fit_2(25, 1);
New2(2) = Y_fit_2(25, 2);
New2(3) = Y_fit_2(25, 3);
New2(4) = Y_fit_2(25, 4); 

%% Third Segment
t = 50;                                         % Next 50 days: descent from peak

seg3 = data(126:175, :);
fun3= @(x)siroutput(x,t,seg3);
params3 = [0 0 0 New2(1) New2(2) New2(3) New2(4)];
x3 = fmincon(fun3, x2, A, b, Af, bf, lb, ub);
Y_fit_3 = siroutput_full(x3, t);    

New3(1) = Y_fit_3(50, 1);
New3(2) = Y_fit_3(50, 2);
New3(3) = Y_fit_3(50, 3);
New3(4) = Y_fit_3(50, 4); 

%% Fourth Segment
t = 365-175;                                         % Next 50 days: descent from peak

seg4 = data(176:365, :);
fun4= @(x)siroutput(x,t,seg4);
params3 = [0 0 0 New3(1) New3(2) New3(3) New3(4)];
x4 = fmincon(fun4, x3, A, b, Af, bf, lb, ub);
Y_fit_4 = siroutput_full(x4, t);    

%% Plot
Y_fit = cat(1,Y_fit_1,Y_fit_2,Y_fit_3,Y_fit_4);         % Put 3 fits together

diff1 = Y_fit(100,4) - Y_fit(101,4);
diff2 = Y_fit(126,4) - Y_fit(125,4);
diff3 = Y_fit(176,4) - Y_fit(175,4);

Y_fit(101:365,4) = Y_fit(101:365,4) + diff1 * ones;
Y_fit(126:365,4) = Y_fit(126:365,4) - diff2 * ones;
Y_fit(176:365,4) = Y_fit(176:365,4) - diff3 * ones;

plot(Y_fit(:,2));                               % Plot the stuff
plot(Y_fit(:,4));
legend('deaths','infected','minfections','mdeaths');
hold off;

%% Rob Sample


% %Model section for segment 1
% segment_1 = coviddata(1:100,:);
% fun1= @(x)siroutput(x,100,segment_1);
% x1 = fmincon(fun1,x0,A,b,Af,bf,lb,ub);
% Y_fit_1 = siroutput_full(x1, 100);
% 
% %determine new parameters for next segment
% New1(1) = Y_fit_1(100, 1);
% New1(2) = Y_fit_1(100, 2);
% New1(3) = Y_fit_1(100, 3);
% New1(4) = Y_fit_1(100, 4);
% 
% %model section for segment 2 using new parameters
% segment_2 = coviddata(101:250, :);
% fun2= @(x)siroutput(x,150,segment_2);
% params2 = [0 0 0 New1(1) New1(2) New1(3) New1(4)];
% x2 = fmincon(fun2, params2, A, b, Af, bf, lb, ub);
% Y_fit_2 = siroutput_full(x2, 150);