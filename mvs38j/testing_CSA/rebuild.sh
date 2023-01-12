#!/bin/bash

# I am doing all my testing in the custom container image
# I have built; I restart with the base container each time.
# So after the container restart I need to re-create the files
# I have been working with back onto that base.
#
# 'subjob' thows the files to the ascii card reader on port 3505.
# It replaced the 'dummy' userid and password in the jobdecks
# with real ones from my bash profile.

# macros used
subjob MACLIB.txt
#
# a proc I use so I do not have to re-submit the batch job
# to run the interactive program each time
subjob PROCLIB.txt
sleep 5
#
# mainly a debugging tool, it can be run at various steps
# in batch programs to WTO table entries to make it easier
# to see whats happening (rather than having to use the
# display option of the interactive program at multiple steps).
subjob MDCSAQRY.txt
sleep 5
#
# The main program. Will allocate the table and a second step 
# will run it in interactive mode (I will remove the second step
# at some point)
subjob MDCSAMGR.txt
sleep 5
#
# Batch job to perform getmain/freemain activities for the slots.
# While it can be used as a debugging aid to test the macros
# that perform those tasks it is a useful program I will keep
# around (it can run at IPL time after the main program to reserve
# slots for anything I can think of that might want to use it).
subjob MDCSAMOD.txt
#
# And purely for debugging.
# Will use the macros to
#   stepn   - alloc CSA memory and write data to it (authorised)
#   stepn+n - read the data from CSA memory (non-authorised)
#   stepn+n - release the slot-id/storage/table entry (using mdcsamod)
#   (n used rather than step numbers as lots of query steps
#    in there as well to display what is happening)
#   stepn+n - release the slot-id/storage/table entry
# subjob DEBUG.txt
