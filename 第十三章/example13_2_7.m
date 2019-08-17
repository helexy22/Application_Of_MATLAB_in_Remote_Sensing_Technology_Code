clear;

dc = shaperead('usastatelo', 'UseGeoCoords', true,...
    'Selector',{@(name) strcmpi(name,'District of Columbia'),...
    'Name'});
lat = [dc.Lat]';
lon = [dc.Lon]';
[lat lon]

mstruct = defaultm('mercator');
mstruct.origin = [38.89 -77.04 0];
mstruct = defaultm(mstruct);

[x,y] = mfwdtran(mstruct,lat,lon);
[x y]

[lat2,lon2] = minvtran(mstruct,x,y);
[lat2 lon2]
