import math
import random
from scipy.special import erfinv

def sample_point_fn(cb, param_names, param_values):
    tags ={}

    # Setup some baseline parameters, but allow them to be overwritten afterwards by inputs to this function
    params_dict = Setup_Base_Parameters()

    for name, value in zip(param_names, param_values):
        params_dict[name] = value
    RI_Vacc_Setup(cb, params_dict['META_MCV1Cov'], params_dict['META_MCV2Frac'])

    #Now I am through the required parameters
    for param, value in params_dict.items():
        if param.startswith('META'):
            tags = MetaParameterHandler(cb, param, value, tags)
        else:
            cb.set_param(param, value)
        tags[param] = value
    return tags

def Setup_Base_Parameters():
    # Set some defaults here, but allow them to be overwritten by inputs to the function
    params_dict = dict()
    params_dict['Relative_Sample_Rate_Immune'] = 0.02
    params_dict['Infectivity_Scale_Type'] = 'ANNUAL_BOXCAR_FUNCTION'
    params_dict['Infectivity_Boxcar_Forcing_Amplitude'] = 0.2
    params_dict['Infectivity_Boxcar_Forcing_Start_Time'] = 30
    params_dict['Infectivity_Boxcar_Forcing_End_Time'] = 120
    params_dict['logLevel_Node'] = "ERROR"
    params_dict['logLevel_default'] = "ERROR"
    params_dict['logLevel_JsonConfigurable'] = "ERROR"
    params_dict['logLevel_StandardEventCoordinator'] = "ERROR"
    params_dict['logLevel_Memory'] = "ERROR"
    params_dict['Enable_Abort_Zero_Infectivity'] = 1
    params_dict['Simulation_Timestep'] = 3.0
    # mAB_prfiles = [(150, 50), (90, 30), (120, 51)]
    params_dict['Maternal_Sigmoid_HalfMaxAge'] = 150
    params_dict['Maternal_Sigmoid_SteepFac'] = 50
    params_dict['Maternal_Sigmoid_SusInit'] = 0.05
    params_dict['Simulation_Duration'] = 9125
    return params_dict


def RI_Vacc_Setup(cb, MCV1, MCV2):
    # RI Vaccination is all set up in the demographics file using individual properties

    # I need to make sure that this is writing correctly - assigning dictionaries in this way in a loop may be tricky.
    demog = cb.demog_overlays['demographics.json']

    demog['Defaults']['IndividualProperties'][0]['Initial_Distribution'] = [MCV2*MCV1, (1-MCV2)*MCV1, 1-MCV1]

    cb.demog_overlays['demographics.json'] = demog


def MetaParameterHandler(cb, param, value, tags):
    #A place to handle all of the various metaparameters that may arise
    if param == 'META_Migration':
        cb.set_param('x_Local_Migration', value)
        cb.set_param('x_Air_Migration', value)
        tags['x_Local_Migration'] = value
        tags['x_Air_Migration'] = value
    if param == 'META_MCV1Days':
        for event in cb.campaign.Events:
            if event.Event_Name == 'MCV1':
                event.Event_Coordinator_Config.Intervention_Config.Actual_IndividualIntervention_Config.Delay_Period_Mean = value
                event.Event_Coordinator_Config.Intervention_Config.Actual_IndividualIntervention_Config.Delay_Period_Std_Dev = value/6.0
        tags['MCV1_Dose_Days'] = value
    if param == 'META_MaB_Profile':
        mAb_profiles = {'Long': [150, 50], 'Short': [90, 30], 'Mix': [120, 51]}
        cb.set_param('Maternal_Sigmoid_HalfMaxAge', mAb_profiles[value][0])
        cb.set_param('Maternal_Sigmoid_SteepFac', mAb_profiles[value][1])
        tags['Maternal_Antibody_Profile'] = value
        tags['Maternal_Sigmoid_HalfMaxAge'] = mAb_profiles[value][0]
        tags['Maternal_Sigmoid_SteepFac'] = mAb_profiles[value][1]
    if param == 'META_Timesteps':
        cb.set_param('Simulation_Timestep', int(value))
        cb.set_param('Spatial_Output_Days_To_Accumulate', int(30/value))
        for event in cb.campaign.Events:
                event.Event_Coordinator_Config.Timesteps_Between_Repetitions = max(int(1), int(
                    event.Event_Coordinator_Config.Timesteps_Between_Repetitions/value))
        tags['Simulation_Timestep'] = value
        tags['Spatial_Output_Days_To_Accumulate'] = 30/value
    if param == 'META_campaign_coverage':
        for event in cb.campaign.Events:
            if event.Event_Name == 'SIAs - SIAOnly Group':
                event.Event_Coordinator_Config.Demographic_Coverage = value
    return tags
