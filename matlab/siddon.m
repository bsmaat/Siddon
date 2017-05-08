drawTheGrid = true;

% the points
p1x = -1.5;
p1y = 0.1;

p2x = 1.5;
p2y = 0.11;

p1 = [p1x p1y];
p2 = [p2x p2y];

% the number of planes
Nx = 5;
Ny = 5;

% separation between planes
d = 1;

% position of first plane (in x or y)
X0 = -2;
Y0 = -2;


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
alpha_x0 = (X0 - p1x)/(p2x - p1x);
alpha_xf = (X0 + (Nx-1)*d - p1x) / (p2x - p1x); 

alpha_y0 = (Y0 - p1y)/(p2y - p1y);
alpha_yf = (Y0 + (Ny-1)*d - p1y) / (p2y - p1y); 

alpha_xmin = min([alpha_x0, alpha_xf]);
alpha_xmax = max([alpha_x0, alpha_xf]);

alpha_ymin = min([alpha_y0, alpha_yf]);
alpha_ymax = max([alpha_y0, alpha_yf]);

alpha_min = max([alpha_xmin, alpha_ymin]);
alpha_max = min([alpha_xmax, alpha_ymax]);






%# this  is computing imin, imax, jmin, jmax
%# need to find intersection alpha values
if (alpha_min < alpha_max) 
    disp('Intersecting voxel space...');
end

if (p1x < p2x) 
  
  if (alpha_min == alpha_xmin)
    i_min = 1;
  else 
    i_min = ceil((p1x + alpha_min *  (p2x - p1x) - X0)/d);
  end
  
  if (alpha_max == alpha_xmax) 
    i_max = Nx - 1;
  else
    i_max = floor((p1x + alpha_max * (p2x - p1x) - X0)/d);
  end
  
  alphax = ((X0 + i_min * d) - p1x)/(p2x - p1x);
  
elseif (p1x > p2x) 
  
  if (alpha_min == alpha_xmin)
    i_max = Nx - 2;
  else 
    i_max = floor((p1x + alpha_min * (p2x - p1x) - X0)/d);
  end
  
  if (alpha_max == alpha_xmax) 
    i_min = 0;
  else
    i_min = ceil((p1x + alpha_max * (p2x - p1x) - X0)/d);
  end
  
  alphax = ((X0 + i_max * d) - p1x)/(p2x - p1x);
  
else 
  disp('Special case: p1x and p2x are the same');
end



if (p1y < p2y) 
  
  if (alpha_min == alpha_ymin)
    j_min = 1;
  else 
    j_min = ceil((p1y + alpha_min *  (p2y - p1y) - Y0)/d);
  end
  
  if (alpha_max == alpha_ymax) 
    j_max = Ny - 1;
  else
    j_max = floor((p1y + alpha_max * (p2y - p1y) - Y0)/d);
  end
  
  alphay = ((Y0 + j_min * d) - p1y)/(p2y - p1y);

  
elseif (p1y > p2y) 

  if (alpha_min == alpha_ymin)
    j_max = Ny - 2;
  else 
    j_max = floor((p1y + alpha_min * (p2y - p1y) - Y0)/d);
  end
  
  if (alpha_max == alpha_ymax) 
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

Nv = 4; %# numer of pixels intersected
%# dconv is from beginning to end
dconv = sqrt( (p2x - p1x)^2 + (p2y - p1y)^2 );
d12 = 0;
alphac = alpha_min;

%disp(['Indicies: ', num2str(i),' ', num2str(j)]);
for k = 1:Nv
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

%disp(['Distance: ', num2str(d12)]);





