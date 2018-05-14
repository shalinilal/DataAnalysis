function [ Vsmooth,Rsmooth ] = Get_Ron(V,I)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%  V1 = cell2mat(V(:,1))
%  I1 = cell2mat(I(:,2))
 
  dV = interp1(V,linspace(1,length(V),150));
  dI = interp1(I,linspace(1,length(I),150));
 R = diff(dV)./diff(dI);
 dR = interp1(R,linspace(1,length(R),150)); 

  %finding peaks%
  peaks = find( dR < 100 | dR > 10000);
counter = 0;

while ~isempty(peaks)
    peaks = find( dR < 100 | dR> 10000);
    dR(peaks) = ( dR(peaks-1) + dR(peaks+1) ) / 2;
    counter=counter+1;
end

 dRmin = 0.01;
 
 [Rsmooth,Vsmooth]= smoother(dR,dV,dRmin);
 

%  subplot(2,1,1);plot(dV,dR); 
%  subplot(2,1,2); plot(Vsmooth, Rsmooth);


end

