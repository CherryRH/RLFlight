function agent = createTD3Agent(numObs, obsInfo, numAct, actInfo, Ts)
% Walking Robot -- TD3 Agent Setup Script
% Copyright 2024 The MathWorks, Inc.

%% Create the actor and critic networks using the createNetworks helper function
[criticNetwork1,criticNetwork2,actorNetwork] = createNetworks(numObs,numAct); % Use of 2 Critic networks

%% Specify options for the critic and actor representations using rlOptimizerOptions
criticOptions = rlOptimizerOptions('Optimizer','adam','LearnRate',3e-4,... 
                                        'GradientThreshold',1);
actorOptions = rlOptimizerOptions('Optimizer','adam','LearnRate',3e-4,...
                                       'GradientThreshold',1);

%% Create critic and actor representations using specified networks and
% options
critic1 = rlQValueFunction(criticNetwork1,obsInfo,actInfo,'ObservationInputNames','observation','ActionInputNames','action');
critic2 = rlQValueFunction(criticNetwork2,obsInfo,actInfo,'ObservationInputNames','observation','ActionInputNames','action');
actor  = rlContinuousDeterministicActor(actorNetwork,obsInfo,actInfo);

%% Specify TD3 agent options
agentOptions = rlTD3AgentOptions;
agentOptions.SampleTime = Ts;
agentOptions.DiscountFactor = 0.99;
agentOptions.MiniBatchSize = 128;
agentOptions.ExperienceBufferLength = 1e5;
agentOptions.TargetSmoothFactor = 5e-3;

agentOptions.NumEpoch = 3;
agentOptions.MaxMiniBatchPerEpoch = 100;
agentOptions.LearningFrequency = -1;
agentOptions.PolicyUpdateFrequency = 1;
agentOptions.TargetUpdateFrequency = 1;

agentOptions.TargetPolicySmoothModel.StandardDeviationMin = 0.05; % target policy noise
agentOptions.TargetPolicySmoothModel.StandardDeviation = 0.05; % target policy noise
agentOptions.TargetPolicySmoothModel.LowerLimit = -0.5;
agentOptions.TargetPolicySmoothModel.UpperLimit = 0.5;
agentOptions.ExplorationModel = rl.option.OrnsteinUhlenbeckActionNoise; % set up OU noise as exploration noise (default is Gaussian for rlTD3AgentOptions)
agentOptions.ExplorationModel.MeanAttractionConstant = 1;
agentOptions.ExplorationModel.StandardDeviation = 0.1;

agentOptions.ActorOptimizerOptions = actorOptions;
agentOptions.CriticOptimizerOptions = criticOptions;

%% Create agent using specified actor representation, critic representations and agent options
agent = rlTD3Agent(actor, [critic1,critic2], agentOptions);