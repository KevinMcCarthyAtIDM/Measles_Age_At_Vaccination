##
"""
Measles Age At Vaccination Simulations
"""
#
import itertools
import json
import math
import os
import random

from dtk.utils.core.DTKConfigBuilder import DTKConfigBuilder
from dtk.utils.reports import BaseAgeHistReport
from simtools.ModBuilder import ModBuilder, ModFn
from simtools.SetupParser import SetupParser
from simtools.ExperimentManager.ExperimentManagerFactory import ExperimentManagerFactory
from SetupFunctions import sample_point_fn

#Run on HPC
SetupParser.default_block = "HPC"

cb = DTKConfigBuilder.from_files(config_name='InputFiles\\config.json', campaign_name='InputFiles\\basecampaign.json')
cb.set_param('Num_Cores', 1)
cb.set_experiment_executable(path='Executable\\Eradication.exe')
cb.add_demog_overlay(name='demographics.json', content=json.load(open('InputFiles\\AgeAtVacc_singlenode_demographics.json')))
cb.experiment_files.add_file(path='InputFiles\\reports.json')
cb.experiment_files.add_file(path='reporter_plugins\\libReportAgeAtInfectionHistogram_plugin.dll')
cb.add_reports(BaseAgeHistReport(type='ReportPluginAgeAtInfectionHistogram',
                                 age_bins=[x/12 for x in range(1, 180)],
                                 interval_years=1))

if __name__ == "__main__":

    SetupParser.init('HPC')
    BaseInfs = [1.0, 1.5, 2.0, 2.5]
    MCV1Covs = [0, 0.25, 0.5, 0.75, 1.0]
    MCV2Covs = [0, 0.25, 0.5, 0.75]
    SIACovs = [0, 0.25, 0.5, 0.75]
    MCV1Days = [90, 120, 150, 180, 210, 240, 270, 300, 330, 365]
    mAbProfs = ['Long', 'Short', 'Mix']

    allCombs = list(itertools.product(BaseInfs, MCV1Covs, SIACovs, MCV1Days, mAbProfs, MCV2Covs))
    mod_fns = []
    for combo in allCombs:
        names = ['Base_Infectivity', 'META_MCV1Cov', 'META_campaign_coverage', 'Run_Number', 'META_MCV1Days',
                'META_MaB_Profile', 'META_MCV2Frac', 'META_Timesteps']

        values = [combo[0], combo[1], combo[2], random.randint(1, 1e6), combo[3],
                combo[4], combo[5], 3.0]

        mod_fns.append(ModFn(sample_point_fn, names, values))

    builder = ModBuilder.from_combos(mod_fns)

    # Name the experiment
    exp_name = 'Measles Age at Vaccination'
    run_sim_args = {'config_builder': cb,
                    'exp_name': exp_name,
                    'exp_builder': builder}

    exp_manager = ExperimentManagerFactory.from_cb(cb)
    exp_manager.experiment_tags = {}
    exp_manager.bypass_missing = True
    exp_manager.run_simulations(**run_sim_args)
#    exp_manager.wait_for_finished(verbose=True)

#    am = AnalyzeManager('latest')
#    am.add_analyzer(Output2MatlabAnalyzer())
#    am.analyze()
