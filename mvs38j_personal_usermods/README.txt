************************************************************************
*                                                                      *
*        These are usermods I have slapped together for mvs3.8j        *
*                      USE AT YOUR OWN RISK                            *
*                                                                      *
*          As always stored on github so I do not lose them            *
*                                                                      *
************************************************************************

ZMD0001 - This is TK4- specific, do not use it on TK3
          Update the TK4- IEECVXIT with changes I need
          for my personal automation.

          This will be useless to most of you unless you are
          really interested in how hard it is to revert the
          changes TK4- applied on top of TK3. In TK3 if was
          just a case of dropping/reinstalling ZUM003 to
          make changes, it is a lot messier in TK4-

          FILES:
              ZMD0001_IEECVXIT_tk4_mods.txt  ... apply changes
              ZMD0001R.txt    ... backout changes (has manual steps)
          TK3 users do not use this, use ZUM0003 provided with TK3


ZMD0002 - Usable with TK3 and TK4-
          Allow easy addition of additional CONSOLE DISPLAY commands

          This usermod alters IEE3503D (console display command) at
          the point immediately before it would issue a 'invalid command'
          message; it is altered to try to link to a program MID3503D
          to try to resolve any additional commands. MID3503D returns
          to IEE3503D with either command handled or still unknown.
          (if MID3503D does not exist in the linklist the only impact
          is a 806 warning when you issue an invalid command).

          FILES:
              ZMD0002_IEE3503D_tk4_mods.txt  ... apply changes
              ZMD0002R.txt             ... backout (restore) changes
            plus
              MID3503D.txt       ... example MID3503D module

          The example MID3503D provides the additional commands
            * 'D SMF' and 'D SMF,O' extracted from CBT tape 486 file 887,
              the 'D SMF is incomplete (as per the CBT source)
            * 'D APF[LIST]' extracted from CBT tape 486 file 887
           and ones I have started adding
            * 'D TIME' to include the day name and yyyy/mm/dd in the
              response display, rather than the pointless 'D T' command
            * 'D IPL[INFO]' to display the last IPL time plus
              stuff like ipl volser, ipl type warm/cvio/clpa etc
              (ok, unix geek, I needed a 'uptime' equivalent)
          Benefits: once the usermod is in no more SMP work
            * new commands can be added simply by assembling a new
              version of MID3503D (in TK4- instantly available
              UNLESS linklib goes to a second extent in which case
              compress it and IPL; in TK3 you have to IPL to see the
              new version)... if you screw up just assemble a 
              prior version again, or delete it and re-IPL
            * the worst impact of a coding error in MID3503D is a
              system dump dataset is populated

