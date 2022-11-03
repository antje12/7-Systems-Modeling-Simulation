function [di,time] = diagnosis_4(Y,Z,A,B1,B2,di)
%FORWARD_PASS Forward pass algorithm
%	@param di sequence of diagnosis by obserations
%	@param cs current state
%   @param Y and Z Input measured sequence 1xL or Lx1
%   @param A Transitional model NxNxK
%   @param B1 and B2 Measureemtn model NxM
       
    [N,L] = size(di);
    for i=1:L       % diagnosis
        sum = 0;
        for j = 1:N
            sum = sum + B1(j,Y(i))* B2(j,Z(i)) * di(j,i);
        end
        for j = 1:N
           di(j,i) = (B1(j,Y(i))* B2(j,Z(i)) * di(j,i))/sum;
        end  
    end   
    time = i;
end