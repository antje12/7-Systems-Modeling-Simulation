function [current_distributions] = viterbi_7(Y2,Z2,U2, pinit, A, B1,B2)


    N = size(A,1);
    M = size(B1,2);
    [P,Q] = size(Y2);
    current_distributions = 0;
    for r = 1:Q   
        Y = Y2{r};
        Z = Z2{r};
        U = U2{r};
        [L,l] = size(Y); 
        %U(end,:)=[]; % reduce the last one         
        if numel(pinit) ~= N || size(A,2) ~= N || size(B1,1) ~=N || numel(U) ~= L-1
            error('dimension error')
        end
        Vt = zeros(N,L);
        % basis part
        for j=1:N
            Vt(j,1) = pinit(j) * B1(j,Y(1))* B2(j,Z(1));
        end        
        % recursion forward part
        for i=2:L
            for j=1:N
                v0 = 0;
                for k=1:N
                    v1=Vt(k,i-1) * A(k,j,U(i-1)) * B1(j,Y(i))* B2(j,Z(i));
                    if (v1>v0)
                        Vt(j,i) = v1;
                        v0 = v1;
                    end
                end
            end
            %-------------------------------
            L2 = i;
            % recursion backward pass
            for i2=L2-1:-1:1
                for j2=1:N
                    v00 = 0;
                    for k=1:N
                        v2 = A(j2,k,U(i2)) * B1(k,Y(i2+1))* B2(k,Z(i2+1)) * Vt(k,i2+1);
                        if (v2>v00)
                            Vt(j2,i2) = v2;
                            v00 = v2;
                        end
                    end
                end                
            end
            %-------------------------------
            %------last index (Vt) update statr---
            for j=1:N
                v0 = 0;
                for k=1:N
                    v1=Vt(k,i-1) * A(k,j,U(i-1)) * B1(j,Y(i))* B2(j,Z(i));
                    if (v1>v0)
                        Vt(j,i) = v1;
                        v0 = v1;
                    end
                end
            end
            %---------update end------------------
        end
        [di,time] = diagnosis_4(Y,Z,A,B1,B2,Vt);
        current_distributions = di(:,end);
        %if(r == 1)
           % current_distributions = di(:,end);
       % else
           % current_distributions = horzcat(current_distributions, di(:,end));
        %end
    end
end