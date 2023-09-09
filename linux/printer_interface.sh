#!/bin/bash
# ----------------------------------------------------------------
# printer_interface.sh
# 
# I have all output from printer 00E piped through this script.
# Hercules configuration line is as below
# 
# 000E 1403 "|/home/mark/hercules/turnkey3/mark/scripts/printer_interface.sh" crlf
#
# It will create a individual text file for each JOB or STC that
# is printed to device 00E (I use print class G for that printer
# as generally only Guest users will use it.
#
# 2013/02/26: MID: wrote a bash script to convert the text file
#                  that was being generated to a PDF file, because
#                  I could. Also fixed the issue of leading spaces
#                  being dropped from lines as we want the PDF file
#                  to look correct, didn't matter when the browser
#                  was displaying just text.
# 2023/02/16: MID: added a chmod 644 after each output file is 
#                  created so it can be read without changing userid
#                  (needed for my containers that v mount to local storage)
#                  Always create a JOB PDF, having it inside a
#                  check to for other functions was not logical
# ----------------------------------------------------------------

# Figure out where our prt directory is knowing we are in xxx/mark/scripts
# Then we know where our prt/prt00e/job and prt/prtooe/stc directories
# are to use for output
# (required as I have hercules installed in different directories
#  between test and play).
origdir=`pwd`
mydir=`dirname $0`    # .../mark/scripts/thisscript
cd ${mydir}/../../prt/prt00e
PRTDIR=`pwd`
# PRTDIR="/home/mark/hercules/turnkey3/prt/prt00e"

# And now PRTDIR is set back to my origional code
PRTDEST="default.txt"
PRTLINE="YES"    # should be NO, but for debugging dump all records to default.txt as needed
savedjobname=""

cd ${PRTDIR}

# Change IFS to a newline so leading spaces on each line are not
# dropped off by the read command.
IFS="
"
cat | while read dataline
do
   is_start=`echo "${dataline}" | egrep "CONT   STC|CONT   JOB|START  STC|START  JOB"`
   if [ "${is_start}." != "." ];
   then
      jobname=`echo "${dataline}" | awk {'print $5'}`
      if [ "${jobname}." != "${savedjobname}." ];
      then
         savedjobname="${jobname}"
         datenow=`date +"%Y%m%d%H%M%S-%N"`
         is_job=`echo "${dataline}" | egrep "CONT   JOB|START  JOB"`
         echo "DEBUG: switched to ${jobname}-${jobtime}-${datenow}.txt at:${dataline}" >> ${PRTDEST}
         if [ "${is_job}." != "." ];
         then
            jobtime=`echo "${dataline}" | awk {'print $8$9'}`
            PRTDEST="job/${jobname}-${jobtime}-${datenow}.txt"
         else
            jobtime=`echo "${dataline}" | awk {'print $7$8'}`
            PRTDEST="stc/${jobname}-${jobtime}-${datenow}.txt"
         fi
      fi
      PRTLINE="YES"
   fi
   is_end=`echo "${dataline}" | egrep "END   STC|END   JOB|END OF JOB"`
   if [ "${is_end}." != "." ];
   then
      is_eoj=`echo "${dataline}" | grep "END OF JOB"`
      if [ "${is_eoj}." != "." ];
      then
         echo "${dataline}" >> ${PRTDEST}
      else 
         chmod 644 ${PRTDEST}
      fi
      #
      # create a copy as a PDF file 
      if [ -x ${mydir}/makepdf ];
      then
         PRTDEST2=`echo "${PRTDEST}" | sed -e 's/txt/pdf/'`
         ${mydir}/makepdf "${PRTDEST}" "${PRTDEST2}"
         chmod 644 ${PRTDEST2}
      else
         PRTDEST2=""
      fi
      # added the below to copy printed output files to the
      # hercules section of my website so users of my guest
      # system can download the output if they want. Has to 
      # be a seperate script suid to apache as my hercules
      # userid cannot access the website directories.
      # BACKGROUND IT to avoid hanging the printing script
      # itself.
      # add to sudoers the below three lines
      #     # Added for hercules print spooling, to copy to the website
      #     Defaults:mark !requiretty
      #     mark osprey=NOPASSWD: /home/mark/hercules/turnkey3/mark/scripts/printer_copytowebsite.sh
      if [ -x ${mydir}/printer_copytowebsite.sh ];
      then
         if [ "${PRTDEST}." != "default.txt." ];
         then
            # text file to always be there
            nohup sudo ${mydir}/printer_copytowebsite.sh "${PRTDEST}" &
            # PDF file may not be
            if [ "${PRTDEST2}." != "." -a -f ${PRTDEST2} ];
            then
               nohup sudo ${mydir}/printer_copytowebsite.sh "${PRTDEST2}" &
            fi
         fi
      fi
      PRTDEST="default.txt"
#      PRTLINE="NO"
      PRTLINE="YES"    # should be NO, but for debugging dump all records to default.txt as needed
      savedjobname="default.txt"   # mf1 writes two reports with same time so MUST reset
                                   # this to force appending to the existing file
      echo "DEBUG: switched to default.txt at:${dataline}" >> ${PRTDEST}
   fi
   if [ "${PRTLINE}." = "YES." ];
   then
      echo "${dataline}" >> ${PRTDEST}
   fi
done
unset IFS
exit 0
