function matrix = readfile(name)
fid = fopen(name);
matrix = cell2mat(textscan(fid, '%f %f %f %f %f %f %f %f %f %f','headerlines',11));
end