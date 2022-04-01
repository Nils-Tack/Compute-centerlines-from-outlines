% Author: Nils Tack
% Compiled with Matlab 2020a
% Script used to produce the centerline of an object. Input file(s) must be 
% n x 2 matrices of the x and y coordinates of the boundary of the object 
% (outline). 
% This script was originaly developed to trace and output the centerlines of
% swimming fish.

%% Main paths
path_main = 'D:\Documents\USF\Research\Research project\MATLAB tools\Matlab scripts\Centerline\test files'; % set path to 'Data' folder

% Other paths
path_outlines = fullfile(path_main,'outlines'); % outlines produced from BW masks (.csv)
path_centerlines = fullfile(path_main,'centerlines'); % store centerlines produced from outlines (.csv)

%% Test one frame
% Options
scaleFactor = 16;           % Artificial scale to fit the outline (in mm) into a BW mask of size 'imageSize'
opts.test = 1;              % Option to plot preview of computation
opts.orientation = 2;       % Option to select orientation (1 = vertical, 2 = horizontal)
Npoints = 7;                % Number of points along final centerline
opts.rotateProfile = 1;     % Option to rotate profile

i1 = 1; % test frame

% Import outline
D_outlines = dir(fullfile(path_outlines,'iface_*.csv')); % path to outlines
outline = importdata(quickfilepath(D_outlines(i1)));

if opts.rotateProfile == 1
    [outline,rotCenter] = RotateProfile(outline,90,3); % rotate profile to have the fish swim toward the right of the frame
end

final_centerline = makeCenterline(outline,scaleFactor,Npoints,opts);

%% Export all the centerlines
opts.test = 0;   
mkdir(path_centerlines)

figure; 
fprintf('Exporting centerlines...');
for i = 1:length(D_outlines)

% Import outline
outline = importdata(quickfilepath(D_outlines(i)));

if opts.rotateProfile == 1
   outline = RotateProfile(outline,90,4,rotCenter); % rotate profile to have the fish swim toward the right of the frame
end

final_centerline = makeCenterline(outline,scaleFactor,Npoints,opts);

% Show quality of centerline
hold on
plot(outline(:,1),outline(:,2),'.k');
plot(final_centerline(:,1),final_centerline(:,2),'.r','markersize',10);
axis equal
hold off

% Export outline
filename = sprintf('centerline_%05g', i); % Number sequentially
csvwrite(fullfile(path_centerlines,[filename,'.csv']),final_centerline)

% Show progress
progressCount2(i,length(D_outlines)); % display export progress

pause(0.1)
clf
end

fprintf('done\n');
