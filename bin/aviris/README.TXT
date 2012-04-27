IDL Interface to ATREM

The files in this directory:

atrem.pro - Widget interface for external AtRem FORTRAN code.  To date
   I've only been able to compile AtRem on SG1 and EDCSNS1.

atrem_defaults.pro - File sourced by atrem.pro containing default
   variable values. 

readnavfile.pro - Reads AVIRIS .nav file and places required data into
   a structure

rmctrl.sed - sed script used to remove control characters from .nav files

spc2wav.pro - Converts AVIRIS .spc spectra file to AtRem .wav file for
   mapping bands to wavelengths

NOTES: 

The atrem executable needs to be in your unix path or otherwise
 aliased. 

An AtRem input file named 'atrem.input' will be placed in your current
 working directory when the Make Input File button is pushed.  All out
 output files will also be placed in the current working directory, 
 including a log file, 'atrem.log'

