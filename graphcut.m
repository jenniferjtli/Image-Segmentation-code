function [B] = graphcut(segmentimage,segments,keyindex)
%
% W18 EECS 504 HW4p2 Fg-bg Graph-cut
% Jason Corso, jjcorso@umich.edu
%
% Function to take a superpixel set and a keyindex and convert to a 
%  foreground/background segmentation.
%
% keyindex is the index to the superpixel we wish to use as foreground and
% find its relevant neighbors that would be in the same macro-segment
%
% Similarity is computed based on segments(i).fv (which is a color histogram)
%  and spatial proximity.
%
% segmentimage and segments are returned by the superpixel function
%  segmentimage is called S and segments is called Copt  
%
% OUTPUT:  B is a binary image with 1's for those pixels connected to the
%          source node and hence in the same segment as the keyindex.
%          B has 0's for those nodes connected to the sink.

%% Compute basic adjacency information of superpixels
%%%  Note that segNeighbors is code you need to implement
adjacency = j_segNeighbors(segmentimage);
%debug
figure; imagesc(adjacency); title('adjacency');

% Normalization for distance calculation based on the image size.
% For points (x1,y1) and (x2,y2), distance is exp(-||(x1,y1)-(x2,y2)||^2/dnorm)
% Thinking of this like a Gaussian and considering the Std-Dev of the Gaussian 
% to be roughly half of the total number of pixels in the image. Just a
% guess.
dnorm = 2*prod(size(segmentimage)/2)^2;

k = length(segments);

%% Generate capacity matrix
capacity = zeros(k+2,k+2);  % initialize the zero-valued capacity matrix
source = k+1;  % set the index of the source node
sink = k+2;    % set the index of the sink node

% This is a single planar graph with an extra source and sink.
%
% Capacity of a present edge in the graph (adjacency) is to be defined as the product of
%  1:  the histogram similarity between the two color histogram feature vectors.
%      use the provided histintersect function below to compute this similarity 
%  2:  the spatial proximity between the two superpixels connected by the edge.
%      use exp(-D(a,b)/dnorm) where D is the euclidean distance between superpixels a and b,
%      dnorm is given above.
%
% * Source gets connected to every node except sink:
%   capacity is with respect to the keyindex superpixel
% * Sink gets connected to every node except source:
%   capacity is opposite that of the corresponding source-connection (from each superpixel)
%   in our case, the max capacity on an edge is 3; so, 3 minus corresponding capacity
% * Other superpixels get connected to each other based on computed adjacency
% matrix:
%  capacity defined as above. EXCEPT THAT YOU ALSO NEED TO MULTIPLY BY A SCALAR 0.25 for
%  adjacent superpixels.


%%% FILL IN CODE HERE to generate the capacity matrix using the description above.
%source edges
for m=1:k
    capacity(k+1,m)=histintersect(segments(m).fv,segments(keyindex).fv)*...
        exp(-((segments(m).x-segments(keyindex).x)^2+(segments(m).y-segments(keyindex).y)^2)/dnorm);
end
% sink
capacity(1:k,k+2)=3-(capacity(k+1,1:k))';
%other nodes
for m=1:k-1
    for n=m+1:k
        if adjacency(m,n)==1
            capacity(m,n)=0.25*histintersect(segments(m).fv,segments(n).fv)*...
            exp(-((segments(m).x-segments(n).x)^2+(segments(m).y-segments(n).y)^2)/dnorm);
            capacity(n,m)=capacity(m,n);
        end
    end
end
%%%

%debug
figure; imagesc(capacity); title('capacity');


%% Compute the cut (this code is provided to you)
[~,current_flow] = ff_max_flow(source,sink,capacity,k+2);

%% Extract the two-class segmentation.
%  The cut will separate all nodes into those connected to the
%   source and those connected to the sink.
%  The current_flow matrix contains the necessary information about
%   the max-flow through the graph.
%
% Populate the binary matrix B with 1's for those nodes that are connected
%  to the source (and hence are in the same big segment as our keyindex) in the
%  residual graph.
% 
% You need to compute the set of reachable nodes from the source.  Recall, from
%  lecture that these are any nodes that can be reached from any path from the
%  source in the graph with residual capacity (original capacity - current flow) 
%  being positive.

%%%  FILL IN CODE HERE to read the cut into B
r=capacity-current_flow;
G=digraph(r);
v=bfsearch(G,k+1);
B=zeros(size(segmentimage));
for m=1:length(v)
    B(segmentimage==v(m))=1;
end
%%%

end


function c = histintersect(a,b)
    c = sum(min(a,b));
end
