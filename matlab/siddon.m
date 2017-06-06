drawTheGrid = true;

% the points
p1x = -3.3;
p1y = 0.1;

p2x = 4.5;
p2y = 4.5;

p1 = [p1x p1y];
p2 = [p2x p2y];

% the number of planes
Nx = 11;
Ny = 11;

% separation between planes
d = 1;

% position of first plane (in x or y)
X0 = -5;
Y0 = -5;


if (drawTheGrid == true) 
% draw the grid

    % edges
    X_start = X0;
    X_end = X0 + (Nx-1) * d;
    
    Y_start = Y0;
    Y_end = Y0 + (Ny-1) * d;

    figure;
    hold on;
    for i = 1:Nx
        for j = 1:Ny
            Xb = X0 + (i-1)*d;
            Yb = Y0 + (j-1)*d;
            line([Xb Xb], [Y_start Y_end]);
            line([X_start X_end], [Yb Yb]);
        end
    end


    %plot(A(1),A(2),'o');
    %plot(B(1),B(2),'*');
    plot([p1x p2x], [p1y p2y], 'r');
end

% find alpha_min and alpha_max
alpha_x0 = (X0 - p1x)/(p2x - p1x); % hit first x plane
alpha_xf = (X0 + (Nx-1)*d - p1x) / (p2x - p1x); % hit last x plane

alpha_y0 = (Y0 - p1y)/(p2y - p1y); % hit first y plane
alpha_yf = (Y0 + (Ny-1)*d - p1y) / (p2y - p1y); % hit last y plane

alpha_xmin = min([alpha_x0, alpha_xf]); % the first x plane we hit
alpha_xmax = max([alpha_x0, alpha_xf]); % the last x plane we hit

alpha_ymin = min([alpha_y0, alpha_yf]); % the first y plane we hit
alpha_ymax = max([alpha_y0, alpha_yf]); % the last y plane we hit

alpha_min = max([alpha_xmin, alpha_ymin]); % the first plane we hit (x or y)
alpha_max = min([alpha_xmax, alpha_ymax]); % the lane plane we hit (x or y)






%# this  is computing imin, imax, jmin, jmax
%# need to find intersection alpha values
if (alpha_min < alpha_max) 
    disp('Intersecting voxel space...');
end

if (p1x < p2x) 
  
  if (alpha_xmin < 0) 
    i_min = ceil((p1x - X0)/d);
  elseif (alpha_min == alpha_xmin)
    i_min = 1;
  else 
    i_min = ceil((p1x + alpha_min *  (p2x - p1x) - X0)/d);
  end
  
  if (alpha_xmax > 1) 
    i_max = floor((p1x + (p2x - p1x) - X0)/d);
  elseif (alpha_max == alpha_xmax) 
    i_max = Nx - 1;
  else
    i_max = floor((p1x + alpha_max * (p2x - p1x) - X0)/d);
  end
  
  alphax = ((X0 + i_min * d) - p1x)/(p2x - p1x);
  
elseif (p1x > p2x) 
  
  if (alpha_xmin < 0) 
    i_max = floor((p1x + (p2x - p1x) - X0)/d);
  elseif (alpha_min == alpha_xmin)
    i_max = Nx - 2;
  else 
    i_max = floor((p1x + alpha_min * (p2x - p1x) - X0)/d);
  end
  
  if (alpha_xmax > 1)
    i_min = ceil((p1x - X0)/d);
  elseif (alpha_max == alpha_xmax) 
    i_min = 0;
  else
    i_min = ceil((p1x + alpha_max * (p2x - p1x) - X0)/d);
  end
  
  alphax = ((X0 + i_max * d) - p1x)/(p2x - p1x);
  
else 
  disp('Special case: p1x and p2x are the same');
end



if (p1y < p2y) 
  
  if (alpha_ymin < 0) 
    j_min = ceil((p1y - Y0)/d);
  elseif (alpha_min == alpha_ymin)
    j_min = 1;
  else 
    j_min = ceil((p1y + alpha_min *  (p2y - p1y) - Y0)/d);
  end
  
  if (alpha_ymax > 1) 
    j_max = floor((p1y + (p2y - p1y) - Y0)/d);
  elseif (alpha_max == alpha_ymax) 
    j_max = Ny - 1;
  else
    j_max = floor((p1y + alpha_max * (p2y - p1y) - Y0)/d);
  end
  
  alphay = ((Y0 + j_min * d) - p1y)/(p2y - p1y);

  
elseif (p1y > p2y) 

  if (alpha_ymin < 0) 
    j_max = floor((p1y + (p2y - p1y) - Y0)/d);
  elseif (alpha_min == alpha_ymin)
    j_max = Ny - 2;
  else 
    j_max = floor((p1y + alpha_min * (p2y - p1y) - Y0)/d);
  end
  
  if (alpha_ymax > 1)
    j_min = ceil((p1y - Y0)/d);
  elseif (alpha_max == alpha_ymax) 
    j_min = 0;
  else
    j_min = ceil((p1y + alpha_max * (p2y - p1y) - Y0)/d);
  end
 
  alphay = ((Y0 + j_max * d) - p1y)/(p2y - p1y);

 
else 
  disp('Special case: p1y and p2y are the same');
end
    
%# calculate first interected pixel indices

alphatmp = (min(alphax, alphay) + alpha_min)/2;

i = floor( (p1x + alphatmp * (p2x - p1x) - X0)/d );
j = floor( (p1y + alphatmp * (p2y - p1y) - Y0)/d );

tmp = [alphax alphay];
af_min = min(tmp);
tmp = sort(tmp);

for m=1:size(tmp,2)
  alpha_mean = (tmp(m) + alpha_min)  * 0.5;
  i0 = floor( (p1x + alpha_mean * (p2x - p1x) - X0)/d );
  j0 = floor( (p1y + alpha_mean * (p2y - p1y) - Y0)/d );
  i0
  j0
end


% temporary fix since the above won't get the right one if we're in teh
% pixel space
i = round( (p1x + alphax * (p2x - p1x) - X0)/d) - 1;
j = round( (p1y + alphay * (p2y - p1y) - X0)/d) - 1;

alphaxu = abs(d / (p2x - p1x));
if (p1x < p2x) 
  iu = 1;
elseif (p1x > p2x)
  iu = -1;
elseif (p1x == p2x) 
  disp('Special case!');
end

alphayu = abs(d / (p2y - p1y));
if (p1y < p2y) 
  ju = 1;
elseif (p1y > p2y) 
  ju = -1;
elseif (p1y == p2y) 
  disp('Speical case y!');
end


%# finally

if (j_min > j_max) 
    disp('no y planes crossed');
end

if (i_min > i_max)
    disp('no x planes crossed');
end

Np = (i_max - i_min + 1) + (j_max - j_min + 1);

%# dconv is from beginning to end
dconv = sqrt( (p2x - p1x)^2 + (p2y - p1y)^2 );
d12 = 0;

%{
if (i_min > 1 || j_min > 1) 
    alphac = 0;
%else
    if (alphax <= alphay)
        l = (alphax - alphac) * dconv;
        disp(['Indicies (i): ', num2str(i),' ', num2str(j), ' ', num2str(l)]);

        d12 = d12 + l;
        i = i + iu;
        alphac = alphax;
        alphax = alphax + alphaxu;
      elseif (alphax > alphay) 
        l = (alphay - alphac) * dconv;
        disp(['Indicies (j): ', num2str(i),' ', num2str(j), ' ', num2str(l)]);


        d12 = d12 + l;
        j = j + ju;
        alphac = alphay;
        alphay = alphay + alphayu;
      elseif (alphax == alphay) 
        disp(['Indicies (=): ', num2str(i), ' ' , num2str(j)]);
        alphax = alphax + alphaxu; 
    end
end
%}

%alphac = alphax;
%alphax = alphax + alphaxu;

% 1+1 because i've delt with the first plane already above (when it starts
% insdie pixel)
%for k = 1+1:Np
alphac = 0;
t = min([alphaxu, alphayu]);
while (alphac + t < alpha_max)
  if (alphax <= alphay) 
    l = (alphax - alphac) * dconv;
    disp(['Indicies (i): ', num2str(i),' ', num2str(j), ' ', num2str(l)]);

    d12 = d12 + l;
    i = i + iu;
    alphac = alphax;
    alphax = alphax + alphaxu;
  elseif (alphax > alphay) 
    l = (alphay - alphac) * dconv;
    disp(['Indicies (j): ', num2str(i),' ', num2str(j), ' ', num2str(l)]);

    
    d12 = d12 + l;
    j = j + ju;
    alphac = alphay;
    alphay = alphay + alphayu;
  elseif (alphax == alphay) 
    disp(['Indicies (=): ', num2str(i), ' ' , num2str(j)]);
    alphax = alphax + alphaxu; 
  end
end

%{
if (i_max < Nx - 1 || j_max < Ny - 1) 
    alphax = 1;
    
%else
    if (alphax <= alphay)
        l = (alphax - alphac) * dconv;
        disp(['Indicies (i): ', num2str(i),' ', num2str(j), ' ', num2str(l)]);

        d12 = d12 + l;
        i = i + iu;
        alphac = alphax;
        alphax = alphax + alphaxu;
      elseif (alphax > alphay) 
        l = (alphay - alphac) * dconv;
        disp(['Indicies (j): ', num2str(i),' ', num2str(j), ' ', num2str(l)]);


        d12 = d12 + l;
        j = j + ju;
        alphac = alphay;
        alphay = alphay + alphayu;
      elseif (alphax == alphay) 
        disp(['Indicies (=): ', num2str(i), ' ' , num2str(j)]);
        alphax = alphax + alphaxu; 
    end
end
%}





