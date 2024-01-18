function [Z, X, Y] = generatezdisplacements(xsi_r, xsi_i, xsi_r_2, xsi_i_2, t)
%Generate Z Displacements, partly simulating ocean
    g = 9.81; %m/s^2
    N = 128;
    M = 128;
    L_x = N;
    L_z = M;
    A = 0.0002;
    
    V = 10.24; %Windspeed in m/s
    L = V^2/g;
    w = [1;0]; %Wind Direction
    
    Z = zeros(128, 128);
    tilda_h = zeros(128, 128);
    tilda_h_x = zeros(128, 128);
    tilda_h_y = zeros(128, 128);
    
    %Loop Through
    for n=0:128-1
        for m=0:128-1
            k = [(2*pi*n-pi*N)/L_x;(2*pi*m-pi*M)/L_z];
            magnitudek = norm(k);
            magnitudek = max(0.0001, magnitudek);
            omega = sqrt(g * magnitudek);
            
            
            P_h = A*exp(-1/(magnitudek*L).^2)/magnitudek^4 * dot(k/magnitudek, w/norm(w))^2;
            P_h_minusk = A*exp(-1/(magnitudek*L).^2)/magnitudek^4 * dot(-k/magnitudek,w/norm(w))^2;
            
            tilda_h_0 = (xsi_r(n+1, m+1)+1i*xsi_i(n+1, m+1))*sqrt(P_h/2);
            tilda_h_star0 = (xsi_r_2(n+1, m+1)+1i*xsi_i_2(n+1, m+1))*sqrt(P_h_minusk/2);
            tilda_h_star0 = conj(tilda_h_star0);
            
            tilda_h(n+1, m+1) = tilda_h_0*exp(1i*omega*t) + tilda_h_star0*exp(-1i*omega*t);
            
            tilda_h_x(n+1, m+1) = -i*k(1)/magnitudek*tilda_h(n+1, m+1) * -1^n;
            tilda_h_y(n+1, m+1) = -i*k(2)/magnitudek*tilda_h(n+1, m+1) * -1^m;
            
            tilda_h(n+1, m+1) = tilda_h(n+1, m+1) * -1^m;
            tilda_h(n+1, m+1) = tilda_h(n+1, m+1) * -1^n;
        end
    end
    
%     Z = ifft(ifft(tilda_h.').')*N;
%     X = ifft(ifft(tilda_h_x.').')*N;
%     Y = ifft(ifft(tilda_h_y.').')*N;


    Z = ifft2(tilda_h, 'symmetric')*N^2;
    X = ifft2(tilda_h_x, 'symmetric')*N^2;
    Y = ifft2(tilda_h_y, 'symmetric')*N^2;
    %disp(size(Z));
end

