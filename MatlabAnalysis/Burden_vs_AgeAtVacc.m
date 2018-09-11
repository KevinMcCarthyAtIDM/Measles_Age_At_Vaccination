mkdir('Images');
clf;
cc = params.Base_Infectivity == 2 & ...
    params.MCV1Cov == 1 & ...
    params.SIACov == -1 & ...
    params.META_MCV2Frac == 0.0;
ccL = cc & strcmpi(params.mAb, 'Long');
ccM = cc & strcmpi(params.mAb, 'Mix');
ccS = cc & strcmpi(params.mAb, 'Short');

myfigure_square();
preSIA = 730:1825;
postSIA = 1825:3000;
alltime = 730:3000;
annualBurden = cellfun(@(x) sum(x(alltime))/(3/365*length(alltime)), allInf);
totalBurden_L = annualBurden(ccL);
totalBurden_M = annualBurden(ccM);
totalBurden_S = annualBurden(ccS);
[ages_L, indL] = sort(params.MCV1Days(ccL));
[ages_S, indS] = sort(params.MCV1Days(ccS));
[ages_M, indM] = sort(params.MCV1Days(ccM));

plot(ages_L/30, totalBurden_L(indL), 'b-');
hold on
plot(ages_M/30, totalBurden_M(indM), 'g-');
plot(ages_S/30, totalBurden_S(indS), 'r-');
xlabel('Age at Vaccination (months)')
ylabel('Average annual burden');
yl = ylim;
text(9, .8*yl(2)+.2*yl(1), 'Infected mothers', 'Color', 'b');
text(9, .76*yl(2)+.24*yl(1), 'Vaccinated mothers', 'Color', 'r');
text(9, .72*yl(2)+.28*yl(1), 'Mixed population', 'Color', 'g');
myprint('-dpng', 'Images\Burden_MCV1Only_p1.png');

cc = params.Base_Infectivity == 2 & ...
    params.MCV1Cov == 1 & ...
    params.SIACov == -1 & ...
    params.META_MCV2Frac == 1.0;
ccL = cc & strcmpi(params.mAb, 'Long');
ccM = cc & strcmpi(params.mAb, 'Mix');
ccS = cc & strcmpi(params.mAb, 'Short');
totalBurden_L2 = annualBurden(ccL);
totalBurden_M2 = annualBurden(ccM);
totalBurden_S2 = annualBurden(ccS);
[ages_L2, indL2] = sort(params.MCV1Days(ccL));
[ages_S2, indS2] = sort(params.MCV1Days(ccS));
[ages_M2, indM2] = sort(params.MCV1Days(ccM));

plot(ages_L2/30, totalBurden_L2(indL2), 'b--');
hold on
plot(ages_M2/30, totalBurden_M2(indM2), 'g--');
plot(ages_S2/30, totalBurden_S2(indS2), 'r--');
myprint('-dpng', 'Images\Burden_MCV2_p1.png');


clf;
plot(ages_L/30, totalBurden_L(indL), 'b-');
hold on
plot(ages_M/30, totalBurden_M(indM), 'g-');
plot(ages_S/30, totalBurden_S(indS), 'r-');
xlabel('Age at Vaccination (months)')
ylabel('Average annual burden');
yl = ylim;
text(9, .8*yl(2)+.2*yl(1), 'Infected mothers', 'Color', 'b');
text(9, .74*yl(2)+.26*yl(1), 'Vaccinated mothers', 'Color', 'r');
text(9, .68*yl(2)+.32*yl(1), 'Mixed population', 'Color', 'g');

cc = params.Base_Infectivity == 2 & ...
    params.MCV1Cov == 1 & ...
    params.SIACov == 0.5 & ...
    params.META_MCV2Frac == 0.0;
ccL3 = cc & strcmpi(params.mAb, 'Long');
ccM3 = cc & strcmpi(params.mAb, 'Mix');
ccS3 = cc & strcmpi(params.mAb, 'Short');


postSIABurden = cellfun(@(x) sum(x(postSIA))/(3/365*length(postSIA)), allInf);

 totalBurden_L3 = postSIABurden(ccL3);
 totalBurden_M3 = postSIABurden(ccM3);
 totalBurden_S3 = postSIABurden(ccS3);
[ages_L3, indL3] = sort(params.MCV1Days(ccL3));
[ages_S3, indS3] = sort(params.MCV1Days(ccS3));
[ages_M3, indM3] = sort(params.MCV1Days(ccM3));

plot(ages_L3/30, totalBurden_L3(indL3), 'b--');
hold on
plot(ages_M3/30, totalBurden_M3(indM3), 'g--');
plot(ages_S3/30, totalBurden_S3(indS3), 'r--');
myprint('-dpng', 'Burden_wSIA_p1.png');