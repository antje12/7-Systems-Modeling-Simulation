clc
clear
close all
trainSeqNumber = 50;    %number of training sequences - Test with 50, 60, 70, 80, 90, 100
testSeqNumber = 5;      %number of testing sequences


%*********** data generation starts **********************************
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
    [X{i}, Y{i}, Z{i}] = simulation(pinit, A, B1, B2, U{i});
end
%*********** data generation ends ************************************


%*********** Model initialization starts *****************************
% init param
%A_init = rand(3,3,2);

A_init(:,:,1) = [0.8 0.1 0.1;
                0.1 0.8 0.1;
                0.1 0.1 0.8]; 
A_init(:,:,2) = [0.1 0.8 0.1;
                0.1 0.1 0.8;
                0.8 0.1 0.1];

B_init1 = rand(3,3);
B_init2 = rand(3,3);
pinit_init = rand(3,1);
%*********** Model initialization ends ******************************


%*********** Model training starts **********************************
%Learning parameters
nr_iter = 20; % number of iteration
[pinit_lrn, A_lrn, B_lrn1, B_lrn2] = EM_param_learning(Y,Z,U, pinit_init, A_init, B_init1, B_init2, nr_iter);

disp ('01 The initial states are:------------------- ') 
pinit_lrn

disp ('02 The transition matrices are:------------------- ') 
A_lrn

disp ('03 The emission matrices are:------------------- ') 
B_lrn1
B_lrn2
%*********** Model training ends ************************************


%*********** Model testing starts ************************************
disp ('04 The diagnosis estimation:------------------- ') 
%generating testting sequences
for i = 1:testSeqNumber
    % control seq
    L = round(100.*rand + 150);
    p_trans = 0.5;     % prob to chose trans action
    U2{i} = (rand(L-1, 1) < p_trans) + 1;
    [X2{i}, Y2{i}, Z2{i}] = simulation(pinit, A, B1, B2, U2{i});
end

% applying the Viterbi algorithm
[current_distributions] = viterbi_7(Y2,Z2,U2, pinit_lrn, A_lrn, B_lrn1, B_lrn2)

% Finding maximum probable states
[value,index] = max(current_distributions);
disp ('05 The final statement::------------------- ')
if any(isnan(current_distributions)) 
    disp ('!!!!!! Not enough information in the data. Creat a new dataset or increase the data volume.')
elseif (index == 1)
    disp ('The system is in good health.')
elseif (index == 2)
    disp ('The system is damaged but still functioning.')
else
    disp ('The system is failed.')
end
%*********** Model testing ends ************************************
