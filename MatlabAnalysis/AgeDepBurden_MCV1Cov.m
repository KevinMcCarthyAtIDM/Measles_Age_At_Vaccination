cc = params.Base_Infectivity == 2 & ...
    params.SIACov == -1 & ...
    params.META_MCV2Frac == 0.0 & ...
    strcmpi(params.mAb, 'Mix');
ccL = cc &  params.MCV1Cov == 0.5;
ccM = cc &  params.MCV1Cov == 0.75;
ccH = cc &  params.MCV1Cov == 1.0;

myfigure_square();
preSIA = 730:1825;
postSIA = 1825:3000;
alltime = 730:3000;
fracBurden = cellfun(@(x) sum(sum(x(10:25, 1:9)))/sum(sum(x(10:25, 1:60))), agedist_mo);
fracBurden_L = fracBurden(ccL);
fracBurden_M = fracBurden(ccM);
fracBurden_H = fracBurden(ccH);
[ages_L, indL] = sort(params.MCV1Days(ccL));
[ages_M, indM] = sort(params.MCV1Days(ccM));
[ages_H, indH] = sort(params.MCV1Days(ccH));
colors = cbrewer('seq', 'Blues', 9);

plot(ages_L/30, fracBurden_L(indL), '-', 'Color', colors(9, :));
hold on
plot(ages_M/30, fracBurden_M(indM), '-', 'Color', colors(7, :));
plot(ages_H/30, fracBurden_H(indH), '-', 'Color', colors(5, :));
xlabel('Age at Vaccination (months)')
ylabel('Fraction of burden between 6 and 9 months, MCV1 only');
yl = ylim;
text(3, .8*yl(2)+.2*yl(1), '50% MCV1 Coverage', 'Color', colors(9, :));
text(3, .76*yl(2)+.24*yl(1), '75%', 'Color', colors(7, :));
text(3, .72*yl(2)+.28*yl(1), '100%', 'Color', colors(5, :));
myprint('-dpng', 'Images\FracBurden_MCV1Only.png');

clf;
cc = params.Base_Infectivity == 2 & ...
    params.SIACov == -1 & ...
    params.MCV1Cov == 0.75 & ...
    strcmpi(params.mAb, 'Mix');
cc0= cc & params.META_MCV2Frac == 0; 
cc50= cc & params.META_MCV2Frac == 0.5; 
cc75 = cc & params.META_MCV2Frac == 0.75; 
cc100= cc & params.META_MCV2Frac == 1; 
fracBurden0 = fracBurden(cc0);
fracBurden50 = fracBurden(cc50);
fracBurden75 = fracBurden(cc75);
fracBurden100 = fracBurden(cc100);

[~, ind0] = sort(params.MCV1Days(cc0));
[~, ind50] = sort(params.MCV1Days(cc50));
[~, ind75] = sort(params.MCV1Days(cc75));
[~, ind100] = sort(params.MCV1Days(cc100));
colors = cbrewer('seq', 'Blues', 9);
plot(ages_L/30, fracBurden0(ind0), '-', 'Color', colors(9, :));
hold on
plot(ages_L/30, fracBurden50(ind50), '-', 'Color', colors(7, :));
plot(ages_L/30, fracBurden75(ind75), '-', 'Color', colors(5, :));
plot(ages_L/30, fracBurden100(ind100), '-', 'Color', colors(3, :));
yl = ylim;
xlabel('Age at Vaccination (months)')
ylabel('Fraction of burden below 9 months');
text(3, .8*yl(2)+.2*yl(1), 'no MCV2', 'Color', colors(9,:));
text(3, .76*yl(2)+.24*yl(1), 'MCV2 = 50% MCV1', 'Color', colors(7,:));
text(3, .72*yl(2)+.28*yl(1), 'MCV2 = 75% MCV1', 'Color', colors(5,:));
text(3, .68*yl(2)+.32*yl(1), 'MCV2 = 100% MCV1', 'Color', colors(3,:));
myprint('-dpng', 'Images\FracBurden_MCV2.png');
