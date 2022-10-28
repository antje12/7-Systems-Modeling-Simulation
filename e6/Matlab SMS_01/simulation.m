function [X, Y, Z] = simulation(pinit, A, B1, B2, U)
    %SIMULATION Simulate a IO-HMM given a system model
    %   @param pinit Initial probabilities Nx1
    %   @param A Transitional model NxNxK
    %   @param B Measureemtn model NxM
    %   @param U Input control sequence (L-1)x1
    %   @return Z Output measurements Lx1
    %   @return X Output ground truth states Lx1


    % check dimensions
    N = size(A,1);
    M = size(B1,2);
    L = numel(U) + 1;
    K = size(A,3);

    if numel(pinit) ~= N || size(A,2) ~= N || size(B1,1) ~=N 
        error('dimension error')
    end

    % initial states
    X = state_sampler(pinit);
    Y = state_sampler(B1(X(1),:));
    Z = state_sampler(B2(X(1),:));

    for i=2:L
        X = [X; state_sampler(A(X(i-1),:,U(i-1)))];
        Y = [Y; state_sampler(B1(X(i),:))];
        Z = [Z; state_sampler(B2(X(i),:))];
    end

end


% sampler function
function x = state_sampler(xprob)

if abs(sum(xprob) - 1.0) > 1e-6
    error('sum prob should be one')
end

accum_prob = cumsum(xprob);
sample = rand;
for i=1:numel(xprob)
    if sample <= accum_prob(i)
        x = i;
        break;
    end
end

end