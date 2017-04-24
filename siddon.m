

% the points
p1x = -5;
p1y = -5;

p2x = 6;
p2y = 6;

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


if (alpha_min < alpha_max) 
    disp('Intersecting voxel space...');
endif

if (p1x < p2x) 
  
  if (alpha_min == alpha_xmin)
    i_min = 1;
  else 
    i_min = ceil((p1x + alpha_min *  (p2x - p1x) - X0)/d);
  endif
  
  if (alpha_max == alpha_xmax) 
    i_max = Nx - 1;
  else
    i_max = floor((p1x + alpha_max * (p2x - p1x) - X0)/d);
  endif
  
elseif (p1x > p2x) 
  
  if (alpha_min == alpha_xmin)
    i_max = Nx - 2;
  else 
    i_max = floor((p1x + alpha_min * (p2x - p1x) - X0)/d);
  endif
  
  if (alpha_max == alpha_xmax) 
    i_min = 0;
  else
    i_min = ceil((p1x + alpha_max * (p2x - p1x) - X0)/d);
  endif
  
else 
  disp('Special case: p1x and p2x are the same');
endif


if (p1y < p2y) 

elseif (p1y > p2y) 
 
else 
  disp('Special case: p1y and p2y are the same');
endif