basedir = '..\Experiments\31d35117-78b5-e811-a2c0-c4346bcb7275\';
sims = dir([basedir '\*.mat']);
sims = sims(1:end);
sim_metadata = loadJson([basedir '\metadata_output.json']);

erad = zeros(length(sims), 1);
agedist_mo = cell(length(sims),1);
allInf = cell(length(sims),1);
simID = cell(length(sims),1);
params.Base_Infectivity = zeros(length(sims),1);
params.MCV1Cov = zeros(length(sims),1);
params.SIACov = zeros(length(sims),1);
params.MCV1Days = zeros(length(sims),1);
params.mAb = cell(length(sims),1);
params.META_MCV2Frac = zeros(length(sims),1);
tic;
for simind = 1:length(sims)
    
    if mod(simind, 50)==0
        toc
        disp(['On ' num2str(simind) ' of ' num2str(length(sims))]);
    end
    sim = sims(simind);
    simouts = load([basedir '\' sim.name]);
    if strcmpi(sim.name, 'condensed_output.mat')
        continue;
    end
    simfield = strrep(strrep(strrep(sim.name, 'output_', ''), '.mat', ''), '-', '_');
    if startsWith(simfield, split(num2str(0:9), '  '))
        simfield = ['alpha_' simfield];
    end
    params.Base_Infectivity(simind) = sim_metadata.(simfield).Base_Infectivity;
    params.MCV1Cov(simind) = sim_metadata.(simfield).META_MCV1Cov;
    params.SIACov(simind) = sim_metadata.(simfield).META_campaign_coverage;
    params.MCV1Days(simind) = sim_metadata.(simfield).META_MCV1Days;
    params.mAb{simind} = sim_metadata.(simfield).META_MaB_Profile;
    params.META_MCV2Frac(simind) = sim_metadata.(simfield).META_MCV2Frac;
    erad(simind) = simouts.allInfected(end) == 0 || length(simouts.allInfected)<3041;
    agedist_mo{simind} = simouts.age_distribution;
    allInf{simind} = simouts.allNewInfections;
    simID{simind} = strrep(strrep(strrep(sim.name, 'output_', ''), '.mat', ''), '-', '_');
end
save([basedir '\condensed_output.mat'], 'params', 'erad', 'agedist_mo', 'allInf', 'simID');

