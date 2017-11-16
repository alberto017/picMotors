==============
Code Directory
==============

This directory contains template files for absolute code development. This 
means that program memory code and RAM variables will be placed exactly 
where you specifically define them to be, using directives such as ORG. 
These directives are interpreted during assembly and place the code 
following the directive in a specified portion of program memory. 

Template files containing absolute code generally use an ORG directive to 
place code at a reset vector and an ORG directive to place code at each 
interrupt vector location.  The interrupt vector location in program memory 
precedes the code of the "main" program in program memory.  

================
Object Directory
================
This directory contains template files for relocatable code development.
This means that program memory code and RAM variables will be placed by the 
linker using directives such as CODE. The assembler builds portions of code 
and then the location of the code is determined by a linker script included 
in the project being built.  

Template files containing relocatable code do not use an ORG directive to 
place code within program memory.  Instead, the CODE directive is used to 
place code at specific locations in program memory as well as making the 
linker script decide where the code gets placed within program memory.

=============================
Absolute vs. Relocatable Code
=============================

For more on absolute and relocatable code, see the MPASM assembler 
documentation (user's guide or on-line help file) under "Assembler Operation".
