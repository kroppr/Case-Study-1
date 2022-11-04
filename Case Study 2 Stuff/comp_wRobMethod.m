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
Af = [0 0 0 1 1 1 1];                           % Copied from base_sir_fit. Don't think parameters causing issue.
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

seg2 = coviddata(101:125, :);
fun2= @(x)siroutput(x,t,seg2);
params2 = [0 0 0 New1(1) New1(2) New1(3) New1(4)];
x2 = fmincon(fun2, params2, A, b, Af, bf, lb, ub);
Y_fit_2 = siroutput_full(x2, t);    

New2(1) = Y_fit_2(25, 1);
New2(2) = Y_fit_2(25, 2);
New2(3) = Y_fit_2(25, 3);
New2(4) = Y_fit_2(25, 4); 

%% Third Segment
t = 50;                                         % Next 50 days: descent from peak

seg3 = coviddata(126:175, :);
fun3= @(x)siroutput(x,t,seg3);
params2 = [0 0 0 New2(1) New2(2) New2(3) New2(4)];
x2 = fmincon(fun2, params2, A, b, Af, bf, lb, ub);
Y_fit_3 = siroutput_full(x2, t);    

New3(1) = Y_fit_3(50, 1);
New3(2) = Y_fit_3(50, 2);
New3(3) = Y_fit_3(50, 3);
New3(4) = Y_fit_3(50, 4); 

%% Plot
Y_fit = cat(1,Y_fit_1,Y_fit_2,Y_fit_3);         % Put 3 fits together

plot(1-Y_fit(:,1));                               % Plot the stuff
plot(Y_fit(:,4));
legend('deaths','infected','minfections','mdeaths');
title('Plot with first three segment fits')
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
