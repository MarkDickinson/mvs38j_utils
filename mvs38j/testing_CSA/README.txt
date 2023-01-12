This folder is not ready for anything of any use yet.
It is the start of my implementation of using CSA storage to
share data between programs.

I cannot actually think of anything to use it for yet; I was just
curious. It does not implement ENQ/DEQ anywhere so not really
safe for use for anything yet.

Everything has been tested and works but it is really just pieces
without any application.

Most of these will not assemble without my personal MACRO
library anyway, although I think the main personal routine 
used it my TODEC8 macro in most of the displays and you may
have you own equivalent.
The main program the allocates the index table into CSA storage
absolutely requires you have my EVENTHUB macro for it to assemble
which is available seperately.

Global changes required in every file
   MARK.LIB.LOAD to a program library of your choice
   MARK.LIB.LOAD.APFAUTH to a program libraru in your APF list
   MARK.LIB.MACROS.CSA to a macro library you can use, if
     using an existing one edit the JCL as it expects to create 
     a new file
   SYS9.PROCLIB to a proclib you can start tasks from, although
     you only need this if you want to run it this way instead
     of as batch.

   Each JCL deck has a USER and PASSWORD entry you will need
   to change. I have a bash script to submit jcl decks to the
   ascii card reader that substitutes the values to real ones
   in my bash profile as I kept forgetting to remove working
   ones on stuff put to github, now I just use the dummy ones.

--- ==================================================== ---
--- REFER TO BUGS.txt before even considering using this ---
--- ==================================================== ---

It is also important to note that (like installing RAKF that breaks
all documented security chains by just clobering where the top of
the security chain should be) installing this will cause problems
if you have any other products that may want to chain off CVTUSER
as it takes ownership of it and implements my chain.

I suppose the correct way would be to use a two byte table as 
recomended and have the first entry refer to my custom table
address and let anything else that expects to use the two byte table
chained off CVTUSER work as expected... as expected only if other
tools use the recomendation.
In TK4- nothing is using CVTUSER yet.

TODO
   - find more doc on the recomended method, I might change all
     this stuff to the recomended two word table and hang my own 
     chain off it. If I ever find the time, and if I can actually
     find elusive doc on CVTUSER to confirm that is the correct
     approach.

--- ==================================================== ---
--- REFER TO BUGS.txt before even considering using this ---
--- ==================================================== ---

But if you have read this far and are interested in whats
in this folder...

I am investigating how to use CSA to share data between 
different running progams. Using CSA seems a lot easier than
scheduling SRBs all over the place.

As I was not sure what TK4- was doing I needed to query CVTUSER.
Result: it is binary zeros in TK4- so nothing is using it yet.

The recomendation for this is to chain a two word list off the 
CVTUSER pointer; I will use three words for now. 
Consider it 'site specific'.

I have chosen to use a table format of
    CVTUSER points to the getmained table in CSA
    The table is a list of three word elements of
        4 byte slot-identifier 
        word recording address of getmained CSA storage
        word recording size of getmained storage (used by MDSCAREL...
        ...macro when it is asked to freemain storage)
    The slot-id defaults to 'FREE' for all slots at initialisation,
    except the first slot which has our identification header which
    has a reserved slot-id.
    AS NOTED ABOVE if I can find documented usage on the CVTUSER chain
    I might change how I setup the table, but as the macros would be
    updated to support that also there should be no real issues
    [for me as I am the only user].

    When a program uses my macro to allocate memory slot search is
    1. find a slot-id matching the requesting one and if no memory
       attached do agetmain and use it; or if in use refuse to do anything
    2. if no slot matched the requested slot-id locate a 'FREE' one
       and assign it the slot id, getmain and use it.
    Note: on 1; the macro can be used with a getmain request size of
          zero the purpose of which is just to change a slot-id from
          'FREE' to the specified slot-id to effectively reserve it
          for later use (if it is not 'FREE' it is not available
          in searched for a free slot but can still be used by slot-id
          identifier explicitly when whatever it was reserved for
          starts.


Programs/Files so far
=====================
  MACLIB   - macros needed
  PROCLIB  - procedures (testing only)
  MDCSAQRY - normal program, non-authourised
     show the value of CVTUSER 
          either 0 if not used or address of a list if allocated
          if allocated will also display all the table entries
  MDCSAMGR - authorised,
             must be in supervisor mode to update CVTUSER and write
             into CSA allocated memory
     -- initialisation mode, 
        checks CVTUSER is not in use
        getmains an area in CSA, SP241 with the defauly key 8
               (key 8 allows other programs to read the data)
        updates CVTUSER to point to the getmained area
        creates the a table of FREE entries, entry 1 is reserved for a...
        ...header that identifies the table as one we created
     -- interactive mode (via mofify ("F jjjjj,cmd" commands)
        checks CVTUSER is in use and points to a table with the...
        ...header information we expect, if not will stop
        can display the table entries (like the query program)
        command 'wipecsa' will WTOR for confirmation then if there...
        ...are no table entries with getmained info stored will...
        ...freemain that table and set CVTUSER back to zeros, this...
        ...is faster than IPLing when I screw something up.
  MDCSAMOD - authorised,
             must be in supervisor mode to write into CSA allocated
             memory
        checks CVTUSER is in use and points to a table with the...
        ...header information we expect, if not will stop
        reads a DD of card image records in the format
           '*' in column 1 is a comment
           'ADD CCCC nnnn' 
                find a free slot and allocate CCCC as the slot-id
                and getmain nnnn bytes of memory for that slot
                (currently MAX nnnn is coded as 4096)
                Note: the getmain returns no error for non-zero
                      values so I am assuming it is working
           'ADD CCCC 0   ' 
                find a free slot and allocate CCCC as the slot-id,
                as memory request is 0 it only updated (reserves)
                the slot-id name
           'REL CCCC' 
                find the slot-id matching CCCC, freemain the
                address and number of byted recorded in the table
                for it, set the addr and size back to 0 and the
                slot-id back to 'FREE'

--- TODO ---
  (1) Think of an actual use for it.
  (2) Maybe add an additional modify command to MDCSAMGR to allow it
      to release memory and slots individually; but for now the
      batch job MDCSAMOD does that perfectly well.

THOUGHTS
  The recomended "list" format is a word identifier then a word address
  of the shared CSA memory area. I have obviosly changed that to also
  store the size allocated so a three word table rather than a two 
  word table so that when memory is to be de-allocated the table knows
  the size and the macros can get the correct value rather than
  relying on a programmer to get it correct.
  That may not be the correct way if there is an OS table somewhere
  that hold that size info, but I have not found it yet.
