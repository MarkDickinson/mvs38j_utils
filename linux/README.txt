I now run Turnkey3 under Hercules on a linux system.
Using a Linux host system allows a lot of flexibility, my key scripts
are provided here.

Important: These files are customised for my system.
You will have to adjust paths in the scripts as needed to get them to
work on your systems.

Brief description of files
==========================
makepdf                  - convert a text file to a PDF file.
                           This is called by my printer_interface.sh
                           script if it exists to create a PDF of the
                           job output as well as the text output.
                           Can be used standalone to convert text
                           files to PDF files but line/column sizes
                           I have tries to tweak for lineflow output.

marks_tk3                - LINUX headless startup/shutdown of a TK3
                           system using screen and c3270. Push the
                           power on button on the server and five
                           minutes later from any remote client you
                           can logon to tso.
                           or ssh to the server and use 'screen' to
                           directly connect to the backgrounded
                           application sessions on the server

printer_interface.sh     - bash script to process text streams from
                           a hercules printer into unique job files.
                           This is designed to be used as the output
                           processing script of a hercules 'pipe' 
                           printer, for example...
                           000E 1403 "|/.../printer_interface.sh" crlf
                           Give in the JES2 config device 00E a unique
                           print class and every job sent to it will
                           be in a seperate text file (and PDF file
                           also if you use the makepdf script above).

