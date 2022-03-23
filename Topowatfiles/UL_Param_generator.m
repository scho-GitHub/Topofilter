%% Define Parameter sets from conditioned space for Topofilter simulation

%%set up parameter arrays
a1=zeros(1,n);
b1=zeros(1,n);
a2=zeros(1,n);
b2=zeros(1,n);

%Conditioned parameter space for Le Sueur Outlet Toposhed
for i=1:n 
    a1(i)=(-0.01+0.007)*rand()-0.007;
    b1(i)=(-0.2+0.05)*rand()-0.05;
    a2(i)=(-1.2e-7+1e-10)*rand()-1e-10;
    b2(i)=(-0.1+1e-4)*rand()-1e-4;
end
