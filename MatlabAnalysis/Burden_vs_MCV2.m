mkdir('Images');
load('..\Experiments\31d35117-78b5-e811-a2c0-c4346bcb7275\condensed_output.mat');

cc = params.Base_Infectivity == 2 & ...
    params.MCV1Cov == 0.75 & ...
    params.SIACov == -1 & ...
    strcmpi(params.mAb, 'Short');

cc0= cc & params.META_MCV2Frac == 0; 
cc50= cc & params.META_MCV2Frac == 0.5; 
cc75 = cc & params.META_MCV2Frac == 0.75; 
cc100= cc & params.META_MCV2Frac == 1; 

myfigure_square();
preSIA = 730:1825;
postSIA = 1825:3000;
alltime = 730:3000;
annualBurden = cellfun(@(x) sum(x(alltime))/(3/365*length(alltime)), allInf);
totalBurden0 = annualBurden(cc0);
totalBurden50 = annualBurden(cc50);
totalBurden75 = annualBurden(cc75);
totalBurden100 = annualBurden(cc100);

[ages_0, ind0] = sort(params.MCV1Days(cc0));
[ages_50, ind50] = sort(params.MCV1Days(cc50));
[ages_75, ind75] = sort(params.MCV1Days(cc75));
[ages_100, ind100] = sort(params.MCV1Days(cc100));
colors = cbrewer('seq', 'Blues', 9);

plot(ages_0/30, totalBurden0(ind0), '-', 'Color', colors(9, :));
hold on
plot(ages_0/30, totalBurden50(ind50), '-', 'Color', colors(7, :));
plot(ages_0/30, totalBurden75(ind75), '-', 'Color', colors(5, :));
plot(ages_0/30, totalBurden100(ind100), '-', 'Color', colors(3, :));
xlabel('Age at Vaccination (months)')
ylabel('Average annual burden');
yl = ylim;
text(9, .8*yl(2)+.2*yl(1), 'no MCV2', 'Color', colors(9,:));
text(9, .76*yl(2)+.24*yl(1), 'MCV2 = 50% MCV1', 'Color', colors(7,:));
text(9, .72*yl(2)+.28*yl(1), 'MCV2 = 75% MCV1', 'Color', colors(5,:));
text(9, .68*yl(2)+.32*yl(1), 'MCV2 = 100% MCV1', 'Color', colors(3,:));
title('Burden vs. MCV2 coverage, MCV1 = 75%')
myprint('-dpng', 'Images\Burden_vs_MCV2_MCV1p75_short.png');
