function [a,b,c,d]=para(ep,r,alphac,betac,deltac)
         % this is the function for assigning the decaying  part for
         % neighboring pixels.
         % Inputs : ep = exponential value
         %           r = power of the exp
         % alphac-->deltac : center pixal values of four different
         % endmembers
         % Outputs : a,b,c,d =desired pixel alpha --> gama values
       
         a=alphac*exp(-(ep^r)); %  force assign 
         b=betac*exp(-(ep^r));
         c=deltac*exp(-(ep^r));
         sum=a+b+c;
         d=1-sum; % from the sum to one constrain
end