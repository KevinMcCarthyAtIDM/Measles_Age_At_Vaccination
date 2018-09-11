##
"""
Measles Ward Simulations: Sample demographic
"""
#
import json
import os

from simtools.Analysis.AnalyzeManager import AnalyzeManager
from simtools.Utilities.Encoding import NumpyEncoder

from PythonAnalysis.Output2MatlabAnalyzer import Output2MatlabAnalyzer
from simtools.Utilities.COMPSUtilities import get_experiment_by_id
from COMPS import Client
from COMPS.Data import QueryCriteria

Client.login('https://comps.idmod.org')

if __name__ == "__main__":
    exp_list = ['7bf92112-2db2-e811-a2c0-c4346bcb7275', '4d832701-63b5-e811-a2c0-c4346bcb7275',
				'020b39aa-65b5-e811-a2c0-c4346bcb7275', '31d35117-78b5-e811-a2c0-c4346bcb7275'
                ]
    for exp in exp_list:
        tmp = get_experiment_by_id(exp, query_criteria=QueryCriteria().select_children(["tags"]))
        if (os.path.exists(os.path.join('Experiments', exp))) or (any([sim.state.value != 6 for sim in tmp.get_simulations()])):
            continue

#        with open(os.path.join('Experiments', 'experiment_metadata.json'), 'r', encoding='utf8') as jsonfile:
#            exp_metadata = json.load(jsonfile)
#        exp_metadata[exp] = tmp.tags
#        with open(os.path.join('Experiments', 'experiment_metadata.json'), 'w', encoding='utf8') as jsonfile:
#            json.dump(exp_metadata, jsonfile, cls=NumpyEncoder, indent=3)

        am = AnalyzeManager(exp)
        am.add_analyzer(Output2MatlabAnalyzer())
        am.analyze()
