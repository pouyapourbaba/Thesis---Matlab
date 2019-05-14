%LIN2LOG   conversion from linear to logarithmic scale
%
%Revision: 5.0.0cd   Date: 17-Jul-2001

function logout = lin2log(linin)

logout = 10*log10(linin);
