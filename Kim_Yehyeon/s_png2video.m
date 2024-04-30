load 'Grid data.mat'
%%
vidObj = VideoWriter('asdf', 'Motion JPEG AVI');
vidObj.Quality = 100;
vidObj.FrameRate = 3.14;
open(vidObj);

rdata = imread('C:\Users\Administrator\Desktop\PNG\AIB_20211201_1000.png');

 %%%%%%%%%%%%%%
    sdrng = 800; %[m]
    dr = 3; %[m]
    nr = 512;
    
    rr = sdrng:dr:sdrng+dr*(nr-1);
    
    nimg = 129;
    nbearing = 1080;
    
    theta = linspace(0,2*pi,nbearing);
    
    [Th,R] = meshgrid(theta,rr);
    
    X = R.*cos( deg2rad(61) - Th);
    Y = R.*sin( deg2rad(61) - Th);
    %%%%%%%%%%%%%%

rdata = reshape(rdata,nr,nbearing,nimg);
rdata = flip(rdata,3);


for ii = 1:129%nimg
    figure(10)
    hold off
%     set(gcf,'position', [100 100 1200 800])

    surf(X, Y, rdata(:,:,ii), 'edgealpha',0);

    axis equal; 
    set(gcf,'color','w');
    axis off;
    axis([-1000 -200 550 1350]); view(0,90);
    colormap default;    
    caxis([0 100]);    set(gca,'fontsize',13); grid off;
    currFrame = getframe(gcf);
    writeVideo(vidObj,currFrame);

end

close(vidObj);




