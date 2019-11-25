function MAIN()

% Parameters
model   = 'contour';
savefig = 0;

% Simulation
sets = SETTINGS(model);

ind=1:1;
for ii=ind
    if (ii==1), preload=0;
    else, preload=1;
    end
    
    args = SETARGS(preload, sets);

    fprintf('Computing.. '); tic;
    u = TEMP(model, args); toc;
end

fprintf('Creating figures.. '); tic;
PRINT(model, savefig, u, args, sets); toc;