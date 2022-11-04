data = load("COVIDdata.mat");
COVID_STLmetro = deal(data.COVID_STLmetro);
STLmetroPopFixed=27.3714*100000;

COVID_MO_array=table2array(COVID_STLmetro(:,5:6));
COVID_MO_proportion=COVID_MO_array/STLmetroPopFixed;

coviddata = COVID_MO_proportion; % TO SPECIFY
t = 798; % TO SPECIFY

%%
A = [0 0 0 .99 .99 .99 .99];
b = 1;

Af = [0 0 0 1 1 1 1];
bf = 1;

ub = [1 1 1 1 1 1 1]';
lb = [0 0 0 0 0 0 0]';

x0 = [0 0 0 1 0 0 0]; 

%% Model each segment
%Segments to focus on:
%0-100, 101-250, 251-350, 351-500, 500-650, 651-700, 701-end

%Model section for segment 1
segment_1 = coviddata(1:100,:);
fun1= @(x)siroutput(x,100,segment_1);
x1 = fmincon(fun1,x0,A,b,Af,bf,lb,ub);
Y_fit_1 = siroutput_full(x1, 100);

%determine new parameters for next segment, NOT IN USE RIGHT NOW
New1(1) = Y_fit_1(100, 1);
New1(2) = Y_fit_1(100, 2);
New1(3) = Y_fit_1(100, 3);
New1(4) = Y_fit_1(100, 4);

%model section for segment 2 using new parameters
segment_2 = coviddata(101:250, :);
fun2= @(x)siroutput(x,150,segment_2);
%Parameters, NOT IN USE RIGHT NOW
params2 = [x1(1) x1(2) x1(3) New1(1) New1(2) New1(3) New1(4)];
x2 = fmincon(fun2, x1, A, b, Af, bf, lb, ub);
Y_fit_2 = siroutput_full(x2, 150);

New2(1) = Y_fit_2(150, 1);
New2(2) = Y_fit_2(150, 2);
New2(3) = Y_fit_2(150, 3);
New2(4) = Y_fit_2(150, 4);


segment_3 = coviddata(251:350,:);
fun3= @(x)siroutput(x,100,segment_3);
params3 = [x2(1) x2(2) x2(3) New2(1) New2(2) New2(3) New2(4)];
x3 = fmincon(fun3, x2, A, b, Af, bf, lb, ub);
Y_fit_3 = siroutput_full(x3, 100);

New3(1) = Y_fit_3(100, 1);
New3(2) = Y_fit_3(100, 2);
New3(3) = Y_fit_3(100, 3);
New3(4) = Y_fit_3(100, 4);


segment_4 = coviddata(351:500,:);
fun4= @(x)siroutput(x,150,segment_4);
params4 = [x3(1) x3(2) x3(3) New3(1) New3(2) New3(3) New3(4)];
x4 = fmincon(fun4, x3, A, b, Af, bf, lb, ub);
Y_fit_4 = siroutput_full(x4, 150);

New4(1) = Y_fit_4(150, 1);
New4(2) = Y_fit_4(150, 2);
New4(3) = Y_fit_4(150, 3);
New4(4) = Y_fit_4(150, 4);


segment_5 = coviddata(501:650,:);
fun5= @(x)siroutput(x,150,segment_5);
params5 = [x4(1) x4(2) x4(3) New4(1) New4(2) New4(3) New4(4)];
x5 = fmincon(fun5, x4, A, b, Af, bf, lb, ub);
Y_fit_5 = siroutput_full(x5, 150);

New5(1) = Y_fit_5(150, 1);
New5(2) = Y_fit_5(150, 2);
New5(3) = Y_fit_5(150, 3);
New5(4) = Y_fit_5(150, 4);

segment_6 = coviddata(651:700,:);
fun6= @(x)siroutput(x,50,segment_6);
params6 = [x5(1) x5(2) x5(3) New5(1) New5(2) New5(3) New5(4)];
x6 = fmincon(fun6, x5, A, b, Af, bf, lb, ub);
Y_fit_6 = siroutput_full(x6, 50);

New6(1) = Y_fit_6(50, 1);
New6(2) = Y_fit_6(50, 2);
New6(3) = Y_fit_6(50, 3);
New6(4) = Y_fit_6(50, 4);

segment_7 = coviddata(701:798,:);
fun7= @(x)siroutput(x,t-700,segment_7);
params7 = [x6(1) x6(2) x6(3) New6(1) New6(2) New6(3) New6(4)];
x7 = fmincon(fun7, x6, A, b, Af, bf, lb, ub);
Y_fit_7 = siroutput_full(x7, t-700);

Segmented_Fit = cat(1, Y_fit_1, Y_fit_2, Y_fit_3, Y_fit_4, Y_fit_5, Y_fit_6, Y_fit_7);

figure(1);
hold on;
plot(Segmented_Fit(:,4));
plot(coviddata(:,2));
legend('fit','real')
hold off;