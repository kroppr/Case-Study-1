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
                 
fun1= @(x1)siroutput(x1,t,seg1);      
x1 = fmincon(fun1,x0,A,b,Af,bf,lb,ub); 
Y_fit_1 = siroutput_full(x1,t);

New1(1) = Y_fit_1(100, 1);
New1(2) = Y_fit_1(100, 2);
New1(3) = Y_fit_1(100, 3);
New1(4) = Y_fit_1(100, 4);        

%% Second Segment: Days 101-125
t = 25;                                         

seg2 = data(101:125, :);
fun2= @(x2)siroutput(x2,t,seg2);
params2 = [x1(1) x1(2) x1(3) New1(1) New1(2) New1(3) New1(4)];
x2 = fmincon(fun2, params2, A, b, Af, bf, lb, ub);
Y_fit_2 = siroutput_full(x2, t);    

New2(1) = Y_fit_2(25, 1);
New2(2) = Y_fit_2(25, 2);
New2(3) = Y_fit_2(25, 3);
New2(4) = Y_fit_2(25, 4); 

%% Third Segment: Days 126-199
t = 74;                                         % Next 50 days: descent from peak

seg3 = data(126:199, :);
fun3= @(x3)siroutput(x3,t,seg3);
params3 = [x2(1) x2(2) x2(3) New2(1) New2(2) New2(3) New2(4)];
x3 = fmincon(fun3, params3, A, b, Af, bf, lb, ub);
Y_fit_3 = siroutput_full(x3, t);    

New3(1) = Y_fit_3(50, 1);
New3(2) = Y_fit_3(50, 2);
New3(3) = Y_fit_3(50, 3);
New3(4) = Y_fit_3(50, 4); 

%% Fourth Segment: Days 201-365
t = 365-201;                                         % Next 50 days: descent from peak

seg4 = data(202:365, :);
fun4= @(x4)siroutput(x4,t,seg4);
params4 = [x3(1) x3(2) x3(3) New3(1) New3(2) New3(3) New3(4)];
x4 = fmincon(fun4, params4, A, b, Af, bf, lb, ub);
Y_fit_4 = siroutput_full(x4, t);    


%% Plot
Y_fit = cat(1,Y_fit_1,Y_fit_2,Y_fit_3,Y_fit_4);         % Put 3 fits together

plot(Y_fit(:,2));
plot(Y_fit(:,4));

legend('deaths','infected','minfections','mdeaths');
title('Plot With ')
hold off;

%% Figuring vaccinated and breakthrough

% Infections spike at vaccination time; call pre-vax flat percentage the standard
% infection rate. The spike appears to be directly caused by vaccinations,
% consider entire spike to be vaccinated people. INITIALLY: spike % -
% standard % = vaccinated %. THEN: vaxed individuals 4% as likely to
% contract, so the % infected after spike is [standard % * (1-vaxed) + 4% *
% standard % * vaxed.

StadardInfRate = sum(Y_fit(1:100,2))/100;

PreVax = zeros(100);
SpikeVax = Y_fit_2(:,2) - ones * StadardInfRate;
PostSpikeVax = ones*StadardInfRate - Y_fit_4(:,2);


