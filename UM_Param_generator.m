%% Define Parameter sets from conditioned space for Topofilter simulation

%%set up parameter arrays
a1=zeros(1,n);
b1=zeros(1,n);
a2=zeros(1,n);
b2=zeros(1,n);

%Conditioned parameter space for Main Cobb Toposhed
for i=1:n 
    a1(i)=(-0.01+1e-3)*rand()-1e-3;
    b1(i)=(-0.5+0.001)*rand()-0.001;
    a2(i)=(-2.0e-7+2e-8)*rand()-2e-8;
    b2(i)=(-0.1+2e-4)*rand()-1e-5;
end
