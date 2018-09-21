function Bmap = segNeighbors(svMap)
%  
%  W18 EECS 504 HW4p2 Fg-bg Graph-cut
%  Jason Corso, jjcorso@umich.edu
%
%  Implement the code to compute the adjacency matrix for the superpixel graph
%  captured by svMap
%
%  INPUT:  svMap is an integer image with the value of each pixel being
%           the id of the superpixel with which it is associated
%  OUTPUT: Bmap is a binary adjacency matrix NxN (N being the number of superpixels
%           in svMap).  Bmap has a 1 in cell i,j if superpixel i and j are neighbors.
%           Otherwise, it has a 0.  Superpixels are neighbors if any of their
%           pixels are neighbors.

segmentList = unique(svMap);
segmentNum = length(segmentList);

%%% FILL IN THE CODE HERE to calculate the adjacency
Bmap=zeros(segmentNum);
s=size(svMap);
for m=1:s(1)-1
    for n=1:s(2)-1
        Bmap(svMap(m,n),svMap(m,n+1))=1;
        Bmap(svMap(m,n),svMap(m+1,n))=1;
        Bmap(svMap(m,n),svMap(m+1,n+1))=1;
        %symmetric
        Bmap(svMap(m,n+1),svMap(m,n))=1;
        Bmap(svMap(m+1,n),svMap(m,n))=1;
        Bmap(svMap(m+1,n+1),svMap(m,n))=1;
    end
end
% a type of diagonal neighbors
for m=2:s(1)
    for n=1:s(2)-1
        Bmap(svMap(m,n),svMap(m-1,n+1))=1;
        Bmap(svMap(m-1,n+1),svMap(m,n))=1;
    end
end
Bmap=Bmap-eye(segmentNum);
%%%

