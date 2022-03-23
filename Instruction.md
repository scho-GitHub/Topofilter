*Before you run MATLAB® code and Simulink® models on a [GitHub®-hosted runner](https://docs.github.com/en/free-pro-team@latest/actions/reference/specifications-for-github-hosted-runners), first use the [Setup MATLAB action](https://github.com/marketplace/actions/setup-matlab#set-up-matlab). The action sets up the specified MATLAB release on a Linux® virtual machine. If you do not specify a release, the action sets up the latest release of MATLAB.^

The Setup MATLAB action is not supported on [self-hosted runners](https://docs.github.com/en/free-pro-team@latest/actions/hosting-your-own-runners/about-self-hosted-runners). Currently, it is available only for public projects. It does not set up transformation products, such as MATLAB Coder™ and MATLAB Compiler™.

Go to [Setup MATLAB](https://github.com/marketplace/actions/setup-matlab) for more instruction.

^These codes have been tested in MATLAB R2021a but not been tested on GitHub®-hosted runner. It is recommended that user download the Workspaces and model code to run on MATLAB.
