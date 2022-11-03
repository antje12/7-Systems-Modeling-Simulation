
clear
close all

trainSeqNumber = 50;    %number of training sequences
testSeqNumber = 5;      %number of testing sequences


% system model: transition matrices
A = zeros(3,3,2);
A(:,:,1) = [0.8 0.1 0.1;
            0.1 0.8 0.1;
            0.1 0.1 0.8];   % action: non-shift (left to right)
A(:,:,2) = [0.1 0.8 0.1;
            0.1 0.1 0.8;
            0.8 0.1 0.1];   % action: shift to next
% system model: emission matrices
B1 = [0.90 0.05 0.05;
      0.05 0.90 0.05;
      0.05 0.05 0.90];
B2 = [0.80 0.15 0.05;
      0.20 0.75 0.05;
      0.10 0.05 0.85];
% system model: initial distribution/initial states
pinit = [1; 0; 0];

%generating training sequences
for i = 1:trainSeqNumber
    L = round(100.*rand + 150);
    p_trans = 0.5;     % prob to chose trans action
    U{i} = (rand(L-1, 1) < p_trans) + 1;
    [X{i}, Y{i}, Z{i}] = simulation(pinit, A, B1,B2, U{i});
end

% init param
A_init = rand(3,3,2);
B_init1 = rand(3,3);
B_init2 = rand(3,3);
pinit_init = rand(3,1);

% normalize init param
for k=1:size(A_init,3)
    for i=1:size(A_init,1)
        A_init(i,:,k) = A_init(i,:,k) / sum(A_init(i,:,k));
    end
end
for i=1:size(B_init1,1)
    B_init1(i,:) = B_init1(i,:) / sum(B_init1(i,:));
end
for i=1:size(B_init2,1)
    B_init2(i,:) = B_init2(i,:) / sum(B_init2(i,:));
end
pinit_init = pinit_init / sum(pinit_init);

%Learning parameters
nr_iter = 20; % number of iteration
[pinit_lrn, A_lrn, B_lrn1, B_lrn2] = EM_param_learning(Y,Z,U, pinit_init, A_init, B_init1, B_init2, nr_iter)


%Testting
%Predicting future