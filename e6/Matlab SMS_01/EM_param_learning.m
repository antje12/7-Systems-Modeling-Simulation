function [pinit, A, B1, B2] = EM_param_learning(Y,Z,U2, pinit_init, A_init, B_init1,B_init2, nr_iter)
%EM HMM parameter learning
        
% customizing data:
[m,n]=size(Z);
Y2 = Y{1}; %initial observation1
Z2 = Z{1}; %initial observation2
U = [U2{1};1]; %initial input
for i=2:n
    Z2 = [Z2;Z{i}];
    Y2 = [Y2;Y{i}];
    U = [U;U2{i};1];
end
[L2,l] = size(Z2);
[L1,l] = size(Y2);
U(end,:)=[];

% check dimensions
N = size(A_init,1);
M = size(B_init1,2);
%L = numel(Y);
K = size(A_init,3);

if numel(pinit_init) ~= N || size(A_init,2) ~= N || size(B_init1,1) ~=N || numel(U) ~= L1-1
    error('dimension error')
end

% init
pinit = pinit_init;
A = A_init;
B1 = B_init1;
B2 = B_init2;

%[vtrb] = viterbi_2(Y,Z,U2, pinit, A, B1,B2);

for iter=1:nr_iter

    % E-step
    % forward backward pass
    [Pf,lseq_cell] = forward_pass(Y,Z,U2, pinit, A, B1,B2);
    Pb = backward_pass(Y,Z, U2, A, B1,B2);
    
    % size of all sequences
    [maxSeq,aa] = cellfun(@size,Y.');
    for i=2:n
        maxSeq(i)= maxSeq(i)+maxSeq(i-1);
    end

    % state probabilities given measured sequence p(x_t=i | Y)
    P = zeros(N,L1);
    for i=1:L1
        if(i==2913)
            k=19;
        end
        k = 1;
        while (k<=n)
            if (i <= maxSeq(k))
                lseq = lseq_cell(k);
                k = n;
            end
            k = k+1;
        end
        for j=1:N           
            P(j,i) = Pf(j,i) * Pb(j,i) / lseq;
        end
    end
         
    % M-step
    % state transition probabilities given measured sequence p(x_t=i, x_{t+1}=j | Y)
    phi = zeros(N,N,L1-1);
    for i=1:L1-1
        q = 1;
        while (q<=n)
            if (i <= maxSeq(q))
                lseq = lseq_cell(q);
                q = n;
            end
            q = q+1;
        end
        for j=1:N
            for k=1:N              
                phi(j,k,i) = Pf(j,i) * A(j,k,U(i)) * B1(k,Y2(i+1))* B2(k,Z2(i+1)) * Pb(k,i+1) / lseq;
            end
        end           
    end

    % update params
    for i=1:N
        pinit(i) = P(i,1);
    end
    
    for i=1:N
        for j=1:N
            for k=1:K
                uk_idx = find(U==k);
                A(i,j,k) = sum(phi(i,j,uk_idx)) / sum(P(i,uk_idx));
            end
        end
    end
    
    for i=1:N
        for k=1:M
            yk_idx = find(Y2==k);
            B1(i,k) = sum(P(i, yk_idx)) / sum(P(i,1:L1));
            zk_idx = find(Z2==k);
            B2(i,k) = sum(P(i, zk_idx)) / sum(P(i,1:L1));
        end
    end
end
for i=1:size(A_init,3)
    A(:,:,i) = A(:,:,i)./sum(A(:,:,i),2);
end
end