function pbc = backward_pass(Y2,Z2,U2, A, B1,B2)
%BACKWARD_PASS Backward pass algorithm
%   @param Y Input measured sequence 1xL or Lx1
%   @param A Transitional model NxNxK
%   @param B Measureemtn model NxM
%   @param U Input control sequence (L-1)x1
%   @return Pb Output backward pass results NxL

% check dimensions
N = size(A,1);
M = size(B1,2);
pbc = 0;
[m,n]=size(Y2);
    for k=1:n
        Z = Z2{k};
        Y = Y2{k};
        [L,l] = size(Y);
       
        U = U2{k};% seperate input
        %U(end,:)=[]; % reduce the last one
        
        if size(A,2) ~= N || size(B1,1) ~=N || max(Y) > M || numel(U) ~= L-1  
            error('dimension error')
        end
        
        Pb = zeros(N,L); 
        % init
        Pb(:,L) = ones(N,1);
        
        % backward pass
        for i=L-1:-1:1
            for j=1:N
                for k=1:N
                    Pb(j,i) = Pb(j,i) + A(j,k,U(i)) * B1(k,Y(i+1))* B2(k,Z(i+1)) * Pb(k,i+1);
                end
            end
        end
        if (pbc == 0)
            pbc = Pb;
        else
            pbc = [pbc,Pb];
        end
    end
end