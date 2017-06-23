[TOC]

# Description

This repository contains the source code necessary to run the coupled HYCOM-CICE model developed at NERSC. In the repository you will find the HYCOM and CICE source codes, utility routines, and a directory containing a simple model setup (Directory TP0a1.00). Below is a short description of how to set up and compile the code

# Prerequisites

The following tools are necessary 

A working fortran compiler.

To run the HYCOM-CICE coupled code, you will need to have a working installation of the Eearth System Modelling Framework: https://www.earthsystemcog.org/projects/esmf/download/. The code has been tested and verified to work with ESMF v 5.2.0.rp3.

A working python 2.7 installation, [more info can be found here](doc/python.md)

# Retrieval of code and tools

## Retrieving NERSC-HYCOM-CICE
Clone code from main repository (TODO: Fix when moved/use markdown)

`
git clone https://bitbucket.org/knutal/nersc-hycom-cice
`

If you get errors about server certificates, see [here](../..//overview#markdown-header-server-certificates)


## Retrieving and installing ESMF

To run the HYCOM-CICE coupled code, you will need to have a working installation of the Eearth System Modelling Framework: https://www.earthsystemcog.org/projects/esmf/download/. The code has been tested and verified to work with ESMF v 5.2.0.rp3.

You could try to install his yourself, instructions are available in the downloaded distribution. However, it is probably recommended that you let your local IT support to do it.


## Site-specific details

### Hexagon.bccs.uib.no

On hexagon, most tools are installed already. Make sure these commands are run first:

    module load python/2.7.9-dso
    module load udunits
    export PYTHONPATH=$PYTHONPATH:/home/nersc/knutali/opt/python/lib/python2.7/site-packages/

The last location contains the github modules, as well as basemap, cfunits and f90nml python modules

Apart from that, make sure you use the pgi compiler and libraries in the cray PrgEnv. You will also have to be a member of the "nersc" group and you will need access to a cpu account. Here is a setup that is known to qwork (as of 2016-11-10):


    module swap PrgEnv-cray PrgEnv-pgi
    module load cmake
    module load cray-libsci
    module unload xtpe-interlagos # This is needed to compile on login nodes (istanbul cpu)
    module load fftw
    module load cray-netcdf
    module load ncview
    module load python/2.7.9-dso # NB: sets PYTHONHOME, which can cause problems for some scripts that uses the full path
    module load subversion


# This and that...

## Server certificates
If you get an error like "server certificate verification failed", you will need to install certificates on the machine where you want to run the model(or contact IT support). More [here...](https://en.wikipedia.org/wiki/Certificate_authority). If certificate installation fails, you can try this as a last resort before issuing the git clone commands:
`
export GIT_SSL_NO_VERIFY=true
`
