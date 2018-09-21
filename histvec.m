function v = histvec(image,mask,b)
%
%  W18 EECS 504 HW4p2 Fg-bg Graph-cut
%  Jason Corso, jjcorso@umich.edu
%
%  For each channel in the image, compute a b-bin histogram (uniformly space
%  bins in the range 0:1) of the pixels in image where the mask is true. 
%  Then, concatenate the vectors together into one column vector (first
%  channel at top).
%
%  mask is a matrix of booleans the same size as image.
% 
%  normalize the histogram of each channel so that it sums to 1.
%
%  You CAN use the hist function.
%  You MAY loop over the channels.

chan = size(image,3);

c = 1/b;       % bin offset
x = c/2:c:1;   % bin centers


%%% FILL IN THE CODE HERE
% The output v should be a 3*b vector because we have a color image and 
% you have a separate histogram per color channel.
Ir=image(:,:,1);
Ig=image(:,:,2);
Ib=image(:,:,3);
Ir=Ir(mask);
Ig=Ig(mask);
Ib=Ib(mask);
vr=zeros(b,1);
vg=zeros(b,1);
vb=zeros(b,1);
for m=1:length(Ir)
    bin_r=ceil(Ir(m)/c);
    if bin_r==0
        bin_r=1;
    end
    vr(bin_r)=vr(bin_r)+1;
    bin_g=ceil(Ig(m)/c);
    if bin_g==0
        bin_g=1;
    end
    vg(bin_g)=vg(bin_g)+1;
    bin_b=ceil(Ib(m)/c);
    if bin_b==0
        bin_b=1;
    end
    vb(bin_b)=vb(bin_b)+1;
end
vr=vr/sum(vr);
vg=vg/sum(vg);
vb=vb/sum(vb);
v=[vr;vg;vb];
%%%

