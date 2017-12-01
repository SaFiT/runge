function [ Xi, Yi] = runge(fun, Y0, step, a, b)
butcher = [      0     0      0 0 0 0 0;...
               4/7     0      0 0 0 0 0;...
           115/112 -5/16      0 0 0 0 0;...
           589/630  5/18 -16/45 0 0 0 0;...
229/1200-29/6000*5^0.5 119/240-187/1200*5^0.5 -14/75+34/375*5^0.5 -3/100*5^0.5 0 0 0;...
71/2400-587/12000*5^0.5 187/480-391/2400*5^0.5 -38/75+26/375*5^0.5 27/80-3/400*5^0.5 (1+5^0.5)/4 0 0;...
-49/480+43/160*5^0.5 -425/96+51/32*5^0.5 52/15-4/5*5^0.5 -27/16+3/16*5^0.5 5/4-3/4*5^0.5 5/2-0.5*5^0.5 0];
 
Ci = [0 4/7 5/7 6/7 (5-5^0.5)/10 (5+5^0.5)/10 1];
Bi = [1/12 0 0 0 5/12 5/12 1/12];
Ki = zeros(1,7);
n = abs(fix((b-a)/step));
Xi = zeros(1,n);
Yi = zeros(1,n);
Yi(1)=Y0;
Xi(1)= a;
Ki(1) = fun(Xi(1),Yi(1));
 for nn = 2: 1 : n
    sum1=0;
    for i = 1 : 1 :6
         sum = 0;
         for j = 1: 1 :6
            sum = sum + butcher(i+1,j)*Ki(j);
            Ki(i+1) = fun(Xi(nn-1)+Ci(i+1)*step,Yi(nn-1)+step*sum);
         end
    end
    for k = 1: 1 :7
        sum1 = sum1+ Bi(k)*Ki(k);
    end
     Yi(nn) = Yi(nn-1)+step*sum1;
        fprintf('Yi = %d\n',Yi(nn-1)); %disp(Xi(nn-1));
        Xi(nn) = Xi(nn-1)+step;
 end
  
 %%%%%%%%%%%%%%%%%%%%%
 step2= step/2;
 n = abs(fix((b-a)/step2));
 Xi1 = zeros(1,n);
Yi1 = zeros(1,n);
Yi1(1)=Y0;
Xi1(1)= a;
 
 for nn = 2: 1 : n
    sum12=0;
    for i = 1 : 1 :6
         sum2 = 0;
         for j = 1: 1 :6
            sum2 = sum2 + butcher(i+1,j)*Ki(j);
            Ki(i+1) = fun(Xi1(nn-1)+Ci(i+1)*step2,Yi1(nn-1)+step2*sum2);
         end
    end
    for k = 1: 1 :7
        sum12 = sum12+ Bi(k)*Ki(k);
    end
     Yi1(nn) = Yi1(nn-1)+step2*sum12;
       fprintf('Yi1 = %d\n',Yi1(nn-1));
        Xi1(nn) = Xi1(nn-1)+step2;
 end
 
 
 del = abs(Yi(3)-Yi1(3))/63;
 fprintf('Погрешность = %d \n',del);
end
