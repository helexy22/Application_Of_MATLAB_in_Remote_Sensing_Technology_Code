clear;
fileID = fopen('doubledata.bin','w');
fwrite(fileID,magic(3),'double');
fclose(fileID);

fileID = fopen('doubledata.bin');
A = fread(fileID,[3 3],'double')
fclose(fileID);
