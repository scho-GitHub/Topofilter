# Read before running the model
*Before you run MATLAB® code and Simulink® models on a [GitHub®-hosted runner](https://docs.github.com/en/free-pro-team@latest/actions/reference/specifications-for-github-hosted-runners), first use the [Setup MATLAB action](https://github.com/marketplace/actions/setup-matlab#set-up-matlab). The action sets up the specified MATLAB release on a Linux® virtual machine. If you do not specify a release, the action sets up the latest release of MATLAB.^

The Setup MATLAB action is not supported on [self-hosted runners](https://docs.github.com/en/free-pro-team@latest/actions/hosting-your-own-runners/about-self-hosted-runners). Currently, it is available only for public projects. It does not set up transformation products, such as MATLAB Coder™ and MATLAB Compiler™.

Go to [Setup MATLAB](https://github.com/marketplace/actions/setup-matlab) for more instruction.

^These codes have been tested in MATLAB R2021a but not been tested on GitHub®-hosted runner. It is recommended that user download the Workspaces and model code to run on MATLAB.

# Topofilter simulation instruction
The model runs independently in the four nested Topofilter Subwatersheds (Toposheds). Subsequently, simulation at the outlet Toposhed is executed. 

For example, **Upper Maple (UM)** Topofilter simulation can be executed in the following order:

1. Upload the Workspace **UM_Topovar.mat** from **Topowatfiles folder** to access input variables, including the gridded topographic variables (Lf, dEf) and USLE outputs, arrays of river network data, observed sediment loading, and other information used in the Topofilter simulation. 
2. Run **UM_Param_generator.m** from **Topowatfiles folder** to populate Topofilter parameter set from conditioned parameter space.
3. Run **Topofilter.m** to simulate sediment delivery, deposition, and loading in the UM. This code is compatible with all Topowat once steps 1 and 2 are completed. 

Similarly, Topofilter simulation in three steps can be executed in other Toposheds: Main Cobb (MC), Little Cobb (LC), Upper Le Sueur (UL), and Le Sueur Outlet (LO). From **Topowatfiles folder**, access the Workspaces **MC_Topovar.mat, LC_Topovar.mat, UL_Topovar.mat, and LO_Topovar.mat**. Run **MC_Param_generator.m, LC_Param_generator.m, UL_Param_generator.m, and LO_Param_generator.m**.
