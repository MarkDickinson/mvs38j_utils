These are utilities I have needed to create to let my Turnkey3 MVS3.8J
system look after itself.

These are stable. Any updated (and probably still abending) versions
containing updates, bug-fixes and major enhancements are probably
available on a use at your own risk basis on my website at
http://mdickinson.dyndns.org/hercules/downloads/index.php

Brief desription of files here
==============================
BKBYVTOC.txt    - given a list of disk volumes (and backup proc templates)
                  will generate the JCL required to backup the files on
                  those disk packs to tape. Creates backup listings of
                  files backed up to disk

BKBYVTOC_extras.txt - a messy collection of programs I use to manage
                  backups produced by bkbyvtoc. Programs to merge
                  and trim outputs and scripts to allow a web page
                  to be used to run restore jobs.
                  Probably only usefull to me.
                  And this is an exception to the 'these are stable'
                  statement above.

COBRENUM.txt    - renumbers (or inserts) sequence numbers needed for MVT
                  COBOL source members so I don't have to bother keeping
                  them in sequence manually when editing the members

DASDSCAN.txt    - check all online dasd volumes to make sure they are
                  not getting low on freespace. where possible checks
                  that files on the dasd volser are not using too many
                  extents (program source comments explain the 
                  'where possible' and refer to the appropriate manual.

DATEPROG.txt    - UTILITY LIBRARY/PROGRAMS/MACROS used by many of my
                  programs. If you download anything from here you will
                  probably need this. It will one day be the only date
                  utility/conversion library I will ever need. 
                  Started out as a way to return all possible
                  displayable info about a provided date, and now
                  includes some date calculation routines.
                  Assembler macros provide the interfaces to the
                  programs. Also has standalone macros to work out
                  day of week and if a leap year.
                  Has a couple of programs I use to exercise the 
                  library time calculation functions that provide
                  a simple job scheduler skeleton I will probably
                  take further one day.
                  This is a work in progress and the latest stable
                  version, newer and bugfix versions will be on
                  my website before they reach here.

EVENTHUB        - BETA - S/370 macro for mutitasking programs
                  (eventhub_macro.txt  eventhub_test_program.txt)
                  MACRO to easily provide MVS3.8J assembler programs
                  with COMM area processing, multiple WTORs, and
                  multiple timers
                  eventhub_macro.txt - the MACRO
                  eventhub_test_program.txt - demo program and the
                  only documentation at this point

GETMAXCC.txt    - I needed code to scan the return codes of all prior
                  jobsteps in a batch job. It was hard to track down
                  how to do that for mvs3.8j so saved here so I don't
                  lose it.
                  This is how to get that info, to be usefull you
                  would need to put it into a program that made
                  decisions on that information :-)

IPLINFO.txt     - I wanted more info logged than the default reason
                  for ipl the OS provides (which we have all disabled
                  anyway). This records the ipltime, ipl volser and cuu
                  used, if it was a clpa/cvio/warm ipl, and of course
                  the reason text entered; logged to a disk file.
                  If no response to prompt in 10mins the prompt is
                  cancelled.
                  My use for this is to keep track of what I was doing
                  when I broke the system :-( but I was also
                  interested in how to extract the ipl information
                  from the system

JOBCONT2.txt    - add a continuation card containing the data passed
                  in the parm to the job cards of jobs it submits.
                  I use this instead of iebgener to submit job streams
                  to intrdr since I installed RAKF (and gave the
                  default batch access to nothing) and use it to
                  append a user/password to the job cards, allowing
                  the scheduler(s) job members to be coded as normal 
                  and not need to know that info.
                  But you can use it to append anything to the job
                  cards

MDJOBREL.txt    - A work in progress, but what is here works.
                  Uses a control file to release held jobs when a
                  running job completes, I submit my daily/weekly
                  batch in bulk as mainly held jobs, where the 
                  running jobs release dependent held jobs as they
                  complete (if the running job was < maxcc allowed).
                  This provides a simple batch job dependency method
                  to avoid dataset contention.
                  See the $DOC member for how to use it.
                  A work in progress as I intend to connect all the
                  various bits I have in this section into a full
                  scheduler with automated restart/recovery etc at
                  some point.

MMPF.txt        - Marks Message Processing Facility
MMPF_user_manual.odt - User manual for MMPF.
                  Marks message processing facility; I got sick of
                  putting complicated code into IEECVXIT and filling
                  up the system dump datasets when I made a mistake.
                  A console buffer screen scraper that can automate
                  action/attention messages on the console using
                  usefull rules with &WORD1-&WORD20 so you don't have
                  to do any message parsing yourself. Provides a 
                  simple 'only if keyworkN=xx' method also.
                  Also can change rulesets on the fly via
                  'F MMPF,MMPF=nn'.

SCHEDULE.txt    - Schedule from Xephon magazine 1999/02 
                  Xephon editions are available on www.cbttape.org
                  Converted to run on MVS3.8J, see changes member.

TAPEMAN3.txt    - My tape automount solution
                  Totally automate tape mounts for all local tapes.
TAPEMAN3_Installation_Manual.odt  - installation manual
TAPEMAN3_User_Manual.odt          - user manual
                  Since this was written hercules has an auto-operator
                  facility; but that will blindly mount tapes, I still
                  think this is currently better.
                  * REQUIRES HERCCMD  http://www.grzes.com/herccmd.aws
                    to issue the devinit commands
                  * REQUIRES my MMPF above (an archived/unsupported 
                    version that can be run via IEECVXIT is still
                    available on my website if you don't have MMPF)
                  * maintains a VSAM database of managed tapes that
                    can be automatically mounted and their state
                    (active or scratch) so requests for scratch tapes
                    will not overwite an in-use tape
                  * handles mount requests for named volsers and
                    scratch tapes
                  * on a request for a scratch tape if none are
                    available will WTOR the operator to provide a
                    volser name to use
                  * will never attempt to automount a tape request
                    for a non-managed tape, will just alert that
                    it is not managed.

TASKMON.txt     - Task monitor, keeps running tasks in a preferred
                  state, either up or down.
                  I use it now mainly for restarting MMPF after 
                  it has been shutdown by IEECVXIT for operations
                  against the tape database... and for restarting
                  JES2 on the odd occasion I want to update parms
                  remotely and need to stop it with an abend :-).
                  Before I used TK3 I used to use this to shutdown
                  my system (has a F(modify) command to change the
                  desired state of all tasks to down) but TK3 systems
                  use BSPPILOT for shutdown.

