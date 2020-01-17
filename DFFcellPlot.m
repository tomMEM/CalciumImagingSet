



CellSignal = zeros(size(mean_cell,1)*size(mean_cell,2), size(mean_cell{1,1},1));
k = 1;
for i = 1:size(mean_cell,1)
    for j = 1:size(mean_cell,2)
        CellSignal(k, :) = mean_cell{i,j}';
        k = k+1;
    end
end


%
signalmat = CellSignal';
Ntimes=size(signalmat,1);
    dt=0.49;
    window=fix(30/dt); % baseline is calculated for a window of 30s)
    order=fix(0.08*window);
    background = 0;   
    baseline=ordfilt2(signalmat, order, (1:window)')-background;
    baselinesm=filter(ones(1,window)/window,1,baseline);
    t1=min(fix(1.5*window), size(baselinesm,1)-1);
    ai=baselinesm(t1,:);
    bi=repmat(ai,t1,1);
    baselinesm(1:t1,:)=bi;
    af=baselinesm(Ntimes-t1,:);
    bf=repmat(af,t1,1);
    baselinesm((Ntimes-t1+1):Ntimes,:)=bf;
    
    DFF=(signalmat-baselinesm-background)./baselinesm;

    DFF = D.DFF;
    DFF(DFF==Inf)=0;
    DFF(isnan(DFF)) = 0 ;
    DFFdisp=DFF;
    DFFdisp(find(DFF<0.02))=0;
    
    figure, imshow(DFFdisp', []);
    
    DFFcomplement = imcomplement(DFFdisp');
    figure, imshow(DFFcomplement, []);
    
    
    DFFdisp1 = DFFdisp;

% plot 1
shock = 125:125:525;
    figure, hold on;
    image(256*rescalegd(transpose(DFFdisp1)));  % good plot, scaled with 1% and 99% range
    % vline(shock, 'r'); 
    hold off;
    
% plot 2
shock = 125:125:525;
    figure, hold on;
    image(scaledata(transpose(DFFdisp1), 0, 1024));  % good plot
    vline(shock, 'r'); 
    hold off;
    
% plot trace


for i = 1:335
    % i = 294;
    figure, hold on;
    plot(DFFdisp(:,i)); vline(shock, 'r');
    hold off;
end


    
    
    


    
    
    