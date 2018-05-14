function [Ynew,Xnew] = smoother(Y, X, dYlim)

%j=1;
k=1;
if Y(1) == Inf
    Xnew(1) = X(2);
    Ynew(1) = Y(2);
else
    Xnew(1) = X(1);
    Ynew(1) = Y(1);
end
for i = 2:length(Y)
    if Y(i) ~= Inf && abs(Ynew(k)-Y(i)) >= dYlim
%          if (i-j) == 1
%              k=k+1;j=i;
%              Xnew(k) = X(i);
%              Ynew(k) = Y(i);
%          else
%               j=i;
            k=k+1;
            Xnew(k) = (X(i)+Xnew(k-1))/2;
            Ynew(k) = Ynew(k-1)+ (Xnew(k)-Xnew(k-1))*(Y(i)-Ynew(k-1))/(X(i)-Xnew(k-1));
%        end
    end
end

Ynew = Ynew';
Xnew = Xnew';

