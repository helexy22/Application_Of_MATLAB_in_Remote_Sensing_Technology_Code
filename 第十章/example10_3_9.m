clear;

load stereoPointPairs
f = estimateFundamentalMatrix(...
    matched_points1,matched_points2,'NumTrials',2000);
imageSize = [200 300];
[isIn,epipole] = isEpipoleInImage(f,imageSize)
