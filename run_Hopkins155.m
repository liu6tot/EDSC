% Motion segmentation on John Hopkins155 dataset Using EDSC
% Pan Ji, pan.ji@anu.edu.au
% Oct 2013, ANU
% Modified in Oct. 2017 by Pan Ji (pan.ji@adelaide.edu.au)

clear, close all

addpath(genpath(pwd))
addpath('Ncut_9') % add paths of the Ncuts functions
cd 'Hopkins155'; % cd to your Hopkins155 dir
warning off;

file = dir;
idx = 0;
idx2 = 0;
idx3 = 0;
for i = 1:length(file)		
    if ( (file(i).isdir == 1) && ~strcmp(file(i).name,'.') && ~strcmp(file(i).name,'..') )
        filepath = file(i).name;
        eval(['cd ' filepath]);        
        
        f = dir;
        foundValidData = false;
        for j = 1:length(f)
            if ( ~isempty(strfind(f(j).name,'_truth.mat')) )
                ind = j;
                foundValidData = true;
				eval(['load ' f(ind).name]);
                break
            end
		end        
        cd ..        
        
        if(foundValidData)   
 			idx = idx+1;
 			n = max(s);           
            N = size(x,2);
            F = size(x,3);
            D = 2*F;
            X = reshape(permute(x(1:2,:,:),[1 3 2]),D,N); % data matrix with dimension DxF							
		
			lambda = 120; r = 4*n; outlier = false; post = true; affine = true; Dim = 4; alpha = 4;
			% X = dataProjection(X,r); % project data to 4n dimension with PCA			
			[Missrate, C, grp] = edsc(X,s,lambda,affine,outlier,Dim,alpha);

			disp([filepath ': ' num2str(100*Missrate) '%']);

 			missrate_tol(idx) = Missrate;
			if(max(s) == 2)
				idx2 = idx2+1;
				missrate_two(idx2) = Missrate;
			elseif(max(s) == 3)
				idx3 = idx3+1;
				missrate_three(idx3) = Missrate;
			end
 	
        end
    end
end
avgtol = mean(missrate_tol);
medtol = median(missrate_tol);
avgtwo = mean(missrate_two);
medtwo = median(missrate_two);
avgthree = mean(missrate_three);
medthree = median(missrate_three);
disp(['Mean of all: ' num2str(100*avgtol) '%' ', median of all: ' num2str(100*medtol) '%;']);
disp(['Mean of two: ' num2str(100*avgtwo) '%' ', median of two: ' num2str(100*medtwo) '%;']);
disp(['Mean of three: ' num2str(100*avgthree) '%' ', median of three: ' num2str(100*medthree) '%.']);


