%LOG2LIN   conversion from logarithmic to linear scale
%
%Revision: 5.0.0cd   Date: 17-Jul-2001

function linout = db2lin(login)

linout = 10.^((login)/10);
