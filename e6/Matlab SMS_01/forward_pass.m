function [pfc,lseq] = forward_pass(Y2,Z2,U2, pinit, A, B1,B2)
%FORWARD_PASS Forward pass algorithm
%   @param Y Input measured sequence 1xL or Lx1
%   @param pinit Initial probabilities Nx1
%   @param A Transitional model NxNxK
%   @param B Measureemtn model NxM
%   @param U Input control sequence (L-1)x1
%   @return Pf Output forward pass results NxL

% check dimensions
N = size(A,1);
M = size(B1,2);
pfc = 0;
[m,n]=size(Y2);
    
lseq = zeros(n,1);
    for k2=1:n
        Z = Z2{k2};
        Y = Y2{k2};
        [L,l] = size(Y);

        U = U2{k2}; % seperate input
        %U(end,:)=[]; % reduce the last one
        
        if numel(pinit) ~= N || size(A,2) ~= N || size(B1,1) ~=N || numel(U) ~= L-1
            error('dimension error')
        end
        
        Pf = zeros(N,L);
        % init
        for j=1:N
            Pf(j,1) = pinit(j) * B1(j,Y(1))* B2(j,Z(1));
        end
        
        % forward pass
        for i=2:L
            if i==20
                hh=1;
            end
            for j=1:N
                for k=1:N
                    Pf(j,i) = Pf(j,i) + Pf(k,i-1) * A(k,j,U(i-1)) * B1(j,Y(i))* B2(j,Z(i));
                end
            end  
        end
       
        lseq(k2) = sum(Pf(:,L));
        if (pfc == 0)
            pfc = Pf;
        else
            pfc = [pfc,Pf];
        end
    end  
end