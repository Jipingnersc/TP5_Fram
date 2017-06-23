[toc]

Most routines are set up following instructions in the section  'Procedure for
compiling/installing MSCPROGS'. The routines using the FES2004 and FES2014 and C
apis are compiled differently. See instructions for these below.


# Procedure for compiling/installing MSCPROGS

* Go into the directory MSCPROGS/src/

* Inside the Make.Inc directory, link the relevant make include file (ex make.fimm.ifort, make.hexagon.pgi etc etc) to make.inc in directory Make.Inc. If you dont have a suitable setup for your machine, go to "Procedure for porting".

* Note that the make.linux.xxx is intented to be a generic macro set for linux machines, can be used as a starting point. on Cray systems with ftn compiler, use make.hexagon.xxx as a starting point

* In the directory MSCPROGS/src, type gmake clean to clean out any old modules, object files and executables lying around.

* In the same directory, type "gmake all" and cross fingers - if it fails - examine the include file to make sure its ok. You will usually get some clue on whats going wrong during the make process.

* Some libraries and include files will be installed first in MSCPROGS/lib and MSCPROGS/include, these libraries are needed by most programs. The makefile should see too it that these programs are installed first.

* If everything went okay when doing "gmake all" (this process may take some time), type gmake install and the routines should be copied to MSCPROGS/bin and MSCPROGS/bin_setup

* Tides_FES routines also require you to install FES2004 first, the code for this can be found in ../src_others. gmake and gmake install will copy the FES libs and include files to ../lib/ and ../include)

* Tides_FES is set up with gcc (gnu), so you will need the gnu netcdf libraries for the "fes2nc" program (set this by hand in the Tides_FES/nersc_src directory .  The others should compile fine though, and they are the important ones....

* Note that NCARG-test can be troublesome -- it needs ncar graphics to be installed ( see ncarg definitions in the make include files). The ncar compiler setup may also set some limits on your choice of compiler. If Ncar graphics is set up with e.g the ifort compiler, it may be a good idea to set up everything with ifort for "smooth compiling.."


# Procedure for porting:

* First copy everything (MSCProgs and subdirectories) to the new machine.

* Set up a new make include file in Make.Inc,  suggested naming: make.machinename.compilername. Its usually easiest to take one of the existing make.* files as a starting point. 

* Use the same variable names that is used in the other make include files. If you change variable names, you will have to edit 20-30 makefiles by hand. Its your choice...

* Set up compiler + linker/compiler options. Using a real size of 8 bytes is generally recommended. Pay attention to flags for free/fixed source form (.F90 .f90 files are free-form while .F .f files are fixed-form). 

* Also pay attention to little/big endian input/output flags for portability of binary files. HYCOM files are usually stored as big-endian, x86, x86_64 (AMD/Intel CPUs) uses little-endian as default file I/O so compilers on these architectures usually need a conversion flag.  POWER/PowerPC (e.g IBM and old macs) use big-endian file I/O so they dont need a conversion flag.

* Set up libraries and include paths to wherever they are on your system (Variables LIBS and INCLUDE) in make.inc

* For numerical libraries, the code supports FFTW, LAPACK and ESSL libraries. In general the LAPACK and FFTW libraries can be installed on most machines, so its a relatively safe bet to go for these. ESSL is AIX/IBM only as far as I know.

* In addition you will need netcdf libraries.

some CPP flags you need to define in the make include files:

|CPP flag | meaning|
|-------- | -------------|
|LAPACK   | use Lapack libraries |
|FFTW     | use FFTW  Fourier transform libraries |
|ESSL     | use ESSL  libraries, typically available on AIX machines. If you set this, unset FFTW and LAPACK.|
|IARGC    | defines the iargc function as real4, external in the code. Some compilers need this |


After the makefile is set up, link it to the make.inc file as
described in the procedure for compiling/installing.


# Site-specific comments


hexagon (and other Cray XT systems) control environment variables through module systems. Using this, the make.inc file can have empty LIB and INCLUDE variables, as these are set mainly by the module system using environment variables.

## hexagon.bccs.uib.no 

The following module setup was used with luck on hexagon

    module swap PrgEnv-cray PrgEnv-pgi
    module load cmake
    module load cray-libsci
    module unload xtpe-interlagos # This is needed to compile on login nodes (istanbul cpu)
    module load fftw
    module load cray-netcdf
    module load ncview
    module load python/2.7.9-dso # NB: sets PYTHONHOME, which can cause problems for some scripts that uses the full path
    module load subversion
    module swap pgi pgi/14.1.0 
    module swap cray-libsci cray-libsci/12.2.0 
    module swap cray-mpich cray-mpich2 
    module swap cray-netcdf cray-netcdf/4.3.2 

# Procedure for compiling/installing Tides_FES2004 and Tides_FES214

These libraries depend on extarnal FES libraries that need to be compiled and
installed. They usually also require you to use the gnu c compiler. You will
find some description of how to compile these two in
[src/Tides_FES2004](src/Tides_FES2004)
and
[src/Tides_FES2014](src/Tides_FES2014)
