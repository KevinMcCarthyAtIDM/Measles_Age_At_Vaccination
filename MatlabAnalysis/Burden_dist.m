cc = params.Base_Infectivity == 2 & ...
    params.SIACov == -1 & ...
    params.META_MCV2Frac == 0.0 & ...
    strcmpi(params.mAb, 'Mix') & ...
    params.MCV1Cov == 0.75;
    
    cc6 = cc & params.MCV1Days == 180;
    cc9 = cc & params.MCV1Days == 270;
    cc12 = cc & params.MCV1Days == 365;

colors = cbrewer('seq', 'Blues', 9);
myfigure_square();



plot(smooth2a(sum(agedist_mo{cc6}(15:25, :), 1), 3, 1), '-', 'Color', colors(9, :));
hold on
plot(smooth2a(sum(agedist_mo{cc9}(15:25, :), 1), 3, 1), '-', 'Color', colors(6, :));
plot(smooth2a(sum(agedist_mo{cc12}(15:25, :), 1), 3, 1), '-', 'Color', colors(3, :));
yl = ylim;
text(15, .76*yl(2)+.24*yl(1), '75% cov. w/ MCV1 at 6 months', 'Color', colors(9,:));
text(26.3, .72*yl(2)+.28*yl(1), ' at 9 months', 'Color', colors(6,:));
text(26.3, .68*yl(2)+.32*yl(1), ' at 12 months', 'Color', colors(3,:));
xlim([0, 36])
xlabel('Age of Infection (months)')
ylabel('Age-stratified burden');
title('Age-stratified Burden vs. age at vaccination, no MCV2')
myprint('-dpng', 'Images\AgeBurden_MCV1.png');

clf;
cc = params.Base_Infectivity == 2 & ...
    params.SIACov == -1 & ...
    params.META_MCV2Frac == 1.0 & ...
    strcmpi(params.mAb, 'Mix') & ...
    params.MCV1Cov == 0.75;
    
    cc6 = cc & params.MCV1Days == 180;
    cc9 = cc & params.MCV1Days == 270;
    cc12 = cc & params.MCV1Days == 365;

colors = cbrewer('seq', 'Blues', 9);
myfigure_square();



plot(smooth2a(sum(agedist_mo{cc6}(15:25, :), 1), 3, 1), '-', 'Color', colors(9, :));
hold on
plot(smooth2a(sum(agedist_mo{cc9}(15:25, :), 1), 3, 1), '-', 'Color', colors(6, :));
plot(smooth2a(sum(agedist_mo{cc12}(15:25, :), 1), 3, 1), '-', 'Color', colors(3, :));
yl = ylim;
text(15, .76*yl(2)+.24*yl(1), '75% cov. w/ MCV1 at 6 months', 'Color', colors(9,:));
text(26.3, .72*yl(2)+.28*yl(1), ' at 9 months', 'Color', colors(6,:));
text(26.3, .68*yl(2)+.32*yl(1), ' at 12 months', 'Color', colors(3,:));
xlim([0, 36])
xlabel('Age of Infection (months)')
ylabel('Age-stratified burden');
title('Age-stratified Burden vs. age at vaccination, 100% MCV2')
myprint('-dpng', 'Images\AgeBurden_100MCV2.png');

clf;
cc = params.Base_Infectivity == 2 & ...
    params.SIACov == 0.75 & ...
    params.META_MCV2Frac == 0.0 & ...
    strcmpi(params.mAb, 'Mix') & ...
    params.MCV1Cov == 0.75;
    cc6 = cc & params.MCV1Days == 180;
    cc9 = cc & params.MCV1Days == 270;
    cc12 = cc & params.MCV1Days == 365;
colors = cbrewer('seq', 'Blues', 9);
myfigure_square();



plot(smooth2a(sum(agedist_mo{cc6}(15:25, :), 1), 3, 1), '-', 'Color', colors(9, :));
hold on
plot(smooth2a(sum(agedist_mo{cc9}(15:25, :), 1), 3, 1), '-', 'Color', colors(6, :));
plot(smooth2a(sum(agedist_mo{cc12}(15:25, :), 1), 3, 1), '-', 'Color', colors(3, :));
yl = ylim;
text(25, .76*yl(2)+.24*yl(1), '75% cov. w/ MCV1 at 6 months', 'Color', colors(9,:));
text(43.5, .72*yl(2)+.28*yl(1), ' at 9 months', 'Color', colors(6,:));
text(43.5, .68*yl(2)+.32*yl(1), ' at 12 months', 'Color', colors(3,:));
xlim([0, 60])
xlabel('Age of Infection (months)')
ylabel('Age-stratified burden');
title('Age-stratified Burden vs. age at vaccination w/ SIAs')
myprint('-dpng', 'Images\AgeBurden_SIA.png');
