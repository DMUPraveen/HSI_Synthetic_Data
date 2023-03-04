
function [alpha,beta,delta,gama] = syngen(height,width,noofit)
%% Initiaisation 
% generating the matrices to save abundance fractions. Here I assumed two endmembers
alpha=zeros(height,width); % abundance fraction of the 1st end member
beta=zeros(height,width); % abundance fraction of the 2nd end member
delta=zeros(height,width); % abundance fraction of the 3rd end member
gama=zeros(height,width); % abundance fraction of the 4th end member
%% Padding Issue
%----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------%
%% Finding Coner Points
%let's take the cordinates (m,n) 
%The corners are (1,:),(100,:),(:,1),(:,100)
imageheight     = height;
imagewidth      = width;
noofiterations  = noofit; 
% how many iterations are we going to run have to stop overlapping

%% main loop
for l = 1:noofiterations
    %generating a random number
    x = randi([1,width]);
    y = randi([1,height]);
    random_center   = [x,y];
    disp(random_center) %-------------------------------------
    %selection whether a corner or not (1-8 different corners 9 not a corner)
    response = whichcorner(random_center(1),random_center(2),imageheight,imagewidth);
    r_all(l) = response; 
    %checking whether it is already occupied
    if alpha(random_center(1),random_center(2)) == 0
        switch response
            case 1 %north west
                %% We've to pscillate between 1 and 2.
osinit=1;
osend= 4; 
end_mem_num = (osend-osinit)*rand+osinit; % this is taken from an uniform distribution
end_mem_num=round(end_mem_num);
clear osinit osend % we don't want osinit and osend


%% generating a random number for the 1st or 2nd end-member(abundance value)
%we want to generate a number higher than or equal to 0.5 but less than or equal to 1
%this will make sure the dominate nature of an endmember in a single pixel.
if end_mem_num==1 %now it assigns abundance fractions to alpha matrix
    
rinit = 0.5;
rend = 1; 
alpha(x,y) = (rend-rinit)*rand+rinit; % force assign
beta(x,y)=(rend-alpha(x,y))*rand; %generate 2 nd endmember always lower than alpha 
sum1=alpha(x,y)+beta(x,y);% check summation exceed 1
delta(x,y)=(rend-sum1)*rand;% generate 3 rd endmember ensuring less than both alpha and beta
sum2=sum1+delta(x,y);% check summation exceed 1
gama(x,y)=1-sum2;%generate 4th endmember by ensuring the sum to 1
clear rinit rend % we don't want rinit and rend

%% Moving to the verticle direction
%step 01
% we need a random exponent for the negative exponential( exp(-e1^2),
% 0<e1<1)
% we need another random exponent (exp(-r2^2)), % we've decided to chose
% e2<e1
% to have this inequality e2=rand_mul*e1; where, rand_mul is a number which
% ranges between 0.8 and 1

%% generation of e1
e1init = 0;
e1end = 1; 
e1= (e1end-e1init)*rand+e1init;
% we don't want e1init and e1end variables
clear e1init e1end % we don't want e1init and e1end
%% generation of rand_mul
tempinit = 0.8;
tempend = 1; 
rand_mul= (tempend-tempinit)*rand+tempinit;
% we don't want tempinit and tempend variables
clear tempinit tempend
%% generation of e2
e2init = 0;
e2end = 1; 
rand_mul= (e2end-e2init)*rand+e2init;
% we don't want e2init and e2end variables
clear e2init e2end
e2=rand_mul*e1;
%% generating exponentials
%immediate_south pixel

% center pixel value assign
alphac=alpha(x,y);
betac=beta(x,y);
deltac=delta(x,y);
i=x+1;j=y;
[a,b,c,d]=para(e1,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the horizontal direction
% for this let us interchange the e1 and e2 (e1-->e2,e2-->e1)
%% generating exponentials
%immediate_right pixel
i=x;j=y+1;
[a,b,c,d]=para(e1,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j


%% moving in the main diagonal direction
% for this let's decay it as exp(-e1^3) and exp(-e2^3)
%% generating exponentials
%immediate_east_south pixel
i=x+1;j=y+1;
[a,b,c,d]=para(e2,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j

elseif end_mem_num==2 % now it assings fractions to beta matrix

rinit = 0.5;
rend = 1; 
beta(x,y) = (rend-rinit)*rand+rinit; % force assign
alpha(x,y)=(rend-beta(x,y))*rand; %generate 2 nd endmember always lower than beta
sum1=alpha(x,y)+beta(x,y);% check summation exceed 1
delta(x,y)=(rend-sum1)*rand;% generate 3 rd endmember ensuring less than both alpha and beta
sum2=sum1+delta(x,y);% check summation exceed 1
gama(x,y)=1-sum2;%generate 4th endmember by ensuring the sum to 1
%% Moving to the verticle direction
%step 01
% we need a random exponent for the negative exponential( exp(-e1^2),
% 0<e1<1)
% we need another random exponent (exp(-r2^2)), % we've decided to chose
% e2<e1
% to have this inequality e2=rand_mul*e1; where, rand_mul is a number which
% ranges between 0.8 and 1

%% generation of e1
e1init = 0;
e1end = 1; 
e1= (e1end-e1init)*rand+e1init;
% we don't want e1init and e1end variables
clear e1init e1end
%% generation of rand_mul
tempinit = 0.8;
tempend = 1; 
rand_mul= (tempend-tempinit)*rand+tempinit;
% we don't want tempinit and tempend variables
clear tempinit tempend
%% generation of e2
e2init = 0;
e2end = 1; 
rand_mul= (e2end-e2init)*rand+e2init;
% we don't want e2init and e2end variables
clear e2init e2end
e2=rand_mul*e1;
%% generating exponentials
%immediate_south pixel
% center pixel value assign
alphac=alpha(x,y);
betac=beta(x,y);
deltac=delta(x,y);
i=x+1;j=y;
[a,b,c,d]=para(e1,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j

%% moving in the horizontal direction
% for this let us interchange the e1 and e2 (e1-->e2,e2-->e1)
%% generating exponentials
%immediate_right pixel
i=x;j=y+1;
[a,b,c,d]=para(e1,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the main diagonal direction
% for this let's decay it as exp(-e1^3) and exp(-e2^3)
%% generating exponentials

%immediate_east_south pixel
i=x+1;j=y+1;
[a,b,c,d]=para(e2,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j

elseif end_mem_num==3 % now it assings fractions to delta matrix
    
rinit = 0.5;
rend = 1; 
delta(x,y) = (rend-rinit)*rand+rinit; % force assign
gama(x,y)=(rend-delta(x,y))*rand; %generate 2 nd endmember always lower than delta 
sum1=gama(x,y)+delta(x,y);% check summation exceed 1
beta(x,y)=(rend-sum1)*rand;% generate 3 rd endmember ensuring less than both gama and delta
sum2=sum1+beta(x,y);% check summation exceed 1
alpha(x,y)=1-sum2;%generate 4th endmember by ensuring the sum to 1
%% Moving to the verticle direction
%step 01
% we need a random exponent for the negative exponential( exp(-e1^2),
% 0<e1<1)
% we need another random exponent (exp(-r2^2)), % we've decided to chose
% e2<e1
% to have this inequality e2=rand_mul*e1; where, rand_mul is a number which
% ranges between 0.8 and 1

%% generation of e1
e1init = 0;
e1end = 1; 
e1= (e1end-e1init)*rand+e1init;
% we don't want e1init and e1end variables
clear e1init e1end
%% generation of rand_mul
tempinit = 0.8;
tempend = 1; 
rand_mul= (tempend-tempinit)*rand+tempinit;
% we don't want tempinit and tempend variables
clear tempinit tempend
%% generation of e2
e2init = 0;
e2end = 1; 
rand_mul= (e2end-e2init)*rand+e2init;
% we don't want e2init and e2end variables
clear e2init e2end
e2=rand_mul*e1;
%% generating exponentials
%immediate_south pixel
% center pixel value assign
alphac=alpha(x,y);
betac=beta(x,y);
deltac=delta(x,y);
i=x+1;j=y;
[a,b,c,d]=para(e1,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j

%% moving in the horizontal direction
% for this let us interchange the e1 and e2 (e1-->e2,e2-->e1)
%% generating exponentials

%immediate_right pixel
i=x;j=y+1;
[a,b,c,d]=para(e1,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the main diagonal direction
% for this let's decay it as exp(-e1^3) and exp(-e2^3)
%% generating exponentials

%immediate_east_south pixel
i=x+1;j=y+1;
[a,b,c,d]=para(e2,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j

elseif end_mem_num==4 % now it assings fractions to gama matrix
    
rinit = 0.5;
rend = 1; 
gama(x,y) = (rend-rinit)*rand+rinit; % force assign
delta(x,y)=(rend-gama(x,y))*rand;%generate 2 nd endmember always lower than gama 
sum1=gama(x,y)+delta(x,y);% check summation exceed 1
alpha(x,y)=(rend-sum1)*rand;% generate 3 rd endmember ensuring less than both gama and delta
sum2=sum1+alpha(x,y);% check summation exceed 1
beta(x,y)=1-sum2;%generate 4th endmember by ensuring the sum to 1
%% Moving to the verticle direction
%step 01
% we need a random exponent for the negative exponential( exp(-e1^2),
% 0<e1<1)
% we need another random exponent (exp(-r2^2)), % we've decided to chose
% e2<e1
% to have this inequality e2=rand_mul*e1; where, rand_mul is a number which
% ranges between 0.8 and 1

%% generation of e1
e1init = 0;
e1end = 1; 
e1= (e1end-e1init)*rand+e1init;
% we don't want e1init and e1end variables
clear e1init e1end
%% generation of rand_mul
tempinit = 0.8;
tempend = 1; 
rand_mul= (tempend-tempinit)*rand+tempinit;
% we don't want tempinit and tempend variables
clear tempinit tempend
%% generation of e2
e2init = 0;
e2end = 1; 
rand_mul= (e2end-e2init)*rand+e2init;
% we don't want e2init and e2end variables
clear e2init e2end
e2=rand_mul*e1;
%% generating exponentials
%immediate_south pixel
% center pixel value assign
alphac=alpha(x,y);
betac=beta(x,y);
deltac=delta(x,y);
i=x+1;j=y;
[a,b,c,d]=para(e1,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j

%% moving in the horizontal direction
% for this let us interchange the e1 and e2 (e1-->e2,e2-->e1)
%% generating exponentials
%immediate_right pixel
i=x;j=y+1;
[a,b,c,d]=para(e1,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the main diagonal direction
% for this let's decay it as exp(-e1^3) and exp(-e2^3)
%% generating exponentials

%immediate_east_south pixel
i=x+1;j=y+1;
[a,b,c,d]=para(e2,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
end                


            case 2 %north east
                
                
               %% We've to pscillate between 1 and 2.
osinit=1;
osend= 4; 
end_mem_num = (osend-osinit)*rand+osinit; % this is taken from an uniform distribution
end_mem_num=round(end_mem_num);
clear osinit osend % we don't want osinit and osend


%% generating a random number for the 1st or 2nd end-member(abundance value)
%we want to generate a number higher than or equal to 0.5 but less than or equal to 1
%this will make sure the dominate nature of an endmember in a single pixel.
if end_mem_num==1 %now it assigns abundance fractions to alpha matrix
    
rinit = 0.5;
rend = 1; 
alpha(x,y) = (rend-rinit)*rand+rinit; % force assign
beta(x,y)=(rend-alpha(x,y))*rand; %generate 2 nd endmember always lower than alpha 
sum1=alpha(x,y)+beta(x,y);% check summation exceed 1
delta(x,y)=(rend-sum1)*rand;% generate 3 rd endmember ensuring less than both alpha and beta
sum2=sum1+delta(x,y);% check summation exceed 1
gama(x,y)=1-sum2;%generate 4th endmember by ensuring the sum to 1
clear rinit rend % we don't want rinit and rend

%% Moving to the verticle direction
%step 01
% we need a random exponent for the negative exponential( exp(-e1^2),
% 0<e1<1)
% we need another random exponent (exp(-r2^2)), % we've decided to chose
% e2<e1
% to have this inequality e2=rand_mul*e1; where, rand_mul is a number which
% ranges between 0.8 and 1

%% generation of e1
e1init = 0;
e1end = 1; 
e1= (e1end-e1init)*rand+e1init;
% we don't want e1init and e1end variables
clear e1init e1end % we don't want e1init and e1end
%% generation of rand_mul
tempinit = 0.8;
tempend = 1; 
rand_mul= (tempend-tempinit)*rand+tempinit;
% we don't want tempinit and tempend variables
clear tempinit tempend
%% generation of e2
e2init = 0;
e2end = 1; 
rand_mul= (e2end-e2init)*rand+e2init;
% we don't want e2init and e2end variables
clear e2init e2end
e2=rand_mul*e1;
%% generating exponentials
%immediate_south pixel

% center pixel value assign
alphac=alpha(x,y);
betac=beta(x,y);
deltac=delta(x,y);
i=x+1;j=y;
[a,b,c,d]=para(e1,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the horizontal direction
% for this let us interchange the e1 and e2 (e1-->e2,e2-->e1)
%% generating exponentials
%immediate_left pixel
i=x;j=y-1;
[a,b,c,d]=para(e2,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the off-diagonal direction
% for this let's decay it as exp(-e2^3) and exp(-e1^3)
%% generating exponentials
%immediate_east_south pixel
i=x+1;j=y-1;
[a,b,c,d]=para(e1,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j

elseif end_mem_num==2 % now it assings fractions to beta matrix
rinit = 0.5;
rend = 1; 
beta(x,y) = (rend-rinit)*rand+rinit; % force assign
alpha(x,y)=(rend-beta(x,y))*rand; %generate 2 nd endmember always lower than beta
sum1=alpha(x,y)+beta(x,y);% check summation exceed 1
delta(x,y)=(rend-sum1)*rand;% generate 3 rd endmember ensuring less than both alpha and beta
sum2=sum1+delta(x,y);% check summation exceed 1
gama(x,y)=1-sum2;%generate 4th endmember by ensuring the sum to 1
%% Moving to the verticle direction
%step 01
% we need a random exponent for the negative exponential( exp(-e1^2),
% 0<e1<1)
% we need another random exponent (exp(-r2^2)), % we've decided to chose
% e2<e1
% to have this inequality e2=rand_mul*e1; where, rand_mul is a number which
% ranges between 0.8 and 1

%% generation of e1
e1init = 0;
e1end = 1; 
e1= (e1end-e1init)*rand+e1init;
% we don't want e1init and e1end variables
clear e1init e1end
%% generation of rand_mul
tempinit = 0.8;
tempend = 1; 
rand_mul= (tempend-tempinit)*rand+tempinit;
% we don't want tempinit and tempend variables
clear tempinit tempend
%% generation of e2
e2init = 0;
e2end = 1; 
rand_mul= (e2end-e2init)*rand+e2init;
% we don't want e2init and e2end variables
clear e2init e2end
e2=rand_mul*e1;
%% generating exponentials
%immediate_south pixel
% center pixel value assign
alphac=alpha(x,y);
betac=beta(x,y);
deltac=delta(x,y);
i=x+1;j=y;
[a,b,c,d]=para(e1,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the horizontal direction
% for this let us interchange the e1 and e2 (e1-->e2,e2-->e1)
%% generating exponentials
%immediate_left pixel
i=x;j=y-1;
[a,b,c,d]=para(e2,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j

%% moving in the off-diagonal direction
% for this let's decay it as exp(-e2^3) and exp(-e1^3)
%immediate_east_south pixel
i=x+1;j=y-1;
[a,b,c,d]=para(e1,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j

elseif end_mem_num==3 % now it assings fractions to delta matrix
rinit = 0.5;
rend = 1; 
delta(x,y) = (rend-rinit)*rand+rinit; % force assign
gama(x,y)=(rend-delta(x,y))*rand; %generate 2 nd endmember always lower than delta 
sum1=gama(x,y)+delta(x,y);% check summation exceed 1
beta(x,y)=(rend-sum1)*rand;% generate 3 rd endmember ensuring less than both gama and delta
sum2=sum1+beta(x,y);% check summation exceed 1
alpha(x,y)=1-sum2;%generate 4th endmember by ensuring the sum to 1
%% Moving to the verticle direction
%step 01
% we need a random exponent for the negative exponential( exp(-e1^2),
% 0<e1<1)
% we need another random exponent (exp(-r2^2)), % we've decided to chose
% e2<e1
% to have this inequality e2=rand_mul*e1; where, rand_mul is a number which
% ranges between 0.8 and 1

%% generation of e1
e1init = 0;
e1end = 1; 
e1= (e1end-e1init)*rand+e1init;
% we don't want e1init and e1end variables
clear e1init e1end
%% generation of rand_mul
tempinit = 0.8;
tempend = 1; 
rand_mul= (tempend-tempinit)*rand+tempinit;
% we don't want tempinit and tempend variables
clear tempinit tempend
%% generation of e2
e2init = 0;
e2end = 1; 
rand_mul= (e2end-e2init)*rand+e2init;
% we don't want e2init and e2end variables
clear e2init e2end
e2=rand_mul*e1;
%% generating exponentials
%immediate_south pixel
% center pixel value assign
alphac=alpha(x,y);
betac=beta(x,y);
deltac=delta(x,y);
i=x+1;j=y;
[a,b,c,d]=para(e1,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the horizontal direction
% for this let us interchange the e1 and e2 (e1-->e2,e2-->e1)
%% generating exponentials
%immediate_left pixel
i=x;j=y-1;
[a,b,c,d]=para(e2,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j

%% moving in the off-diagonal direction
% for this let's decay it as exp(-e2^3) and exp(-e1^3)
%immediate_east_south pixel
i=x+1;j=y-1;
[a,b,c,d]=para(e1,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
elseif end_mem_num==4 % now it assings fractions to gama matrix
rinit = 0.5;
rend = 1; 
gama(x,y) = (rend-rinit)*rand+rinit; % force assign
delta(x,y)=(rend-gama(x,y))*rand;%generate 2 nd endmember always lower than gama 
sum1=gama(x,y)+delta(x,y);% check summation exceed 1
alpha(x,y)=(rend-sum1)*rand;% generate 3 rd endmember ensuring less than both gama and delta
sum2=sum1+alpha(x,y);% check summation exceed 1
beta(x,y)=1-sum2;%generate 4th endmember by ensuring the sum to 1
%% Moving to the verticle direction
%step 01
% we need a random exponent for the negative exponential( exp(-e1^2),
% 0<e1<1)
% we need another random exponent (exp(-r2^2)), % we've decided to chose
% e2<e1
% to have this inequality e2=rand_mul*e1; where, rand_mul is a number which
% ranges between 0.8 and 1

%% generation of e1
e1init = 0;
e1end = 1; 
e1= (e1end-e1init)*rand+e1init;
% we don't want e1init and e1end variables
clear e1init e1end
%% generation of rand_mul
tempinit = 0.8;
tempend = 1; 
rand_mul= (tempend-tempinit)*rand+tempinit;
% we don't want tempinit and tempend variables
clear tempinit tempend
%% generation of e2
e2init = 0;
e2end = 1; 
rand_mul= (e2end-e2init)*rand+e2init;
% we don't want e2init and e2end variables
clear e2init e2end
e2=rand_mul*e1;
%% generating exponentials
%immediate_south pixel
% center pixel value assign
alphac=alpha(x,y);
betac=beta(x,y);
deltac=delta(x,y);
i=x+1;j=y;
[a,b,c,d]=para(e1,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the horizontal direction
% for this let us interchange the e1 and e2 (e1-->e2,e2-->e1)
%% generating exponentials
%immediate_left pixel
i=x;j=y-1;
[a,b,c,d]=para(e2,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the off-diagonal direction
% for this let's decay it as exp(-e2^3) and exp(-e1^3)
%% generating exponentials
%immediate_east_south pixel
i=x+1;j=y-1;
[a,b,c,d]=para(e1,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
end
clear alphac betac gamac deltac


            case 3 %spanning north w-->e
                
                
                %% We've to pscillate between 1 and 2.
osinit=1;
osend= 4; 
end_mem_num = (osend-osinit)*rand+osinit; % this is taken from an uniform distribution
end_mem_num=round(end_mem_num);
clear osinit osend % we don't want osinit and osend


%% generating a random number for the 1st or 2nd end-member(abundance value)
%we want to generate a number higher than or equal to 0.5 but less than or equal to 1
%this will make sure the dominate nature of an endmember in a single pixel.
if end_mem_num==1 %now it assigns abundance fractions to alpha matrix
    
rinit = 0.5;
rend = 1; 
alpha(x,y) = (rend-rinit)*rand+rinit; % force assign
beta(x,y)=(rend-alpha(x,y))*rand; %generate 2 nd endmember always lower than alpha 
sum1=alpha(x,y)+beta(x,y);% check summation exceed 1
delta(x,y)=(rend-sum1)*rand;% generate 3 rd endmember ensuring less than both alpha and beta
sum2=sum1+delta(x,y);% check summation exceed 1
gama(x,y)=1-sum2;%generate 4th endmember by ensuring the sum to 1
clear rinit rend % we don't want rinit and rend

%% Moving to the verticle direction
%step 01
% we need a random exponent for the negative exponential( exp(-e1^2),
% 0<e1<1)
% we need another random exponent (exp(-r2^2)), % we've decided to chose
% e2<e1
% to have this inequality e2=rand_mul*e1; where, rand_mul is a number which
% ranges between 0.8 and 1

%% generation of e1
e1init = 0;
e1end = 1; 
e1= (e1end-e1init)*rand+e1init;
% we don't want e1init and e1end variables
clear e1init e1end % we don't want e1init and e1end
%% generation of rand_mul
tempinit = 0.8;
tempend = 1; 
rand_mul= (tempend-tempinit)*rand+tempinit;
% we don't want tempinit and tempend variables
clear tempinit tempend
%% generation of e2
e2init = 0;
e2end = 1; 
rand_mul= (e2end-e2init)*rand+e2init;
% we don't want e2init and e2end variables
clear e2init e2end
e2=rand_mul*e1;
%% generating exponentials
%immediate_south pixel

% center pixel value assign
alphac=alpha(x,y);
betac=beta(x,y);
deltac=delta(x,y);
i=x+1;j=y;
[a,b,c,d]=para(e1,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j

%% moving in the horizontal direction
% for this let us interchange the e1 and e2 (e1-->e2,e2-->e1)
%% generating exponentials
%immediate_left pixel
i=x;j=y-1;
[a,b,c,d]=para(e2,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%immediate_right pixel
i=x;j=y+1;
[a,b,c,d]=para(e1,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j


%% moving in the main diagonal direction
% for this let's decay it as exp(-e1^3) and exp(-e2^3)
%% generating exponentials


%immediate_east_south pixel
i=x+1;j=y+1;
[a,b,c,d]=para(e2,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j

%% moving in the off-diagonal direction
% for this let's decay it as exp(-e2^3) and exp(-e1^3)
%% generating exponentials

%immediate_east_south pixel
i=x+1;j=y-1;
[a,b,c,d]=para(e1,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j

elseif end_mem_num==2 % now it assings fractions to beta matrix
rinit = 0.5;
rend = 1; 
beta(x,y) = (rend-rinit)*rand+rinit; % force assign
alpha(x,y)=(rend-beta(x,y))*rand; %generate 2 nd endmember always lower than beta
sum1=alpha(x,y)+beta(x,y);% check summation exceed 1
delta(x,y)=(rend-sum1)*rand;% generate 3 rd endmember ensuring less than both alpha and beta
sum2=sum1+delta(x,y);% check summation exceed 1
gama(x,y)=1-sum2;%generate 4th endmember by ensuring the sum to 1
%% Moving to the verticle direction
%step 01
% we need a random exponent for the negative exponential( exp(-e1^2),
% 0<e1<1)
% we need another random exponent (exp(-r2^2)), % we've decided to chose
% e2<e1
% to have this inequality e2=rand_mul*e1; where, rand_mul is a number which
% ranges between 0.8 and 1

%% generation of e1
e1init = 0;
e1end = 1; 
e1= (e1end-e1init)*rand+e1init;
% we don't want e1init and e1end variables
clear e1init e1end
%% generation of rand_mul
tempinit = 0.8;
tempend = 1; 
rand_mul= (tempend-tempinit)*rand+tempinit;
% we don't want tempinit and tempend variables
clear tempinit tempend
%% generation of e2
e2init = 0;
e2end = 1; 
rand_mul= (e2end-e2init)*rand+e2init;
% we don't want e2init and e2end variables
clear e2init e2end
e2=rand_mul*e1;
%% generating exponentials
%immediate_south pixel
% center pixel value assign
alphac=alpha(x,y);
betac=beta(x,y);
deltac=delta(x,y);
i=x+1;j=y;
[a,b,c,d]=para(e1,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j

%% moving in the horizontal direction
% for this let us interchange the e1 and e2 (e1-->e2,e2-->e1)
%% generating exponentials
%immediate_left pixel
i=x;j=y-1;
[a,b,c,d]=para(e2,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%immediate_right pixel
i=x;j=y+1;
[a,b,c,d]=para(e1,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the main diagonal direction
% for this let's decay it as exp(-e1^3) and exp(-e2^3)
%% generating exponentials
%immediate_east_south pixel
i=x+1;j=y+1;
[a,b,c,d]=para(e2,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the off-diagonal direction
% for this let's decay it as exp(-e2^3) and exp(-e1^3)
%% generating exponentials
%immediate_east_south pixel
i=x+1;j=y-1;
[a,b,c,d]=para(e1,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j

elseif end_mem_num==3 % now it assings fractions to delta matrix
rinit = 0.5;
rend = 1; 
delta(x,y) = (rend-rinit)*rand+rinit; % force assign
gama(x,y)=(rend-delta(x,y))*rand; %generate 2 nd endmember always lower than delta 
sum1=gama(x,y)+delta(x,y);% check summation exceed 1
beta(x,y)=(rend-sum1)*rand;% generate 3 rd endmember ensuring less than both gama and delta
sum2=sum1+beta(x,y);% check summation exceed 1
alpha(x,y)=1-sum2;%generate 4th endmember by ensuring the sum to 1
%% Moving to the verticle direction
%step 01
% we need a random exponent for the negative exponential( exp(-e1^2),
% 0<e1<1)
% we need another random exponent (exp(-r2^2)), % we've decided to chose
% e2<e1
% to have this inequality e2=rand_mul*e1; where, rand_mul is a number which
% ranges between 0.8 and 1

%% generation of e1
e1init = 0;
e1end = 1; 
e1= (e1end-e1init)*rand+e1init;
% we don't want e1init and e1end variables
clear e1init e1end
%% generation of rand_mul
tempinit = 0.8;
tempend = 1; 
rand_mul= (tempend-tempinit)*rand+tempinit;
% we don't want tempinit and tempend variables
clear tempinit tempend
%% generation of e2
e2init = 0;
e2end = 1; 
rand_mul= (e2end-e2init)*rand+e2init;
% we don't want e2init and e2end variables
clear e2init e2end
e2=rand_mul*e1;
%% generating exponentials
%immediate_south pixel
% center pixel value assign
alphac=alpha(x,y);
betac=beta(x,y);
deltac=delta(x,y);
i=x+1;j=y;
[a,b,c,d]=para(e1,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j

%% moving in the horizontal direction
% for this let us interchange the e1 and e2 (e1-->e2,e2-->e1)
%% generating exponentials
%immediate_left pixel
i=x;j=y-1;
[a,b,c,d]=para(e2,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%immediate_right pixel
i=x;j=y+1;
[a,b,c,d]=para(e1,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the main diagonal direction
% for this let's decay it as exp(-e1^3) and exp(-e2^3)
%% generating exponentials
%immediate_east_south pixel
i=x+1;j=y+1;
[a,b,c,d]=para(e2,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the off-diagonal direction
% for this let's decay it as exp(-e2^3) and exp(-e1^3)
%% generating exponentials
%immediate_east_south pixel
i=x+1;j=y-1;
[a,b,c,d]=para(e1,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
elseif end_mem_num==4 % now it assings fractions to gama matrix
rinit = 0.5;
rend = 1; 
gama(x,y) = (rend-rinit)*rand+rinit; % force assign
delta(x,y)=(rend-gama(x,y))*rand;%generate 2 nd endmember always lower than gama 
sum1=gama(x,y)+delta(x,y);% check summation exceed 1
alpha(x,y)=(rend-sum1)*rand;% generate 3 rd endmember ensuring less than both gama and delta
sum2=sum1+alpha(x,y);% check summation exceed 1
beta(x,y)=1-sum2;%generate 4th endmember by ensuring the sum to 1
%% Moving to the verticle direction
%step 01
% we need a random exponent for the negative exponential( exp(-e1^2),
% 0<e1<1)
% we need another random exponent (exp(-r2^2)), % we've decided to chose
% e2<e1
% to have this inequality e2=rand_mul*e1; where, rand_mul is a number which
% ranges between 0.8 and 1

%% generation of e1
e1init = 0;
e1end = 1; 
e1= (e1end-e1init)*rand+e1init;
% we don't want e1init and e1end variables
clear e1init e1end
%% generation of rand_mul
tempinit = 0.8;
tempend = 1; 
rand_mul= (tempend-tempinit)*rand+tempinit;
% we don't want tempinit and tempend variables
clear tempinit tempend
%% generation of e2
e2init = 0;
e2end = 1; 
rand_mul= (e2end-e2init)*rand+e2init;
% we don't want e2init and e2end variables
clear e2init e2end
e2=rand_mul*e1;
%% generating exponentials
%immediate_south pixel
% center pixel value assign
alphac=alpha(x,y);
betac=beta(x,y);
deltac=delta(x,y);
i=x+1;j=y;
[a,b,c,d]=para(e1,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j

%% moving in the horizontal direction
% for this let us interchange the e1 and e2 (e1-->e2,e2-->e1)
%% generating exponentials
%immediate_left pixel
i=x;j=y-1;
[a,b,c,d]=para(e2,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%immediate_right pixel
i=x;j=y+1;
[a,b,c,d]=para(e1,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the main diagonal direction
% for this let's decay it as exp(-e1^3) and exp(-e2^3)
%% generating exponentials
%immediate_east_south pixel
i=x+1;j=y+1;
[a,b,c,d]=para(e2,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the off-diagonal direction
% for this let's decay it as exp(-e2^3) and exp(-e1^3)
%% generating exponentials
%immediate_east_south pixel
i=x+1;j=y-1;
[a,b,c,d]=para(e1,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
end
clear alphac betac gamac deltac



            case 4 %south west
                
                
                %% We've to pscillate between 1 and 2.
osinit=1;
osend= 4; 
end_mem_num = (osend-osinit)*rand+osinit; % this is taken from an uniform distribution
end_mem_num=round(end_mem_num);
clear osinit osend % we don't want osinit and osend


%% generating a random number for the 1st or 2nd end-member(abundance value)
%we want to generate a number higher than or equal to 0.5 but less than or equal to 1
%this will make sure the dominate nature of an endmember in a single pixel.
if end_mem_num==1 %now it assigns abundance fractions to alpha matrix
    
rinit = 0.5;
rend = 1; 
alpha(x,y) = (rend-rinit)*rand+rinit; % force assign
beta(x,y)=(rend-alpha(x,y))*rand; %generate 2 nd endmember always lower than alpha 
sum1=alpha(x,y)+beta(x,y);% check summation exceed 1
delta(x,y)=(rend-sum1)*rand;% generate 3 rd endmember ensuring less than both alpha and beta
sum2=sum1+delta(x,y);% check summation exceed 1
gama(x,y)=1-sum2;%generate 4th endmember by ensuring the sum to 1
clear rinit rend % we don't want rinit and rend

%% Moving to the verticle direction
%step 01
% we need a random exponent for the negative exponential( exp(-e1^2),
% 0<e1<1)
% we need another random exponent (exp(-r2^2)), % we've decided to chose
% e2<e1
% to have this inequality e2=rand_mul*e1; where, rand_mul is a number which
% ranges between 0.8 and 1

%% generation of e1
e1init = 0;
e1end = 1; 
e1= (e1end-e1init)*rand+e1init;
% we don't want e1init and e1end variables
clear e1init e1end % we don't want e1init and e1end
%% generation of rand_mul
tempinit = 0.8;
tempend = 1; 
rand_mul= (tempend-tempinit)*rand+tempinit;
% we don't want tempinit and tempend variables
clear tempinit tempend
%% generation of e2
e2init = 0;
e2end = 1; 
rand_mul= (e2end-e2init)*rand+e2init;
% we don't want e2init and e2end variables
clear e2init e2end
e2=rand_mul*e1;
%% generating exponentials
%immediate_south pixel

% center pixel value assign
alphac=alpha(x,y);
betac=beta(x,y);
deltac=delta(x,y);
%immediate_north pixel
i=x-1;j=y;
[a,b,c,d]=para(e2,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the horizontal direction
% for this let us interchange the e1 and e2 (e1-->e2,e2-->e1)
%% generating exponentials
%immediate_right pixel
i=x;j=y+1;
[a,b,c,d]=para(e1,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the off-diagonal direction
% for this let's decay it as exp(-e2^3) and exp(-e1^3)
%% generating exponentials
%immediate_north_east pixel
i=x-1;j=y+1;
[a,b,c,d]=para(e2,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
elseif end_mem_num==2 % now it assings fractions to beta matrix
rinit = 0.5;
rend = 1; 
beta(x,y) = (rend-rinit)*rand+rinit; % force assign
alpha(x,y)=(rend-beta(x,y))*rand; %generate 2 nd endmember always lower than beta
sum1=alpha(x,y)+beta(x,y);% check summation exceed 1
delta(x,y)=(rend-sum1)*rand;% generate 3 rd endmember ensuring less than both alpha and beta
sum2=sum1+delta(x,y);% check summation exceed 1
gama(x,y)=1-sum2;%generate 4th endmember by ensuring the sum to 1
%% Moving to the verticle direction
%step 01
% we need a random exponent for the negative exponential( exp(-e1^2),
% 0<e1<1)
% we need another random exponent (exp(-r2^2)), % we've decided to chose
% e2<e1
% to have this inequality e2=rand_mul*e1; where, rand_mul is a number which
% ranges between 0.8 and 1

%% generation of e1
e1init = 0;
e1end = 1; 
e1= (e1end-e1init)*rand+e1init;
% we don't want e1init and e1end variables
clear e1init e1end
%% generation of rand_mul
tempinit = 0.8;
tempend = 1; 
rand_mul= (tempend-tempinit)*rand+tempinit;
% we don't want tempinit and tempend variables
clear tempinit tempend
%% generation of e2
e2init = 0;
e2end = 1; 
rand_mul= (e2end-e2init)*rand+e2init;
% we don't want e2init and e2end variables
clear e2init e2end
e2=rand_mul*e1;
%% generating exponentials
%immediate_south pixel
% center pixel value assign
alphac=alpha(x,y);
betac=beta(x,y);
deltac=delta(x,y);
%immediate_north pixel
i=x-1;j=y;
[a,b,c,d]=para(e2,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the horizontal direction
% for this let us interchange the e1 and e2 (e1-->e2,e2-->e1)
%% generating exponentials
%immediate_right pixel
i=x;j=y+1;
[a,b,c,d]=para(e1,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the off-diagonal direction
% for this let's decay it as exp(-e2^3) and exp(-e1^3)
%% generating exponentials
%immediate_north_east pixel
i=x-1;j=y+1;
[a,b,c,d]=para(e2,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
elseif end_mem_num==3 % now it assings fractions to delta matrix
rinit = 0.5;
rend = 1; 
delta(x,y) = (rend-rinit)*rand+rinit; % force assign
gama(x,y)=(rend-delta(x,y))*rand; %generate 2 nd endmember always lower than delta 
sum1=gama(x,y)+delta(x,y);% check summation exceed 1
beta(x,y)=(rend-sum1)*rand;% generate 3 rd endmember ensuring less than both gama and delta
sum2=sum1+beta(x,y);% check summation exceed 1
alpha(x,y)=1-sum2;%generate 4th endmember by ensuring the sum to 1
%% Moving to the verticle direction
%step 01
% we need a random exponent for the negative exponential( exp(-e1^2),
% 0<e1<1)
% we need another random exponent (exp(-r2^2)), % we've decided to chose
% e2<e1
% to have this inequality e2=rand_mul*e1; where, rand_mul is a number which
% ranges between 0.8 and 1

%% generation of e1
e1init = 0;
e1end = 1; 
e1= (e1end-e1init)*rand+e1init;
% we don't want e1init and e1end variables
clear e1init e1end
%% generation of rand_mul
tempinit = 0.8;
tempend = 1; 
rand_mul= (tempend-tempinit)*rand+tempinit;
% we don't want tempinit and tempend variables
clear tempinit tempend
%% generation of e2
e2init = 0;
e2end = 1; 
rand_mul= (e2end-e2init)*rand+e2init;
% we don't want e2init and e2end variables
clear e2init e2end
e2=rand_mul*e1;
%% generating exponentials
%immediate_south pixel
% center pixel value assign
alphac=alpha(x,y);
betac=beta(x,y);
deltac=delta(x,y);
%immediate_north pixel
i=x-1;j=y;
[a,b,c,d]=para(e2,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the horizontal direction
% for this let us interchange the e1 and e2 (e1-->e2,e2-->e1)
%% generating exponentials
%immediate_right pixel
i=x;j=y+1;
[a,b,c,d]=para(e1,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the off-diagonal direction
% for this let's decay it as exp(-e2^3) and exp(-e1^3)
%% generating exponentials
%immediate_north_east pixel
i=x-1;j=y+1;
[a,b,c,d]=para(e2,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
elseif end_mem_num==4 % now it assings fractions to gama matrix
rinit = 0.5;
rend = 1; 
gama(x,y) = (rend-rinit)*rand+rinit; % force assign
delta(x,y)=(rend-gama(x,y))*rand;%generate 2 nd endmember always lower than gama 
sum1=gama(x,y)+delta(x,y);% check summation exceed 1
alpha(x,y)=(rend-sum1)*rand;% generate 3 rd endmember ensuring less than both gama and delta
sum2=sum1+alpha(x,y);% check summation exceed 1
beta(x,y)=1-sum2;%generate 4th endmember by ensuring the sum to 1
%% Moving to the verticle direction
%step 01
% we need a random exponent for the negative exponential( exp(-e1^2),
% 0<e1<1)
% we need another random exponent (exp(-r2^2)), % we've decided to chose
% e2<e1
% to have this inequality e2=rand_mul*e1; where, rand_mul is a number which
% ranges between 0.8 and 1

%% generation of e1
e1init = 0;
e1end = 1; 
e1= (e1end-e1init)*rand+e1init;
% we don't want e1init and e1end variables
clear e1init e1end
%% generation of rand_mul
tempinit = 0.8;
tempend = 1; 
rand_mul= (tempend-tempinit)*rand+tempinit;
% we don't want tempinit and tempend variables
clear tempinit tempend
%% generation of e2
e2init = 0;
e2end = 1; 
rand_mul= (e2end-e2init)*rand+e2init;
% we don't want e2init and e2end variables
clear e2init e2end
e2=rand_mul*e1;
%% generating exponentials
%immediate_south pixel
% center pixel value assign
alphac=alpha(x,y);
betac=beta(x,y);
deltac=delta(x,y);
%immediate_north pixel
i=x-1;j=y;
[a,b,c,d]=para(e2,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the horizontal direction
% for this let us interchange the e1 and e2 (e1-->e2,e2-->e1)
%% generating exponential
%immediate_right pixel
i=x;j=y+1;
[a,b,c,d]=para(e1,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j

%% moving in the off-diagonal direction
% for this let's decay it as exp(-e2^3) and exp(-e1^3)
%% generating exponentials
%immediate_north_east pixel
i=x-1;j=y+1;
[a,b,c,d]=para(e2,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
end
clear alphac betac gamac deltac



            case 5 %south east
                
                
 %% We've to pscillate between 1 and 2.
osinit=1;
osend= 4; 
end_mem_num = (osend-osinit)*rand+osinit; % this is taken from an uniform distribution
end_mem_num=round(end_mem_num);
clear osinit osend % we don't want osinit and osend


%% generating a random number for the 1st or 2nd end-member(abundance value)
%we want to generate a number higher than or equal to 0.5 but less than or equal to 1
%this will make sure the dominate nature of an endmember in a single pixel.
if end_mem_num==1 %now it assigns abundance fractions to alpha matrix
    
rinit = 0.5;
rend = 1; 
alpha(x,y) = (rend-rinit)*rand+rinit; % force assign
beta(x,y)=(rend-alpha(x,y))*rand; %generate 2 nd endmember always lower than alpha 
sum1=alpha(x,y)+beta(x,y);% check summation exceed 1
delta(x,y)=(rend-sum1)*rand;% generate 3 rd endmember ensuring less than both alpha and beta
sum2=sum1+delta(x,y);% check summation exceed 1
gama(x,y)=1-sum2;%generate 4th endmember by ensuring the sum to 1
clear rinit rend % we don't want rinit and rend

%% Moving to the verticle direction
%step 01
% we need a random exponent for the negative exponential( exp(-e1^2),
% 0<e1<1)
% we need another random exponent (exp(-r2^2)), % we've decided to chose
% e2<e1
% to have this inequality e2=rand_mul*e1; where, rand_mul is a number which
% ranges between 0.8 and 1

%% generation of e1
e1init = 0;
e1end = 1; 
e1= (e1end-e1init)*rand+e1init;
% we don't want e1init and e1end variables
clear e1init e1end % we don't want e1init and e1end
%% generation of rand_mul
tempinit = 0.8;
tempend = 1; 
rand_mul= (tempend-tempinit)*rand+tempinit;
% we don't want tempinit and tempend variables
clear tempinit tempend
%% generation of e2
e2init = 0;
e2end = 1; 
rand_mul= (e2end-e2init)*rand+e2init;
% we don't want e2init and e2end variables
clear e2init e2end
e2=rand_mul*e1;
%% generating exponentials
%immediate_south pixel

% center pixel value assign
alphac=alpha(x,y);
betac=beta(x,y);
deltac=delta(x,y);
%immediate_north pixel
i=x-1;j=y;
[a,b,c,d]=para(e2,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the horizontal direction
% for this let us interchange the e1 and e2 (e1-->e2,e2-->e1)
%% generating exponentials
%immediate_left pixel
i=x;j=y-1;
[a,b,c,d]=para(e2,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j

%% moving in the main diagonal direction
% for this let's decay it as exp(-e1^3) and exp(-e2^3)
%% generating exponentials
%immediate_north_west pixel
i=x-1;j=y-1;
[a,b,c,d]=para(e1,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
elseif end_mem_num==2 % now it assings fractions to beta matrix
rinit = 0.5;
rend = 1; 
beta(x,y) = (rend-rinit)*rand+rinit; % force assign
alpha(x,y)=(rend-beta(x,y))*rand; %generate 2 nd endmember always lower than beta
sum1=alpha(x,y)+beta(x,y);% check summation exceed 1
delta(x,y)=(rend-sum1)*rand;% generate 3 rd endmember ensuring less than both alpha and beta
sum2=sum1+delta(x,y);% check summation exceed 1
gama(x,y)=1-sum2;%generate 4th endmember by ensuring the sum to 1
%% Moving to the verticle direction
%step 01
% we need a random exponent for the negative exponential( exp(-e1^2),
% 0<e1<1)
% we need another random exponent (exp(-r2^2)), % we've decided to chose
% e2<e1
% to have this inequality e2=rand_mul*e1; where, rand_mul is a number which
% ranges between 0.8 and 1

%% generation of e1
e1init = 0;
e1end = 1; 
e1= (e1end-e1init)*rand+e1init;
% we don't want e1init and e1end variables
clear e1init e1end
%% generation of rand_mul
tempinit = 0.8;
tempend = 1; 
rand_mul= (tempend-tempinit)*rand+tempinit;
% we don't want tempinit and tempend variables
clear tempinit tempend
%% generation of e2
e2init = 0;
e2end = 1; 
rand_mul= (e2end-e2init)*rand+e2init;
% we don't want e2init and e2end variables
clear e2init e2end
e2=rand_mul*e1;
%% generating exponentials
%immediate_south pixel
% center pixel value assign
alphac=alpha(x,y);
betac=beta(x,y);
deltac=delta(x,y);
%immediate_north pixel
i=x-1;j=y;
[a,b,c,d]=para(e2,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the horizontal direction
% for this let us interchange the e1 and e2 (e1-->e2,e2-->e1)
%% generating exponentials
%immediate_left pixel
i=x;j=y-1;
[a,b,c,d]=para(e2,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the main diagonal direction
% for this let's decay it as exp(-e1^3) and exp(-e2^3)
%% generating exponentials
%immediate_north_west pixel
i=x-1;j=y-1;
[a,b,c,d]=para(e1,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
elseif end_mem_num==3 % now it assings fractions to delta matrix
rinit = 0.5;
rend = 1; 
delta(x,y) = (rend-rinit)*rand+rinit; % force assign
gama(x,y)=(rend-delta(x,y))*rand; %generate 2 nd endmember always lower than delta 
sum1=gama(x,y)+delta(x,y);% check summation exceed 1
beta(x,y)=(rend-sum1)*rand;% generate 3 rd endmember ensuring less than both gama and delta
sum2=sum1+beta(x,y);% check summation exceed 1
alpha(x,y)=1-sum2;%generate 4th endmember by ensuring the sum to 1
%% Moving to the verticle direction
%step 01
% we need a random exponent for the negative exponential( exp(-e1^2),
% 0<e1<1)
% we need another random exponent (exp(-r2^2)), % we've decided to chose
% e2<e1
% to have this inequality e2=rand_mul*e1; where, rand_mul is a number which
% ranges between 0.8 and 1

%% generation of e1
e1init = 0;
e1end = 1; 
e1= (e1end-e1init)*rand+e1init;
% we don't want e1init and e1end variables
clear e1init e1end
%% generation of rand_mul
tempinit = 0.8;
tempend = 1; 
rand_mul= (tempend-tempinit)*rand+tempinit;
% we don't want tempinit and tempend variables
clear tempinit tempend
%% generation of e2
e2init = 0;
e2end = 1; 
rand_mul= (e2end-e2init)*rand+e2init;
% we don't want e2init and e2end variables
clear e2init e2end
e2=rand_mul*e1;
%% generating exponentials
%immediate_south pixel
% center pixel value assign
alphac=alpha(x,y);
betac=beta(x,y);
deltac=delta(x,y);
%immediate_north pixel
i=x-1;j=y;
[a,b,c,d]=para(e2,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the horizontal direction
% for this let us interchange the e1 and e2 (e1-->e2,e2-->e1)
%% generating exponentials
%immediate_left pixel
i=x;j=y-1;
[a,b,c,d]=para(e2,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the main diagonal direction
% for this let's decay it as exp(-e1^3) and exp(-e2^3)
%% generating exponentials

%immediate_north_west pixel
i=x-1;j=y-1;
[a,b,c,d]=para(e1,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
elseif end_mem_num==4 % now it assings fractions to gama matrix
rinit = 0.5;
rend = 1; 
gama(x,y) = (rend-rinit)*rand+rinit; % force assign
delta(x,y)=(rend-gama(x,y))*rand;%generate 2 nd endmember always lower than gama 
sum1=gama(x,y)+delta(x,y);% check summation exceed 1
alpha(x,y)=(rend-sum1)*rand;% generate 3 rd endmember ensuring less than both gama and delta
sum2=sum1+alpha(x,y);% check summation exceed 1
beta(x,y)=1-sum2;%generate 4th endmember by ensuring the sum to 1
%% Moving to the verticle direction
%step 01
% we need a random exponent for the negative exponential( exp(-e1^2),
% 0<e1<1)
% we need another random exponent (exp(-r2^2)), % we've decided to chose
% e2<e1
% to have this inequality e2=rand_mul*e1; where, rand_mul is a number which
% ranges between 0.8 and 1

%% generation of e1
e1init = 0;
e1end = 1; 
e1= (e1end-e1init)*rand+e1init;
% we don't want e1init and e1end variables
clear e1init e1end
%% generation of rand_mul
tempinit = 0.8;
tempend = 1; 
rand_mul= (tempend-tempinit)*rand+tempinit;
% we don't want tempinit and tempend variables
clear tempinit tempend
%% generation of e2
e2init = 0;
e2end = 1; 
rand_mul= (e2end-e2init)*rand+e2init;
% we don't want e2init and e2end variables
clear e2init e2end
e2=rand_mul*e1;
%% generating exponentials
%immediate_south pixel
% center pixel value assign
alphac=alpha(x,y);
betac=beta(x,y);
deltac=delta(x,y);
%immediate_north pixel
i=x-1;j=y;
[a,b,c,d]=para(e2,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the horizontal direction
% for this let us interchange the e1 and e2 (e1-->e2,e2-->e1)
%% generating exponentials
%immediate_right pixel
i=x;j=y+1;
[a,b,c,d]=para(e1,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the main diagonal direction
% for this let's decay it as exp(-e1^3) and exp(-e2^3)
%% generating exponentials
%immediate_north_west pixel
i=x-1;j=y-1;
[a,b,c,d]=para(e1,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
end
clear alphac betac gamac deltac 

                

            case 6 %spanning south w-->e
                
                
                %% We've to pscillate between 1 and 2.
osinit=1;
osend= 4; 
end_mem_num = (osend-osinit)*rand+osinit; % this is taken from an uniform distribution
end_mem_num=round(end_mem_num);
clear osinit osend % we don't want osinit and osend


%% generating a random number for the 1st or 2nd end-member(abundance value)
%we want to generate a number higher than or equal to 0.5 but less than or equal to 1
%this will make sure the dominate nature of an endmember in a single pixel.
if end_mem_num==1 %now it assigns abundance fractions to alpha matrix
    
rinit = 0.5;
rend = 1; 
alpha(x,y) = (rend-rinit)*rand+rinit; % force assign
beta(x,y)=(rend-alpha(x,y))*rand; %generate 2 nd endmember always lower than alpha 
sum1=alpha(x,y)+beta(x,y);% check summation exceed 1
delta(x,y)=(rend-sum1)*rand;% generate 3 rd endmember ensuring less than both alpha and beta
sum2=sum1+delta(x,y);% check summation exceed 1
gama(x,y)=1-sum2;%generate 4th endmember by ensuring the sum to 1
clear rinit rend % we don't want rinit and rend

%% Moving to the verticle direction
%step 01
% we need a random exponent for the negative exponential( exp(-e1^2),
% 0<e1<1)
% we need another random exponent (exp(-r2^2)), % we've decided to chose
% e2<e1
% to have this inequality e2=rand_mul*e1; where, rand_mul is a number which
% ranges between 0.8 and 1

%% generation of e1
e1init = 0;
e1end = 1; 
e1= (e1end-e1init)*rand+e1init;
% we don't want e1init and e1end variables
clear e1init e1end % we don't want e1init and e1end
%% generation of rand_mul
tempinit = 0.8;
tempend = 1; 
rand_mul= (tempend-tempinit)*rand+tempinit;
% we don't want tempinit and tempend variables
clear tempinit tempend
%% generation of e2
e2init = 0;
e2end = 1; 
rand_mul= (e2end-e2init)*rand+e2init;
% we don't want e2init and e2end variables
clear e2init e2end
e2=rand_mul*e1;
%% generating exponentials
%immediate_south pixel

% center pixel value assign
alphac=alpha(x,y);
betac=beta(x,y);
deltac=delta(x,y);
%immediate_north pixel
i=x-1;j=y;
[a,b,c,d]=para(e2,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the horizontal direction
% for this let us interchange the e1 and e2 (e1-->e2,e2-->e1)
%% generating exponentials
%immediate_left pixel
i=x;j=y-1;
[a,b,c,d]=para(e2,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%immediate_right pixel
i=x;j=y+1;
[a,b,c,d]=para(e1,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the main diagonal direction
% for this let's decay it as exp(-e1^3) and exp(-e2^3)
%% generating exponentials
%immediate_north_west pixel
i=x-1;j=y-1;
[a,b,c,d]=para(e1,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the off-diagonal direction
% for this let's decay it as exp(-e2^3) and exp(-e1^3)
%% generating exponentials
%immediate_north_east pixel
i=x-1;j=y+1;
[a,b,c,d]=para(e2,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
elseif end_mem_num==2 % now it assings fractions to beta matrix
rinit = 0.5;
rend = 1; 
beta(x,y) = (rend-rinit)*rand+rinit; % force assign
alpha(x,y)=(rend-beta(x,y))*rand; %generate 2 nd endmember always lower than beta
sum1=alpha(x,y)+beta(x,y);% check summation exceed 1
delta(x,y)=(rend-sum1)*rand;% generate 3 rd endmember ensuring less than both alpha and beta
sum2=sum1+delta(x,y);% check summation exceed 1
gama(x,y)=1-sum2;%generate 4th endmember by ensuring the sum to 1
%% Moving to the verticle direction
%step 01
% we need a random exponent for the negative exponential( exp(-e1^2),
% 0<e1<1)
% we need another random exponent (exp(-r2^2)), % we've decided to chose
% e2<e1
% to have this inequality e2=rand_mul*e1; where, rand_mul is a number which
% ranges between 0.8 and 1

%% generation of e1
e1init = 0;
e1end = 1; 
e1= (e1end-e1init)*rand+e1init;
% we don't want e1init and e1end variables
clear e1init e1end
%% generation of rand_mul
tempinit = 0.8;
tempend = 1; 
rand_mul= (tempend-tempinit)*rand+tempinit;
% we don't want tempinit and tempend variables
clear tempinit tempend
%% generation of e2
e2init = 0;
e2end = 1; 
rand_mul= (e2end-e2init)*rand+e2init;
% we don't want e2init and e2end variables
clear e2init e2end
e2=rand_mul*e1;
%% generating exponentials
%immediate_south pixel
% center pixel value assign
alphac=alpha(x,y);
betac=beta(x,y);
deltac=delta(x,y);
%immediate_north pixel
i=x-1;j=y;
[a,b,c,d]=para(e2,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the horizontal direction
% for this let us interchange the e1 and e2 (e1-->e2,e2-->e1)
%% generating exponentials
%immediate_left pixel
i=x;j=y-1;
[a,b,c,d]=para(e2,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%immediate_right pixel
i=x;j=y+1;
[a,b,c,d]=para(e1,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the main diagonal direction
% for this let's decay it as exp(-e1^3) and exp(-e2^3)
%% generating exponentials
%immediate_north_west pixel
i=x-1;j=y-1;
[a,b,c,d]=para(e1,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the off-diagonal direction
% for this let's decay it as exp(-e2^3) and exp(-e1^3)
%% generating exponentials
%immediate_north_east pixel
i=x-1;j=y+1;
[a,b,c,d]=para(e2,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j

elseif end_mem_num==3 % now it assings fractions to delta matrix
rinit = 0.5;
rend = 1; 
delta(x,y) = (rend-rinit)*rand+rinit; % force assign
gama(x,y)=(rend-delta(x,y))*rand; %generate 2 nd endmember always lower than delta 
sum1=gama(x,y)+delta(x,y);% check summation exceed 1
beta(x,y)=(rend-sum1)*rand;% generate 3 rd endmember ensuring less than both gama and delta
sum2=sum1+beta(x,y);% check summation exceed 1
alpha(x,y)=1-sum2;%generate 4th endmember by ensuring the sum to 1
%% Moving to the verticle direction
%step 01
% we need a random exponent for the negative exponential( exp(-e1^2),
% 0<e1<1)
% we need another random exponent (exp(-r2^2)), % we've decided to chose
% e2<e1
% to have this inequality e2=rand_mul*e1; where, rand_mul is a number which
% ranges between 0.8 and 1

%% generation of e1
e1init = 0;
e1end = 1; 
e1= (e1end-e1init)*rand+e1init;
% we don't want e1init and e1end variables
clear e1init e1end
%% generation of rand_mul
tempinit = 0.8;
tempend = 1; 
rand_mul= (tempend-tempinit)*rand+tempinit;
% we don't want tempinit and tempend variables
clear tempinit tempend
%% generation of e2
e2init = 0;
e2end = 1; 
rand_mul= (e2end-e2init)*rand+e2init;
% we don't want e2init and e2end variables
clear e2init e2end
e2=rand_mul*e1;
%% generating exponentials
%immediate_south pixel
% center pixel value assign
alphac=alpha(x,y);
betac=beta(x,y);
deltac=delta(x,y);
%immediate_north pixel
i=x-1;j=y;
[a,b,c,d]=para(e2,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the horizontal direction
% for this let us interchange the e1 and e2 (e1-->e2,e2-->e1)
%% generating exponentials
%immediate_left pixel
i=x;j=y-1;
[a,b,c,d]=para(e2,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%immediate_right pixel
i=x;j=y+1;
[a,b,c,d]=para(e1,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the main diagonal direction
% for this let's decay it as exp(-e1^3) and exp(-e2^3)
%% generating exponentials

%immediate_north_west pixel
i=x-1;j=y-1;
[a,b,c,d]=para(e1,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the off-diagonal direction
% for this let's decay it as exp(-e2^3) and exp(-e1^3)
%% generating exponentials
%immediate_north_east pixel
i=x-1;j=y+1;
[a,b,c,d]=para(e2,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
elseif end_mem_num==4 % now it assings fractions to gama matrix
rinit = 0.5;
rend = 1; 
gama(x,y) = (rend-rinit)*rand+rinit; % force assign
delta(x,y)=(rend-gama(x,y))*rand;%generate 2 nd endmember always lower than gama 
sum1=gama(x,y)+delta(x,y);% check summation exceed 1
alpha(x,y)=(rend-sum1)*rand;% generate 3 rd endmember ensuring less than both gama and delta
sum2=sum1+alpha(x,y);% check summation exceed 1
beta(x,y)=1-sum2;%generate 4th endmember by ensuring the sum to 1
%% Moving to the verticle direction
%step 01
% we need a random exponent for the negative exponential( exp(-e1^2),
% 0<e1<1)
% we need another random exponent (exp(-r2^2)), % we've decided to chose
% e2<e1
% to have this inequality e2=rand_mul*e1; where, rand_mul is a number which
% ranges between 0.8 and 1

%% generation of e1
e1init = 0;
e1end = 1; 
e1= (e1end-e1init)*rand+e1init;
% we don't want e1init and e1end variables
clear e1init e1end
%% generation of rand_mul
tempinit = 0.8;
tempend = 1; 
rand_mul= (tempend-tempinit)*rand+tempinit;
% we don't want tempinit and tempend variables
clear tempinit tempend
%% generation of e2
e2init = 0;
e2end = 1; 
rand_mul= (e2end-e2init)*rand+e2init;
% we don't want e2init and e2end variables
clear e2init e2end
e2=rand_mul*e1;
%% generating exponentials
%immediate_south pixel
% center pixel value assign
alphac=alpha(x,y);
betac=beta(x,y);
deltac=delta(x,y);
%immediate_north pixel
i=x-1;j=y;
[a,b,c,d]=para(e2,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the horizontal direction
% for this let us interchange the e1 and e2 (e1-->e2,e2-->e1)
%% generating exponentials
%immediate_left pixel
i=x;j=y-1;
[a,b,c,d]=para(e2,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%immediate_right pixel
i=x;j=y+1;
[a,b,c,d]=para(e1,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the main diagonal direction
% for this let's decay it as exp(-e1^3) and exp(-e2^3)
%% generating exponentials

%immediate_north_west pixel
i=x-1;j=y-1;
[a,b,c,d]=para(e1,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the off-diagonal direction
% for this let's decay it as exp(-e2^3) and exp(-e1^3)
%% generating exponentials
%immediate_north_east pixel
i=x-1;j=y+1;
[a,b,c,d]=para(e2,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
end
clear alphac betac gamac deltac




            case 7 %spanning west n-->s 
              
            
%% We've to pscillate between 1 and 2.
osinit=1;
osend= 4; 
end_mem_num = (osend-osinit)*rand+osinit; % this is taken from an uniform distribution
end_mem_num=round(end_mem_num);
clear osinit osend % we don't want osinit and osend


%% generating a random number for the 1st or 2nd end-member(abundance value)
%we want to generate a number higher than or equal to 0.5 but less than or equal to 1
%this will make sure the dominate nature of an endmember in a single pixel.
if end_mem_num==1 %now it assigns abundance fractions to alpha matrix
    
rinit = 0.5;
rend = 1; 
alpha(x,y) = (rend-rinit)*rand+rinit; % force assign
beta(x,y)=(rend-alpha(x,y))*rand; %generate 2 nd endmember always lower than alpha 
sum1=alpha(x,y)+beta(x,y);% check summation exceed 1
delta(x,y)=(rend-sum1)*rand;% generate 3 rd endmember ensuring less than both alpha and beta
sum2=sum1+delta(x,y);% check summation exceed 1
gama(x,y)=1-sum2;%generate 4th endmember by ensuring the sum to 1
clear rinit rend % we don't want rinit and rend

%% Moving to the verticle direction
%step 01
% we need a random exponent for the negative exponential( exp(-e1^2),
% 0<e1<1)
% we need another random exponent (exp(-r2^2)), % we've decided to chose
% e2<e1
% to have this inequality e2=rand_mul*e1; where, rand_mul is a number which
% ranges between 0.8 and 1

%% generation of e1
e1init = 0;
e1end = 1; 
e1= (e1end-e1init)*rand+e1init;
% we don't want e1init and e1end variables
clear e1init e1end % we don't want e1init and e1end
%% generation of rand_mul
tempinit = 0.8;
tempend = 1; 
rand_mul= (tempend-tempinit)*rand+tempinit;
% we don't want tempinit and tempend variables
clear tempinit tempend
%% generation of e2
e2init = 0;
e2end = 1; 
rand_mul= (e2end-e2init)*rand+e2init;
% we don't want e2init and e2end variables
clear e2init e2end
e2=rand_mul*e1;
%% generating exponentials
%immediate_south pixel
% center pixel value assign
alphac=alpha(x,y);
betac=beta(x,y);
deltac=delta(x,y);
i=x+1;j=y;
[a,b,c,d]=para(e1,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%immediate_north pixel
i=x-1;j=y;
[a,b,c,d]=para(e2,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the horizontal direction
% for this let us interchange the e1 and e2 (e1-->e2,e2-->e1)
%% generating exponentials
%immediate_right pixel
i=x;j=y+1;
[a,b,c,d]=para(e1,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the main diagonal direction
% for this let's decay it as exp(-e1^3) and exp(-e2^3)
%% generating exponentials
%immediate_east_south pixel
i=x+1;j=y+1;
[a,b,c,d]=para(e2,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j

%% moving in the off-diagonal direction
% for this let's decay it as exp(-e2^3) and exp(-e1^3)
%% generating exponentials
%immediate_north_east pixel
i=x-1;j=y+1;
[a,b,c,d]=para(e2,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
elseif end_mem_num==2 % now it assings fractions to beta matrix
rinit = 0.5;
rend = 1; 
beta(x,y) = (rend-rinit)*rand+rinit; % force assign
alpha(x,y)=(rend-beta(x,y))*rand; %generate 2 nd endmember always lower than beta
sum1=alpha(x,y)+beta(x,y);% check summation exceed 1
delta(x,y)=(rend-sum1)*rand;% generate 3 rd endmember ensuring less than both alpha and beta
sum2=sum1+delta(x,y);% check summation exceed 1
gama(x,y)=1-sum2;%generate 4th endmember by ensuring the sum to 1
%% Moving to the verticle direction
%step 01
% we need a random exponent for the negative exponential( exp(-e1^2),
% 0<e1<1)
% we need another random exponent (exp(-r2^2)), % we've decided to chose
% e2<e1
% to have this inequality e2=rand_mul*e1; where, rand_mul is a number which
% ranges between 0.8 and 1

%% generation of e1
e1init = 0;
e1end = 1; 
e1= (e1end-e1init)*rand+e1init;
% we don't want e1init and e1end variables
clear e1init e1end
%% generation of rand_mul
tempinit = 0.8;
tempend = 1; 
rand_mul= (tempend-tempinit)*rand+tempinit;
% we don't want tempinit and tempend variables
clear tempinit tempend
%% generation of e2
e2init = 0;
e2end = 1; 
rand_mul= (e2end-e2init)*rand+e2init;
% we don't want e2init and e2end variables
clear e2init e2end
e2=rand_mul*e1;
%% generating exponentials
%immediate_south pixel
% center pixel value assign
alphac=alpha(x,y);
betac=beta(x,y);
deltac=delta(x,y);
i=x+1;j=y;
[a,b,c,d]=para(e1,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%immediate_north pixel
i=x-1;j=y;
[a,b,c,d]=para(e2,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the horizontal direction
% for this let us interchange the e1 and e2 (e1-->e2,e2-->e1)
%% generating exponentials
%immediate_right pixel
i=x;j=y+1;
[a,b,c,d]=para(e1,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the main diagonal direction
% for this let's decay it as exp(-e1^3) and exp(-e2^3)
%% generating exponentials
%immediate_east_south pixel
i=x+1;j=y+1;
[a,b,c,d]=para(e2,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the off-diagonal direction
% for this let's decay it as exp(-e2^3) and exp(-e1^3)
%% generating exponentials
%immediate_north_east pixel
i=x-1;j=y+1;
[a,b,c,d]=para(e2,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
elseif end_mem_num==3 % now it assings fractions to delta matrix
rinit = 0.5;
rend = 1; 
delta(x,y) = (rend-rinit)*rand+rinit; % force assign
gama(x,y)=(rend-delta(x,y))*rand; %generate 2 nd endmember always lower than delta 
sum1=gama(x,y)+delta(x,y);% check summation exceed 1
beta(x,y)=(rend-sum1)*rand;% generate 3 rd endmember ensuring less than both gama and delta
sum2=sum1+beta(x,y);% check summation exceed 1
alpha(x,y)=1-sum2;%generate 4th endmember by ensuring the sum to 1
%% Moving to the verticle direction
%step 01
% we need a random exponent for the negative exponential( exp(-e1^2),
% 0<e1<1)
% we need another random exponent (exp(-r2^2)), % we've decided to chose
% e2<e1
% to have this inequality e2=rand_mul*e1; where, rand_mul is a number which
% ranges between 0.8 and 1

%% generation of e1
e1init = 0;
e1end = 1; 
e1= (e1end-e1init)*rand+e1init;
% we don't want e1init and e1end variables
clear e1init e1end
%% generation of rand_mul
tempinit = 0.8;
tempend = 1; 
rand_mul= (tempend-tempinit)*rand+tempinit;
% we don't want tempinit and tempend variables
clear tempinit tempend
%% generation of e2
e2init = 0;
e2end = 1; 
rand_mul= (e2end-e2init)*rand+e2init;
% we don't want e2init and e2end variables
clear e2init e2end
e2=rand_mul*e1;
%% generating exponentials
%immediate_south pixel
% center pixel value assign
alphac=alpha(x,y);
betac=beta(x,y);
deltac=delta(x,y);
i=x+1;j=y;
[a,b,c,d]=para(e1,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%immediate_north pixel
i=x-1;j=y;
[a,b,c,d]=para(e2,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the horizontal direction
% for this let us interchange the e1 and e2 (e1-->e2,e2-->e1)
%% generating exponentials
%immediate_right pixel
i=x;j=y+1;
[a,b,c,d]=para(e1,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the main diagonal direction
% for this let's decay it as exp(-e1^3) and exp(-e2^3)
%% generating exponentials
%immediate_east_south pixel
i=x+1;j=y+1;
[a,b,c,d]=para(e2,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the off-diagonal direction
% for this let's decay it as exp(-e2^3) and exp(-e1^3)
%% generating exponentials
%immediate_north_east pixel
i=x-1;j=y+1;
[a,b,c,d]=para(e2,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
elseif end_mem_num==4 % now it assings fractions to gama matrix
rinit = 0.5;
rend = 1; 
gama(x,y) = (rend-rinit)*rand+rinit; % force assign
delta(x,y)=(rend-gama(x,y))*rand;%generate 2 nd endmember always lower than gama 
sum1=gama(x,y)+delta(x,y);% check summation exceed 1
alpha(x,y)=(rend-sum1)*rand;% generate 3 rd endmember ensuring less than both gama and delta
sum2=sum1+alpha(x,y);% check summation exceed 1
beta(x,y)=1-sum2;%generate 4th endmember by ensuring the sum to 1
%% Moving to the verticle direction
%step 01
% we need a random exponent for the negative exponential( exp(-e1^2),
% 0<e1<1)
% we need another random exponent (exp(-r2^2)), % we've decided to chose
% e2<e1
% to have this inequality e2=rand_mul*e1; where, rand_mul is a number which
% ranges between 0.8 and 1

%% generation of e1
e1init = 0;
e1end = 1; 
e1= (e1end-e1init)*rand+e1init;
% we don't want e1init and e1end variables
clear e1init e1end
%% generation of rand_mul
tempinit = 0.8;
tempend = 1; 
rand_mul= (tempend-tempinit)*rand+tempinit;
% we don't want tempinit and tempend variables
clear tempinit tempend
%% generation of e2
e2init = 0;
e2end = 1; 
rand_mul= (e2end-e2init)*rand+e2init;
% we don't want e2init and e2end variables
clear e2init e2end
e2=rand_mul*e1;
%% generating exponentials
%immediate_south pixel
% center pixel value assign
alphac=alpha(x,y);
betac=beta(x,y);
deltac=delta(x,y);
i=x+1;j=y;
[a,b,c,d]=para(e1,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%immediate_north pixel
i=x-1;j=y;
[a,b,c,d]=para(e2,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the horizontal direction
% for this let us interchange the e1 and e2 (e1-->e2,e2-->e1)
%% generating exponentials
%immediate_right pixel
i=x;j=y+1;
[a,b,c,d]=para(e1,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the main diagonal direction
% for this let's decay it as exp(-e1^3) and exp(-e2^3)
%% generating exponentials
%immediate_east_south pixel
i=x+1;j=y+1;
[a,b,c,d]=para(e2,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the off-diagonal direction
% for this let's decay it as exp(-e2^3) and exp(-e1^3)
%% generating exponentials
%immediate_north_east pixel
i=x-1;j=y+1;
[a,b,c,d]=para(e2,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
end
clear alphac betac gamac deltac

                
                
            case 8 %spanning east n-->s
                
                %% We've to pscillate between 1 and 2.
osinit=1;
osend= 4; 
end_mem_num = (osend-osinit)*rand+osinit; % this is taken from an uniform distribution
end_mem_num=round(end_mem_num);
clear osinit osend % we don't want osinit and osend


%% generating a random number for the 1st or 2nd end-member(abundance value)
%we want to generate a number higher than or equal to 0.5 but less than or equal to 1
%this will make sure the dominate nature of an endmember in a single pixel.
if end_mem_num==1 %now it assigns abundance fractions to alpha matrix
    
rinit = 0.5;
rend = 1; 
alpha(x,y) = (rend-rinit)*rand+rinit; % force assign
beta(x,y)=(rend-alpha(x,y))*rand; %generate 2 nd endmember always lower than alpha 
sum1=alpha(x,y)+beta(x,y);% check summation exceed 1
delta(x,y)=(rend-sum1)*rand;% generate 3 rd endmember ensuring less than both alpha and beta
sum2=sum1+delta(x,y);% check summation exceed 1
gama(x,y)=1-sum2;%generate 4th endmember by ensuring the sum to 1
clear rinit rend % we don't want rinit and rend

%% Moving to the verticle direction
%step 01
% we need a random exponent for the negative exponential( exp(-e1^2),
% 0<e1<1)
% we need another random exponent (exp(-r2^2)), % we've decided to chose
% e2<e1
% to have this inequality e2=rand_mul*e1; where, rand_mul is a number which
% ranges between 0.8 and 1

%% generation of e1
e1init = 0;
e1end = 1; 
e1= (e1end-e1init)*rand+e1init;
% we don't want e1init and e1end variables
clear e1init e1end % we don't want e1init and e1end
%% generation of rand_mul
tempinit = 0.8;
tempend = 1; 
rand_mul= (tempend-tempinit)*rand+tempinit;
% we don't want tempinit and tempend variables
clear tempinit tempend
%% generation of e2
e2init = 0;
e2end = 1; 
rand_mul= (e2end-e2init)*rand+e2init;
% we don't want e2init and e2end variables
clear e2init e2end
e2=rand_mul*e1;
%% generating exponentials
%immediate_south pixel

% center pixel value assign
alphac=alpha(x,y);
betac=beta(x,y);
deltac=delta(x,y);
i=x+1;j=y;
[a,b,c,d]=para(e1,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%immediate_north pixel
i=x-1;j=y;
[a,b,c,d]=para(e2,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the horizontal direction
% for this let us interchange the e1 and e2 (e1-->e2,e2-->e1)
%% generating exponentials
%immediate_left pixel
i=x;j=y-1;
[a,b,c,d]=para(e2,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the main diagonal direction
% for this let's decay it as exp(-e1^3) and exp(-e2^3)
%% generating exponentials
%immediate_north_west pixel
i=x-1;j=y-1;
[a,b,c,d]=para(e1,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the off-diagonal direction
% for this let's decay it as exp(-e2^3) and exp(-e1^3)
%% generating exponentials
%immediate_east_south pixel
i=x+1;j=y-1;
[a,b,c,d]=para(e1,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
elseif end_mem_num==2 % now it assings fractions to beta matrix
rinit = 0.5;
rend = 1; 
beta(x,y) = (rend-rinit)*rand+rinit; % force assign
alpha(x,y)=(rend-beta(x,y))*rand; %generate 2 nd endmember always lower than beta
sum1=alpha(x,y)+beta(x,y);% check summation exceed 1
delta(x,y)=(rend-sum1)*rand;% generate 3 rd endmember ensuring less than both alpha and beta
sum2=sum1+delta(x,y);% check summation exceed 1
gama(x,y)=1-sum2;%generate 4th endmember by ensuring the sum to 1
%% Moving to the verticle direction
%step 01
% we need a random exponent for the negative exponential( exp(-e1^2),
% 0<e1<1)
% we need another random exponent (exp(-r2^2)), % we've decided to chose
% e2<e1
% to have this inequality e2=rand_mul*e1; where, rand_mul is a number which
% ranges between 0.8 and 1

%% generation of e1
e1init = 0;
e1end = 1; 
e1= (e1end-e1init)*rand+e1init;
% we don't want e1init and e1end variables
clear e1init e1end
%% generation of rand_mul
tempinit = 0.8;
tempend = 1; 
rand_mul= (tempend-tempinit)*rand+tempinit;
% we don't want tempinit and tempend variables
clear tempinit tempend
%% generation of e2
e2init = 0;
e2end = 1; 
rand_mul= (e2end-e2init)*rand+e2init;
% we don't want e2init and e2end variables
clear e2init e2end
e2=rand_mul*e1;
%% generating exponentials
%immediate_south pixel
% center pixel value assign
alphac=alpha(x,y);
betac=beta(x,y);
deltac=delta(x,y);
i=x+1;j=y;
[a,b,c,d]=para(e1,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%immediate_north pixel
i=x-1;j=y;
[a,b,c,d]=para(e2,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the horizontal direction
% for this let us interchange the e1 and e2 (e1-->e2,e2-->e1)
%% generating exponentials
%immediate_left pixel
i=x;j=y-1;
[a,b,c,d]=para(e2,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the main diagonal direction
% for this let's decay it as exp(-e1^3) and exp(-e2^3)
%% generating exponentials
%immediate_north_west pixel
i=x-1;j=y-1;
[a,b,c,d]=para(e1,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the off-diagonal direction
% for this let's decay it as exp(-e2^3) and exp(-e1^3)
%% generating exponentials
%immediate_east_south pixel
i=x+1;j=y-1;
[a,b,c,d]=para(e1,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
elseif end_mem_num==3 % now it assings fractions to delta matrix
rinit = 0.5;
rend = 1; 
delta(x,y) = (rend-rinit)*rand+rinit; % force assign
gama(x,y)=(rend-delta(x,y))*rand; %generate 2 nd endmember always lower than delta 
sum1=gama(x,y)+delta(x,y);% check summation exceed 1
beta(x,y)=(rend-sum1)*rand;% generate 3 rd endmember ensuring less than both gama and delta
sum2=sum1+beta(x,y);% check summation exceed 1
alpha(x,y)=1-sum2;%generate 4th endmember by ensuring the sum to 1
%% Moving to the verticle direction
%step 01
% we need a random exponent for the negative exponential( exp(-e1^2),
% 0<e1<1)
% we need another random exponent (exp(-r2^2)), % we've decided to chose
% e2<e1
% to have this inequality e2=rand_mul*e1; where, rand_mul is a number which
% ranges between 0.8 and 1

%% generation of e1
e1init = 0;
e1end = 1; 
e1= (e1end-e1init)*rand+e1init;
% we don't want e1init and e1end variables
clear e1init e1end
%% generation of rand_mul
tempinit = 0.8;
tempend = 1; 
rand_mul= (tempend-tempinit)*rand+tempinit;
% we don't want tempinit and tempend variables
clear tempinit tempend
%% generation of e2
e2init = 0;
e2end = 1; 
rand_mul= (e2end-e2init)*rand+e2init;
% we don't want e2init and e2end variables
clear e2init e2end
e2=rand_mul*e1;
%% generating exponentials
%immediate_south pixel
% center pixel value assign
alphac=alpha(x,y);
betac=beta(x,y);
deltac=delta(x,y);
i=x+1;j=y;
[a,b,c,d]=para(e1,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%immediate_north pixel
i=x-1;j=y;
[a,b,c,d]=para(e2,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the horizontal direction
% for this let us interchange the e1 and e2 (e1-->e2,e2-->e1)
%% generating exponentials
%immediate_left pixel
i=x;j=y-1;
[a,b,c,d]=para(e2,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the main diagonal direction
% for this let's decay it as exp(-e1^3) and exp(-e2^3)
%% generating exponentials
%immediate_north_west pixel
i=x-1;j=y-1;
[a,b,c,d]=para(e1,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the off-diagonal direction
% for this let's decay it as exp(-e2^3) and exp(-e1^3)
%% generating exponentials
%immediate_east_south pixel
i=x+1;j=y-1;
[a,b,c,d]=para(e1,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
elseif end_mem_num==4 % now it assings fractions to gama matrix
rinit = 0.5;
rend = 1; 
gama(x,y) = (rend-rinit)*rand+rinit; % force assign
delta(x,y)=(rend-gama(x,y))*rand;%generate 2 nd endmember always lower than gama 
sum1=gama(x,y)+delta(x,y);% check summation exceed 1
alpha(x,y)=(rend-sum1)*rand;% generate 3 rd endmember ensuring less than both gama and delta
sum2=sum1+alpha(x,y);% check summation exceed 1
beta(x,y)=1-sum2;%generate 4th endmember by ensuring the sum to 1
%% Moving to the verticle direction
%step 01
% we need a random exponent for the negative exponential( exp(-e1^2),
% 0<e1<1)
% we need another random exponent (exp(-r2^2)), % we've decided to chose
% e2<e1
% to have this inequality e2=rand_mul*e1; where, rand_mul is a number which
% ranges between 0.8 and 1

%% generation of e1
e1init = 0;
e1end = 1; 
e1= (e1end-e1init)*rand+e1init;
% we don't want e1init and e1end variables
clear e1init e1end
%% generation of rand_mul
tempinit = 0.8;
tempend = 1; 
rand_mul= (tempend-tempinit)*rand+tempinit;
% we don't want tempinit and tempend variables
clear tempinit tempend
%% generation of e2
e2init = 0;
e2end = 1; 
rand_mul= (e2end-e2init)*rand+e2init;
% we don't want e2init and e2end variables
clear e2init e2end
e2=rand_mul*e1;
%% generating exponentials
%immediate_south pixel
% center pixel value assign
alphac=alpha(x,y);
betac=beta(x,y);
deltac=delta(x,y);
i=x+1;j=y;
[a,b,c,d]=para(e1,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%immediate_north pixel
i=x-1;j=y;
[a,b,c,d]=para(e2,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the horizontal direction
% for this let us interchange the e1 and e2 (e1-->e2,e2-->e1)
%% generating exponentials
%immediate_left pixel
i=x;j=y-1;
[a,b,c,d]=para(e2,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the main diagonal direction
% for this let's decay it as exp(-e1^3) and exp(-e2^3)
%% generating exponentials
%immediate_north_west pixel
i=x-1;j=y-1;
[a,b,c,d]=para(e1,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the off-diagonal direction
% for this let's decay it as exp(-e2^3) and exp(-e1^3)
%% generating exponentials
%immediate_east_south pixel
i=x+1;j=y-1;
[a,b,c,d]=para(e1,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
end
clear alphac betac gamac deltac




            case 9 %not a cornerpoint 
            %this is the common phenomena so add the normal block here
            
%% abundances assigned therefore generate the next center point
%% We've to pscillate between 1 and 2.
osinit=1;
osend= 4; 
end_mem_num = (osend-osinit)*rand+osinit; % this is taken from an uniform distribution
end_mem_num=round(end_mem_num);
clear osinit osend % we don't want osinit and osend


%% generating a random number for the 1st or 2nd end-member(abundance value)
%we want to generate a number higher than or equal to 0.5 but less than or equal to 1
%this will make sure the dominate nature of an endmember in a single pixel.
if end_mem_num==1 %now it assigns abundance fractions to alpha matrix
    
rinit = 0.5;
rend = 1; 
alpha(x,y) = (rend-rinit)*rand+rinit; % force assign
beta(x,y)=(rend-alpha(x,y))*rand; %generate 2 nd endmember always lower than alpha 
sum1=alpha(x,y)+beta(x,y);% check summation exceed 1
delta(x,y)=(rend-sum1)*rand;% generate 3 rd endmember ensuring less than both alpha and beta
sum2=sum1+delta(x,y);% check summation exceed 1
gama(x,y)=1-sum2;%generate 4th endmember by ensuring the sum to 1
clear rinit rend % we don't want rinit and rend

%% Moving to the verticle direction
%step 01
% we need a random exponent for the negative exponential( exp(-e1^2),
% 0<e1<1)
% we need another random exponent (exp(-r2^2)), % we've decided to chose
% e2<e1
% to have this inequality e2=rand_mul*e1; where, rand_mul is a number which
% ranges between 0.8 and 1

%% generation of e1
e1init = 0;
e1end = 1; 
e1= (e1end-e1init)*rand+e1init;
% we don't want e1init and e1end variables
clear e1init e1end % we don't want e1init and e1end
%% generation of rand_mul
tempinit = 0.8;
tempend = 1; 
rand_mul= (tempend-tempinit)*rand+tempinit;
% we don't want tempinit and tempend variables
clear tempinit tempend
%% generation of e2
e2init = 0;
e2end = 1; 
rand_mul= (e2end-e2init)*rand+e2init;
% we don't want e2init and e2end variables
clear e2init e2end
e2=rand_mul*e1;
%% generating exponentials
%immediate_south pixel

% center pixel value assign
alphac=alpha(x,y);
betac=beta(x,y);
deltac=delta(x,y);
i=x+1;j=y;
[a,b,c,d]=para(e1,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%immediate_north pixel
i=x-1;j=y;
[a,b,c,d]=para(e2,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the horizontal direction
% for this let us interchange the e1 and e2 (e1-->e2,e2-->e1)
%% generating exponentials
%immediate_left pixel
i=x;j=y-1;
[a,b,c,d]=para(e2,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%immediate_right pixel
i=x;j=y+1;
[a,b,c,d]=para(e1,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j


%% moving in the main diagonal direction
% for this let's decay it as exp(-e1^3) and exp(-e2^3)
%% generating exponentials
%immediate_north_west pixel
i=x-1;j=y-1;
[a,b,c,d]=para(e1,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j

%immediate_east_south pixel
i=x+1;j=y+1;
[a,b,c,d]=para(e2,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j

%% moving in the off-diagonal direction
% for this let's decay it as exp(-e2^3) and exp(-e1^3)
%% generating exponentials
%immediate_north_east pixel
i=x-1;j=y+1;
[a,b,c,d]=para(e2,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j

%immediate_east_south pixel
i=x+1;j=y-1;
[a,b,c,d]=para(e1,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j

elseif end_mem_num==2 % now it assings fractions to beta matrix
rinit = 0.5;
rend = 1; 
beta(x,y) = (rend-rinit)*rand+rinit; % force assign
alpha(x,y)=(rend-beta(x,y))*rand; %generate 2 nd endmember always lower than beta
sum1=alpha(x,y)+beta(x,y);% check summation exceed 1
delta(x,y)=(rend-sum1)*rand;% generate 3 rd endmember ensuring less than both alpha and beta
sum2=sum1+delta(x,y);% check summation exceed 1
gama(x,y)=1-sum2;%generate 4th endmember by ensuring the sum to 1
%% Moving to the verticle direction
%step 01
% we need a random exponent for the negative exponential( exp(-e1^2),
% 0<e1<1)
% we need another random exponent (exp(-r2^2)), % we've decided to chose
% e2<e1
% to have this inequality e2=rand_mul*e1; where, rand_mul is a number which
% ranges between 0.8 and 1

%% generation of e1
e1init = 0;
e1end = 1; 
e1= (e1end-e1init)*rand+e1init;
% we don't want e1init and e1end variables
clear e1init e1end
%% generation of rand_mul
tempinit = 0.8;
tempend = 1; 
rand_mul= (tempend-tempinit)*rand+tempinit;
% we don't want tempinit and tempend variables
clear tempinit tempend
%% generation of e2
e2init = 0;
e2end = 1; 
rand_mul= (e2end-e2init)*rand+e2init;
% we don't want e2init and e2end variables
clear e2init e2end
e2=rand_mul*e1;
%% generating exponentials
%immediate_south pixel
% center pixel value assign
alphac=alpha(x,y);
betac=beta(x,y);
deltac=delta(x,y);
i=x+1;j=y;
[a,b,c,d]=para(e1,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%immediate_north pixel
i=x-1;j=y;
[a,b,c,d]=para(e2,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the horizontal direction
% for this let us interchange the e1 and e2 (e1-->e2,e2-->e1)
%% generating exponentials
%immediate_left pixel
i=x;j=y-1;
[a,b,c,d]=para(e2,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%immediate_right pixel
i=x;j=y+1;
[a,b,c,d]=para(e1,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the main diagonal direction
% for this let's decay it as exp(-e1^3) and exp(-e2^3)
%% generating exponentials

%immediate_north_west pixel
i=x-1;j=y-1;
[a,b,c,d]=para(e1,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j

%immediate_east_south pixel
i=x+1;j=y+1;
[a,b,c,d]=para(e2,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the off-diagonal direction
% for this let's decay it as exp(-e2^3) and exp(-e1^3)
%% generating exponentials
%immediate_north_east pixel
i=x-1;j=y+1;
[a,b,c,d]=para(e2,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j

%immediate_east_south pixel
i=x+1;j=y-1;
[a,b,c,d]=para(e1,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j

elseif end_mem_num==3 % now it assings fractions to delta matrix
rinit = 0.5;
rend = 1; 
delta(x,y) = (rend-rinit)*rand+rinit; % force assign
gama(x,y)=(rend-delta(x,y))*rand; %generate 2 nd endmember always lower than delta 
sum1=gama(x,y)+delta(x,y);% check summation exceed 1
beta(x,y)=(rend-sum1)*rand;% generate 3 rd endmember ensuring less than both gama and delta
sum2=sum1+beta(x,y);% check summation exceed 1
alpha(x,y)=1-sum2;%generate 4th endmember by ensuring the sum to 1
%% Moving to the verticle direction
%step 01
% we need a random exponent for the negative exponential( exp(-e1^2),
% 0<e1<1)
% we need another random exponent (exp(-r2^2)), % we've decided to chose
% e2<e1
% to have this inequality e2=rand_mul*e1; where, rand_mul is a number which
% ranges between 0.8 and 1

%% generation of e1
e1init = 0;
e1end = 1; 
e1= (e1end-e1init)*rand+e1init;
% we don't want e1init and e1end variables
clear e1init e1end
%% generation of rand_mul
tempinit = 0.8;
tempend = 1; 
rand_mul= (tempend-tempinit)*rand+tempinit;
% we don't want tempinit and tempend variables
clear tempinit tempend
%% generation of e2
e2init = 0;
e2end = 1; 
rand_mul= (e2end-e2init)*rand+e2init;
% we don't want e2init and e2end variables
clear e2init e2end
e2=rand_mul*e1;
%% generating exponentials
%immediate_south pixel
% center pixel value assign
alphac=alpha(x,y);
betac=beta(x,y);
deltac=delta(x,y);
i=x+1;j=y;
[a,b,c,d]=para(e1,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%immediate_north pixel
i=x-1;j=y;
[a,b,c,d]=para(e2,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the horizontal direction
% for this let us interchange the e1 and e2 (e1-->e2,e2-->e1)
%% generating exponentials
%immediate_left pixel
i=x;j=y-1;
[a,b,c,d]=para(e2,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%immediate_right pixel
i=x;j=y+1;
[a,b,c,d]=para(e1,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the main diagonal direction
% for this let's decay it as exp(-e1^3) and exp(-e2^3)
%% generating exponentials

%immediate_north_west pixel
i=x-1;j=y-1;
[a,b,c,d]=para(e1,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j

%immediate_east_south pixel
i=x+1;j=y+1;
[a,b,c,d]=para(e2,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the off-diagonal direction
% for this let's decay it as exp(-e2^3) and exp(-e1^3)
%% generating exponentials
%immediate_north_east pixel
i=x-1;j=y+1;
[a,b,c,d]=para(e2,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j

%immediate_east_south pixel
i=x+1;j=y-1;
[a,b,c,d]=para(e1,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
elseif end_mem_num==4 % now it assings fractions to gama matrix
rinit = 0.5;
rend = 1; 
gama(x,y) = (rend-rinit)*rand+rinit; % force assign
delta(x,y)=(rend-gama(x,y))*rand;%generate 2 nd endmember always lower than gama 
sum1=gama(x,y)+delta(x,y);% check summation exceed 1
alpha(x,y)=(rend-sum1)*rand;% generate 3 rd endmember ensuring less than both gama and delta
sum2=sum1+alpha(x,y);% check summation exceed 1
beta(x,y)=1-sum2;%generate 4th endmember by ensuring the sum to 1
%% Moving to the verticle direction
%step 01
% we need a random exponent for the negative exponential( exp(-e1^2),
% 0<e1<1)
% we need another random exponent (exp(-r2^2)), % we've decided to chose
% e2<e1
% to have this inequality e2=rand_mul*e1; where, rand_mul is a number which
% ranges between 0.8 and 1

%% generation of e1
e1init = 0;
e1end = 1; 
e1= (e1end-e1init)*rand+e1init;
% we don't want e1init and e1end variables
clear e1init e1end
%% generation of rand_mul
tempinit = 0.8;
tempend = 1; 
rand_mul= (tempend-tempinit)*rand+tempinit;
% we don't want tempinit and tempend variables
clear tempinit tempend
%% generation of e2
e2init = 0;
e2end = 1; 
rand_mul= (e2end-e2init)*rand+e2init;
% we don't want e2init and e2end variables
clear e2init e2end
e2=rand_mul*e1;
%% generating exponentials
%immediate_south pixel
% center pixel value assign
alphac=alpha(x,y);
betac=beta(x,y);
deltac=delta(x,y);
i=x+1;j=y;
[a,b,c,d]=para(e1,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%immediate_north pixel
i=x-1;j=y;
[a,b,c,d]=para(e2,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the horizontal direction
% for this let us interchange the e1 and e2 (e1-->e2,e2-->e1)
%% generating exponentials
%immediate_left pixel
i=x;j=y-1;
[a,b,c,d]=para(e2,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%immediate_right pixel
i=x;j=y+1;
[a,b,c,d]=para(e1,2,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the main diagonal direction
% for this let's decay it as exp(-e1^3) and exp(-e2^3)
%% generating exponentials

%immediate_north_west pixel
i=x-1;j=y-1;
[a,b,c,d]=para(e1,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j

%immediate_east_south pixel
i=x+1;j=y+1;
[a,b,c,d]=para(e2,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
%% moving in the off-diagonal direction
% for this let's decay it as exp(-e2^3) and exp(-e1^3)
%% generating exponentials
%immediate_north_east pixel
i=x-1;j=y+1;
[a,b,c,d]=para(e2,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j

%immediate_east_south pixel
i=x+1;j=y-1;
[a,b,c,d]=para(e1,3,alphac,betac,deltac);
alpha(i,j)=a;beta(i,j)=b;delta(i,j)=c;gama(i,j)=d;
clear a b c d
clear i j
end
clear alphac betac gamac deltac
        end
    else

    end     
end

%%
figure(1)

padaya(:,:,1) = alpha;
padaya(:,:,2) = beta;
padaya(:,:,3) = gama;
padaya(:,:,4) = delta;

figure(1)
for i = 1:4
    subplot(2,2,i)
    imagesc(padaya(:,:,i))
end

end
